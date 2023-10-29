# dbt Project: target-board

## Overview

The `docker-compose.yml` file consists of two services:
- `postgres`
- `dbt`

that are used to build the data models defined in the project into a target Postgres database.

## `postgres` service

## `dbt` service
This service is built out of the `Dockerfile` and is responsible for creating dbt seeds, models and snapshots
on `postgres` service. The project contains seeds, models (staging), macros

## Prerequisites

Before getting started, make sure you have the following prerequisites installed:

- Docker
- Python 3.10

## Project Structure

The project consists of the following components:

- **Models**: These are SQL files that define the data transformations.

    - `call_durations.sql`: Calculates call durations for calls that are started.
    - `finished_calls.sql`: Identifies and extracts information about finished calls.
    - `unfinished_calls.sql`: Identifies and extracts information about unfinished calls.

- **Seeds**: Data files and schema definitions for the call events data.

    - `seeds/call_events_base.csv`: A sample CSV file containing call event data.

- **Macros**: Reusable SQL code for the project.

    - `macros/call_duration_macro.sql`: A macro for calculating call durations.

- **dbt Project Configuration**: `dbt_project.yml` defines project-level configurations.

- **Profiles Configuration**: `profiles.yml` specifies connection details to database.

- **Docker Configuration**: `Dockerfile` and `docker-compose.yml` provide the setup for running dbt inside a Docker container.
## Models

The project includes the following models:

### `call_durations`

This staging model calculates the duration of call events. It utilizes the `calculate_call_duration` macro to extract information from the `public.call_events_base` table. The model is designed to determine the call duration for events marked as 'call started' in the call events data. It performs the following tasks:

1. It employs the `calculate_call_duration` macro to obtain the call duration information, including columns such as `id`, `event_type`, `start_time`, `end_time`, and `call_duration_in_seconds`.

2. The model filters records where the `event_type` is 'call started' and the call duration is not null.

### `finished_calls`

This staging model focuses on finished calls. It extracts data from the `public.call_events_base` table and identifies call events marked as 'call ended (answer)'. The model provides information about call end times for these events. Here are the steps:

1. The model utilizes a CTE (Common Table Expression) to select relevant columns from the `public.call_events_base` table.

2. It identifies call events with 'call ended (answer)' as the `event_type`.

3. The result includes columns like `call_id` and `call_end_time`, which represents the end time for finished calls.

### `unfinished_calls`

This staging model deals with unfinished calls. It extracts data from the `public.call_events_base` table and excludes events marked as 'call ended (answer)'. The model provides information about the last event time for these unfinished calls. The process is as follows:

1. The model uses a CTE to select relevant columns from the `public.call_events_base` table.

2. It filters out call events with 'call ended (answer)' as the `event_type`.

3. The result includes columns like `call_id` and `last_event_time`, representing the last event time for unfinished calls.

## Macros

The project uses the following macros:

### `call_duration_macro.sql`

This macro is a reusable SQL code snippet for calculating the duration of calls. It is utilized in the `call_durations.sql` model to determine the duration of calls that are marked as 'call started' in the call events data. The macro performs the following steps:

1. It defines a common table expression (CTE) called `calls`, which selects relevant columns from the `public.call_events_base` table and calculates the `end_time` by using the `LEAD` window function.

2. The macro then selects records from the CTE where the `event_type` is 'call started' and the call duration is not null.

3. The result includes columns such as `id`, `event_type`, `start_time`, `end_time`, and `call_duration_in_seconds`, which represents the call duration in seconds.

## How to Use





###  1. Clone the project repository to your local machine.

```bash
git clone https: https://github.com/sargsyanvlad/dbt_targetboard.git
git clone ssh: git@github.com:sargsyanvlad/dbt_targetboard.git
```
### 2. Navigate to the project directory.

### 3.  Running the dummy dbt project
First, let's build the services defined in our `docker-compose.yml` file:

```bash
docker-compose build
```

and now let's run the services so that the dbt models are created in our target Postgres database:

```commandline
docker-compose up
```

This will spin up two containers namely `dbt` (out of the `target-board-dbt	` image) and `postgres` (out of the
`dbt-postgres` image).

Notes:
- For development purposes, both containers will remain up and running
- If you would like to end the `dbt` container, feel free to remove the `&& sleep infinity` in `CMD` command of the
  `Dockerfile`

Now you can query the tables constructed form the seeds, models and snapshots defined in the dbt project:
```sql
-- Query seed tables
SELECT * FROM call_events_base;

-- Query staging views
SELECT * FROM call_durations; --this view table use a "calculate_call_duration" macro in order to create a view table

SELECT * FROM finished_calls;

SELECT * FROM unfinished_calls;
```

## License

This project is licensed under the MIT License.
