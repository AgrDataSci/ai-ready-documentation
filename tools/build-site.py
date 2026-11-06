#!/usr/bin/env python3
"""Build the maniva website in every language.

The English pages in site/ are the source. Each file in site/i18n/ holds the
translations for one language, keyed by the exact English text of an element
or attribute. The script writes English to the output root and each other
language to its own folder (fr/, pt/), then adds the language switcher and the
hreflang links to every page.

Usage: python3 tools/build-site.py OUTPUT_DIR

It warns, without failing, about translations whose English text no longer
exists in the pages (stale) and about English text that has no translation
yet (missing), so a wording change in English shows what to update.
"""

import html
import json
import re
import shutil
import sys
from pathlib import Path

SITE = Path(__file__).resolve().parent.parent / "site"
BASE_URL = "https://agrdatasci.github.io/maniva/"
LANGS = [("en", "English", "EN", "en_US")]  # extended from site/i18n/*.json
ASSET_PREFIXES = ("logo/", "partners/", "styles.css", "main.js", "share-card.png", "version.json")
# English words that stay the same in every language and need no translation
KEEP = {"GitHub", "ORCID", "CC BY 4.0", "CITATION.cff", "maniva", "Version", "1.0.0", "1000FARMS",
        "Kauê de Sousa", "Marie-Angélique Laporte", "Jacob van Etten",
        "k.desousa@cgiar.org", "m.a.laporte@cgiar.org", "j.vanetten@cgiar.org",
        "github.com/AgrDataSci/maniva", "CGIAR Digital Transformation",
        "Alliance of Bioversity International and CIAT, CGIAR"}


def warn(message):
    # GitHub Actions shows ::warning:: lines as annotations on the run
    print(f"::warning::{message}")


def protected_spans(text):
    """Character ranges that must not be translated (translate="no", scripts, styles, svg)."""
    spans = []
    for m in re.finditer(r'<(p|span|div|pre)\b[^>]*\btranslate="no"[^>]*>.*?</\1>', text, re.S):
        spans.append(m.span())
    for tag in ("script", "style", "svg"):
        for m in re.finditer(rf"<{tag}\b.*?</{tag}>", text, re.S):
            spans.append(m.span())
    return spans


def translate(text, strings):
    """Replace whole element contents (>text<) and whole attribute values ("text")."""
    used = set()
    spans = protected_spans(text)

    def outside(pos):
        return not any(a <= pos < b for a, b in spans)

    # Longest first, so a full sentence wins over a shorter one it contains
    for en in sorted(strings, key=len, reverse=True):
        tr = strings[en]
        for left, right in ((">", "<"), ('"', '"')):
            needle = left + en + right
            out, i, hit = [], 0, False
            while True:
                j = text.find(needle, i)
                if j < 0:
                    break
                if outside(j):
                    out.append(text[i:j] + left + (html.escape(tr, quote=True) if left == '"' else tr) + right)
                    hit = True
                else:
                    out.append(text[i:j + len(needle)])
                i = j + len(needle)
            if hit:
                out.append(text[i:])
                text = "".join(out)
                spans = protected_spans(text)
                used.add(en)
    return text, used


def visible_text(text):
    """Text segments a reader sees, outside protected spans."""
    for a, b in sorted(protected_spans(text), reverse=True):
        text = text[:a] + text[b:]
    text = re.sub(r"<head>.*?</head>", "", text, flags=re.S)
    for seg in re.findall(r">([^<>]+)<", text):
        seg = " ".join(html.unescape(seg).split())
        # Single tokens (repository names, emails, codes) need no translation
        if " " in seg and re.search(r"[A-Za-z]{3}", seg):
            yield seg


def relink(text, depth):
    """Point asset paths to the site root from a language folder."""
    up = "../" * depth

    def fix(m):
        attr, url = m.group(1), m.group(2)
        if url.startswith(ASSET_PREFIXES):
            return f'{attr}="{up}{url}"'
        return m.group(0)

    return re.sub(r'\b(href|src)="([^"#:][^"]*)"', fix, text)


def page_url(lang, page):
    folder = "" if lang == "en" else f"{lang}/"
    name = "" if page == "index.html" else page
    return BASE_URL + folder + name


def switcher(lang, page, langs, label):
    name = "" if page == "index.html" else page
    up = "" if lang == "en" else "../"
    links = []
    for code, title, short, _ in langs:
        if code == lang:
            href = name or "./"
        else:
            href = up + ("" if code == "en" else f"{code}/") + name or "./"
        current = ' aria-current="true"' if code == lang else ""
        links.append(f'<a href="{href}" hreflang="{code}" lang="{code}" title="{title}"{current}>{short}</a>')
    return f'  <div class="lang-switch" role="group" aria-label="{label}">' + "".join(links) + "</div>\n"


def head_links(lang, page, langs, locale):
    out = []
    for code, _, _, _ in langs:
        out.append(f'<link rel="alternate" hreflang="{code}" href="{page_url(code, page)}">')
    out.append(f'<link rel="alternate" hreflang="x-default" href="{page_url("en", page)}">')
    out.append(f'<meta property="og:locale" content="{locale}">')
    return "\n".join(out) + "\n"


def main():
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    out = Path(sys.argv[1])
    out.mkdir(parents=True, exist_ok=True)

    langs = list(LANGS)
    tables = {}
    for f in sorted((SITE / "i18n").glob("*.json")):
        data = json.loads(f.read_text(encoding="utf-8"))
        code = f.stem
        langs.append((code, data["name"], code.upper(), data["locale"]))
        tables[code] = data

    # Copy everything except the pages and the translation files
    for item in SITE.iterdir():
        if item.name == "i18n" or item.suffix == ".html":
            continue
        target = out / item.name
        if item.is_dir():
            shutil.copytree(item, target, dirs_exist_ok=True)
        else:
            shutil.copy2(item, target)

    pages = sorted(p.name for p in SITE.glob("*.html"))
    english = {p: (SITE / p).read_text(encoding="utf-8") for p in pages}

    for code, name, short, locale in langs:
        used_all = set()
        for page in pages:
            text = english[page]
            depth = 0
            if code != "en":
                data = tables[code]
                text, used = translate(text, data["strings"])
                used_all |= used
                text = text.replace('<html lang="en">', f'<html lang="{code}" data-root="../">', 1)
                text = text.replace(f'content="{page_url("en", page)}"', f'content="{page_url(code, page)}"', 1)
                js = json.dumps(data["js"], ensure_ascii=False)
                text = text.replace("<script src=\"main.js", f'<script id="i18n" type="application/json">{js}</script>\n<script src="main.js', 1)
                depth = 1
                text = relink(text, depth)
                # Report English left untranslated
                for seg in sorted(set(visible_text(text)) & set(visible_text(english[page]))):
                    if seg not in KEEP and seg not in data["strings"].values():
                        warn(f"{code}/{page}: no translation for \"{seg[:80]}\"")
            text = text.replace("</head>", head_links(code, page, langs, locale) + "</head>", 1)
            label = "Language" if code == "en" else tables[code].get("language_label", "Language")
            text = text.replace("</header>", switcher(code, page, langs, label) + "</header>", 1)
            target = out / ("" if code == "en" else code) / page
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_text(text, encoding="utf-8")
        if code != "en":
            for en in sorted(set(tables[code]["strings"]) - used_all):
                warn(f"site/i18n/{code}.json: English text no longer on the site, update or remove \"{en[:80]}\"")
        print(f"built {code}: {', '.join(pages)}")


if __name__ == "__main__":
    main()
