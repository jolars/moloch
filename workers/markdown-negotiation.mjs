function acceptsMarkdown(header) {
  return (header ?? "").split(",").some((range) => {
    const [type, ...parameters] = range.trim().toLowerCase().split(";");
    if (type.trim() !== "text/markdown") return false;
    const quality = parameters.find((parameter) =>
      parameter.trim().startsWith("q="),
    );
    if (!quality) return true;
    const value = quality.trim().slice(2);
    return (
      /^(?:0(?:\.\d{0,3})?|1(?:\.0{0,3})?)$/.test(value) && Number(value) > 0
    );
  });
}

function markdownPath(path) {
  if (path.endsWith("/")) return `${path}index.llms.md`;
  if (path.endsWith(".html")) return `${path.slice(0, -5)}.llms.md`;
  if (!path.split("/").at(-1).includes(".")) return `${path}.llms.md`;
  return null;
}

function varyOnAccept(headers) {
  const vary = headers.get("vary");
  if (!vary) headers.set("vary", "Accept");
  else if (
    !vary
      .split(",")
      .some((value) => ["accept", "*"].includes(value.trim().toLowerCase()))
  ) {
    headers.set("vary", `${vary}, Accept`);
  }
}

async function fetchOriginal(request, fetchOrigin) {
  const response = await fetchOrigin(request);
  if (!/^text\/html(?:;|$)/i.test(response.headers.get("content-type") ?? ""))
    return response;
  const headers = new Headers(response.headers);
  varyOnAccept(headers);
  return new Response(request.method === "HEAD" ? null : response.body, {
    status: response.status,
    statusText: response.statusText,
    headers,
  });
}

export async function handleRequest(request, fetchOrigin = fetch) {
  const url = new URL(request.url);
  const path = markdownPath(url.pathname);
  if (!path || !["GET", "HEAD"].includes(request.method))
    return fetchOrigin(request);
  if (!acceptsMarkdown(request.headers.get("accept")))
    return fetchOriginal(request, fetchOrigin);

  const markdownUrl = new URL(url);
  markdownUrl.pathname = path;
  markdownUrl.search = "";
  const requestHeaders = new Headers(request.headers);
  requestHeaders.set("accept", "text/markdown");
  // HTML validators and ranges cannot describe the Markdown representation.
  for (const header of [
    "if-none-match",
    "if-modified-since",
    "if-range",
    "range",
  ])
    requestHeaders.delete(header);

  try {
    const markdown = await fetchOrigin(
      new Request(markdownUrl, {
        method: "GET",
        headers: requestHeaders,
        redirect: "manual",
      }),
    );
    if (
      markdown.status === 200 &&
      /^text\/(?:markdown|plain)(?:;|$)/i.test(
        markdown.headers.get("content-type") ?? "",
      )
    ) {
      const body = await markdown.text();
      const headers = new Headers(markdown.headers);
      for (const header of [
        "content-length",
        "content-encoding",
        "etag",
        "last-modified",
        "content-range",
        "accept-ranges",
        "transfer-encoding",
      ])
        headers.delete(header);
      headers.set("content-type", "text/markdown; charset=utf-8");
      headers.set(
        "x-markdown-tokens",
        String(Math.ceil(new TextEncoder().encode(body).length / 4)),
      );
      varyOnAccept(headers);
      return new Response(request.method === "HEAD" ? null : body, { headers });
    }
    await markdown.body?.cancel();
  } catch {
    console.error(
      JSON.stringify({ event: "markdown_fetch_failed", path: url.pathname }),
    );
  }
  return fetchOriginal(request, fetchOrigin);
}

export default {
  fetch(request) {
    return handleRequest(request);
  },
};
