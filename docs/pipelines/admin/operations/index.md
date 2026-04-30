---
title: Operate and troubleshoot Azure Pipelines
description: A reading path for administrators who run Azure Pipelines day to day, including capacity planning, agent management, and triage.
ms.date: 04/29/2026
ms.topic: overview
ms.service: azure-devops
ms.subservice: azure-pipelines
---

# Operate and troubleshoot Azure Pipelines

Use this guide to keep Azure Pipelines healthy after you set them up. It covers the most common operator tasks: planning capacity, managing agents, monitoring usage, and triaging the pipelines that aren't running.

## Plan and right-size capacity

1. **Understand what consumes a parallel job.** Each running job consumes one parallel-job slot for its duration. See [Configure and pay for parallel jobs](../../licensing/concurrent-jobs.md).
2. **Pick a hosting model.**
   - [Microsoft-hosted agents](../../agents/hosted.md) — fastest to start, no maintenance, billed per parallel job. Choose this when your jobs run from public-network endpoints.
   - [Self-hosted agents](../../agents/agents.md#self-hosted-agents) — full control over the OS, network access, installed software, and caches. Choose this when jobs need access to private resources or custom tooling.
   - [Managed DevOps Pools](/azure/devops/managed-devops-pools/overview) — Microsoft-managed self-hosted agents that scale on demand inside your network.
   - [Scale set agents](../../agents/scale-set-agents.md) — auto-scaling self-hosted agents backed by an Azure Virtual Machine Scale Set.
3. **Right-size your concurrency.** Use the [agent pool consumption report](../../agents/pool-consumption-report.md) to see how many parallel jobs are in use and where queue waits appear. Buy more parallel jobs only after the report confirms a sustained ceiling.

## Manage agent pools

- [Create and manage agent pools](../../agents/pools-queues.md) — including project-level queues vs collection-level pools.
- [Agent pool security](../../policies/permissions.md#set-agent-pool-security-in-azure-pipelines) — control which projects and pipelines can use a pool.
- [Microsoft-hosted agent images](../../agents/hosted.md#software) — what's preinstalled on each Microsoft-hosted image.
- [Self-hosted agent installation](../../agents/agents.md#install) — Linux, macOS, Windows, and Docker.
- [Update agents](../../agents/agents.md#update-agents) and the [agent deprecation schedule](../../agents/agents.md#agent-version-and-upgrades).

## Monitor pipelines and agents

- [View agent pool consumption](../../agents/pool-consumption-report.md) — current and historical concurrency.
- [View pipeline reports](../../reports/pipelinereport.md) — failure rate, duration, and pass rate per pipeline.
- [Monitor pipelines with dashboard widgets](../../reports/pipeline-widgets.md) — surface health on team dashboards.
- [Pipeline run sequence](../../process/runs.md) — what happens at queue, dispatch, and execution.

## Triage common operator problems

| Symptom | Start here |
| --- | --- |
| Pipeline queues but never runs | [Pipeline queues but never starts](../../troubleshooting/troubleshoot-start.md) |
| Pipeline didn't trigger from a commit, PR, or schedule | [Troubleshoot pipeline triggers](../../troubleshooting/troubleshoot-triggers.md) |
| A run failed and you need the full picture | [Review logs](../../troubleshooting/review-logs.md) and [Troubleshoot pipeline runs](../../troubleshooting/troubleshooting.md) |
| Azure Resource Manager service connection won't authenticate | [Troubleshoot Azure Resource Manager service connections](../../release/azure-rm-endpoint.md) |
| Workload identity service connection won't authenticate | [Troubleshoot workload identity service connections](../../release/troubleshoot-workload-identity.md) |
| Web App deployment task failing | [Troubleshoot Azure Web App deployment](../../troubleshooting/troubleshoot-azure-web-app-deploy.md) |
| Self-hosted agent quarantined by antivirus | [Antivirus exclusions](../../troubleshooting/anti-virus-exclusion.md) |

## Operate Azure DevOps Server (on-premises)

If you administer Azure DevOps Server rather than Azure DevOps Services, also see:

- [Configure parallel jobs on Azure DevOps Server](../../licensing/concurrent-jobs.md?view=azure-devops-2022&preserve-view=true)
- [Set collection-level retention policies](../../policies/retention.md#set-collection-level-retention-policies)

## Next steps

- [Govern and secure Azure Pipelines](../governance/index.md)
- [Pipeline permissions and security roles](../../policies/permissions.md)
- [Pipeline run sequence](../../process/runs.md)
