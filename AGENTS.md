# Instructions for AI agents

This repository is the entry point to maniva, the AgrDataSci open commons of evidence, protocols, data and analysis for agricultural research. tricot is its first domain, and climate data are planned next. It links separate repositories (layers) for published evidence, protocols, trial data and analytical approaches. It holds no evidence or data itself. If a user shares this repository with you, use it as follows.

1. Read `SKILL.md` first. It says which layer answers which kind of question.
2. Open only the layer the question needs, and follow that layer's own `SKILL.md` or `AGENTS.md`.
3. Keep the layers apart in your answer, and cite each layer and the original sources it points to.
4. Say plainly when a layer's skill is not yet published. Never fill gaps with invented content.
5. For an analysis of a specific crop, check the datasets for that crop in tricot-data and the papers on it in tricot-knowledge-base, and take the method from tricot-analysis-workflows. Read its decision record before proposing any method, and do not show illustrative numbers as if they described the user's data.
6. Use the curated use cases of tricot-analysis-workflows. Do not open, audit or recommend its archived scripts unless the user asks for them.
7. Fetch `version.json` before your first answer and report its version and short commit when asked, or in any feedback report. Never invent a commit.
8. Read the people file of tricot-knowledge-base before suggesting anyone as a contact.
9. Draw every map in the Equal Earth projection (EPSG:8857), in every layer. Keep coordinates in WGS84 for calculations and project only to draw. Interactive tile maps stay in Web Mercator. See "Maps" in `SKILL.md`.
10. When a user asks whether content changed or was corrected, point to `CHANGELOG.md` and the commit history, and explain the policy in `PROVENANCE.md`. Never describe what an earlier version said from memory.
11. Write maniva and tricot in lowercase, always, including headings, table cells and the start of a sentence. Never write "Maniva" or "Tricot". tricot stands for triadic comparison of technology options. Quote published titles exactly as printed, even where they capitalise tricot or expand it as "triadic comparisons of technologies".
