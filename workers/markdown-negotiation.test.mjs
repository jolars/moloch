import assert from "node:assert/strict";
import test from "node:test";
import { handleRequest } from "./markdown-negotiation.mjs";

function origin({
  markdownStatus = 200,
  markdownType = "text/markdown",
  vary = "Accept-Encoding",
  fail = false,
} = {}) {
  const requests = [];
  const fetcher = async (request) => {
    requests.push(request);
    if (new URL(request.url).pathname.endsWith(".llms.md")) {
      if (fail) throw new Error("Origin unavailable.");
      return new Response("# Moloch\n\nLaTeX: `\\usetheme{moloch}`.\n", {
        status: markdownStatus,
        headers: {
          "content-type": markdownType,
          "cache-control": "max-age=600",
          etag: '"markdown"',
          "content-length": "50",
          "last-modified": "Sun, 11 Oct 2026 12:00:00 GMT",
          vary,
        },
      });
    }
    return new Response(request.method === "HEAD" ? null : "<h1>Moloch</h1>", {
      headers: {
        "content-type": "text/html; charset=utf-8",
        etag: '"html"',
        vary,
      },
    });
  };
  return { requests, fetcher };
}

test("serves HTML by default and preserves its body and validators", async () => {
  for (const accept of [
    "",
    "*/*",
    "text/html",
    "text/markdown;q=0",
    "text/markdown;q=invalid",
    "text/markdown;q=2",
  ]) {
    const { requests, fetcher } = origin();
    const response = await handleRequest(
      new Request("https://moloch.ink/", { headers: { accept } }),
      fetcher,
    );
    assert.equal(requests.length, 1);
    assert.equal(requests[0].url, "https://moloch.ink/");
    assert.equal(await response.text(), "<h1>Moloch</h1>");
    assert.equal(response.headers.get("etag"), '"html"');
    assert.equal(response.headers.get("vary"), "Accept-Encoding, Accept");
  }
});

test("maps pages to Markdown within their documentation channel", async () => {
  for (const [page, markdown] of [
    ["/", "/index.llms.md"],
    ["/index.html", "/index.llms.md"],
    ["/customization.html", "/customization.llms.md"],
    ["/customization", "/customization.llms.md"],
    ["/dev/", "/dev/index.llms.md"],
    ["/latest/commands.html", "/latest/commands.llms.md"],
    [
      "/releases/v2.2.0/getting-started.html",
      "/releases/v2.2.0/getting-started.llms.md",
    ],
    [
      "/texlive/2026/implementation/beamerthememoloch.html",
      "/texlive/2026/implementation/beamerthememoloch.llms.md",
    ],
    ["/texlive/latest/changelog/", "/texlive/latest/changelog/index.llms.md"],
  ]) {
    const { requests, fetcher } = origin();
    const response = await handleRequest(
      new Request(`https://moloch.ink${page}?view=full`, {
        headers: { accept: "text/html, TEXT/MARKDOWN;q=0.8" },
      }),
      fetcher,
    );
    assert.equal(requests.length, 1);
    assert.equal(requests[0].url, `https://moloch.ink${markdown}`);
    assert.equal(
      response.headers.get("content-type"),
      "text/markdown; charset=utf-8",
    );
    assert.match(await response.text(), /\\usetheme\{moloch\}/);
    assert.equal(response.headers.get("vary"), "Accept-Encoding, Accept");
    assert.equal(response.headers.get("cache-control"), "max-age=600");
    assert.ok(Number(response.headers.get("x-markdown-tokens")) > 0);
    for (const header of ["content-length", "etag", "last-modified"])
      assert.equal(response.headers.has(header), false);
  }
});

test("removes HTML conditionals and ranges from Markdown origin requests", async () => {
  const { requests, fetcher } = origin();
  const headers = {
    accept: "text/markdown",
    "if-none-match": '"html"',
    "if-modified-since": "yesterday",
    range: "bytes=0-10",
    "if-range": '"html"',
  };
  const request = new Request("https://moloch.ink/", { headers });
  const response = await handleRequest(request, fetcher);
  assert.equal(response.status, 200);
  assert.equal(requests[0].headers.get("accept"), "text/markdown");
  assert.equal(requests[0].redirect, "manual");
  for (const header of [
    "if-none-match",
    "if-modified-since",
    "if-range",
    "range",
  ]) {
    assert.equal(requests[0].headers.has(header), false);
    assert.equal(request.headers.get(header), headers[header]);
  }
});

test("returns Markdown HEAD headers without a body", async () => {
  const { requests, fetcher } = origin();
  const response = await handleRequest(
    new Request("https://moloch.ink/", {
      method: "HEAD",
      headers: { accept: "text/markdown" },
    }),
    fetcher,
  );
  assert.equal(requests[0].method, "GET");
  assert.equal(
    response.headers.get("content-type"),
    "text/markdown; charset=utf-8",
  );
  assert.ok(Number(response.headers.get("x-markdown-tokens")) > 0);
  assert.equal(await response.text(), "");
});

test("falls back to HTML when Markdown is missing, redirected, or an error page", async () => {
  for (const options of [
    { markdownStatus: 404 },
    { markdownStatus: 500 },
    { markdownStatus: 301 },
    { markdownType: "text/html" },
  ]) {
    const { requests, fetcher } = origin(options);
    const response = await handleRequest(
      new Request("https://moloch.ink/customization.html", {
        headers: { accept: "text/markdown" },
      }),
      fetcher,
    );
    assert.deepEqual(
      requests.map((request) => new URL(request.url).pathname),
      ["/customization.llms.md", "/customization.html"],
    );
    assert.equal(await response.text(), "<h1>Moloch</h1>");
    assert.equal(
      response.headers.get("content-type"),
      "text/html; charset=utf-8",
    );
    assert.equal(response.headers.get("vary"), "Accept-Encoding, Accept");
  }
});

test("falls back to HTML when fetching Markdown throws", async (t) => {
  t.mock.method(console, "error", () => {});
  const { fetcher } = origin({ fail: true });
  const response = await handleRequest(
    new Request("https://moloch.ink/", {
      headers: { accept: "text/markdown" },
    }),
    fetcher,
  );
  assert.equal(response.status, 200);
  assert.equal(await response.text(), "<h1>Moloch</h1>");
});

test("normalizes plain-text Markdown and preserves existing Vary dimensions", async () => {
  for (const vary of ["*", "accept, Accept-Encoding"]) {
    const { fetcher } = origin({
      markdownType: "text/plain; charset=utf-8",
      vary,
    });
    const response = await handleRequest(
      new Request("https://moloch.ink/", {
        headers: { accept: "text/markdown" },
      }),
      fetcher,
    );
    assert.equal(response.headers.get("vary"), vary);
    assert.equal(
      response.headers.get("content-type"),
      "text/markdown; charset=utf-8",
    );
  }
});

test("passes assets and unsupported methods through unchanged", async () => {
  for (const [path, method] of [
    ["/images/og.jpg", "GET"],
    ["/moloch.pdf", "HEAD"],
    ["/llms.txt", "GET"],
    ["/styles.css", "GET"],
    ["/customization.llms.md", "GET"],
    ["/", "POST"],
  ]) {
    const request = new Request(`https://moloch.ink${path}`, {
      method,
      headers: { accept: "text/markdown", range: "bytes=0-10" },
    });
    const expected = new Response(null, { status: 206 });
    const response = await handleRequest(request, async (actual) => {
      assert.equal(actual, request);
      return expected;
    });
    assert.equal(response, expected);
  }
});

test("preserves missing-page statuses for both representations", async () => {
  for (const accept of ["text/html", "text/markdown"]) {
    const response = await handleRequest(
      new Request("https://moloch.ink/missing.html", { headers: { accept } }),
      async () =>
        new Response("Missing", {
          status: 404,
          headers: { "content-type": "text/html" },
        }),
    );
    assert.equal(response.status, 404);
    assert.equal(await response.text(), "Missing");
    assert.equal(response.headers.get("vary"), "Accept");
  }
});
