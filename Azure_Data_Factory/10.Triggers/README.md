Triggers automate the execution of a data piepeline

There are three types of triggers

1. Schedule Triggers
- Define Schedule time to execute pipelines.
Ex. Every sunday

- I can't create triggers which is dependent on another triggers.

2. Event based triggres

- Runs on a events
- Ex. Addition of a file or remove a file

- Single trigger can run multiple pipelines or pipeline can be run by multiple-event based triggers

- Triggers dependencies not possible.

3. Tumbling window triggers

- Usefule while we want to execute pipeline for specific period of a time range.

- Ex. Execute to ingest data from last day 8 AM to todays 8 AM. 
- Ex. Every one hr.

- Can create trigger dependencies

- Ex. Execute a trigger based on another trigger.

- TO EXECUTE2 PIPELINE ONE BY ONE USE ACTIVITY `EXECUTE PIPELINE` AND VCONNECT TO EACH OTHER