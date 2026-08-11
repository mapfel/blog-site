# Marko Apfel's blog

Hugo source for `https://blog.marko-apfel.de/`. Articles live in the separate
`blog-content` repository and are included at `content-source` as a Git
submodule.

## Prerequisites

- Git
- Hugo 0.164.0 or newer
- Python 3.11 or newer for content validation

## Clone and run

```sh
git clone --recurse-submodules <site-repository-url>
cd blog-site
hugo server --buildDrafts
```

If the repository was cloned without submodules:

```sh
git submodule update --init --recursive
```

## Create an article on Windows

Run the authoring helper from the site repository:

```powershell
./scripts/new-post.ps1 -Title "My article title"
```

The helper creates `content-source/content/posts/YYYY/MM/<slug>/index.md`.
Commit and push that change from inside `content-source`, then commit the updated
submodule pointer in this repository.

## Publish content changes

```sh
git -C content-source add .
git -C content-source commit -m "Add article"
git -C content-source push
git add content-source
git commit -m "Update article repository"
git push
```

## GitHub Pages

The workflow in `.github/workflows/pages.yml` builds and deploys `main`. After
pushing the repository:

1. Select **GitHub Actions** as the Pages source.
2. Set the custom domain to `blog.marko-apfel.de`.
3. Create a DNS CNAME named `blog` pointing to `<account>.github.io`.
4. Enable HTTPS after GitHub validates the DNS record.

The relative URL in `.gitmodules` assumes both GitHub repositories have the same
owner and are named `blog-site` and `blog-content`.
