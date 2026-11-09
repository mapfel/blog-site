---
name: hugo-article-workflow
description: Create English-language Hugo blog articles using the existing blog-post-writing skill, validate them, and open draft pull requests in the blog-content repository.
---

# Hugo Article Workflow

## Purpose

Create new articles for the Hugo blog through a controlled GitHub pull request workflow.

The agent is responsible for writing, validating, committing, and submitting articles for review.

The user is exclusively responsible for reviewing, approving, merging, and publishing articles.

## Repositories

- Site repository: `blog-site`
- Content repository: `blog-content`
- Site submodule path: `content-source`
- Content base branch: `main`

Local repository paths must be configured for the current environment.

## Writing instructions

Before writing an article:

1. Load and follow the `blog-post-writing` skill.
2. Read its `references/conventions.md`.
3. Inspect relevant existing articles.
4. Follow the current Hugo configuration and content validator.
5. Write in English, regardless of the language used in the Telegram request, unless explicitly instructed otherwise.
6. Never invent personal experiences, measurements, or technical results.

## Article structure

Create a Hugo leaf page bundle:

`content/posts/YYYY/MM/article-slug/index.md`

Use TOML front matter with the required fields:

- `title`
- `description`
- `date`
- `lastmod`
- `draft`
- `topics`
- `tags`

Set `draft = false` for articles created through this pull request workflow.

Check for existing slugs and reuse established topic and tag vocabulary.

## Git workflow

1. Work exclusively in the `blog-content` repository.
2. Check the working tree for uncommitted changes.
3. Stop if unexpected changes exist.
4. Fetch the latest remote state.
5. Create a unique feature branch from `origin/main`.
6. Use the naming convention `article/<slug>`.
7. Write the article using the writing skill.
8. Validate the article.
9. Stage only the files belonging to the new article.
10. Review the staged diff.
11. Commit using the prefix `article:`.
12. Push the feature branch to GitHub.
13. Create a draft pull request targeting `main`.

Never push directly to `main`.

## Validation

Run from the content repository root:

`python scripts/validate_content.py content/posts`

Additionally:

- Check TOML front matter.
- Check date and directory consistency.
- Check slug uniqueness.
- Check internal links.
- Check local image references.
- Check technical accuracy.
- Run a Hugo build when the site checkout and required dependencies are available.

Do not create a pull request if validation fails.

## Pull request

Use GitHub CLI to create a draft pull request.

The pull request description must include:

- Article summary
- Main technical topics
- Validation results
- Known limitations or unresolved questions
- Editorial review checklist

## Telegram response

After successfully creating the pull request, report:

- Article title
- Feature branch
- Pull request URL
- Validation status
- Any issues requiring review

## Safety boundaries

- Never merge pull requests.
- Never modify `blog-site` automatically.
- Never update the submodule pointer.
- Never trigger publication.
- Never force-push.
- Never overwrite existing branches.
- Never commit credentials or secrets.
- Stop and report unexpected repository or authentication errors.
