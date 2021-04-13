# Simple Vault Validation Pipeline
The intent of this repository/demo is to provide an example of a validation pipeline that can be used in the operational management of Vault.

Validation pipelines can be used to perform the evaluation of number of tasks, such as:

- New Versions/Bug Fixes
- Configuration Changes
- Untested Use Cases

Traditionally, these tasks have been performed manually by operations teams, spending anywhere from hours to weeks manually building and testing a production replica. With tools available today, these workflows can be automated, reducing the amount of time and human error that tend to be present with manual intervention.


## Planned Changes
I intend to expand this demonstration out in a manner that would mimic a full production simulataion. Below is a list of items that will bring it to that point:

 - Expand Vault Cluster to 5 Nodes with Raft Peering
 - Restore a Snapshot
 - Create Additional Use Cases for Testing
