# Simple Vault Validation Pipeline
The intent of this repository/demo is to provide an example of a validation pipeline that can be used in the operational management of Vault.

Validation pipelines can be used to automate the execution of number of tasks, such as:

- New Versions/Bug Fixes
- Configuration Changes
- Consumer Use Cases
- Vault Benchmarking

Traditionally, these tasks have been performed manually by operations teams, spending anywhere from hours to weeks manually building and testing a production replica. With tools available today, these workflows can be automated, reducing the amount of time and human error that tend to be present with manual intervention.

At a high level, a validation pipeline process looks something like this:

 - A change is committed/pushed to a code repository where all configuration for Vault is being stored.
 - A CI/CD tool detects the change in the repository and begins the build process.
 - A Vault cluster is deployed, using the same specifications as the production cluster(s).
 - A snapshot of production data is restored to the new Vault cluster.
 - A number of validation tests are executed against the new Vault cluster, mimicing production workloads.
 - The test results are posted to the CI/CD tool and the new Vault cluster is deprovisioned.

## Dependencies
This demonstration currently follows some of the benchmarking instructions created by Stenio Ferreira here:

https://medium.com/hashicorp-engineering/hashicorp-vault-performance-benchmark-13d0ea7b703f

The above instructions utilize benchmarking scripts created by Roger Berlind that can be found here:

https://github.com/hashicorp/vault-guides/tree/master/operations/benchmarking/wrk-core-vault-operations

The specific pieces used for this pipeline are:

 - Cloud Provider: DigitalOcean
 - CI/CD Provider: CircleCI
 - Infrastructure Provisioning: Terraform 0.14.10
 - Configuration Management: SaltStack
 - Benchmarking: LuaJit and wrk (built for CentOS 8, included in files directory)
 - Script/Salt Execution: Python3

## Detailed Process
This demonstration currently executes the following process:

 - A change is committed/pushed to this repo.
 - CircleCI detects the change, creates a new container/workspace, and begins the build process.
 - A container is launched, the repository is cloned, and the Terraform provisioning begins.
 - Two hosts are created: one Vault host and one benchmarking hosts.
 - The Vault hosts is bootstrapped using Terraform provisioners and SaltStack.
 - The benchmarking host is bootstrapped using Terraform provisioners.
 - Vault is automatically initialized and unsealed. The unseal key/root token are stored in a file in /root.
 - A 'loadtester' user is created in Vault and assigned a simple policy.
 - DNS entries are created for both hosts.
 - The build container is destroyed, but the workspace is set to persist in CircleCI.
 - A new CircleCI container is launched that logs into the benchmarking hosts and executes a Python script to run the benchmark test, then checks the output of that test.
 - The container is destroyed in CircleCI
 - A new CircleCI container is launched using the persistent workspace previously saved.
 - 'Terraform destroy' is executed to delete the two hosts and all associated DNS records.
 - The build completes.

## Planned Changes
I intend to expand this demonstration out in a manner that would mimic a full production simulataion. Below is a list of items that will bring it to that point:

 - Expand Vault Cluster to 5 Nodes with Raft Peering
 - Restore a Snapshot
 - Create Additional Use Cases for Testing
