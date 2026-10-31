# Proposal: five-layer AI-ready scientific documentation architecture

Status: **discussion draft**, not an adopted standard. This proposal extends the existing [master repository](../README.md) without moving or duplicating authoritative assets.

## Purpose

Help people and AI assistants discover scientific resources and trace claims through evidence, protocols, datasets, analytical decisions, code, and outputs. The master repository is a **discovery and governance entry point**, not a replacement for independently maintained repositories.

## Five complementary layers

| Layer | Question | Initial resource | Role |
| --- | --- | --- | --- |
| Evidence | What do we know, and how certain is it? | [tricot-knowledge-base](https://github.com/AgrDataSci/tricot-knowledge-base) | Verified literature, evidence boundaries, citations, expert context |
| Protocols | How were observations generated? | [tricot-protocols](https://github.com/AgrDataSci/tricot-protocols) | SOPs, experimental designs, surveys, traits |
| Data | What was observed? | [tricot-data](https://github.com/AgrDataSci/tricot-data) | Datasets, metadata, access conditions, provenance |
| Analysis | How did observations become results? | [ClimMob-analysis](https://github.com/AgrDataSci/ClimMob-analysis) | Production workflows and separately curated, generalizable analytical examples |
| Integration | How do resources connect to environmental and other data? | Data integration (planned) | Shared identifiers, environmental linkages, interoperability |

The layers are conceptual: a repository may contribute to more than one, but each resource should have an identifiable authoritative location.

## Cross-cutting resource: FAIR and AI-ready analysis template

The [template-repo-data-analysis](https://github.com/AgrDataSci/template-repo-data-analysis) is **not a sixth scientific evidence layer**. It is a reusable project scaffold for creating reproducible analyses across layers. A future revision could include:

- Agent-facing guidance describing capabilities, boundaries, and safe execution.
- Explicit analytical decisions, assumptions, alternatives, diagnostics, and limitations.
- Dependency pinning, tests, example data, and expected results.
- Machine-readable metadata and links to input datasets, protocols, code versions, and outputs.
- Clear distinction between reproducibility of computation and scientific validity of interpretation.

Changes to that template should be developed and reviewed in its own repository.

## Curated analytical examples

Keep operational ClimMob analysis separate from a proposed `examples/` collection of historical scripts that the team chooses to generalize. Each example should state:

1. **Research question and scope:** when the example may or may not apply.
2. **Provenance:** original project, authors, publications, and source code where releasable.
3. **Scientific reasoning:** why the method was chosen, assumptions, plausible alternatives, and relevant literature.
4. **Reproducible implementation:** generalized code, dependencies, safe example inputs, and expected outputs.
5. **Evidence boundaries:** which interpretations are supported, which are exploratory, and what cannot be concluded.
6. **Validation status:** historical illustration, reviewed example, or tested implementation, with evidence for each designation.

An example is **guidance, not a mandatory method or proof of universal suitability**. An AI agent should consider alternatives and should not infer that historical use establishes current best practice. Do not expose participant-level personal information or restricted datasets in examples.

## Proposed traceability chain

`scientific claim → result/output → analytical method and code version → input dataset/version → experimental protocol → supporting evidence`

Links should be bidirectional where practical and use stable identifiers. Each step should disclose missing provenance rather than fabricate a connection.

## Minimum documentation contract (proposal)

For each registered resource, document:

- Name, purpose, maintainer/contact, repository URL, resource type, and status.
- Version or immutable commit reference, release date, citation instructions, and persistent identifier **when available**.
- License and any access or reuse restrictions; documentation and software may require different licenses.
- Inputs, outputs, dependencies, related resources, and provenance.
- Scientific assumptions, uncertainty, limitations, and evidence authority where applicable.
- AI discovery instructions, including when to defer, seek expert review, or avoid executing code.

Machine-readable resource catalogs (e.g. JSON-LD/RO-Crate or CodeMeta where appropriate) are a future implementation option, not a prerequisite to reading the resources.

## FAIR and governance safeguards

- **Findable:** descriptive metadata, discoverable resource catalog, persistent identifiers where assigned.
- **Accessible:** documented access protocols; metadata remain discoverable even when sensitive data cannot be open.
- **Interoperable:** shared identifiers, appropriate vocabularies and ontologies, explicit relationships.
- **Reusable:** provenance, licenses, versioned methods, dependencies, and reproducible examples.

A DOI, README, or passing automated check alone does not establish full FAIR compliance or scientific validity. Distinguish validated evidence, methodological inference, and unknowns. Do not treat a skill file or a repository's institutional affiliation as automatic scientific authority. AI agents must not execute untrusted scripts or disclose restricted information without authorization.

## Proposed next steps

1. Review and approve this architecture before changing the master README.
2. Register the analysis layer and cross-cutting template in the master resource index.
3. Select one historical R script, document its original reasoning, generalize it, and test it with non-sensitive data.
4. Use that pilot to design the next version of the FAIR analysis template.
5. Define validation tests for evidence fidelity, provenance tracing, methodological appropriateness, and honest uncertainty.

This document proposes a structure; it does **not** claim the referenced repositories already meet all requirements.
