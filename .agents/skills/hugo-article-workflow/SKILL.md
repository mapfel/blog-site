---
name: hugo-article-workflow
description: Submit a new or revised blog article as a GitHub draft pull request in the blog-content repository for editorial review. Use when the user asks for the review or pull-request workflow; otherwise use blog-post-writing.
---

# Hugo Article Workflow

Write the article with `blog-post-writing` and its conventions. This skill adds
the Git and review steps around it.

## Boundaries

- All branches, commits, and pull requests belong to `blog-content`, checked out
  at `content-source/` in the site repository. The site repository
  (`blog-site`) is read-only for this workflow, including its configuration,
  workflows, and submodule pointer.
- Work on a feature branch. Changes reach `main` only when the user merges the
  pull request.
- The pull request is the review boundary, so the article keeps `draft = false`.

## Before writing

1. Locate the content repository and verify its remote.
2. Inspect the working tree and branch, and preserve existing changes. When
   another task is in progress, use a separate Git worktree.
3. Fetch, then create `article/<slug>` from `origin/main`, adding a suffix if the
   name exists.
4. Clarify missing editorial requirements essential to the article.

## Validate

Run `python scripts/validate_content.py content/posts` from the content
repository root, and fix its errors. Where the site checkout and tools are
available, also build or preview it (see `maintain-blog`). Check technical
accuracy, local references, the header, and unintended file changes. If
validation fails, report the failure and the fix needed instead of opening a
pull request.

## Commit and pull request

1. Review `git status` and `git diff`, and stage only the article's files.
2. Commit with a concise English message, and push the branch.
3. Open a draft pull request against `main` in `blog-content`, in English, with
   the article summary, validation results, and open review notes:

   ```bash
   gh pr create --base main --head "article/<slug>" --draft \
     --title "Add article: <title>" --body "<summary and validation notes>"
   ```

   Authentication and permissions may be missing; report this rather than
   assume.

The pull request stays a draft. Marking it ready, approving, merging, and
updating the site's submodule pointer belong to the user.

## Report

Return the article title, content path, branch, validation result, pull request
URL, and open questions. If a step fails, say what succeeded, what failed, and
whether a remote branch or pull request exists. The article is published only
after the merge and a later update of the site's submodule pointer.
