# Germplasm integration in maniva

*Design note, 6 November 2026. Under discussion.*

## Status

This note records how maniva identifies germplasm across its data domains, and which points remain open. It is a working document. Items marked agreed reflect the current position of the maniva team. Items marked proposed are open for input from the partners who hold the source systems, in particular breeding data platforms and genebank information systems.

Germplasm integration is under development. It is not part of maniva v1.0.0.

## The problem

One genotype reaches farmers under many names. A line from a single breeding pipeline is released in several countries, in different years, and each country gives it a different name. The same bean line, for example, carries different release names across Central America.

On-farm trials record whatever name the local partner uses. That can be a release name, a pipeline code, a local name or a spelling variant. Without a common identity, three things fail.

- On-farm results cannot flow back to the breeding pipeline that produced the material.
- Results for the same genotype cannot be combined across countries and seasons.
- Trial data cannot be joined to genebank passport data or to genotypic data.

This is the weakest link in the maniva data layer. Location and time come from the trial itself. The identity of the material depends on systems outside the trial.

## Design principle

**Agreed.** Identity belongs to the germplasm, and names are aliases. One germplasm gets one identifier. Each release is a record attached to it, with name, country, year and releasing institution.

We use genotype names instead of variety names for breeding material, because the genotype is stable while the variety name changes with each release.

**Proposed.** The entity is called germplasm and carries a type. Genotype is the right concept for clones and inbred lines. Landraces, open-pollinated varieties and genebank accessions are populations, and the registry must hold them without pretending they are a single genotype.

| Type | Example | Identity is |
| --- | --- | --- |
| Line | inbred bean or rice line | a genotype |
| Clone | cassava, sweetpotato, potato | a genotype |
| Population | landrace, open-pollinated variety | a named population |
| Accession | genebank sample | the accession as conserved |

## Sources of truth

**Agreed.** Each type of material has one authority. maniva does not create germplasm data. It links to the system that owns it.

| Material | Source of truth | Identity | Aliases |
| --- | --- | --- | --- |
| Breeding lines | EBS | germplasm identifier | pipeline codes, synonyms |
| Genebank accessions | Genesys or GRIN-Global | accession DOI or number | collector and local names |
| Public released varieties | EBS, through the parent line | the breeding line | release name, country, year |
| Private varieties | none available | company, name, country, release year | trade names |

Released varieties are pulled back to their breeding line, and the release names are added as aliases. Private companies run independent pipelines that are closed to us, so their products are identified by company, name, country and release year.

## Design decisions under discussion

These six points are proposed. Each one answers a case we already meet in the trial data.

1. **The registry mints its own persistent identifier.** EBS runs as separate instances per centre, so an EBS identifier is not unique across centres. The registry assigns one identifier per germplasm and stores the source identifiers as attributes, prefixed by source. BrAPI provides a field for this, the germplasm PUI.
2. **One germplasm can have several authorities.** A breeding line that is also conserved as an accession exists in EBS and in a genebank system. That is one germplasm with two links, not two records.
3. **Material with no authority gets a local entry.** Farmer landraces, local checks and varieties bred by national programmes outside the CGIAR pipelines appear in most on-farm trials. They receive a registry identifier with source "local" and stay open for later matching.
4. **Alias links carry a status and their evidence.** Linking a released variety to its breeding line often rests on release documents or breeder knowledge. Each link is marked confirmed, probable or unresolved. Analyses that depend on genotype identity can then use confirmed links only.
5. **Private material stays shallow.** Two private entries are never linked as the same genotype unless the company states it. Names are reused across markets and the pipeline behind them is not visible.
6. **Flat files are the source of truth, the service is a tool.** The registry is published as a versioned crosswalk table with a DOI, under the same open licence as the other maniva data. A BrAPI service builds the table and answers live queries. If the service stops, the data and every published analysis still work.

The registry follows existing standards. It adopts the BrAPI germplasm model and the multi-crop passport descriptors, so that exchange with EBS and genebank systems is a question of access, not of format.

The registry is independent of any data collection platform. Platforms use it as clients, to offer a trusted list of germplasm when a trial is designed.

## How germplasm links to the other data

The maniva data domains connect through four shared keys. Germplasm is the key called what. Each domain declares the keys it carries in its metadata, and the analysis workflows implement the joins.

| Key | Identifies | Standard | Join type | Status |
| --- | --- | --- | --- | --- |
| what | the technology option tested | registry identifier, with type | exact match | under development |
| where | the plot or site | longitude and latitude in WGS84, plus administrative unit | spatial extraction or overlap | in use |
| when | the growing season | planting and harvest dates in ISO 8601 | time window | in use |
| who | the participant or household | pseudonymised identifier, stable across seasons | exact match | proposed |

On-farm testing data carry all the keys, since every tricot record has an option, a location and a date. That makes them the hub between the breeding pipeline and the environments and households where the material is used.

The key called what is wider than germplasm. tricot stands for triadic comparison of technology options, and an option can also be an agronomic practice. The registry covers the germplasm options. Practices will be defined in the agronomy domain.

## Schema

The first diagram shows where the registry sits in maniva. The second shows what feeds it.

```
                                    maniva
                    (index of the layers, one entry point)
                                       │
       ┌────────────────┬──────────────┴────┬───────────────────────────┐
       │                │                   │                           │
knowledge base      protocols             data                      analysis
 what we know     how we do it        what we found           how we reason with it
                                            │                           │
    ┌────────────┬───────────┬──────────────┼───────────────┐           │
    │            │           │              │               │           │
 on-farm     breeding    agronomy     environmental  socio-economic     │
 testing     germplasm               CHIRPS, CHIRTS,     RHOMIS         │
 tricot      registry                     soil                          │
available      under       under          under           under         │
            development development    development     development      │
    │            │           │              │               │           │
    └────────────┴───────────┬──────────────┴───────────────┘           │
                             │                                          │
                        shared keys                                     │
                  what, where, when, who                                │
                             │                                          │
                             │              ┌───────────────┬───────────┴───┐
                             │              │               │               │
                             └────────► workflows      R packages       template
                                      use cases and  gosset and the   reproducible
                                    decision records  ClimMob suite   FAIR projects
```

```
      EBS           Genesys, GRIN-Global          release records
breeding lines       genebank accessions   public and private varieties
       │                      │                          │
       └──────────────────────┼──────────────────────────┘
                              │
                     germplasm registry
               one persistent ID per germplasm
      source IDs, aliases, release records, link status
                              │
                         key "what"
                              │
         on-farm testing, breeding and agronomy data
```

## Points for discussion with partners

These questions need the systems that own the data. We bring a design, and we ask for what only they can provide.

**With breeding data platforms**

- Which germplasm identifier is stable and unique across EBS instances? Is the germplasm PUI populated and public?
- Can synonyms, pipeline codes and release names be exposed through the BrAPI germplasm endpoints, and under which access terms?
- Where are release records kept today, and who can confirm the link between a released variety and its breeding line?

**With genebank information systems**

- When a breeding line is also a conserved accession, who asserts that the two are the same germplasm?
- How should the registry reference accessions that have no DOI yet?

**With national programmes and crop leads**

- Who validates the alias links for released varieties in each country?
- What is the minimum record we can hold for private varieties without implying a pedigree we cannot verify?

**Within maniva**

- Who maintains the registry, how often is it updated, and how are versions cited?
- At what coordinate precision are trial locations published, so that farmers are protected and climate extraction still works?
- Is the participant identifier adopted as a fourth shared key?

## Next steps

- [ ] Write the registry specification on the BrAPI germplasm model, with the field list and the link status vocabulary
- [ ] Request read access to germplasm identifiers and synonyms from EBS for one pilot crop
- [ ] Map the germplasm names already recorded in the tricot data for that crop, with crop leads confirming the links
- [ ] Publish a first version of the crosswalk table in the breeding repository, marked under development
- [ ] Add the breeding domain and the registry to the maniva layout
