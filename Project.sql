WITH users_parsed AS
(
SELECT
	user_id,
	signup_datetime,
	promo_signup_flag,
	CASE 
		--an option for short dates that are not written in the standard format, i.e., contain 8 characters or less
		WHEN LENGTH(SPLIT_PART(REPLACE(REPLACE(TRIM(signup_datetime), '/', '.'), '-', '.'), ' ', 1)) <= 8
        THEN TO_DATE(SPLIT_PART(REPLACE(REPLACE(TRIM(signup_datetime), '/', '.'), '-', '.'), ' ', 1), 
                'DD.MM.YY') 
        --for dates with the full year remove the extra parts, replace the separators with a single one and highlight the date
        ELSE TO_DATE(SPLIT_PART(REPLACE(REPLACE(TRIM(signup_datetime), '/', '.'), '-', '.'), ' ', 1), 
                'DD.MM.YYYY')
    END AS signup_ts 
FROM cohort_users_raw 
),
events_parsed as
(SELECT
	user_id,
	event_datetime,
	event_type,
	CASE 
		--an option for short dates that are not written in the standard format, i.e., contain 8 characters or less
		WHEN LENGTH(SPLIT_PART(REPLACE(REPLACE(TRIM(event_datetime), '/', '.'), '-', '.'), ' ', 1)) <= 8
        THEN TO_DATE(SPLIT_PART(REPLACE(REPLACE(TRIM(event_datetime), '/', '.'), '-', '.'), ' ', 1), 
                'DD.MM.YY') 
        --for dates with the full year remove the extra parts, replace the separators with a single one and highlight the date
        ELSE TO_DATE(SPLIT_PART(REPLACE(REPLACE(TRIM(event_datetime), '/', '.'), '-', '.'), ' ', 1), 
                'DD.MM.YYYY')
    END AS event_ts
 FROM cohort_events_raw 
 WHERE event_datetime is not NULL),
user_activity as
(SELECT 
	up.user_id,
	--a function for converting a date into text in the desired format
	TO_CHAR(up.signup_ts, 'YYYY-MM') AS cohort_month,
	up.promo_signup_flag,
	--use the data that has already been cleaned in functions via `case`
	TO_CHAR(ep.event_ts, 'YYYY-MM') AS activity_month,
	--since we cannot calculate “activity_month-cohort_month” in a single query because those values do not yet exist,
    --I will solve this by subtracting the extracted data and converting the year to a month, 
    --then adding the difference in months to account for the offset
	(EXTRACT(year FROM ep.event_ts) - EXTRACT(year FROM up.signup_ts)) * 12 +
    (EXTRACT(month FROM ep.event_ts) - EXTRACT(month FROM up.signup_ts)) AS month_offset
FROM users_parsed up 
JOIN events_parsed ep on up.user_id = ep.user_id
WHERE 	--filter the data
		event_type is not NULL
		AND event_type != 'test_event'
		AND signup_ts is not NULL
		AND event_ts is not NULL)
SELECT
	--building the final aggregated table
	promo_signup_flag,
	cohort_month,
	month_offset,
	--count the number of unique users
	COUNT(distinct user_id) as users_total
FROM user_activity ua
--limit the observation period
WHERE activity_month BETWEEN '2025-01' AND '2025-06'
GROUP BY promo_signup_flag, cohort_month, month_offset
ORDER BY promo_signup_flag, cohort_month, month_offset;



