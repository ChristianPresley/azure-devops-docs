---
title: Govern and secure Azure Pipelines
description: A reading path for administrators who set up permissions, retention, approvals, and resource protection for Azure Pipelines.
ms.date: 04/29/2026
ms.topic: overview
ms.service: azure-devops
ms.subservice: azure-pipelines
---

# Govern and secure Azure Pipelines

Use this guide to plan the controls that determine **who can change a pipeline**, **what a pipeline run can access**, and **what evidence is kept after a deployment**. Each section links to the deeper reference articles.

## Choose your governance model

Pipeline governance in Azure DevOps is layered. Most administrators configure all four layers for production pipelines.

| Layer | What it protects | Start here |
| --- | --- | --- |
| **People** — Permissions and roles | Who can edit, run, approve, or delete pipelines and their resources | [Pipeline permissions and security roles](../../policies/permissions.md) |
| **Resources** — Approvals and checks | What a pipeline run can consume (environments, service connections, agent pools, variable groups, secure files) | [Define approvals and checks](../../process/approvals.md) |
| **Code** — Repository and template protection | Which repositories and templates a pipeline can extend or pull code from | [Repository resource protection](../../process/repository-resource.md) |
| **Evidence** — Retention | How long runs, artifacts, and logs are kept after completion | [Set retention policies](../../policies/retention.md) |

## Set up permissions and roles

1. **Map identities to groups.** Use built-in groups (Project Administrators, Build Administrators, Release Administrators, Endpoint Administrators) before creating custom groups. See [Add users to contribute to pipelines](../../policies/set-permissions.md).
2. **Set object-level permissions** on individual pipelines, environments, agent pools, service connections, and variable groups. See [Pipeline permissions and security roles](../../policies/permissions.md).
3. **Decide on job authorization scope.** Limit pipelines to the project they live in unless cross-project access is required. See [Job authorization scope](../../process/access-tokens.md#job-authorization-scope).
4. **Review job access tokens.** Pipelines authenticate to Azure DevOps using a project-scoped token (`System.AccessToken`). See [Job access tokens](../../process/access-tokens.md).

## Configure approvals, checks, and gates

Approvals and checks are configured on **resources** (environments, service connections, agent pools, variable groups, secure files), not on pipelines. The resource owner controls them.

| You want to... | Use this check |
| --- | --- |
| Require a person to approve before deployment | [Manual approval check](../../process/approvals.md#approvals) on the environment or service connection |
| Block deployments outside business hours | [Business hours check](../../process/approvals.md#business-hours) |
| Call an Azure Function or REST API to evaluate readiness | [Invoke Azure Function or REST API checks](../../process/invoke-checks.md) |
| Restrict which YAML branches and templates can use a resource | [Branch control check](../../process/approvals.md#branch-control) and [Required template check](../../process/approvals.md#required-template) |
| Use deployment gates in a Classic Release pipeline | [Release gates concepts](../../release/approvals/gates.md) and [Use approvals and gates](../../release/deploy-using-approvals.md) |

> [!NOTE]
> YAML pipelines and Classic Release pipelines have separate approval models. YAML pipelines use [environment and resource checks](../../process/approvals.md). Classic Release pipelines use [pre- and post-deployment approvals](../../release/approvals/approvals.md). Pick the model that matches your pipeline type.

## Protect code and templates

- [Repository resource protection](../../process/repository-resource.md) — restrict which repositories a YAML pipeline can pull code from.
- [Security through templates](../../security/templates.md) — require pipelines to extend a vetted template that enforces required steps.
- [Approach to securing YAML pipelines](../../security/approach.md) — recommendations for template permissions, branch policies, and forks.
- [Secure access to repositories from pipelines](../../security/secure-access-to-repos.md) — control how pipelines authenticate to Azure Repos and external Git.

## Keep the right evidence

- [Set retention policies](../../policies/retention.md) — configure project-level rules for how long runs, artifacts, and logs are kept.
- [Set collection-level retention policies](../../policies/retention.md#set-collection-level-retention-policies) — for Azure DevOps Server administrators.
- [How long are test results kept?](../../../test/how-long-to-keep-test-results.md) — separate retention rules apply to test results and attachments.

## Secure shared resources

- [Manage service connections](../../library/service-endpoints.md), including [permissions](../../policies/permissions.md#service-connection-permissions) and [restrictions](../../library/add-resource-protection.md).
- [Use Microsoft Entra workload identity for service connections](../../library/connect-to-azure.md#use-workload-identity-federation) instead of long-lived secrets.
- [Use Azure Key Vault secrets in Azure Pipelines](../../release/azure-key-vault.md), and for restricted networks, [access a private key vault from your pipeline](../../release/key-vault-access.md).
- [Variable groups](../../library/variable-groups.md) and [secure files](../../library/secure-files.md), including [library permissions](../../policies/permissions.md#library-permissions).

## Audit and review

- [Audit log overview](../../../organizations/audit/azure-devops-auditing.md)
- [Pipeline runs in audit events](../../../organizations/audit/azure-devops-auditing.md)

## Next steps

- [Operate and troubleshoot Azure Pipelines](../operations/index.md)
- [Permissions and security roles reference](../../policies/permissions.md)
- [Secure Azure Pipelines](../../security/overview.md)
