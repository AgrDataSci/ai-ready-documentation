# Agent access and scale in maniva

*Design note, 7 November 2026. Under discussion.*

## Status

This note records how big maniva is today, how big it becomes when the next tricot data release lands, and what that means for AI assistants that read it. It proposes a format for agent-facing data and a set of safeguards that keep the suite navigable as new domains join. Items marked agreed reflect the current position of the maniva team. Items marked proposed are open for discussion, in particular with the tricot data managers.

None of the proposals here are part of maniva v1.0.0.

## The problem

maniva works when an assistant can reach the right file and read it. Two things threaten that as the suite grows.

- **File size.** Browsing tools in AI assistants truncate files after a few hundred kilobytes. The tricot trial files are between 3 and 18 MB of JSON. An assistant without code execution sees the opening metadata and nothing else, and then guesses. Testers saw this with ChatGPT.
- **Navigation.** Every new domain adds repositories, indexes and files. If the path from the maniva entry point to a fact grows longer, or the indexes grow larger, assistants lose their way and the suite becomes one more resource that only insiders can use.

## Size of the suite

Sizes are for the current files on the default branch, measured on 7 November 2026. Git history adds to them, mostly through the PDFs in the knowledge base.

| Repository | Layer | Size | What makes it heavy |
| --- | --- | --- | --- |
| tricot-data | Data | 362 MB | 64 trial files in JSON (351 MB), up to 14 MB each |
| tricot-knowledge-base | Literature | 159 MB | 71 PDFs (158 MB). The cards that assistants read take 0.6 MB |
| tricot-protocols | Methods | 57 MB | 27 Word files (53 MB) |
| climatrends | Analysis | 4.8 MB | |
| ClimMob-analysis | Analysis | 4.5 MB | |
| chirps | Analysis | 3.1 MB | |
| tricot-analysis-workflows | Analysis | 3.1 MB | |
| gosset | Analysis | 2.8 MB | |
| maniva | Entry point | 1.6 MB | |
| ClimMobTools | Analysis | 1.1 MB | |
| template-repo-data-analysis | Analysis | 0.8 MB | |
| **Public total** | | **606 MB** | |

Three repositories hold 95% of the suite, and in each case the weight sits in files that assistants cannot use well. PDFs and Word files are invisible to most browsing tools, and the JSON trial files are too large for them.

### After the next data release

The next release of tricot-data holds 586 processed trials, from 101,300 sites on 42 crops. It includes the 64 trials published today, so 522 trials are new. Another 40 trials wait for approval from their data producers.

| | Today | After the release |
| --- | --- | --- |
| tricot-data | 362 MB | about 1,170 MB, or 1,230 MB with the trials awaiting approval |
| Other public repositories | 244 MB | 244 MB |
| **Public total** | **606 MB** | **about 1.4 to 1.5 GB** |
| Private processing repository (source files, scripts, processed trials) | | 1.5 GB |
| **All maniva assets** | | **about 2.9 GB** |

tricot-data alone then passes 1 GB, above the size GitHub recommends for a repository. The largest trial files reach 18.5 MB. Clones slow down, and the share of files that assistants cannot read grows from today's level to almost all of them.

## Format matters more than size

Markdown is the right format to describe data and the wrong format to hold it. A table of 31,000 plot records written as markdown is larger than the same table in JSON.

The JSON trial files are pretty-printed and repeat every field name on every record. We tested 25 trials drawn at random from the release set.

| Format | Share of JSON size | Full release, estimated |
| --- | --- | --- |
| JSON as published | 100% | 1,160 MB |
| CSV, same columns | 28% | about 330 MB |
| CSV, gzipped | 1.5% | about 18 MB |

**Proposed.** Keep JSON as the archival record and add an agent layer generated from it at each release.

1. **A trial card in markdown**, about 6 KB per trial. Any assistant can read it, and it answers most questions without opening another file.
2. **Per-trial CSV files** with exactly the columns of the JSON, so nothing is lost and the two stay in sync.
3. **A summary table per trial** with precomputed descriptive statistics, for assistants that cannot run code.

### Worked example

We generated the agent layer for one published trial, okra in Benin, 2023 (`okra-BEN-7314993d7741`). One JSON file of 11.8 MB becomes five files.

| File | Size | Read by | Holds |
| --- | --- | --- | --- |
| `<trial>.md` | 6 KB | any assistant, first stop | quick facts, genotypes and their roles, traits per collection moment, two at-a-glance tables, sample rows, funders, citation |
| `<trial>_summary.csv` | 26 KB | assistants without code | share of farmers ranking each genotype best or worst, means and medians of numeric traits, per trait and moment |
| `<trial>_plots.csv` | 2.9 MB | code | one row per plot, trait and moment |
| `<trial>_sites.csv` | 322 KB | code | coordinates, administrative names, household and farmer variables |
| `<trial>_variables.csv` | 11 KB | assistants and code | definition, unit and ontology id of every column |

The card states that its shares are descriptive, since they ignore which genotypes met in each set, and points to tricot-analysis-workflows for Plackett-Luce models. Assistants quote cards, so cards must never overclaim.

A script builds all five files from any trial file, so the layer can be regenerated for the full release in one run.

The example also surfaced a data issue. The district names (adm2) in this trial carry spelling variants of the same place, giving 49 districts where there are fewer. Cards will expose issues like this across the release, which makes them a quality check as well as an access route.

## How assistants navigate maniva

Assistants do not hold a hidden index of the suite. A general-purpose assistant with web access follows links. It reads the maniva `llms.txt` or `SKILL.md`, chooses the layers that the router points to, reads each layer's `SKILL.md` and then opens specific files.

A question that crosses layers, such as which genotype performed best, what the literature says about it and how to analyse it, leads the assistant to visit each layer in turn. It can fetch several files at once when it already knows their addresses. The integration across layers happens in the assistant's reasoning, not in the repositories. It works when files name each other explicitly, for example a paper card that names its trial id, or a workflow that names its dataset. Where a link is missing, the assistant guesses.

An assistant that can clone and search the repositories, as in coding environments, does much better. Most maniva users will only have web access, so the design must serve them.

Two consequences follow.

- **The cost of a question depends on path length and index size, not on the size of the suite.** maniva can grow to many domains if every fact stays a few hops from the entry point and each index stays small.
- **Explicit shared keys carry the integration.** The keys what, where and when, and the germplasm identity described in [`germplasm-integration.md`](germplasm-integration.md), are what lets an assistant join layers instead of guessing.

The current budget is already under pressure. maniva's own guidance caps a skill index at about 20 KB, and the knowledge base `SKILL.md` is 52 KB.

## Safeguards for growth

**Proposed.** Four rules keep maniva navigable as domains join.

1. **One catalogue.** maniva holds a single machine-readable catalogue of every asset, with its layer, domain, shared keys, address and size. It is the map for the team and for assistants.
2. **A fixed question set.** About 30 real questions that cross layers, run against the main assistants (ChatGPT, Claude, Gemini) at every release, with a recorded pass rate. A new domain joins only when the set still passes.
3. **Hard budgets.** At most three hops from the maniva entry point to any fact. At most 20 KB per skill index. No file over 1 MB that an assistant is expected to read.
4. **Readable twins.** Every PDF or Word file that an assistant should use has a markdown twin. The knowledge base cards already play this role for the papers. The protocols need the same.

The question set matters most. It turns the worry that maniva grows faster than anyone can navigate into a number that is checked at every release.

## Points for discussion

1. **Where the full JSON lives.** Option A keeps JSON, CSVs and cards in tricot-data on GitHub, at about 1.5 GB. Option B keeps cards and CSVs on GitHub and the JSON on Zenodo only, which keeps the repository well under 1 GB. Option B is preferred, pending agreement with the tricot data managers.
2. **Gzipped or plain CSV.** Gzip cuts size by a further factor of 18, but some assistants cannot open compressed files. Plain CSV for small trials and gzip above a threshold is one option.
3. **What goes in the card.** The at-a-glance tables need a rule for which traits to show. The example uses yield at first harvest and overall characteristics at the last moment.
4. **The summary statistics.** Shares ranked best and worst are simple and honest. Whether to add model-based estimates is a separate decision, given that Plackett-Luce estimates were dropped from the release files.
5. **Cleaning administrative names** before the release, given the spelling variants found in the example.

## Next steps

- Agree the format with the tricot data managers.
- Run the card generator over the 586 trials and review a sample of cards.
- Draft the catalogue and the question set in this repository.
- Bring the knowledge base `SKILL.md` within the 20 KB budget.
- Add markdown twins for the protocols.
