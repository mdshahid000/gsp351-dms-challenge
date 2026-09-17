# GSP351 — Migrate MySQL Data to Cloud SQL Using DMS

Every lab task has a separate script. Run them in order in the same authenticated Cloud Shell session:

```bash
curl -fsSLO https://raw.githubusercontent.com/mdshahid000/gsp351-dms-challenge/master/01_task1_create_connection_profile.sh && chmod +x 01_task1_create_connection_profile.sh && ./01_task1_create_connection_profile.sh
curl -fsSLO https://raw.githubusercontent.com/mdshahid000/gsp351-dms-challenge/master/02_task2_one_time_migration.sh && chmod +x 02_task2_one_time_migration.sh && ./02_task2_one_time_migration.sh
curl -fsSLO https://raw.githubusercontent.com/mdshahid000/gsp351-dms-challenge/master/03_task3_continuous_migration.sh && chmod +x 03_task3_continuous_migration.sh && ./03_task3_continuous_migration.sh
curl -fsSLO https://raw.githubusercontent.com/mdshahid000/gsp351-dms-challenge/master/04_task4_verify_replication.sh && chmod +x 04_task4_verify_replication.sh && ./04_task4_verify_replication.sh
curl -fsSLO https://raw.githubusercontent.com/mdshahid000/gsp351-dms-challenge/master/05_task5_promote_destination.sh && chmod +x 05_task5_promote_destination.sh && ./05_task5_promote_destination.sh
```

Task 1 uses the external IP of `dev-fin-vpp` and creates the source profile. Task 2 targets the existing `mysql-fin-vpp` instance with a one-time migration. Task 3 targets `mysql-fin-vpp-cont` with a continuous migration using VPC peering and waits for the job to run. Task 4 performs the required source update (`addressKey=934`) and checks the destination. Task 5 promotes the continuous destination to standalone.

If the DMS console requires confirmation for an existing destination instance, choose the provided instance exactly; do not create a different Cloud SQL instance. Expected initial customer count is 5030. Allow approximately 30–55 minutes because the migration jobs and initial data copy can take time.
