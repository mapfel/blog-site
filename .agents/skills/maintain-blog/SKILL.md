---
name: maintain-blog
description: Create, edit, migrate, validate, or maintain posts, taxonomies, and the Hugo site for Marko Apfel's blog. Use for this blog's workflow, not generic blogging advice or unrelated websites.
---

# Maintain Blog

## Locate the work

Read applicable `AGENTS.md` files and inspect Git status. Locate the site through
`hugo.toml` and its content mount, rather than a hardcoded machine path.
`blog-site/content-source` is the content repository's submodule checkout and
the default place to edit. A sibling `blog-content` clone, if present, is an
independent checkout of the same repository. Choose the appropriate checkout,
preserve dirty work, and report which changed. Never silently reset or overwrite
another checkout. If Hugo or Pagefind is not on `PATH`, use the binaries in the
site's `.tools/` folder (`scripts/install-tools.ps1` installs them).

Consult relevant READMEs, `archetypes/posts.md`, `scripts/new-post.ps1`, the content
validator, and `.github/workflows/pages.yml` as needed. Current configuration
takes precedence over old examples. Existing `.claude/agents/` files provide
migration and tag-audit background; they do not authorize delegation.

## Author and edit

From the site root, use the existing helper when suitable:

```powershell
./scripts/new-post.ps1 -Title "Article title" -Slug "article-title"
```

It writes `content-source/content/posts/YYYY/MM/<slug>/index.md`. Supply `-Date`
for a specific date. Choose an explicit readable ASCII slug for non-ASCII titles:
automatic slugging removes characters rather than transliterating them. Check
slug uniqueness across all years, not just the destination directory.

Complete the helper's empty description before validation; drafts also require
nonempty descriptions. Retain required TOML fields from the content `AGENTS.md`.
Use `topics`, not `categories`; tags are separate, and `series` is configured
when appropriate. Reuse taxonomy spelling/casing. Keep new articles in draft
unless the user specifies publication readiness.

Open with the reader's problem or what they will learn. Match the source language
and relevant existing posts. No mandatory length, outline, conclusion, or
translation policy is established. Preserve technical meaning, code, and tables;
do not invent personal experience or measurements. Verify changing software claims
against current primary documentation when needed.

Preserve publication dates and URL identity; update `lastmod` for substantive
revisions without moving the post. Public URLs currently default to
`/posts/<slug>/`, not the year/month storage path. Inspect explicit `slug`, `url`,
and aliases before resolving or changing links.

## Migrate source material

Read each selected source fully. Use the supplied file list or explicitly supplied
migration CSV, not an assumed historical source directory. The existing CSV
convention is `FullPath,Created,LastModified,Migrate`: `N` unselected, `Y` selected,
`O` completed. Process selected rows only; mark completed only after copying and
validating. Preserve other rows and original source files.

Preserve existing metadata; convert YAML front matter to TOML when necessary.
When dates are missing, prefer supplied migration metadata, then source Git
history (`git log --follow --format="%aI|%an" -- <path>`): oldest author date for
creation, newest for modification. Disclose filesystem timestamp fallback.
Never replace a known publication date because the file was copied.

Rewrite wiki syntax and terse notes into standalone prose while retaining
technical substance. Handle these cases explicitly:

- Credit copied/mirrored external text and link the original; never present it
  as the owner's original writing. Clarify ambiguous attribution when necessary.
- Preserve open discussions as alternatives or pros/cons; do not invent a verdict.
- Remove or genericize incidental credentials, private hostnames, personal paths,
  and internal identifiers while retaining the technical point. Report meaningful
  substitutions.
- Check destinations before writing; flag collisions instead of overwriting.
  Merge overlapping sources only within the requested scope and report the merge.

Copy referenced assets only, fix bundle-relative links, supply useful alt text,
and retain thumbnail-to-full-size links. Resolve internal links against actual
destination posts. Do not introduce links to unmigrated pages; report unresolved
references rather than inventing destinations.

## Maintain site behavior and taxonomies

For tag audits, count exact values per post and report casing/spelling/plural
variants, possible synonyms, and singletons with affected paths. A singleton is
a review candidate, not proof of error. Keep topics separate from tags. Do not
apply bulk consolidation during an audit-only request.

For layouts, permalinks, assets, and taxonomy changes, check relevant effects on
existing posts, navigation, pagination, RSS, and search. Preserve historic URLs
or supply redirects when URL changes are requested. Edit source files, not
generated output. Keep credentials in the existing secret mechanism.

## Verify and deliver

Validate the checkout actually edited with Python 3.11+:

```powershell
# From the content repository
python scripts/validate_content.py content/posts
# Or from the site root for its submodule
python content-source/scripts/validate_content.py content-source/content/posts
```

The validator does not check every hyperlink, rendered layout, or technical fact.
Build relevant site changes with `hugo --gc --minify`. Preview drafts using
`hugo server --buildDrafts`; production builds exclude them. Inspect representative
pages for visual changes. For search changes, also run the workflow's Pagefind
step after Hugo. Report missing tools or checkout mismatches as verification
limits instead of claiming edited content was built.

Summarize changed files, verification, and unresolved decisions. For migrations,
include source-to-destination mappings, preserved versus inferred metadata,
attribution/privacy changes, and skipped items. Explicitly confirm descriptions
and `lastmod` were completed.

Authoring alone does not authorize commits, pushes, or deployment. When publishing
is requested, publish content before the site's updated submodule pointer.
Inspect branches first: detached submodule HEAD does not identify the intended
publishing branch. The current workflow deploys site `main` pushes; recheck it
before publishing. Respect existing user authorization without adding an
unnecessary approval step.
