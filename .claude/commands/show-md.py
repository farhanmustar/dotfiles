#!/usr/bin/env python3
"""Serve a Markdown file as rendered HTML with dark/light mode, syntax highlighting, print support, and hot reload."""

import argparse
import http.server
import json
import os
import signal
import sys
import threading
import time


def read_md(md_path):
    with open(md_path, "r", encoding="utf-8") as f:
        return f.read()


def escape_for_js(text):
    return (
        text.replace("\\", "\\\\")
        .replace("`", "\\`")
        .replace("$", "\\$")
        .replace("</script", "<\\/script")
    )


def build_html(md_path):
    title = os.path.basename(md_path)
    md_content = read_md(md_path)
    escaped = escape_for_js(md_content)

    return f"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>{title}</title>
<link id="hljs-theme" rel="stylesheet"
  href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/github.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/marked/12.0.1/marked.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/mermaid/10.9.0/mermaid.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js"></script>
<style>
  :root {{
    color-scheme: light;
    --bg: #ffffff;
    --fg: #1f2328;
    --muted: #656d76;
    --border: #d6dae0;
    --accent: #0969da;
    --code-bg: #f4f6f8;
    --bar-bg: #f8f9fa;
    --on: #1a7f37;
    --max-width: 900px;
  }}
  @media (prefers-color-scheme: dark) {{
    :root:not([data-theme="light"]) {{
      color-scheme: dark;
      --bg: #0d1117;
      --fg: #e6edf3;
      --muted: #8d96a0;
      --border: #30363d;
      --accent: #4493f8;
      --code-bg: #161b22;
      --bar-bg: #161b22;
      --on: #3fb950;
    }}
  }}
  :root[data-theme="dark"] {{
    color-scheme: dark;
    --bg: #0d1117;
    --fg: #e6edf3;
    --muted: #8d96a0;
    --border: #30363d;
    --accent: #4493f8;
    --code-bg: #161b22;
    --bar-bg: #161b22;
    --on: #3fb950;
  }}

  * {{ box-sizing: border-box; }}

  body {{
    margin: 0;
    background: var(--bg);
    color: var(--fg);
    font: 16px/1.6 -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
          "Helvetica Neue", Arial, sans-serif;
    -webkit-font-smoothing: antialiased;
  }}

  /* toolbar */
  .toolbar {{
    position: sticky;
    top: 0;
    z-index: 10;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
    padding: 6px 14px;
    background: var(--bar-bg);
    border-bottom: 1px solid var(--border);
    font-size: 13px;
  }}
  .toolbar-left, .toolbar-right {{ display: flex; align-items: center; gap: 8px; min-width: 0; }}
  .doc-name {{
    font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
    color: var(--muted);
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }}
  .doc-status {{ color: var(--muted); font-size: 12px; white-space: nowrap; }}
  .doc-status.flash {{ color: var(--on); }}

  .btn {{
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 4px 10px;
    font: inherit;
    font-size: 13px;
    color: var(--fg);
    background: transparent;
    border: 1px solid var(--border);
    border-radius: 6px;
    cursor: pointer;
    white-space: nowrap;
  }}
  .btn:hover {{ border-color: var(--accent); color: var(--accent); }}
  .btn-icon {{ padding: 4px 7px; }}
  .btn-icon svg {{ display: block; width: 15px; height: 15px; }}
  .btn-theme .icon-sun {{ display: none; }}
  .btn-theme.is-dark .icon-sun {{ display: block; }}
  .btn-theme.is-dark .icon-moon {{ display: none; }}

  /* content */
  .page {{ max-width: var(--max-width); margin: 0 auto; padding: 32px 24px 25vh; }}

  .markdown-body > *:first-child {{ margin-top: 0; }}
  .markdown-body h1, .markdown-body h2, .markdown-body h3,
  .markdown-body h4, .markdown-body h5, .markdown-body h6 {{
    margin: 1.6em 0 .6em;
    line-height: 1.25;
    font-weight: 600;
  }}
  .markdown-body h1 {{ font-size: 2em; padding-bottom: .3em; border-bottom: 1px solid var(--border); }}
  .markdown-body h2 {{ font-size: 1.5em; padding-bottom: .3em; border-bottom: 1px solid var(--border); }}
  .markdown-body h3 {{ font-size: 1.25em; }}
  .markdown-body h4 {{ font-size: 1em; }}
  .markdown-body h5, .markdown-body h6 {{ font-size: .9em; color: var(--muted); }}

  .markdown-body p, .markdown-body ul, .markdown-body ol, .markdown-body dl {{ margin: 0 0 1em; }}
  .markdown-body ul, .markdown-body ol {{ padding-left: 1.8em; }}
  .markdown-body li + li {{ margin-top: .25em; }}
  .markdown-body li > ul, .markdown-body li > ol {{ margin: .25em 0; }}

  .markdown-body a {{ color: var(--accent); text-decoration: none; }}
  .markdown-body a:hover {{ text-decoration: underline; }}

  .markdown-body blockquote {{
    margin: 0 0 1em;
    padding: .2em 1em;
    color: var(--muted);
    border-left: 3px solid var(--border);
  }}

  .markdown-body code {{
    padding: .15em .4em;
    font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace;
    font-size: .875em;
    background: var(--code-bg);
    border-radius: 4px;
  }}
  .markdown-body pre {{
    margin: 0 0 1em;
    padding: 12px 14px;
    overflow-x: auto;
    background: var(--code-bg);
    border: 1px solid var(--border);
    border-radius: 6px;
  }}
  .markdown-body pre code {{ padding: 0; background: none; font-size: .85em; }}
  .markdown-body pre code.hljs {{ background: none; }}

  .markdown-body table {{
    display: block;
    width: max-content;
    max-width: 100%;
    overflow-x: auto;
    margin: 0 0 1em;
    border-collapse: collapse;
  }}
  .markdown-body th, .markdown-body td {{ padding: 6px 13px; border: 1px solid var(--border); }}
  .markdown-body th {{ background: var(--code-bg); font-weight: 600; text-align: left; }}

  .markdown-body img {{ max-width: 100%; }}
  .markdown-body hr {{ height: 1px; margin: 2em 0; background: var(--border); border: 0; }}

  .markdown-body input[type="checkbox"] {{ margin-right: .4em; }}
  .markdown-body li:has(> input[type="checkbox"]) {{ list-style: none; margin-left: -1.4em; }}

  pre.mermaid {{
    padding: 16px;
    text-align: center;
    background: var(--code-bg);
    color: transparent;
    border: 1px solid var(--border);
    border-radius: 6px;
  }}
  pre.mermaid[data-processed="true"] {{ color: inherit; background: transparent; border-color: transparent; }}
  pre.mermaid svg {{ max-width: 100%; height: auto; }}

  /* print */
  @page {{
    size: A4 portrait;
    margin: 18mm 16mm;
  }}

  @media print {{
    :root, :root[data-theme="dark"] {{
      color-scheme: light;
      --bg: #ffffff; --fg: #000000; --muted: #444; --border: #bbb;
      --accent: #0645ad; --code-bg: #f4f6f8; --bar-bg: #fff;
      --on: #1a7f37;
    }}

    * {{ -webkit-print-color-adjust: exact; print-color-adjust: exact; }}
    .toolbar {{ display: none !important; }}

    html, body {{
      background: #fff;
      color: #000;
      margin: 0;
      padding: 0;
    }}
    body {{ font-size: 10.5pt; line-height: 1.45; }}
    .page {{ max-width: none; margin: 0; padding: 0; }}

    :root {{ --heading-reserve: 78mm; }}

    .markdown-body h1, .markdown-body h2, .markdown-body h3,
    .markdown-body h4, .markdown-body h5, .markdown-body h6,
    .markdown-body summary, .markdown-body dt, .markdown-body .pseudo-heading {{
      position: relative;
      break-after: avoid;
      break-inside: avoid;
      margin-top: 1.2em;
      padding-bottom: var(--heading-reserve);
      margin-bottom: calc(.6em - var(--heading-reserve));
    }}

    .markdown-body h1, .markdown-body h2 {{
      padding-bottom: calc(.3em + var(--heading-reserve));
      border-bottom: 0;
    }}
    .markdown-body h1::after, .markdown-body h2::after {{
      content: "";
      position: absolute;
      left: 0;
      right: 0;
      bottom: calc(var(--heading-reserve) - 1px);
      border-bottom: 1px solid var(--border);
    }}
    .markdown-body h1 {{ font-size: 19pt; }}
    .markdown-body h2 {{ font-size: 15pt; }}
    .markdown-body h3 {{ font-size: 12.5pt; }}
    .markdown-body h4, .markdown-body h5, .markdown-body h6 {{ font-size: 11pt; }}

    .markdown-body p {{ orphans: 3; widows: 3; }}

    .markdown-body pre,
    .markdown-body blockquote,
    .markdown-body img,
    .markdown-body tr,
    pre.mermaid {{ break-inside: avoid; }}

    .markdown-body pre {{
      overflow: visible;
      white-space: pre-wrap;
      word-wrap: break-word;
      font-size: 8.5pt;
    }}
    .markdown-body code {{ font-size: .85em; }}

    .markdown-body table {{
      display: table;
      width: 100%;
      max-width: 100%;
      overflow: visible;
      font-size: 9.5pt;
      break-inside: auto;
    }}
    .markdown-body thead {{ display: table-header-group; }}
    .markdown-body th, .markdown-body td {{ padding: 4px 8px; }}

    .markdown-body img,
    pre.mermaid svg {{ max-width: 100%; max-height: 220mm; height: auto; }}

    pre.mermaid {{ padding: 0; background: none; border: 0; }}
    .markdown-body a {{ color: #0645ad; text-decoration: none; }}
  }}
</style>
</head>
<body>

<header class="toolbar">
  <div class="toolbar-left">
    <span class="doc-name">{title}</span>
    <span class="doc-status" id="docStatus"></span>
  </div>
  <div class="toolbar-right">
    <button type="button" class="btn btn-icon" id="printBtn"
            aria-label="Print" title="Print (A4)">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
           stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
        <path d="M6 9V3h12v6"/>
        <path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/>
        <rect x="6" y="14" width="12" height="7" rx="1"/>
      </svg>
    </button>
    <button type="button" class="btn btn-icon btn-theme" id="themeBtn"
            aria-label="Toggle dark mode" title="Switch to dark mode">
      <svg class="icon-moon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
           stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
        <path d="M21 12.8A9 9 0 1 1 11.2 3a7 7 0 0 0 9.8 9.8z"/>
      </svg>
      <svg class="icon-sun" viewBox="0 0 24 24" fill="none" stroke="currentColor"
           stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
        <circle cx="12" cy="12" r="4"/>
        <path d="M12 1.5v2M12 20.5v2M4.2 4.2l1.4 1.4M18.4 18.4l1.4 1.4M1.5 12h2M20.5 12h2M4.2 19.8l1.4-1.4M18.4 5.6l1.4-1.4"/>
      </svg>
    </button>
  </div>
</header>

<main class="page">
  <article class="markdown-body" id="content"></article>
</main>

<script>
(function() {{
  'use strict';

  var HLJS_LIGHT = 'https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/github.min.css';
  var HLJS_DARK  = 'https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/github-dark.min.css';
  var THEME_KEY  = 'show-md-theme';

  var contentEl = document.getElementById('content');
  var statusEl  = document.getElementById('docStatus');
  var themeBtn  = document.getElementById('themeBtn');
  var printBtn  = document.getElementById('printBtn');
  var hljsLink  = document.getElementById('hljs-theme');
  var rootEl    = document.documentElement;
  var darkQuery = window.matchMedia('(prefers-color-scheme: dark)');

  var theme = null;
  try {{ theme = localStorage.getItem(THEME_KEY); }} catch (e) {{}}
  if (theme !== 'dark' && theme !== 'light') theme = null;

  function isDark() {{
    return theme ? theme === 'dark' : darkQuery.matches;
  }}

  /* ---- render ---- */

  function escapeHtml(s) {{
    return s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
  }}

  var renderer = new marked.Renderer();
  var defaultCode = renderer.code.bind(renderer);

  renderer.code = function(code, infostring, escaped) {{
    var isToken = code !== null && typeof code === 'object';
    var text = isToken ? code.text : code;
    var lang = ((isToken ? code.lang : infostring) || '').trim().split(/\\s+/)[0];
    if (lang === 'mermaid') {{
      return '<pre class="mermaid">' + escapeHtml(text) + '</pre>';
    }}
    var highlighted;
    if (lang && hljs.getLanguage(lang)) {{
      highlighted = hljs.highlight(text, {{ language: lang }}).value;
    }} else {{
      highlighted = escapeHtml(text);
    }}
    var cls = lang ? ' class="hljs language-' + escapeHtml(lang) + '"' : '';
    return '<pre><code' + cls + '>' + highlighted + '</code></pre>';
  }};

  marked.setOptions({{ renderer: renderer, gfm: true, breaks: true }});

  function tagPseudoHeadings() {{
    var paras = contentEl.querySelectorAll('p');
    for (var i = 0; i < paras.length; i++) {{
      var p = paras[i];
      var only = p.firstElementChild;
      if (!only || only !== p.lastElementChild) continue;
      if (only.tagName !== 'STRONG' && only.tagName !== 'B') continue;
      if (p.textContent.trim() !== only.textContent.trim()) continue;
      if (!only.textContent.trim()) continue;
      p.classList.add('pseudo-heading');
    }}
  }}

  var lastText = null;

  function renderMarkdown(raw) {{
    var scrollY = window.scrollY;
    contentEl.innerHTML = marked.parse(raw);
    tagPseudoHeadings();
    var h = contentEl.querySelector('h1, h2');
    if (h) document.title = h.textContent.trim();

    var nodes = contentEl.querySelectorAll('pre.mermaid');
    if (nodes.length) {{
      return mermaid.run({{ nodes: nodes, suppressErrors: true }})
        .catch(function(err) {{ console.error('mermaid render failed:', err); }})
        .then(function() {{ window.scrollTo(0, scrollY); }});
    }}
    window.scrollTo(0, scrollY);
    return Promise.resolve();
  }}

  /* ---- theme ---- */

  function applyTheme() {{
    var dark = isDark();
    if (theme) rootEl.setAttribute('data-theme', theme);
    else rootEl.removeAttribute('data-theme');

    themeBtn.classList.toggle('is-dark', dark);
    themeBtn.title = dark ? 'Switch to light mode' : 'Switch to dark mode';
    hljsLink.href = dark ? HLJS_DARK : HLJS_LIGHT;

    mermaid.initialize({{
      startOnLoad: false,
      securityLevel: 'loose',
      theme: dark ? 'dark' : 'default',
      fontFamily: 'inherit'
    }});

    if (lastText !== null && contentEl.querySelector('pre.mermaid')) {{
      return renderMarkdown(lastText);
    }}
    return Promise.resolve();
  }}

  themeBtn.addEventListener('click', function() {{
    theme = isDark() ? 'light' : 'dark';
    try {{ localStorage.setItem(THEME_KEY, theme); }} catch (e) {{}}
    applyTheme();
  }});

  if (darkQuery.addEventListener) {{
    darkQuery.addEventListener('change', function() {{ if (!theme) applyTheme(); }});
  }}

  /* ---- print ---- */

  var themeBeforePrint;

  window.addEventListener('afterprint', function() {{
    if (themeBeforePrint === undefined) return;
    theme = themeBeforePrint;
    themeBeforePrint = undefined;
    applyTheme();
  }});

  function printDoc() {{
    if (!isDark()) {{ window.print(); return; }}
    themeBeforePrint = theme;
    theme = 'light';
    applyTheme().then(function() {{ window.print(); }});
  }}

  printBtn.addEventListener('click', printDoc);

  window.addEventListener('keydown', function(e) {{
    if (e.key !== 'p' && e.key !== 'P') return;
    if (!(e.ctrlKey || e.metaKey) || e.altKey || e.shiftKey) return;
    e.preventDefault();
    printDoc();
  }});

  /* ---- status ---- */

  var flashTimer = null;

  function setStatus(text, kind) {{
    statusEl.textContent = text;
    statusEl.className = 'doc-status' + (kind ? ' ' + kind : '');
    if (flashTimer) clearTimeout(flashTimer);
    if (kind === 'flash') {{
      flashTimer = setTimeout(function() {{ statusEl.className = 'doc-status'; }}, 1200);
    }}
  }}

  function clockTime() {{
    var d = new Date();
    return [d.getHours(), d.getMinutes(), d.getSeconds()]
      .map(function(n) {{ return String(n).padStart(2, '0'); }})
      .join(':');
  }}

  /* ---- boot ---- */

  applyTheme();
  lastText = `{escaped}`;
  renderMarkdown(lastText);
  setStatus('loaded ' + clockTime(), 'flash');

  /* ---- SSE hot reload ---- */

  var evtSource = new EventSource('/events');
  evtSource.addEventListener('update', function(e) {{
    lastText = JSON.parse(e.data);
    renderMarkdown(lastText);
    setStatus('updated ' + clockTime(), 'flash');
  }});
  evtSource.onerror = function() {{
    setStatus('reconnecting…');
    setTimeout(function() {{ location.reload(); }}, 2000);
  }};
}})();
</script>
</body>
</html>"""


file_mtime = 0
sse_clients = []
sse_lock = threading.Lock()


def watch_file(md_path, interval=1):
    global file_mtime
    file_mtime = os.path.getmtime(md_path)
    while True:
        time.sleep(interval)
        try:
            mtime = os.path.getmtime(md_path)
        except OSError:
            continue
        if mtime != file_mtime:
            file_mtime = mtime
            content = read_md(md_path)
            payload = json.dumps(content)
            print(f"[show-md] File changed, pushing update to {len(sse_clients)} client(s)")
            with sse_lock:
                dead = []
                for client in sse_clients:
                    try:
                        client.wfile.write(f"event: update\ndata: {payload}\n\n".encode())
                        client.wfile.flush()
                    except Exception:
                        dead.append(client)
                for c in dead:
                    sse_clients.remove(c)


def serve(md_path, port, bind):
    md_path = os.path.abspath(md_path)
    if not os.path.isfile(md_path):
        print(f"Error: {md_path} not found", file=sys.stderr)
        sys.exit(1)

    class Handler(http.server.BaseHTTPRequestHandler):
        def do_GET(self):
            if self.path == "/events":
                self.send_response(200)
                self.send_header("Content-Type", "text/event-stream")
                self.send_header("Cache-Control", "no-cache")
                self.send_header("Connection", "keep-alive")
                self.end_headers()
                self.wfile.flush()
                with sse_lock:
                    sse_clients.append(self)
                try:
                    while True:
                        time.sleep(1)
                except Exception:
                    pass
                finally:
                    with sse_lock:
                        if self in sse_clients:
                            sse_clients.remove(self)
                return

            html = build_html(md_path)
            self.send_response(200)
            self.send_header("Content-Type", "text/html; charset=utf-8")
            self.end_headers()
            self.wfile.write(html.encode("utf-8"))

        def log_message(self, fmt, *args):
            print(f"[show-md] {args[0]}")

    watcher = threading.Thread(target=watch_file, args=(md_path,), daemon=True)
    watcher.start()

    for attempt in range(10):
        try:
            server = http.server.ThreadingHTTPServer((bind, port + attempt), Handler)
            break
        except OSError:
            if attempt == 9:
                print(f"Error: ports {port}-{port + 9} all in use", file=sys.stderr)
                sys.exit(1)
            print(f"[show-md] Port {port + attempt} in use, trying {port + attempt + 1}")
    actual_port = server.server_address[1]
    print(f"Serving {md_path}")
    print(f"  -> http://{bind}:{actual_port}")
    print("File watcher active - changes will hot reload.")
    print("Press Ctrl+C to stop.")

    signal.signal(signal.SIGINT, lambda *_: sys.exit(0))
    signal.signal(signal.SIGTERM, lambda *_: sys.exit(0))
    server.serve_forever()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("file", help="Path to the Markdown file")
    parser.add_argument("-p", "--port", type=int, default=8088)
    parser.add_argument("-b", "--bind", default="0.0.0.0")
    args = parser.parse_args()
    serve(args.file, args.port, args.bind)
