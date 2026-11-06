# Changelog

This file records every release and every correction. Corrections never replace past content silently. Each entry under Corrections says what changed, why, and which commit changed it. See [`PROVENANCE.md`](PROVENANCE.md) for the policy.

Changes made before this file existed are recorded in the [commit history](https://github.com/AgrDataSci/maniva/commits/main).

## 1.1.0 (2026-11-06)

First release archived on Zenodo. Adds the website, broadens maniva beyond tricot and updates the author list.

### Added

- A "Test maniva" page on the website (`site/test.html`) that walks alpha testers through five steps, from sharing the link to sending feedback, with example questions checked against the published layers.
- A "Talk to the team" section on the website, with institutional contacts for Kauê de Sousa, Marie-Angélique Laporte and Jacob van Etten, who agreed to be listed as contacts in the tricot-knowledge-base people file.
- A website in `site/`, published to GitHub Pages at https://agrdatasci.github.io/maniva/ by the `pages` workflow. It explains the four layers, routes example questions to them, and shows the live version from `version.json`.

### Changed

- The descriptor is now "AI-ready documentation for agricultural research", replacing "AI-ready documentation for tricot", in `README.md`, `SKILL.md`, `AGENTS.md`, `llms.txt`, `metadata/naming.md` and the website. tricot is presented as the first domain and climate and household data as next. The README and the website now open with the problem maniva solves.

## 1.0.0 (2026-11-05)

First production release. The four layers (knowledge base, protocols, data, analysis) are linked from one entry point, and the citation, naming and history policies are in place.

### Added

- `PROVENANCE.md`, the policy against rewriting history and the instructions to verify it.
- `tools/verify-history.sh`, a script that compares the history of `main` and every tag with the snapshots held by Software Heritage.
- The `verify-history` workflow, which runs that script on every push, release and week, and asks Software Heritage to archive the current state.
- Rulesets in `.github/rulesets` that block force pushes, branch deletion and tag changes.
- A naming rule in `AGENTS.md`, `SKILL.md` and `llms.txt`. maniva and tricot are always lowercase, and tricot stands for triadic comparison of technology options.
- The R packages and the analysis template now sit under the analysis layer, in the README diagram and table, the routing table in `SKILL.md` and `llms.txt`. The template was previously described as cross-cutting.

### Changed

- `CITATION.cff` has the new title "maniva. An open commons of evidence, protocols, data and analysis for agricultural research", a rewritten abstract and the keywords tricot, product testing and Crop Ontology. The README citation matches it.

### Corrections

- Marie-Angélique Laporte's given name in `CITATION.cff` repeated her surname (`Marie-Angélique Laporte`), so citations showed it twice. It now reads `Marie-Angélique`.
