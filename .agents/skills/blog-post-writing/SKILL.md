---
name: blog-post-writing
description: Write, draft, or revise a post for Marko Apfel's Hugo blog, including turning notes, a file, or the current conversation into a post, backdating, and choosing its header, topics, and tags. Use for blog writing and editorial reviews; use maintain-blog for site work and migrations.
---

# Write posts for Marko Apfel's blog

Produce a standalone, technically precise post. The blog covers software
engineering, tools, productivity, homelab administration, and digital media. Its
voice is a practitioner sharing useful experience with another practitioner.

[references/conventions.md](references/conventions.md) holds the header schema,
article shapes, presentation rules, and bundle rules. Read it before writing a
header or choosing a structure. Explicit user instructions take precedence over
it and over this skill.

## Voice

- Lead with the actual problem, question, or task. Give enough context for a
  reader arriving from search, and open straight into the material.
- Write new posts in direct, conversational English unless the user requests
  another language. When editing, keep the post's language; the archive also
  contains German. Use contractions naturally. Address the reader as "you" for
  actions; use "I" only for experiences established by the source. Every
  experience, measurement, and result must come from the source.
- Make explanations concrete: exact error messages, commands, settings,
  examples, and the reason a change helps. Preserve technical identifiers, and
  distinguish observed results from illustrative examples. Verify outdated or
  fast-changing technical claims against current primary documentation.
- Give recommendations with their conditions and costs. Keep uncertainty in
  exploratory material and competing arguments in unresolved discussions.
  Present personal preferences as preferences.
- Keep short fixes short. Use longer sections, tables, and checklists only when
  they clarify. End when the useful explanation is complete; a conclusion is
  optional.
- Keep the author's candid opinions where the source supports them. Correct
  awkward wording while keeping practical detail; plain prose beats marketing
  tone.

## Producing a post

1. **Gather the source.** With supplied text, a file, or a draft, use it and
   tidy only where needed. When asked to write up the current conversation,
   draft from what was actually discussed, with its real commands, paths, and
   errors.
2. **Inspect the repository.** Locate the checkout: from the site root, posts are
   in `content-source/content/posts/`; in the content repository alone, in
   `content/posts/`. Read `archetypes/posts.md`, the validator, `hugo.toml`, and
   a few related posts. The repository may have changed since this skill was
   written.
3. **Write the header** by following the conventions reference. For an accurate
   Europe/Berlin timestamp, use PowerShell; Git Bash's `date` ignores
   `TZ='Europe/Berlin'` on Windows and returns the wrong offset:

   ```powershell
   $tz = [TimeZoneInfo]::FindSystemTimeZoneById('W. Europe Standard Time')
   [TimeZoneInfo]::ConvertTime([DateTimeOffset]::Now, $tz).ToString('yyyy-MM-ddTHH:mm:sszzz')
   # A given local time, with the DST offset of that date:
   $local = [datetime]'2026-01-15 10:00'
   [DateTimeOffset]::new($local, $tz.GetUtcOffset($local)).ToString('yyyy-MM-ddTHH:mm:sszzz')
   ```

   Reuse existing topics and tags, listed with counts:

   ```sh
   grep -rhE '^(topics|tags) = ' content-source/content/posts | sort | uniq -c | sort -rn
   ```

4. **Place the bundle** at `content-source/content/posts/YYYY/MM/<slug>/index.md`,
   with `YYYY/MM` taken from `date`; a backdated post goes in its historical
   folder. Confirm the slug is unused across all years, both as a folder name and
   as an explicit `slug`. `scripts/new-post.ps1 -Title ... -Slug ...` can create
   the bundle; complete its empty description, topics, and tags.
5. **Revisions** keep `date`, `slug`, attribution, and existing metadata. Update
   `lastmod` for substantive changes, and keep the bundle in place.
6. **Check before handing off.** Confirm technical fidelity, the header, heading
   hierarchy, links, and bundled media. Then run the validator:
   `python content-source/scripts/validate_content.py content-source/content/posts`
   from the site root, or `python scripts/validate_content.py content/posts`
   from the content repository. Report the path, the validation result
   (including pre-existing failures), and the preview command from
   `maintain-blog`. For a writing-only answer with no file changes, deliver the
   draft without claiming validation.

Git operations follow `AGENTS.md`. For review through a pull request, use
`hugo-article-workflow`.
