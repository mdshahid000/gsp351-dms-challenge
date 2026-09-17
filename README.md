# GSP351 — Fresh Lab Task-wise Scripts

Fresh lab values: source VM `prd-fin-lf4`, one-time target `mysql-fin-lf4`, continuous target `mysql-fin-lf4-cont`, region `europe-west1`, zone `europe-west1-b`.

Run in order:

```bash
curl -fsSLO https://raw.githubusercontent.com/mdshahid000/gsp351-dms-challenge/master/01_task1_create_connection_profile.sh && chmod +x 01_task1_create_connection_profile.sh && ./01_task1_create_connection_profile.sh
curl -fsSLO https://raw.githubusercontent.com/mdshahid000/gsp351-dms-challenge/master/02_task2_one_time_migration.sh && chmod +x 02_task2_one_time_migration.sh && ./02_task2_one_time_migration.sh
curl -fsSLO https://raw.githubusercontent.com/mdshahid000/gsp351-dms-challenge/master/03_task3_continuous_migration.sh && chmod +x 03_task3_continuous_migration.sh && ./03_task3_continuous_migration.sh
curl -fsSLO https://raw.githubusercontent.com/mdshahid000/gsp351-dms-challenge/master/04_task4_verify_replication.sh && chmod +x 04_task4_verify_replication.sh && ./04_task4_verify_replication.sh
curl -fsSLO https://raw.githubusercontent.com/mdshahid000/gsp351-dms-challenge/master/05_task5_promote_destination.sh && chmod +x 05_task5_promote_destination.sh && ./05_task5_promote_destination.sh
```

Important: Tasks 2 and 3 scripts are preflight/checklist scripts. Complete the DMS destination selection in the Google Cloud console exactly as the lab requires: choose Existing instance, not a new destination profile. Task 2 uses `mysql-fin-lf4` and IP allowlist/static IP. Task 3 uses `mysql-fin-lf4-cont` and VPC peering with the `default` VPC. Do not run generic `gcloud connection-profiles create` commands for the existing target instances.

Wait for Task 2 to finish and verify 5030 rows before creating Task 3. Wait for Task 3 to reach Running before Task 4. After Task 4 replication is verified, run Task 5 promotion. Approximate total time is 30–55 minutes.
