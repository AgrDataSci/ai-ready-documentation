<!-- badges: start -->
[![License](https://img.shields.io/badge/License-CC%20BY%204.0-blue.svg)](https://creativecommons.org/licenses/by/4.0/deed.en)
<!-- badges: end -->

# AI-ready documentation for tricot

> Kauê de Sousa, Brayden Youngberg, Marie-Angélique Laporte, Rachel Chase, Jacob van Etten

Since 2011, the tricot approach has produced on-farm trial data on more than 30 crops in more than 25 countries, standard operating procedures in several languages, and a body of peer-reviewed evidence. These assets were written for people who already know where to look. This repository makes them usable by anyone, and by the AI assistants they increasingly work with.

AI-ready documentation means each asset comes with a lightweight skill that tells an AI assistant what the asset contains, how to use it and how to cite it. A user can then ask how many farms a trial needs, get the answer from our published evidence, follow the matching protocol, and load the open data behind it, all in one conversation. In practice, users interact with the team through its papers, its procedures and its data.

## The repositories

Each layer lives in its own repository, with its own versions, license and DOI. This repository links them.

| Repository | Layer | What it holds | Status |
|---|---|---|---|
| [tricot-knowledge-base](https://github.com/AgrDataSci/tricot-knowledge-base) | Literature | Verified cards for the open-access tricot literature, with an expert skill | Active, skill available |
| [tricot-protocols](https://github.com/AgrDataSci/tricot-protocols) | Methods | Standard operating procedures, surveys and trait metadata, in five languages | Available, skill planned |
| [tricot-data](https://github.com/AgrDataSci/tricot-data) | Data | Harmonized trial data in JSON, archived on Zenodo | Available, skill planned |
| [tricot-analysis-workflows](https://github.com/AgrDataSci/tricot-analysis-workflows) | Analysis | The team's analytical approaches, as curated use cases with decision records on methods and their limits, including how trial data link with climate, soil and other environmental data | Active, skill available |

## How it works

```
                 ai-ready-documentation
          (index of the layers, one entry point)
                           │
   ┌───────────────┬───────┴───────┬────────────────┐
   │               │               │                │
knowledge base  protocols        data            analysis
 what we know   how we do it   what we found   how we reason with it
```

The layers connect through shared identifiers. A paper card names the dataset its findings rest on, a dataset names the protocol that produced it, and protocols and data share trait definitions from the Crop Ontology. An assistant can follow those links from a finding to the trials behind it.

A cross-cutting [template for FAIR and reproducible analysis projects](https://github.com/AgrDataSci/template-repo-data-analysis) supports work across all layers.

## Use it

**Share this one link.** Paste `https://github.com/AgrDataSci/ai-ready-documentation` into an AI assistant with web access and ask your question. The assistant reads [`AGENTS.md`](AGENTS.md) and [`SKILL.md`](SKILL.md), which route the question to the right layer and load only what it needs. The same link keeps working as layers are added.

**In Claude.** Upload this repository's `SKILL.md` as a skill to reach every layer from one place, or download the skill of a single layer from its repository. Each skill loads only a small index and opens detailed files when a question needs them.

**In Claude Code.** This repository will become a plugin marketplace, so a single command installs every layer. Until then, clone the layer repositories into your skills directory.

**With other AI tools or by hand.** Every skill is plain markdown. Start from the `SKILL.md` of the layer you need.

## Principles

- **One repository per layer.** Each stays the single source of truth and keeps its own citation and DOI. Nothing is copied into this repository.
- **The same skeleton everywhere.** Every layer has a `SKILL.md`, a `README.md`, a `CITATION.cff` and a `LICENSE`.
- **Light skills.** Skills travel between users, so they load a short index first and detailed files only on demand. Large source files stay in the repository, out of the skill.
- **Verified content.** Numbers are checked against their sources and carry their primary citation. Uncertainty and disagreement are stated, not smoothed over.
- **Open by default.** Content is released under open licenses, and every skill tells the user how to cite the work it draws on.

## Add a layer

1. Create the repository with the shared skeleton.
2. Write a `SKILL.md` with a short description of when to use it, instructions for the assistant, and an index of the detailed files.
3. Keep the skill under about 20 KB of index, with detail in files opened on demand.
4. Add the repository to the table above, to the routing table in `SKILL.md` and to `llms.txt`.

## Cite

To cite this documentation as a whole, use [`CITATION.cff`](CITATION.cff).

> de Sousa K, Chase R, Youngberg B, van Etten J (2026). AI-ready documentation for tricot. Linked literature, protocols and data for decentralized on-farm testing. Version 0.1.0. https://github.com/AgrDataSci/ai-ready-documentation

When you use a specific layer, cite that repository too, and cite the original papers for any finding.

## License

Documentation in this repository is released under [CC BY 4.0](LICENSE). Each linked repository sets its own license.
