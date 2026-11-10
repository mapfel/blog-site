---
name: maintain-blog
description: Run, migrate, and maintain Marko Apfel's Hugo blog. Use to preview, build, or test search locally ("start the local server"); to migrate notes, wiki pages, or a migration CSV into posts; to audit topics and tags; to change hugo.toml, layouts, or the content-source submodule; and to publish. For writing a single post, use blog-post-writing.
---

# Maintain Blog

## Locate the work

Read the applicable `AGENTS.md` files and inspect Git status in both
repositories. Find the site through `hugo.toml` and its content mount, not a
hardcoded machine path. `content-source/` is the default place to edit articles;
a sibling `blog-content` clone is an independent checkout. Choose the checkout
deliberately, preserve dirty work, and report which one changed.

When `content-source/` is empty after a clone, run
`git submodule update --init --recursive`. Current configuration takes
precedence over old examples. When `.tools/` is missing, run
`scripts/install-tools.ps1`; it also refreshes the agent-skill links.

## Preview, build, and search

Paths are relative to the site root.

```powershell
./.tools/hugo/hugo.exe server --buildDrafts
```

`hugo server` runs until stopped, so start it in the background and give the
user the URL (default `http://localhost:1313/`). `--buildDrafts` includes posts
with `draft = true`; production builds exclude them.

Search is absent under `hugo server`: `layouts/partials/head.html` and
`layouts/baseof.html` skip Pagefind when `hugo.IsServer` is true, because the
index exists only after a real build. To test search, mirror the workflow:

```powershell
./.tools/hugo/hugo.exe --gc --minify
./.tools/pagefind/pagefind.exe --site public --serve
```

`--serve` prints its port. Pagefind indexes only the `data-pagefind-body` region
in `layouts/baseof.html`.

## Migrate source material

Read each selected source fully. Work from the supplied file list or migration
CSV, not an assumed historical source directory. The CSV convention is
`FullPath,Created,LastModified,Migrate`: `N` unselected, `Y` selected, `O`
completed. Process `Y` rows only, and mark a row `O` only after copying and
validating. Preserve other rows and the original source files.

Write each post following `blog-post-writing` and its conventions. In addition:

- Preserve existing metadata, and convert YAML front matter to TOML. When dates
  are missing, prefer supplied migration metadata, then source Git history
  (`git log --follow --format="%aI|%an" -- <path>`): the oldest author date for
  `date`, the newest for `lastmod`. Disclose any fallback to filesystem
  timestamps. A copy operation never changes a known publication date.
- Rewrite wiki syntax and terse notes into standalone prose that keeps the
  technical substance.
- Credit copied or mirrored external text and link the original; it stays the
  other author's work. Clarify ambiguous attribution.
- Preserve open discussions as alternatives or pros and cons, without a verdict
  the source lacks.
- Genericize incidental credentials, private hostnames, personal paths, and
  internal identifiers while keeping the technical point. Report meaningful
  substitutions.
- Check destinations before writing, and flag collisions. Merge overlapping
  sources only within the requested scope, and report the merge.
- Copy only referenced assets, make links bundle-relative, write useful alt
  text, and keep thumbnail-to-full-size links. Resolve internal links against
  actual destination posts; report unresolved references instead of linking to
  unmigrated pages.

## Taxonomies and site behavior

A tag audit counts exact values per post and reports casing, spelling, and
plural variants, possible synonyms, and singletons, each with affected paths. A
singleton is a review candidate, not proof of error. Topics and tags are
separate taxonomies. An audit produces findings; consolidation is a separate
request.

For layouts, permalinks, assets, and taxonomy changes, check the effects on
existing posts, navigation, pagination, RSS, and search. Preserve historic URLs,
or add redirects when URL changes are requested. Credentials stay in the
existing secret mechanism.

## Verify and report

Validate the checkout you edited with Python 3.11+:

```powershell
# Site root, for the submodule
python content-source/scripts/validate_content.py content-source/content/posts
# Content repository
python scripts/validate_content.py content/posts
```

The validator checks layout, path/date agreement, required keys, chronology,
duplicate slugs, and images. It does not check hyperlinks, rendering, or
technical facts. Build site changes with `hugo --gc --minify` and inspect
representative pages; run Pagefind after Hugo for search changes. Report
missing tools or checkout mismatches as limits on verification.

Summarize changed files, verification, and open decisions. For migrations, also
report source-to-destination mappings, preserved versus inferred metadata,
attribution and privacy changes, skipped items, and confirm that descriptions
and `lastmod` were completed.

## Publish

Publish only on request, following `README.md` under "Publish content changes":
content repository first, then the site's submodule pointer, staging only the
intended bundles. Check branches first: a detached submodule HEAD does not
identify the publishing branch. The workflow deploys pushes to site `main`;
recheck `.github/workflows/pages.yml` before publishing. Respect authorization
the user has already given without adding approval steps.
