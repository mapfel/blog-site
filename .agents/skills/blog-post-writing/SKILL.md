---
name: blog-post-writing
description: Draft, revise, or adapt posts for Marko Apfel's Hugo blog, using its front matter, practical technical voice, article structures, and bundle conventions. Use for blog writing and editorial reviews, rather than general prose or site implementation.
---

# Write posts for Marko Apfel's blog

Use the user's source and intent to produce a standalone, technically precise post. The blog covers software engineering, tools, productivity, homelab administration, and digital media. Its voice is a practitioner sharing useful experience with another practitioner.

Read [references/conventions.md](references/conventions.md) for the header schema, article patterns, and evidence from the archive. These are defaults inferred from the repository, not a mandate to make every post look alike. Explicit user instructions take precedence.

## Writing decisions

- Lead with the actual problem, question, or task. Explain enough context for a reader arriving from search. Skip generic claims about today's fast-paced technology landscape.
- Write direct, conversational English for new posts unless the user requests another language. Preserve an existing post's language when editing; the archive also contains German. Use contractions naturally. Address the reader as "you" for actions; use "I" only for experiences established by the source. Never invent experiences on Marko's behalf.
- Make explanations concrete: exact error messages, commands, settings, examples, and the reason a change helps. Preserve technical identifiers and distinguish observed results from illustrative examples. Do not copy outdated technical claims as verified facts.
- Give recommendations with their conditions and costs. Retain uncertainty in exploratory material and competing arguments in unresolved discussions. Do not turn personal preferences into universal requirements.
- Keep short fixes short. Use longer sections, tables, and checklists only when they clarify the material. A conclusion is optional; end when the useful explanation is complete. Avoid repetitive takeaways and stock closing labels.
- Keep the author's candid opinions when supported by the source, but do not manufacture outrage, rhetorical questions, jokes, or slang. Correct awkward wording without replacing practical detail with marketing prose.

## Producing a post

Locate the active checkout: the site repository normally contains `hugo.toml` and the content submodule at `content-source/`. If working directly in the content repository, posts are under `content/posts/`. Inspect the current archetype, validator, configuration, and a few related posts before writing metadata or cross-links; the repository may have evolved since this skill was recorded.

Preserve existing dates, slugs, attribution, and useful metadata when revising. For new posts, use the front matter and bundle rules in the reference.

For articles created through the pull request workflow, set `draft = false`. The feature branch and draft pull request serve as the editorial review boundary.

Never merge a pull request, update the site's submodule pointer, or trigger publication without explicit authorization.

Before handing off, check the post's technical fidelity, header, heading hierarchy, links, and bundled media. Run the content validator if a working Python 3.11+ runtime is available:

```sh
python content-source/scripts/validate_content.py content-source/content/posts
```

From the content repository use `python scripts/validate_content.py content/posts`. Report validation limitations or pre-existing failures accurately. For a writing-only response with no file changes, supply the requested draft without implying validation ran.
