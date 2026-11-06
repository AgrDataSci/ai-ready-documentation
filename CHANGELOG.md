# Changelog

This file records every release and every correction. Corrections never replace past content silently. Each entry under Corrections says what changed, why, and which commit changed it. See [`PROVENANCE.md`](PROVENANCE.md) for the policy.

Changes made before this file existed are recorded in the [commit history](https://github.com/AgrDataSci/maniva/commits/main).

## Unreleased

### Changed

- On the website, the "Test the alpha" offer is now "Give feedback", so it no longer repeats the "Test it" menu item, and the menu text is larger.
- The "Work with us" section is now "Collaborate", in the order Try maniva, Contribute data, Partner or fund. "Try maniva" links to the test guide.
- The test guide's last step now holds the report prompt, with a copy button, so testers have it before they open the feedback form.
- Jacob van Etten's profile in "Talk to the team" now gives his focus areas next to his role as Director, Digital Inclusion.
- The website menu has one "Use it" item instead of "Use it" and "Test it". The guide is now "Use maniva" at `site/use.html`, replacing `site/test.html`, and the short three-step section on the home page links to it.
- The profiles of Kauê de Sousa and Marie-Angélique Laporte in "Talk to the team" now open with their roles, like Jacob van Etten's.

## 1.0.0 (2026-11-06)

First release, archived on Zenodo. The four layers (knowledge base, protocols, data, analysis) are linked from one entry point, maniva is titled an open commons of evidence, protocols, data and analysis for agricultural research, with tricot as its first domain, and the citation, naming and history policies are in place.

### Added

- A website in `site/`, published to GitHub Pages at https://agrdatasci.github.io/maniva/ by the `pages` workflow. It explains the four layers, routes example questions to them, shows the live version from `version.json`, and links the forms to propose data and send feedback.
- A "Test maniva" page (`site/test.html`) that walks alpha testers through five steps, from sharing the link to sending feedback, with example questions checked against the published layers.
- A "Talk to the team" section on the website, with institutional contacts for Kauê de Sousa, Marie-Angélique Laporte and Jacob van Etten, who agreed to be listed as contacts in the tricot-knowledge-base people file.
- `PROVENANCE.md`, the policy against rewriting history and the instructions to verify it.
- `tools/verify-history.sh`, a script that compares the history of `main` and every tag with the snapshots held by Software Heritage.
- The `verify-history` workflow, which runs that script on every push, release and week, and asks Software Heritage to archive the current state.
- Rulesets in `.github/rulesets` that block force pushes, branch deletion and tag changes.
- A naming rule in `AGENTS.md`, `SKILL.md` and `llms.txt`. maniva and tricot are always lowercase, and tricot stands for triadic comparison of technology options.
- `metadata/layer-guidance.md`, with the traceability chain, documentation checklist and FAIR safeguards for every layer.

### Changed

- The title is "maniva. An open commons of evidence, protocols, data and analysis for agricultural research" everywhere, matching `CITATION.cff` and the Zenodo record. It replaces the working descriptor "AI-ready documentation for tricot" in `README.md`, `SKILL.md`, `AGENTS.md`, `llms.txt`, `metadata/naming.md` and the website title. "AI-ready" stays as a keyword. tricot is presented as the first domain, and climate and household data as next.
- `README.md` leads with the problem maniva solves, the worked example and how to use it. The tricot background opens the repositories section, and "Why maniva?" sits near the end as one paragraph. The website follows the same order.
- The website offers one way to use maniva, pasting the maniva link into an AI assistant with web access. The README keeps the other routes for technical users.
- The R packages and the analysis template sit under the analysis layer, in the README diagram and table, the routing table in `SKILL.md` and `llms.txt`. The template was previously described as cross-cutting.
- `CITATION.cff` has the title "maniva. An open commons of evidence, protocols, data and analysis for agricultural research", a rewritten abstract, the website URL and an updated keyword list. The authors are Kauê de Sousa, Marie-Angélique Laporte, Brayden Youngberg, Almendra Cremaschi, Rachel Chase and Jacob van Etten. The README and website citations match it.
- `metadata/naming.md` states the decision and its reasons first, then the tests and the names set aside.
- `PROVENANCE.md` states its main claim in the opening, flags the protections that are still pending right after the commitments, and folds "Independent verification" into "Check it yourself".

### Removed

- `proposals/five-layer-architecture.md`, a discussion draft superseded when the integration layer was folded into the analysis layer. Its guidance moved to `metadata/layer-guidance.md`, and the full draft remains in the history at commit `e2927e5`.

### Corrections

- Marie-Angélique Laporte's given name in `CITATION.cff` repeated her surname (`Marie-Angélique Laporte`), so citations showed it twice. It now reads `Marie-Angélique`.
