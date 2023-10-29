{% macro calculate_call_duration() %}
WITH calls AS (
    SELECT
        id,
        event_type,
        start_time,
        LEAD(start_time) OVER (PARTITION BY id ORDER BY start_time) AS end_time
    FROM public.call_events_base
)

SELECT
    id,
    event_type,
    start_time,
    end_time,
    EXTRACT(EPOCH FROM (end_time - start_time)) AS call_duration_in_seconds
FROM calls
WHERE event_type = 'call started' AND EXTRACT(EPOCH FROM (end_time - start_time)) IS NOT NULL
{% endmacro %}
