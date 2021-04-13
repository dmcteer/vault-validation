# Simple Vault Validation Pipeline
The intent of this repository/demo is to provide an example of a validation pipeline that can be used in the operational management of Vault.

Validation pipelines can be used to automate the execution of number of tasks, such as:

- New Versions/Bug Fixes
- Configuration Changes
- Consumer Use Cases

Traditionally, these tasks have been performed manually by operations teams, spending anywhere from hours to weeks manually building and testing a production replica. With tools available today, these workflows can be automated, reducing the amount of time and human error that tend to be present with manual intervention.

At a high level, a validation pipeline process looks something like this:

 - A change is committed/pushed to a code repository where all configuration for Vault is being stored.
 - A CI/CD tool detects the change in the repository and begins the build process.
 - A Vault cluster is deployed, using the same specifications as the production cluster(s).
 - A snapshot of production data is restored to the new Vault cluster.
 - A number of validation tests are executed against the new Vault cluster, mimicing production workloads.
 - The test results are posted to the CI/CD tool and the new Vault cluster is deprovisioned.

## Detailed Process



## Planned Changes
I intend to expand this demonstration out in a manner that would mimic a full production simulataion. Below is a list of items that will bring it to that point:

 - Expand Vault Cluster to 5 Nodes with Raft Peering
 - Restore a Snapshot
 - Create Additional Use Cases for Testing
