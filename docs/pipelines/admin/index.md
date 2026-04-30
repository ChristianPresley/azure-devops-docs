---
title: Administer Azure Pipelines
description: Find administrator and operator guidance for Azure Pipelines capacity, agents, permissions, service connections, governance, security, and troubleshooting.
ms.date: 04/29/2026
ms.topic: overview
ms.service: azure-devops
ms.subservice: azure-pipelines
---

# Administer Azure Pipelines

Azure Pipelines administrators set up the resources, permissions, and controls that teams use to build, test, and deploy software. Use this guide to find the operational docs for planning capacity, managing agents, securing shared resources, and troubleshooting pipeline operations.

## Plan capacity and agents

- [Configure and pay for parallel jobs](../licensing/concurrent-jobs.md)
- [Azure Pipelines agents](../agents/agents.md)
- [Create and manage agent pools](../agents/pools-queues.md)
- [View agent pool consumption](../agents/pool-consumption-report.md)
- [Microsoft-hosted agents](../agents/hosted.md)
- [Self-hosted agents](../agents/agents.md#self-hosted-agents)
- [Scale set agents](../agents/scale-set-agents.md)

## Manage access and permissions

- [Add users to contribute to pipelines](../policies/permissions.md)
- [Manage pipeline permissions](../policies/permissions.md)
- [Job access tokens](../process/access-tokens.md)
- [Service connection permissions](../policies/permissions.md#service-connection-permissions)
- [Agent pool permissions](../policies/permissions.md#agent-pool-permissions)
- [Environment permissions](../policies/permissions.md#environment-permissions)

## Configure service connections and shared resources

- [Manage service connections](../library/service-endpoints.md)
- [Connect to Azure with an Azure Resource Manager service connection](../library/connect-to-azure.md)
- [Access Azure DevOps with Microsoft Entra workload identity](../library/add-devops-entra-service-connection.md)
- [Manage variable groups](../library/variable-groups.md)
- [Use secure files](../library/secure-files.md)
- [Define and target environments](../process/environments.md)

## Govern and secure pipelines

For the full reading path on permissions, retention, approvals, repository protection, and secret handling, see [Govern and secure Azure Pipelines](governance/index.md).

Quick links:

- [Set retention policies](../policies/retention.md)
- [Define approvals and checks (YAML)](../process/approvals.md) or [Release gates and approvals (Classic)](../release/approvals/index.md)
- [Secure Azure Pipelines](../security/overview.md)

## Monitor and troubleshoot

For the full reading path on capacity reporting, agent management, and triage of common operator problems, see [Operate and troubleshoot Azure Pipelines](operations/index.md).

Quick links:

- [Pipeline queues but never starts](../troubleshooting/troubleshoot-start.md)
- [Troubleshoot pipeline triggers](../troubleshooting/troubleshoot-triggers.md)
- [Troubleshoot pipeline runs](../troubleshooting/troubleshooting.md)
- [Review logs](../troubleshooting/review-logs.md)
- [View pipeline reports](../reports/pipelinereport.md)

## See also

- [Key concepts for Azure Pipelines](../get-started/key-pipelines-concepts.md)
- [YAML vs Classic pipelines](../get-started/pipelines-get-started.md)
- [YAML schema reference](/azure/devops/pipelines/yaml-schema/)
