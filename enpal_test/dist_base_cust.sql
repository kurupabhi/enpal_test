
use enpal_test
go

-- assign base ids
with cte_bases as(
	select distinct
		case 
			when latitude=48.137200 then 'Base_1'
			when latitude=50.113600 then 'Base_2'
			when latitude=52.516700 then 'Base_3'
		end as base_id,
		latitude as base_latitude,
		longitude as base_longitude
	from enpal_test.dbo.bases
--
),

-- added separate cte with base ids along with team ids to reduce number of rows for cross join
cte_bases_teams as(
	select distinct
		case 
			when latitude=48.137200 then 'Base_1'
			when latitude=50.113600 then 'Base_2'
			when latitude=52.516700 then 'Base_3'
		end as base_id,
		latitude as base_latitude,
		longitude as base_longitude,
		team_id
	from enpal_test.dbo.bases
--
),

-- calculate the distance from base to each customer. Distance converted to kilometers
cte_dist as(
	select 
		*,  
		(GEOGRAPHY::Point(b.base_latitude, b.base_longitude, 4326).STDistance(GEOGRAPHY::Point(c.latitude, c.longitude, 4326)))/1000 as dist_kms
	from cte_bases as b
	cross join  enpal_test.dbo.customers as c
	
),

-- check the least distance from each customer
cte_near_base as(
	select 
		*,
		min(dist_kms) over (partition by customer_id order by customer_id) as min_dist
	from cte_dist
),

-- assign expected skill levels as per team skills
cte_cust_w_dist AS(
	select 
		customer_id, 
		latitude, 
		longitude, 
		panels_to_install, 
		cast(installation_start_date as date) as installation_start_date, 
		base_id as closest_base, 
		base_latitude,
		base_longitude,
		dist_kms as dist_from_base_kms,
		case
			when panels_to_install <22 then 3
			when panels_to_install <23 then 2
			else 1
		end as expected_skill_level
	from cte_near_base
	where dist_kms=min_dist
),

-- assign priorities as per team availability dates
cte_team_sort AS (
	select 
		c.customer_id, 
		c.installation_start_date, 
		c.panels_to_install, 
		c.closest_base, 
		c.expected_skill_level,
		t.*,
		RANK() OVER (PARTITION BY customer_id ORDER BY t.availability_from) team_assignment_prio
	
	from cte_cust_w_dist c
	left join cte_bases_teams b on c.closest_base=b.base_id
	left join dbo.teams t on b.team_id=t.team_id
	where 1=1
),

-- dataset where customer teams are available during customer installation dates
cte_team_p_1 as(
	select 
		*
	from cte_team_sort
	where installation_start_date between availability_from and availability_till
),

-- dataset where teams would be available some time after customer installation dates
cte_team_p_2 as(
	select 
		*
	from cte_team_sort
	where installation_start_date<availability_from
	and customer_id not in (select distinct customer_id from cte_team_p_1)
),

-- dataset where no teams are available during customer installation date
cte_team_p_3 as(
	select 
		*
	from cte_team_sort
	where installation_start_date>availability_till
	and customer_id not in (select distinct customer_id from cte_team_p_1)
	and customer_id not in (select distinct customer_id from cte_team_p_2)
),

-- prepare data for available teams. if there are no teams available with matching expected skill, also check other team with higher skills. If no team availabl
cte_team_p_1_2 AS (
	select * ,
	case
		when expected_skill_level=skill_level then team_id
		when expected_skill_level!=skill_level and expected_skill_level-1=skill_level then team_id
		else 0
		end as _prio
	from cte_team_p_1
	where customer_id not in (select distinct customer_id from cte_team_p_1 where expected_skill_level=skill_level)
),

cte_team_install AS(
	select 
		customer_id,
		installation_start_date, 
		installation_start_date as earliest_install_date,
		case
			when _prio!=0 then cast(team_id as varchar)
			else 'No team available'
		end as team,
		'N/A' as comments
	from cte_team_p_1_2
	where team_assignment_prio=1
	
	UNION ALL
	
	select 
		customer_id,
		installation_start_date, 
		installation_start_date as earliest_install_date,
		cast(team_id as varchar) as team,
		'N/A' as comments
	
	from cte_team_p_1
	where expected_skill_level=skill_level
),

-- prepare data for teams available in the future, with potential teams that could pick up the task
cte_team_p_2_2 as (
	select *, 
		case when expected_skill_level=skill_level then team_id
			 when expected_skill_level!=skill_level and expected_skill_level-1=skill_level then team_id
		else 0
		end as _prio,
		row_number() OVER (PARTITION BY customer_id, skill_level ORDER BY availability_from) team__prio
	from cte_team_p_2
),

cte_team_check as(
	select 
		customer_id,
		installation_start_date, 
		availability_from as earliest_install_date,
		cast(team_id as varchar)as team,
		'To be schedulled after confirmation' as comments
	
	from cte_team_p_2_2
	where _prio!=0 and team__prio=1 and expected_skill_level=skill_level
	
	
	UNION ALL 
	
	select 
		customer_id,
		installation_start_date, 
		availability_from as earliest_install_date,
		cast(team_id as varchar)as team,
		'To be schedulled after confirmation' as comments
	from cte_team_p_2_2
	where _prio!=0 and team__prio=1 and customer_id not in(select distinct customer_id from cte_team_p_2_2 where _prio!=0 and team__prio=1 and expected_skill_level=skill_level)

),

final as (
	select
		customer_id,
		installation_start_date,
		cast(cast(earliest_install_date as date) as varchar) as earliest_install_date,
		cast(team as varchar) as team,
		comments
	from cte_team_install
	
	UNION ALL
	
	select
		customer_id,
		installation_start_date,
		cast(cast(earliest_install_date as date) as varchar) as earliest_install_date,
		cast(team as varchar) as team,
		comments
	from cte_team_check
	
	UNION ALL
	
	-- Data were no teams are available during the installation period. Hire more?
	select distinct
		customer_id,
		installation_start_date, 
		'N/A' as earliest_install_date,
		'No team available' as team,
		'No team available for this time. To be schedulled after team availability' as comments
	from cte_team_p_3
)

select * from final
order by customer_id