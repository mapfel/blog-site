# Blog conventions and evidence

## Basis and authority

Reviewed on 2026-11-01 in the `blog-site` checkout. A metadata scan covered all 259 article bundles; close reading sampled historical and recent posts, including short fixes, comparisons, tutorials, personal workflows, German articles, and exploratory notes. This is an editorial guide, not a claim that every article follows every pattern.

Use the current validator and Hugo configuration for mechanical requirements; use related posts and the user's instructions for editorial decisions. The archive includes migrated material, inconsistent tags, and uneven prose. Preserve its specificity and personal perspective without imitating accidental grammar, verbosity, or unsupported claims.

## Header: TOML front matter

All 259 posts have `title`, `description`, `date`, `lastmod`, `draft`, `topics`, and `tags`. Explicit `slug` appears in 237, `summary` in 52, and `series` in 10. Field order varies and is not significant. A useful complete new-post header is:

```toml
+++
title = "Diagnosing VLAN Connectivity Failures"
description = "A layer-by-layer checklist for checking VLAN tagging, addressing, routing, and firewall policy."
date = 2026-11-01T10:00:00+01:00
lastmod = 2026-11-01T10:00:00+01:00
draft = false
slug = "diagnosing-vlan-connectivity"
topics = ["Network"]
tags = ["VLAN", "Routing", "Troubleshooting"]
summary = "When a VLAN client cannot reach a service, isolate the failing layer before changing firewall rules."
+++
```

The timestamp and text above are illustrative; use the actual article's values.

| Field | Rule or convention |
| --- | --- |
| `title` | Required, non-empty. Name the tool, symptom, decision, or reader outcome. Titles range from terse task labels to explicit questions and recommendations. No fixed title-case rule is justified by the archive. |
| `description` | Required, non-empty. Write a concise, concrete overview. The current single-post template displays this below the title, and the head template uses it for metadata. It must read well to humans, not as a list of SEO keywords. |
| `date` | Required TOML date/datetime. Use an unquoted RFC3339 datetime with an accurate offset as the normal convention. Preserve original publication dates during migration. The bundle year/month must match it. |
| `lastmod` | Required date/datetime, at least `date`. Preserve an established modification date unless actually updating the post; do not reset publication history. When reconstructing history, prefer supplied metadata or relevant Git history over guessed timestamps. |
| `draft` | Required boolean. `false` for new posts unless the user asks for a draft; review happens in Git (an unpushed change or a draft pull request), not through this flag. Preserve existing status for edits. Imported sources explicitly marked unfinished stay drafts. |
| `slug` | Optional in the validator and archetype, common in existing posts. Use lowercase kebab-case and preserve an existing public slug. Check explicit slugs and folder names across the archive to avoid URL collisions. |
| `topics` | Required array, may be empty. Broad navigation categories; reuse relevant existing values. `Development` is most common, but `OS`, `Network`, `BizTalk`, `Tools`, `Git`, and others also exist. Do not assign everything to `Development`. |
| `tags` | Required array, may be empty. More specific technologies and concepts. Reuse vocabulary from related posts; do not invent many tags just to fill the header. |
| `summary` | Optional. An editorial teaser about the problem or payoff; when supplied, use wording distinct from `description`. The site can generate summaries when it is absent. |
| `series`, `series_order` | Optional grouping and sequence metadata used by the homelab series. Preserve when present; inspect current rendering before assuming a series navigator exists. |
| `legacy_url`, `archive_url`, `legacy_id` | Provenance found on migrated posts. Retain existing values rather than deleting history during a prose edit. |

Tags are mixed in the live corpus: examples include `CSharp`, `C#`, `Functional Programming`, `Software Engineering`, `SophosXG`, `MQTT`, and `Troubleshooting`. An older migration-agent instruction prescribes PascalCase with no spaces, but the posts do not consistently follow it. Prefer an established tag for the same concept; leave taxonomy-wide normalization to a separate request.

## Visible headings and article shape

The single-post template renders the title as the page's H1. Start the body with a short opening or an H2 as appropriate, rather than repeating the title as another H1. Use H2 for main sections and H3 for subdivisions. No fixed section count or mandatory conclusion follows from the archive.

Choose the structure that fits the material:

| Kind | Useful progression | Example in `content-source/content/posts/` |
| --- | --- | --- |
| Short fix | Symptom and exact error → cause → command/change → observed result. Can work without headings. | `2017/02/wrong-permissions-blocks-git/index.md` |
| Diagnostic guide | Concrete failing test → ordered checks → explain what each result implies → verification. | `2024/12/troubleshooting-vlan-connectivity/index.md` |
| Comparison or design decision | Actual decision → options and costs → examples/table → conditional recommendation. | `2024/07/nullable-vs-maybe-monad/index.md`; `2025/12/mosquitto-multi-listener-architecture/index.md` |
| Focused recommendation | Tempting setting/practice → behavior → specific failure modes → replacement. | `2025/02/reproducible-builds/index.md` |
| Personal workflow | Friction and personal requirements → initial implementation → improvements and reasons. | `2026/08/productive-photo-culling/index.md` |
| Command reference | Purpose and scope → command categories → labeled input/output → useful combinations and limitations. Do not reproduce exhaustive listings unless requested. | `2026/09/linux-dmidecode-command/index.md` |
| Exploratory discussion | State tentative status → question and alternatives → examples/checklists → remaining uncertainty. Do not reframe as settled research. | `2025/04/manual-vs-automated-testing/index.md` |

## Wording and presentation

Practical specificity is the strongest common trait. The SSH fix includes the password prompt, file mode, correction, and changed behavior. The VLAN guide replaces "does not work" with a source, destination, service, expected path, and result. Comparison posts explain when each approach fits rather than merely listing features.

Use short paragraphs to connect an observation to its consequence. Lists suit independent checks or trade-offs; numbered steps suit sequences. Tables suit comparable options or settings. Use bold for short labels or key distinctions, not whole paragraphs. Use inline code for commands, filenames, keys, APIs, and literal values. Use fenced blocks with an appropriate language; separate executable commands from terminal output and explain placeholders. The archive's `text`/`txt` fences are precedents, not a reason to leave recognizable code untyped.

New prose may improve language without erasing the author's position. For example, the photo-culling opening can become: "Culling a large photo library takes time. I wanted to rate each image with one key and move straight to the next." This preserves the source's personal requirements while removing awkward phrasing. It does not authorize inventing performance measurements or a successful test.

Preserve source attribution and any disclosure of exploratory or AI-assisted material. Do not rewrite another author's text into Marko's first-person experience. Turn internal wiki fragments into standalone explanations; remove wiki-only markup and resolve internal links. Generalize incidental private paths, identifiers, or hostnames while preserving meaningful technical details. Never fabricate a source or imply a legacy link was checked when it was not.

## Bundles, URLs, and checks

- Store each article at `content-source/content/posts/YYYY/MM/kebab-case-slug/index.md`; in the content repository alone, omit `content-source/`. Update `lastmod` without moving the bundle to a new month.
- Keep referenced local images inside the article bundle, use meaningful alt text, and preserve thumbnail-to-full-image links where useful. Do not copy unrelated media.
- The current `hugo.toml` permalink is `/posts/:slug/`. Link to `/posts/wrong-permissions-blocks-git/`, for example, rather than copying the storage path into a public URL. Earlier migration-agent guidance using year/month URLs conflicts with this configuration.
- Check that internal link targets exist and are intended to be accessible. Avoid links to uncreated or unpublished drafts from a publishable post.
- Current rendering disables raw HTML (`unsafe = false`); prefer Markdown or existing supported Hugo mechanisms.
- Validate TOML, required fields, chronology, path dates, slug collisions, and local images. The repository validator covers many of these, but does not fully verify explicit-slug collisions, external links, prose quality, or technical accuracy.

Mechanical sources in the site checkout: `archetypes/posts.md`, `scripts/new-post.ps1`, `hugo.toml`, `layouts/_default/single.html`, `layouts/partials/head.html`, and `content-source/scripts/validate_content.py`. Consult them again when they change.
