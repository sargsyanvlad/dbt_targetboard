WITH call_data AS (
    SELECT
        id,
        event_type,
        start_time
    FROM public.call_events_base
)
SELECT
    id AS call_id,
    MAX(start_time) AS last_event_time
FROM call_data
WHERE event_type != 'call ended (answer)' -- Exclude finished event types
GROUP BY id
