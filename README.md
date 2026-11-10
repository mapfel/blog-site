# Marko Apfel's blog

Hugo source for `https://blog.marko-apfel.de/`. Articles live in the separate
`blog-content` repository and are included at `content-source` as a Git
submodule.

## Prerequisites

- Git
- Python 3.11 or newer for content validation
- Hugo and Pagefind in the versions pinned in `.github/workflows/pages.yml`
  (installed locally by `scripts/install-tools.ps1`, see below)

## Set up a machine

A single recursive clone contains everything needed to write and build the blog:

```powershell
git clone --recurse-submodules <site-repository-url> blog-site
cd blog-site
git -C content-source switch main
./scripts/install-tools.ps1
```

```text
blog-site/              site repository (layouts, config, workflow)
├── content-source/     blog-content repository as submodule (articles, media)
└── .tools/             Hugo and Pagefind binaries (ignored, from install-tools.ps1)
```

`install-tools.ps1` reads the Hugo and Pagefind versions from the Pages workflow,
so local builds use the same versions as the deployment. Rerun it after the
workflow versions change; `-Force` reinstalls. It prints a line that puts both
tools on `PATH` for the current PowerShell session.

A submodule is checked out at the commit recorded by this repository, in
detached-HEAD state. Switch it to `main` (as above) before writing articles.
To pull newer content into it later:

```sh
git submodule update --remote --merge
```

If the repository was cloned without submodules:

```sh
git submodule update --init --recursive
```

A separate clone of `blog-content` next to this repository is not required. If
one exists, it is an independent checkout: its changes reach `content-source`
only through push and pull.

## Run locally

```powershell
./.tools/hugo/hugo.exe server --buildDrafts
```

To check search as well, build the site and index it like the workflow does:

```powershell
./.tools/hugo/hugo.exe --gc --minify
./.tools/pagefind/pagefind.exe --site public
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
