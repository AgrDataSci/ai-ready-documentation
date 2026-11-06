# Provenance and history

maniva points people and AI assistants to evidence, protocols and data. That only works if the record is honest about its own past. You can trust maniva's history because anyone can compare it with an independent archive we do not control. We do not rewrite history, and we do not ask you to take our word for it.

## What we commit to

1. **The history of `main` is append-only.** We add commits. We never force-push, rebase or delete `main`, so every past state of the repository stays reachable.
2. **Release tags never move or disappear.** A version number always points to the same content.
3. **Corrections are new commits, never silent edits.** When something turns out to be wrong, we fix it in a new commit and record it under Corrections in [`CHANGELOG.md`](CHANGELOG.md), with what changed, why, and the commit that changed it. Content we withdraw is marked as withdrawn. It leaves the current version but stays in the history.
4. **Independent archives hold copies we cannot change.** [Software Heritage](https://www.softwareheritage.org) archives the repository, and every release gets a DOI on [Zenodo](https://zenodo.org). Neither archive lets us alter what it already holds.
5. **The checks are public and automatic.** A workflow compares our history with the independent archive on every push, on every release and every week. Anyone can read its logs and anyone can run the same check.

Signed release tags are the one protection still planned. [Current status](#current-status) shows where each one stands.

### The one exception, stated in advance

If personal data, credentials or material we have no right to publish ever enters the history, the law or our duty to the people concerned may require us to remove it from past commits. That is the only case in which we would rewrite history. If it happens, we will record the date, the reason, the affected files and the old and new commit IDs here and in `CHANGELOG.md`, so the rewrite itself is on the record. The verification check below will flag it, and it should.

## Why this can be checked

Git identifies every commit by a hash of its content and of the commit before it. Change one old commit and every commit after it gets a new ID. A rewrite therefore cannot hide. It shows as soon as anyone compares the current history with a copy taken earlier.

Software Heritage takes those earlier copies. It is a public archive founded by Inria in partnership with UNESCO, and it collects public source code on its own schedule and keeps every snapshot it takes. We do not control it. When it has archived this repository, it becomes a witness that holds commit IDs we cannot reach.

## Check it yourself

You need `git`, `curl`, `jq` and a shell.

```bash
git clone https://github.com/AgrDataSci/maniva
cd maniva
bash tools/verify-history.sh
```

The script asks Software Heritage for every snapshot it has of this repository, under its current name and its former name (`ai-ready-documentation`). It then checks two things.

- Every commit that Software Heritage saw at the tip of `main` is still part of `main` today.
- Every tag that Software Heritage saw still exists and still points to the same object.

`PASS` on every line means the history you cloned extends, and never contradicts, every independent snapshot. `FAIL` means the history differs from what was archived, and the line says where and when. The script only reads. It changes nothing in your clone.

You can also check by hand. Search for the repository on the [Software Heritage archive](https://archive.softwareheritage.org), open any past visit, and compare the commit ID shown for `main` with `git log` in your clone. Every ID it shows must appear in that log.

We welcome anyone, including partner institutions, to run the check and publish the result. If a check fails or you find a change that is not in `CHANGELOG.md`, please open an issue. We will answer in public.

## Automated checks

The [verify-history](.github/workflows/verify-history.yml) workflow runs the same script on every push to `main`, on every release and every Monday. The badge in the [README](README.md) shows its latest result, and every run's log is public under the Actions tab. After each release and each weekly run, the workflow asks Software Heritage to archive the current state, so the next run has a fresh witness.

The badge is not a seal we award ourselves. It reports the outcome of a check that anyone can rerun and that compares our history with an archive we do not control.

## Branch and tag protection

Two repository rulesets enforce the first two commitments on GitHub. Their definitions are in [`.github/rulesets`](.github/rulesets), so anyone can see exactly what is enforced.

- `protect-main-history` blocks force pushes to `main` and its deletion.
- `protect-release-tags` blocks moving or deleting any tag.

Neither ruleset has a bypass, including for repository administrators. Ordinary commits and merged pull requests still reach `main`, and the automated version stamp still works, because none of them rewrites history.

## Scope

This policy covers maniva. Each layer repository adopts it as it publishes releases. For data, each release of tricot-data will also carry a checksum file, so anyone can confirm that a downloaded file is identical to the archived one.

## Current status

| Commitment | Status |
|---|---|
| Rulesets on `main` and tags | Active |
| verify-history workflow | Active from the merge of this file |
| First Software Heritage snapshot | Taken on 6 November 2026 |
| Zenodo DOI per release | Active from 1.0.0, concept DOI [10.5281/zenodo.24011051](https://doi.org/10.5281/zenodo.24011051) |
| Signed release tags | Planned |
| Corrections log in `CHANGELOG.md` | Active |

We update this table when a status changes, and the change itself stays in the history.
