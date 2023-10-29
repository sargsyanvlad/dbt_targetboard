WITH call_data AS (
    SELECT
        id,
        event_type,
        start_time
    FROM public.call_events_base
)
SELECT
    id AS call_id,
    MAX(start_time) AS call_end_time
FROM call_data
WHERE event_type = 'call ended (answer)'
GROUP BY id
