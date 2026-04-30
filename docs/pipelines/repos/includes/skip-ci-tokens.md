---
ms.topic: include
ms.service: azure-devops-pipelines
ms.author: chcomley
author: chcomley
ms.date: 04/30/2026
---

You can tell Azure Pipelines to skip running a pipeline that a push would normally trigger. Just include `[skip ci]` in the message or description of any of the commits that are part of a push, and Azure Pipelines will skip running CI for this push. You can also use any of the following variations.

- `[skip ci]` or `[ci skip]`
- `skip-checks: true` or `skip-checks:true`
- `[skip azurepipelines]` or `[azurepipelines skip]`
- `[skip azpipelines]` or `[azpipelines skip]`
- `[skip azp]` or `[azp skip]`
- `***NO_CI***`
