#!/usr/bin/env python3
"""Serve a Markdown file as rendered HTML with Mermaid diagram support and hot reload."""

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
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/5.5.1/github-markdown-light.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/marked/12.0.1/marked.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/mermaid/10.9.0/mermaid.min.js"></script>
<style>
  body {{
    max-width: 980px;
    margin: 0 auto;
    padding: 2rem 1rem;
    background: #fff;
  }}
  .markdown-body {{
    min-width: 200px;
  }}
  .mermaid {{
    text-align: center;
    background: transparent;
  }}
  @media (max-width: 767px) {{
    body {{ padding: 1rem; }}
  }}
</style>
</head>
<body>
<article class="markdown-body" id="content"></article>
<script>
mermaid.initialize({{ startOnLoad: false, theme: 'default' }});

const renderer = new marked.Renderer();
const defaultCode = renderer.code.bind(renderer);

renderer.code = function(block) {{
  const text = block.text || block;
  const lang = block.lang || '';
  if (lang === 'mermaid') {{
    return '<div class="mermaid">' + text + '</div>';
  }}
  return defaultCode.call(this, block);
}};

marked.setOptions({{ renderer: renderer, gfm: true, breaks: true }});

function renderMarkdown(raw) {{
  document.getElementById('content').innerHTML = marked.parse(raw);
  document.querySelectorAll('.mermaid').forEach(function(el) {{
    el.removeAttribute('data-processed');
  }});
  mermaid.run({{ nodes: document.querySelectorAll('.mermaid') }});
}}

renderMarkdown(`{escaped}`);

const evtSource = new EventSource('/events');
evtSource.addEventListener('update', function(e) {{
  var scrollY = window.scrollY;
  renderMarkdown(JSON.parse(e.data));
  window.scrollTo(0, scrollY);
}});
evtSource.onerror = function() {{
  setTimeout(function() {{ location.reload(); }}, 2000);
}};
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

    server = http.server.ThreadingHTTPServer((bind, port), Handler)
    print(f"Serving {md_path}")
    print(f"  -> http://{bind}:{port}")
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
