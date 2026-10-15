Serve a Markdown file as rendered HTML with Mermaid diagram support.

The user will specify which Markdown file to serve. Use the argument $ARGUMENTS as the file path.

## Steps

1. Resolve the Markdown file path from `$ARGUMENTS`. If the path is relative, resolve it against the current working directory. Confirm the file exists.
2. Kill any existing process on port 8088 (`lsof -ti:8088 | xargs kill 2>/dev/null || true`).
3. Run the serve script in the background:
   ```
   python3 ~/dotfiles/.claude/commands/show-md.py "$ARGUMENTS" &
   ```
4. Report the URL `http://0.0.0.0:8088` to the user and confirm the server is running.
