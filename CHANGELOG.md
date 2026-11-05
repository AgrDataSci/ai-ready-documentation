# Changelog

This file records every release and every correction. Corrections never replace past content silently. Each entry under Corrections says what changed, why, and which commit changed it. See [`PROVENANCE.md`](PROVENANCE.md) for the policy.

Changes made before this file existed are recorded in the [commit history](https://github.com/AgrDataSci/maniva/commits/main).

## Unreleased

### Added

- `PROVENANCE.md`, the policy against rewriting history and the instructions to verify it.
- `tools/verify-history.sh`, a script that compares the history of `main` and every tag with the snapshots held by Software Heritage.
- The `verify-history` workflow, which runs that script on every push, release and week, and asks Software Heritage to archive the current state.
- Rulesets in `.github/rulesets` that block force pushes, branch deletion and tag changes.

### Corrections

None.
