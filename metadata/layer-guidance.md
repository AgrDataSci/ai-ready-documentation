# Guidance for layers

This note says what each maniva layer should document so that a person or an AI assistant can trace a claim back to its sources. It carries over the parts of the five-layer architecture proposal that still apply after the integration layer was folded into the analysis layer. It is guidance, not yet an adopted standard. The shared skeleton every layer must have is in [Add a layer](../README.md#add-a-layer).

## The traceability chain

Every claim should lead back through the layers in this order.

`scientific claim → result or output → analytical method and code version → input dataset and version → experimental protocol → supporting evidence`

Links should run in both directions where practical and use stable identifiers. Where a step is missing, the layer says so rather than inventing a connection.

## What each resource documents

- Name, purpose, maintainer or contact, repository address, resource type and status.
- A version or fixed commit, release date, citation instructions and a persistent identifier when one exists.
- The license and any limits on access or reuse. Documentation and software may need different licenses.
- Inputs, outputs, dependencies, related resources and provenance.
- Scientific assumptions, uncertainty, limitations and the authority of the evidence, where they apply.
- Instructions for AI assistants, including when to defer, when to ask for expert review and when not to run code.

Machine-readable catalogues, such as JSON-LD, RO-Crate or CodeMeta, are a later option. Nobody should need them to read a resource.

## FAIR and governance safeguards

- **Findable.** Descriptive metadata, a catalogue people can search and persistent identifiers where assigned.
- **Accessible.** Access protocols are documented, and metadata stay discoverable even when sensitive data cannot be open.
- **Interoperable.** Shared identifiers, suitable vocabularies and ontologies, and explicit relationships between resources.
- **Reusable.** Provenance, licenses, versioned methods, dependencies and reproducible examples.

A DOI, a README or a passing automated check does not on its own make a resource FAIR or scientifically valid. Each layer keeps validated evidence, methodological inference and unknowns apart. A skill file or an institutional affiliation is not scientific authority in itself. AI assistants must not run untrusted scripts or disclose restricted information without authorization.

## Curated analytical examples

Curated analytical examples now live in [tricot-analysis-workflows](https://github.com/AgrDataSci/tricot-analysis-workflows), which holds the team's use cases and decision records on methods and their limits. Its own documentation sets what each example must state.
