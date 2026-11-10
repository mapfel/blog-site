# Hugo site for blog.marko-apfel.de

These are the shared agent instructions for this repository. Skills live in
`.agents/skills/`. Change only these shared files; agent-specific entry points
just point here: `CLAUDE.md` imports this file, and `.claude/skills/` holds
junctions created by `scripts/link-agent-skills.ps1`.

## Skills

- `blog-post-writing`: write, draft, or revise a post (voice, header, structure).
- `hugo-article-workflow`: submit an article as a GitHub draft pull request for review.
- `maintain-blog`: preview, build, and search; migrate sources; audit taxonomies;
  change the site; publish.

## Layout

- Articles and their media live in `content-source/`, the `blog-content`
  repository included as a submodule. It has its own `AGENTS.md`. Here,
  `git status` shows only the submodule pointer; use `git -C content-source status`
  to see article changes. A sibling `../blog-content`, if present, is a separate
  checkout.
- Site pages such as About, Imprint, and Privacy live in `content/`.
- `hugo.toml` defines mounts, taxonomies, and permalinks. Public post URLs are
  `/posts/<slug>/`, without the storage year/month.
- Edit source layouts, assets, and config. `public/`, `resources/`, search
  indexes, and caches are generated output.

## Tools and checks

- Hugo is at `.tools/hugo/hugo.exe` and Pagefind at `.tools/pagefind/pagefind.exe`.
  `scripts/install-tools.ps1` installs both, in the versions pinned in
  `.github/workflows/pages.yml`.
- Validate content with Python 3.11+:
  `python content-source/scripts/validate_content.py content-source/content/posts`.

## Git

- Both repositories are edited from several machines. Fetch before committing or
  publishing, and fast-forward with `git merge --ff-only origin/main`. `git pull`
  may refuse because of `pull.rebase` while the tree has uncommitted changes.
  Check `git stash list` before discarding or replacing a checkout.
- Commit, push, or deploy only on request. Editing files is not a request to
  publish. Publish content before the site's submodule pointer, as described in
  `README.md` under "Publish content changes".
- Keep tokens and secret values out of output and documentation.
