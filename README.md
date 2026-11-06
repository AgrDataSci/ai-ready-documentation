<!-- badges: start -->
[![ProjStatus](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![License](https://img.shields.io/badge/license-CC%20BY%204.0-blue.svg)](https://creativecommons.org/licenses/by/4.0/)
[![History verified](https://github.com/AgrDataSci/maniva/actions/workflows/verify-history.yml/badge.svg)](PROVENANCE.md)
<!-- badges: end -->

<p align="center"><img src="docs/logo/maniva-logo-horizontal.svg" alt="maniva" width="380"></p>

# maniva

*AI-ready documentation for agricultural research*

Visit the website at [agrdatasci.github.io/maniva](https://agrdatasci.github.io/maniva/).

> Kauê de Sousa, Marie-Angélique Laporte, Brayden Youngberg, Almendra Cremaschi, Rachel Chase, Jacob van Etten

Agricultural research produces papers, protocols, data and code, but they sit in separate places with nothing linking them. Using them well takes an insider, someone who knows which paper backs a method, which protocol produced a dataset and which script analyses it. Breeders in national programmes, students, modellers, other research teams and funders have to ask that insider. AI assistants fill the gap with generic or invented answers. maniva links these assets and documents them so that anyone, and any AI assistant, can use them without the insider.

AI-ready documentation means each asset comes with a lightweight skill that tells an AI assistant what the asset contains, how to use it and how to cite it. A user of tricot, the on-farm testing approach that is maniva's first domain, can then ask how many farms a trial needs, get the answer from our published evidence, follow the matching protocol, and load the open data behind it, all in one conversation.

## Use it

**Share this one link.** Copy the link below, paste it into an AI assistant with web access and ask your question.

```text
https://github.com/AgrDataSci/maniva
```

The assistant reads [`AGENTS.md`](AGENTS.md) and [`SKILL.md`](SKILL.md), which route the question to the right layer and load only what it needs. The same link keeps working as layers are added.

**In Claude.** Upload this repository's `SKILL.md` as a skill to reach every layer from one place, or download the skill of a single layer from its repository. Each skill loads only a small index and opens detailed files when a question needs them.

**In Claude Code.** This repository will become a plugin marketplace, so a single command installs every layer. Until then, clone the layer repositories into your skills directory.

**With other AI tools or by hand.** Every skill is plain markdown. Start from the `SKILL.md` of the layer you need.

## The repositories

tricot (triadic comparison of technology options) is the first domain. Since 2011 it has produced on-farm trial data on more than 30 crops in more than 25 countries, standard operating procedures in several languages and a body of peer-reviewed evidence. Climate data come next. CHIRPS rainfall, CHIRTS temperature and RHOMIS household data are being integrated with the Climate Action team, for use with tricot trials or on their own. Further domains join as they meet the same standards.

Each layer lives in its own repository, with its own versions, license and DOI. This repository links them.

| Repository | Layer | What it holds | Status |
|---|---|---|---|
| [tricot-knowledge-base](https://github.com/AgrDataSci/tricot-knowledge-base) | Literature | Verified cards for the open-access tricot literature, with an expert skill | Active, skill available |
| [tricot-protocols](https://github.com/AgrDataSci/tricot-protocols) | Methods | Standard operating procedures, surveys and trait metadata, in five languages | Available, skill planned |
| [tricot-data](https://github.com/AgrDataSci/tricot-data) | Data | Harmonized trial data in JSON, archived on Zenodo | Available, skill planned |
| [tricot-analysis-workflows](https://github.com/AgrDataSci/tricot-analysis-workflows) | Analysis | The team's analytical approaches, as curated use cases with decision records on methods and their limits, including how trial data link with climate, soil and other environmental data | Active, skill available |
| [gosset](https://github.com/AgrDataSci/gosset), [ClimMobTools](https://github.com/AgrDataSci/ClimMobTools), [climatrends](https://github.com/AgrDataSci/climatrends), [chirps](https://github.com/AgrDataSci/chirps) and [ClimMob-analysis](https://github.com/AgrDataSci/ClimMob-analysis) | Analysis | The R packages the workflows run on, for ranking models, ClimMob data, climate indices and rainfall, plus the workflow behind ClimMob reports | Active, packages on CRAN, report workflow on GitHub |
| [template-repo-data-analysis](https://github.com/AgrDataSci/template-repo-data-analysis) | Analysis | A template for FAIR and reproducible analysis projects, with decision records, tests and provenance linking outputs to data, protocols and evidence | Active, skill available |

## How it works

```
                         maniva
          (index of the layers, one entry point)
                           │
   ┌───────────────┬───────┴───────┬────────────────┐
   │               │               │                │
knowledge base  protocols        data            analysis
 what we know   how we do it   what we found   how we reason with it
                                                    │
                                   ┌────────────────┼────────────────┐
                                   │                │                │
                               workflows        R packages        template
                             use cases and    gosset and the    reproducible
                            decision records  ClimMob suite     FAIR projects
```

The layers connect through shared identifiers. A paper card names the dataset its findings rest on, a dataset names the protocol that produced it, and protocols and data share trait definitions from the Crop Ontology. An assistant can follow those links from a finding to the trials behind it.

The analysis layer has three parts. The workflows say which method to use and why, the R packages run it, and the template packages a new analysis so others can rerun, trace and cite it. The template draws on the other layers too, since its provenance entries link each output to the data, protocol and evidence behind it.

## Principles

- **One repository per layer.** Each stays the single source of truth and keeps its own citation and DOI. Nothing is copied into this repository.
- **The same skeleton everywhere.** Every layer has a `SKILL.md`, a `README.md`, a `CITATION.cff` and a `LICENSE`.
- **Light skills.** Skills travel between users, so they load a short index first and detailed files only on demand. Large source files stay in the repository, out of the skill.
- **Verified content.** Numbers are checked against their sources and carry their primary citation. Uncertainty and disagreement are stated, not smoothed over.
- **History is never rewritten.** Corrections are new commits logged in [`CHANGELOG.md`](CHANGELOG.md), and anyone can check our history against an independent archive. See [`PROVENANCE.md`](PROVENANCE.md).
- **Open by default.** Content is released under open licenses, and every skill tells the user how to cite the work it draws on.

## Add a layer

1. Create the repository with the shared skeleton.
2. Write a `SKILL.md` with a short description of when to use it, instructions for the assistant, and an index of the detailed files.
3. Keep the skill under about 20 KB of index, with detail in files opened on demand.
4. Add the repository to the table above, to the routing table in `SKILL.md` and to `llms.txt`.

[`metadata/layer-guidance.md`](metadata/layer-guidance.md) says what each layer should document so that claims can be traced back to their sources.

## Why maniva?

maniva is pronounced ma-NEE-va. The word comes from Old Tupi *mani'yba*, the stem of the manioc plant. Cassava is propagated from these stem cuttings, and each one carries the potential for new growth. The crop began in South America and travelled from the Amazon to Africa and Asia, adapting to new environments on the way. maniva is meant to work the same way, so that knowledge developed in one place can take root, adapt and create value elsewhere. Cassava is also one of the crops in the trial data. The full reasoning, and the other names we considered, are in [`metadata/naming.md`](metadata/naming.md).

Rooted in biodiversity. Growing through collaboration.

## Cite

To cite this documentation as a whole, use [`CITATION.cff`](CITATION.cff).

> de Sousa K, Laporte MA, Youngberg B, Cremaschi A, Chase R, van Etten J (2026). maniva. An open commons of evidence, protocols, data and analysis for agricultural research. Version 1.1.0. https://github.com/AgrDataSci/maniva

When you use a specific layer, cite that repository too, and cite the original papers for any finding.

## License

Documentation in this repository is released under [CC BY 4.0](LICENSE), with rights held by the International Plant Genetic Resources Institute (Bioversity International). Across the suite, data are released under CC0 1.0, software under the MIT License, and documentation, protocols and methods under CC BY 4.0.
