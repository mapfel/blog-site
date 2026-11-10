# Hugo site

- Read `.agents/skills/maintain-blog/SKILL.md` for authoring and maintenance.
- Articles/media belong in `content-source`; site pages such as About, Imprint,
  and Privacy belong under `content/`. Inspect submodule status and its own
  `AGENTS.md` if present before editing. A sibling `../blog-content`, if present,
  is a separate checkout.
- Hugo and Pagefind may not be on `PATH`; use `.tools/hugo/hugo.exe` and
  `.tools/pagefind/pagefind.exe`, installed by `scripts/install-tools.ps1`.
- Consult `hugo.toml` for mounts, taxonomies, and permalinks. Default public post
  URLs are `/posts/<slug>/`, without the storage year/month.
- Edit source layouts/assets, not generated `public/`, `resources/`, search
  indexes, or caches.
- With Python 3.11+, validate using
  `python content-source/scripts/validate_content.py content-source/content/posts`.
  Build site changes with `hugo --gc --minify`. Preview visual changes and drafts
  with `hugo server --buildDrafts`.
- Search requires Pagefind after Hugo; consult `.github/workflows/pages.yml`
  for current commands and versions. Hugo alone does not verify search.
- Both repositories are edited from more than one machine. Fetch before
  committing or publishing, and fast-forward with `git merge --ff-only origin/main`;
  `git pull` may refuse because of `pull.rebase` while the tree has uncommitted
  changes. Check `git stash list` before discarding or replacing a checkout.
- When publishing is requested, publish content before the site's updated
  submodule pointer. Check branches first. Do not commit, push, or deploy merely
  because files were edited. Never print tokens or document secret values.
