Pre-merge review for the current branch. Act as a professional senior programmer who maintains strict coding standards — review every line to ensure correct coding practice before merging to master.

## Steps

1. Run `/code-review high --fix` on the current branch to review all changes (committed and uncommitted) for correctness bugs, then apply the fixes.
2. Run `/simplify` to review the changed code for reuse, simplification, efficiency, and altitude cleanups, then apply the fixes.
3. After fixes are applied, do a final manual pass over all changed files to verify:
   - No code duplication remains where logic can be shared.
   - No dead code (unused imports, unreachable branches, orphaned functions/variables).
   - Code style is consistent with the rest of the codebase (naming conventions, formatting, patterns, variables name).
   - No non-printable or non-ASCII characters (e.g. smart quotes, em dashes, curly apostrophes). Use only plain ASCII equivalents.
   - Review all comments in changed files. Remove comments that merely restate what the code does. Keep only comments that explain why something non-obvious is done. Shorten verbose comments.
   - Fix anything found in this pass.
4. Run `/code-review high` one final time to confirm all issues are resolved. Report the results.
