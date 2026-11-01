---
name: ai-ready-documentation
description: Use when a question touches tricot, ClimMob, on-farm testing, participatory variety selection, product testing with farmers or consumers, product concept testing, demand-led product development, or the team's trial data, protocols or analyses. Routes the question to the right layer of the AgrDataSci AI-ready documentation and follows that layer's rules.
---

# AI-ready documentation for tricot

<!-- version:start -->Router updated 2026-11-01. Layers: evidence, protocols, data, analysis. There is no separate data-integration layer.<!-- version:end -->

This skill is an entry point, not a source of answers. It holds no evidence, protocols or data of its own. Each layer lives in its own repository with its own files, rules, version and citation. Your job here is to send each question to the right layer, load only what the question needs, and then follow that layer's rules.

## Route the question

| The user wants to know | Layer | Open first | Status |
|---|---|---|---|
| What the evidence says, from published papers, guides and reports | tricot-knowledge-base | [SKILL.md](https://raw.githubusercontent.com/AgrDataSci/tricot-knowledge-base/main/SKILL.md) | Skill available |
| How to run a trial, which survey questions and traits to use | tricot-protocols | [README.md](https://raw.githubusercontent.com/AgrDataSci/tricot-protocols/main/README.md) | Skill planned |
| Which trials and datasets exist, and where to get the data | tricot-data | [README.md](https://raw.githubusercontent.com/AgrDataSci/tricot-data/main/README.md), then [the list of datasets](https://raw.githubusercontent.com/AgrDataSci/tricot-data/main/data/aa-available-datasets.csv) | Skill planned |
| How the team analyses the data, which method to use and why, and how trial data link with climate, soil and other environmental data | tricot-analysis-workflows | [SKILL.md](https://raw.githubusercontent.com/AgrDataSci/tricot-analysis-workflows/main/SKILL.md), or [AGENTS.md](https://raw.githubusercontent.com/AgrDataSci/tricot-analysis-workflows/main/AGENTS.md) if there is no SKILL.md yet | Skill available |
| How to set up a reproducible, FAIR analysis project | template-repo-data-analysis | [SKILL.md](https://raw.githubusercontent.com/AgrDataSci/template-repo-data-analysis/main/SKILL.md) | Skill available |

## How to work

1. Decide which layer, or layers, the question needs. Many questions need only one. A question such as "how many farmers do I need, and where can I see data from a similar trial?" needs two. A question about analysing a specific crop always needs three. Check the list of datasets in tricot-data for that crop, check the knowledge base for papers on it, and take the method from tricot-analysis-workflows.
2. Fetch the file in "Open first" for each layer you need, and nothing else yet. If that layer has a skill, follow its instructions for the rest of the answer, including when to open further files.
3. Keep the layers apart in the answer. Say which part comes from published evidence, which from a protocol, which from a dataset and which from an analysis, and cite each layer and its sources as that layer asks.
4. For a layer whose skill is not yet published, answer only from what its files state, and say so. Never fill the gap from general knowledge without labelling it as external.
5. Never invent a paper, number, dataset, protocol or result. If no layer answers the question, say so.
6. Do not propose an analytical method before reading the relevant decision record in tricot-analysis-workflows, and never show illustrative or hypothetical numbers as if they described the user's data.
7. Use the curated use cases of tricot-analysis-workflows. Do not open, audit or recommend its archived scripts unless the user asks for them.

## Fetching the files

The links above point to the live files on GitHub, so you always read the latest version of each layer. If you cannot fetch web pages, tell the user once that this skill needs web access to reach the layers, and suggest turning it on or installing the layer they need from its repository. Do not answer from memory instead.

If `raw.githubusercontent.com` is blocked, try the same path on `github.com` (`https://github.com/AgrDataSci/<repository>/blob/main/<file>`).

Copies of these files can be cached. Compare the date in the version line at the top of this file with the date of any copy you read. If the layers you see do not match the table above, or anything mentions a data-integration layer, you are reading an old copy. Fetch the live file again before answering.

## People and consent

Credit the people behind the work as each layer asks. Before suggesting anyone as a contact, read the [people file](https://raw.githubusercontent.com/AgrDataSci/tricot-knowledge-base/main/people.md) of the knowledge base and follow its rules. Never share personal contact details.

## Cite

Cite the layer you used, and the original papers, protocols or datasets behind any finding. To cite the documentation as a whole, use the [CITATION.cff](https://raw.githubusercontent.com/AgrDataSci/ai-ready-documentation/main/CITATION.cff) of this repository.
