---
name: hugo-article-workflow
description: Create or revise English-language Hugo blog articles in the blog-content repository, validate them, and submit them as GitHub Draft Pull Requests for editorial review. Use when the user asks to write, prepare, or revise a blog article through the GitHub review workflow.
---

# Hugo Article Workflow

Manage the article creation and review workflow for the Hugo blog.

Use the existing `blog-post-writing` skill for editorial guidance, technical writing standards, front matter conventions, and article structure. Do not duplicate or replace its editorial rules.

## Repository responsibilities

- `blog-site` is the Hugo site repository. Treat it as read-only during article creation.
- `blog-content` is the content repository. All article branches, commits, and pull requests belong here.
- `blog-site` includes `blog-content` as a Git submodule at `content-source/`.
- Never commit to or push directly to `main`.
- Never merge pull requests, update the submodule pointer, or trigger deployment.
- Never modify site configuration or GitHub Actions workflows as part of article writing.

## Before writing

1. Locate the content repository and verify its Git remote.
2. Inspect the working tree and current branch. Do not discard existing changes.
3. Fetch the latest remote state.
4. Create a unique feature branch named `article/<slug>` from `origin/main`. If the name already exists, choose a unique suffix.
5. Inspect related existing articles, the content validator, and the conventions referenced by `blog-post-writing`.
6. Clarify missing essential editorial requirements before proceeding.

Do not use a dirty working tree for an unrelated article. Prefer an isolated Git worktree when another task is in progress.

## Article creation

- Write all article content in English.
- Follow the `blog-post-writing` skill and its `references/conventions.md`.
- Create Hugo leaf page bundles at `content/posts/YYYY/MM/<slug>/index.md`.
- Keep article-specific media in the same bundle.
- Use valid TOML front matter with the required fields.
- Set `draft = false` for new articles in this workflow.
- Ensure that the directory year and month match the article's `date`.
- Use an RFC 3339 timestamp with a timezone offset.
- Ensure `lastmod` is not earlier than `date`.
- Avoid duplicate slugs and conflicting article paths.
- Do not invent personal experiences, measurements, test results, or sources.

A GitHub Draft Pull Request is the editorial review mechanism. The Hugo `draft` field is not used to represent that review status.

## Validation

Run the content repository's validator from the repository root:

```bash
python scripts/validate_content.py content/posts
```

Review the output and fix errors before publishing the branch.

Where the Hugo site checkout and required tooling are available, also run an appropriate Hugo build or preview check.

Check the article manually for technical accuracy, broken local references, incorrect front matter, and unintended file changes.

If validation fails, do not create a pull request claiming the article is ready. Report the failure and the corrective action needed.

## Commit and pull request

1. Review `git status` and `git diff`.
2. Stage only files belonging to the requested article.
3. Use a concise English commit message.
4. Push the feature branch to the content repository.
5. Create a GitHub Draft Pull Request against `main` in `blog-content`.
6. Write the pull request title and description in English.
7. Include an article summary, validation results, and any unresolved review notes.

Example pull request creation:

```bash
gh pr create \
  --base main \
  --head "article/<slug>" \
  --draft \
  --title "Add article: <title>" \
  --body "<English summary and validation notes>"
```

Use the actual branch name and repository context. Do not assume that authentication or repository permissions are configured.

Never mark the pull request ready for review, approve it, or merge it unless a separate, explicitly authorized workflow permits that action. This workflow does not.

## Completion report

Return a concise report containing:

- Article title
- Content path
- Feature branch
- Validation result
- Draft Pull Request URL
- Any open questions or review notes

If a step fails, explain what succeeded, what failed, and whether any remote branch or pull request was created.

Do not claim that the article is published. Publication requires a separate update of the `blog-site` submodule pointer after the content pull request has been merged.