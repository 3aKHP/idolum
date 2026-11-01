# Integrate upstream v0.5.0 into Idolum

Status: done

Base: `58d53286855a626b6e999831ec40ce6dc382e238`.
Upstream: `Sallyn0225/eidolon-sc`, main `f6cee74b17c59a6da49ae17888b5ff38f54ed3fb` (2026-11-01, v0.5.0).
Branch: `maintenance/upstream-v0.5.0`.

The user selected “尽量追上上游全部功能” after the upstream audit. Integrate the complete upstream main using a merge, preserving its history and all product features. The user subsequently authorized committing and pushing the integration branch on 2026-11-01. Preserve the merge history; publish the branch and verify CI. Release and deployment remain outside this task.

## Scope

Import retrieval caching, TLS reuse, parallel tests/CI, dependency corrections, calendar and schedules, slower affinity progression, retirement of daily tasks, cycles, the VA-283 bar, official asset fallback, deployment diagnostics, invitation registration, development-login administration, read-aloud, moments, weather, letters, and their upstream tests/documentation/assets. Use upstream defaults; do not enable paid features or modify the deployment's .env/database.

Preserve Idolum's repository links, GHCR images, removed fork-showcase automation, accepted independent ADRs 0029–0031, frozen eidolon package/environment/volume identifiers, and any dependency versions already newer locally. Imported ADRs 0029–0032 become 0032–0035; update their links and code references. Keep upstream attribution.

Regenerate HTTP and SQLite contracts from the integrated backend in an isolated temporary environment. Keep the pre-import oracle's historical identity and Go-deviation ledger; record the imported upstream revision alongside the current snapshot. The data-package format now follows upstream version 5.

## Validation

Run the repository's affected checks against the pinned base (backend Ruff/Pyright/affected pytest, frontend typecheck/related Vitest), the frontend discipline and scratch checks, a production frontend build, shell syntax checks, and browser smoke acceptance on an isolated development backend using fake outside services. Confirm no unresolved Git conflicts, unique ADR numbers, and the preserved repository/registry/workflow settings. Tests and acceptance must not use production data or real paid APIs.

The audit found 293 upstream commits (263 non-merge), touching 895 files. Next.js 16.4.1 and undici 7.30.1 already existed locally; final manifests/locks preserve newer local versions while including upstream additions.
