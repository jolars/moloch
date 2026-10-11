# Markdown negotiation

This Worker serves Quarto's generated `.llms.md` file when an agent requests
`Accept: text/markdown` at the corresponding page URL. HTML stays on GitHub
Pages. The Worker preserves paths for every documentation channel, including
`/dev/`, `/latest/`, `/releases/<tag>/`, and `/texlive/<year>/`.

The documentation build generates the Markdown files alongside the HTML.
`website.llms-txt` enables this for the installed Quarto version, which ignores
the setting under `book`. The existing publishing workflow copies both formats
to each channel. Options, keys, and LaTeX examples remain in the generated
Markdown, while Quarto removes navigation, scripts, and styles.

Responses include `Content-Type: text/markdown; charset=utf-8`, `Vary: Accept`,
and a token estimate in `x-markdown-tokens` based on UTF-8 bytes divided by
four. Requests that reject Markdown, assets, and unsupported methods use the
origin. If a Markdown file is missing or inaccessible, the Worker falls back to
HTML.

Run the tests and check the Worker bundle from the repository root:

```sh
node --test workers/markdown-negotiation.test.mjs
wrangler deploy --dry-run --config workers/wrangler.jsonc
```

Publish the documentation with its generated Markdown before deploying the
Worker. Existing release and TeX Live channels that have not been rebuilt will
continue to serve HTML until their Markdown files are published.

The `moloch.ink` DNS record must remain proxied through Cloudflare. Deploy with
an authenticated Cloudflare account that can edit Workers and zone routes:

```sh
wrangler deploy --config workers/wrangler.jsonc
```

Set the route to **Fail open** in Cloudflare so GitHub Pages remains available
if the Workers Free daily request limit is reached. No API tokens belong in the
repository.

Verify both representations after publishing and deploying:

```sh
curl -i https://moloch.ink/ -H 'Accept: text/markdown'
curl -i https://moloch.ink/customization.html -H 'Accept: text/markdown'
curl -I https://moloch.ink/ -H 'Accept: text/html'
```
