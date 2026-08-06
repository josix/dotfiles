# Your Neovim Guide (LazyVim)

Generated 2026-08-06 against this config's lazy-lock.json — regenerate if config changes substantially.

This is a reference for **your actual config** at `~/dotfiles/nvim` (symlinked to
`~/.config/nvim`), not generic Vim advice. Every keymap in a table below was
transcribed from a file on this machine — LazyVim core, an installed plugin
spec, or one of your 18 enabled language extras. If something isn't in a
table, it isn't wired up on your machine yet.

---

## 0. How to use this guide

Read chapters 1-11 once, top to bottom — that's the 80% you'll use daily.
Chapters 12-15 are reference material: dip into them when you need a
language-specific keymap, want to know what's customized, or something breaks.

**60-second orientation:**

- Your leader key is `<space>`. Almost every custom command starts with it.
- Press `<space>` and wait — **which-key** pops up a menu of everything
  available from here. This is how you discover commands; you rarely need to
  memorize them up front.
- `<leader>sk` opens a searchable list of *every* keymap currently active,
  live, from your real config. When in doubt, search there instead of
  guessing.
- Normal mode is home base. Insert mode is for typing text. You'll live in
  the tension between the two — that's the VSCode-to-Vim mental shift.

Notation: `<leader>` = space. `<c-x>` = Ctrl+x. `gd` means press `g` then `d`
in sequence (not simultaneously). `[x` / `]x` are "previous/next x" pairs.

---

## 1. Modes and survival

VSCode's Vim extension put you in insert mode most of the time with modal
commands layered on top. Real Neovim flips that: **normal mode is default**,
and insert mode is a special place you visit to type, then leave immediately.

| Key | Action | VSCode equivalent |
|---|---|---|
| `i` | Enter insert mode before cursor | (default typing mode) |
| `jj` | Exit insert mode back to normal | `Esc` — but yours is custom, see below |
| `Esc` | Exit insert mode (still works) | `Esc` |
| `:w` | Save file | `Cmd+S` |
| `:q` | Close window/quit | `Cmd+W` |
| `:wq` or `:x` | Save and quit | `Cmd+S` then close |
| `:q!` | Quit without saving | Close without save (discard prompt) |
| `<leader>qq` | Quit all (all windows/tabs) | `Cmd+Q` |
| `u` | Undo | `Cmd+Z` |
| `<c-r>` | Redo | `Cmd+Shift+Z` |
| `<c-s>` | Save file (works in insert/visual/normal) | `Cmd+S` |

**Your `jj` customization**: typing `jj` quickly in insert mode acts as
`Esc`, ported from your old VSCode `vim.insertModeKeyBindings` setting. Source:
`nvim/lua/config/keymaps.lua:6`. Plain `Esc` still works too — `jj` is a
convenience, not a replacement.

Escape also does double duty in this config: it clears search highlighting
and stops any active snippet, on top of leaving insert mode (LazyVim core,
`keymaps.lua:52-56`).

The undo tree here is more powerful than a linear "Cmd+Z stack" — every
insert-mode session is one undo step, and `,`/`.`/`;` each get their own undo
breakpoint so you don't lose a whole sentence's typing in one `u` (LazyVim
core, `keymaps.lua:76-78`).

---

## 2. Buffers vs windows vs tabs

This is the single biggest mental-model gap coming from VSCode. VSCode's
"tabs" (the row of open files) map to Neovim **buffers** — not Neovim tabs.
Neovim **windows** are split panes. Neovim **tabs** are rarely used — think
of them as separate saved window layouts, not "open files."

- **Buffer** = an open file in memory. You can have 50 open with only one
  visible.
- **Window** = a viewport showing a buffer. Splitting the screen creates more
  windows.
- **Tab** = a collection of windows, all switchable as a set. Most people use
  exactly one tab all day.

So "switch to the next open file" is a **buffer** operation, not a tab
operation.

| Key | Action | VSCode equivalent |
|---|---|---|
| `<S-h>` | Previous buffer | `Cmd+Shift+[` (prev tab) |
| `<S-l>` | Next buffer | `Cmd+Shift+]` (next tab) |
| `[b` / `]b` | Previous / next buffer | prev/next tab |
| `<leader>bd` | Delete (close) buffer, keeps window layout | `Cmd+W` (close tab) |
| `<leader>bo` | Delete all other buffers | "Close Other Tabs" |
| `<leader>bb` | Switch to alternate (last) buffer | `Cmd+backtick` |
| `<leader>bp` | Toggle pin buffer in bufferline | Pin tab |
| `<leader>bj` | Pick a buffer by letter (bufferline) | — |
| `<c-h/j/k/l>` | Move focus to window left/down/up/right | `Cmd+K` then arrow |
| `<c-w>s` (`<leader>-`) | Split window below | Split editor down |
| `<c-w>v` (`<leader>\|`) | Split window right | Split editor right |
| `<leader>wd` | Close current window | Close split pane |
| `<leader>wm` | Zoom/maximize current window (toggle) | Maximize editor group |

Sources: buffer navigation from LazyVim core `keymaps.lua:34-49` and
`bufferline.nvim` keys in `ui.lua:7-19` (both bind `<S-h>/<S-l>/[b/]b` — the
bufferline ones win since bufferline loads on `VeryLazy`); window keys from
`keymaps.lua:14-23,199-202`.

Bufferline (the visual row of tabs at the top) also gives you:

| Key | Action |
|---|---|
| `<leader>bP` | Delete all non-pinned buffers |
| `<leader>br` / `<leader>bl` | Close buffers to the right / left |
| `[B` / `]B` | Move current buffer left/right in the bufferline |

Source: `lazyvim/plugins/ui.lua:8-18`.

Tabs (the actual Neovim kind — rarely needed) live under `<leader><tab>`:
`<leader><tab><tab>` new tab, `]`/`[` next/prev, `d` close, `o` close others,
`f`/`l` first/last. Source: `lazyvim/config/keymaps.lua:206-212`.

---

## 3. Finding things — the snacks picker

This is your Cmd+P / Cmd+Shift+F. LazyVim ships with **snacks.nvim's picker**
here (not Telescope — this config never installed it). Every "find X" and
"search Y" action funnels through it.

| Key | Action | VSCode equivalent |
|---|---|---|
| `<leader><space>` | Find files (root dir) | `Cmd+P` |
| `<leader>ff` | Find files (root dir) | `Cmd+P` |
| `<leader>fF` | Find files (cwd, not project root) | `Cmd+P` (folder-scoped) |
| `<leader>/` | Grep (root dir) | `Cmd+Shift+F` |
| `<leader>sg` | Grep (root dir) | `Cmd+Shift+F` |
| `<leader>sG` | Grep (cwd) | `Cmd+Shift+F` (folder-scoped) |
| `<leader>sw` | Grep visual selection or word under cursor (root) | select text, `Cmd+Shift+F` |
| `<leader>,` | Switch buffers (picker) | `Cmd+P` then recent files |
| `<leader>fb` | Buffers | — |
| `<leader>fr` | Recent files | `Cmd+R` |
| `<leader>fg` | Git files | — |
| `<leader>:` | Command history | `Cmd+Shift+P` history |
| `<leader>sk` | **Keymaps** — search every active binding | Keyboard Shortcuts search |
| `<leader>sh` | Help pages | — |
| `<leader>sd` | Diagnostics (workspace) | Problems panel |
| `<leader>sD` | Diagnostics (current buffer) | Problems panel (file) |
| `<leader>st` | Todo comments | — |
| `<leader>sr` | (grug-far, not picker) Search & replace, see ch. 6 | `Cmd+Shift+H` |
| `<leader>uC` | Colorschemes picker | Theme picker |
| `<leader>sc` | Command history | — |
| `<leader>sC` | Commands | Command Palette |
| `<leader>sm` | Marks | — |
| `<leader>sj` | Jumps | — |
| `<leader>su` | Undo tree/history | — |
| `<leader>sq` / `<leader>sl` | Quickfix / location list | — |
| `<leader>fc` | Find a Neovim config file | — |
| `<leader>fp` | Projects | — |

Source: transcribed wholesale from
`lazyvim/plugins/extras/editor/snacks_picker.lua:58-112`.

Git and GitHub pickers (same file, lines 74-82) — useful once `lazygit`
(ch. 9) isn't enough:

| Key | Action |
|---|---|
| `<leader>gd` | Git diff (hunks) |
| `<leader>gs` | Git status |
| `<leader>gS` | Git stash |
| `<leader>gi` / `<leader>gI` | GitHub issues (open / all) |
| `<leader>gp` / `<leader>gP` | GitHub PRs (open / all) |

LSP-powered pickers (from `snacks_picker.lua:141-159`, active once a language
server attaches — see ch. 7):

| Key | Action |
|---|---|
| `gd` | Goto definition |
| `gr` | Find references |
| `gI` | Goto implementation |
| `gy` | Goto type definition |
| `<leader>ss` | Document symbols (outline of current file) |
| `<leader>sS` | Workspace symbols |

**Inside the picker window** — these keys work while the picker is open,
also sourced from `snacks_picker.lua`:

| Key | Action |
|---|---|
| `<a-c>` (normal/insert) | Toggle between root-dir and cwd search |
| `s` (normal) / `<a-s>` (normal/insert) | Jump to a result with flash-style labels |
| `<a-t>` (normal/insert) | Send results to Trouble (ch. 7) |

---

## 4. File explorer / sidebar

Snacks explorer, not neo-tree (never installed here). Two entry points with
different scope, transcribed from
`lazyvim/plugins/extras/editor/snacks_explorer.lua:6-23`:

| Key | Action | VSCode equivalent |
|---|---|---|
| `<leader>e` | Toggle explorer at **root dir** (project root) | Sidebar (Explorer) |
| `<leader>E` | Toggle explorer at **cwd** (current working dir) | Sidebar scoped to open folder |
| `<leader>fe` | Same as `<leader>e` (explorer, root dir) | — |
| `<leader>fE` | Same as `<leader>E` (explorer, cwd) | — |

`<leader>e` is what you'll use 95% of the time — it always opens rooted at
your project (detected via `.git`, etc.), regardless of which subdirectory
file you currently have open. Use `<leader>E` only when you deliberately want
the explorer scoped to Neovim's literal working directory instead.

**Inside the explorer window** (snacks.nvim explorer defaults — these are
the file-manager-style actions, standard snacks.nvim explorer bindings once
the window is focused):

| Key | Action |
|---|---|
| `a` | Add (create) file or directory |
| `d` | Delete file/directory |
| `r` | Rename |
| `c` | Copy |
| `m` | Move |
| `H` | Toggle showing hidden files |
| `Enter` | Open file / expand directory |
| `<c-v>` / `<c-x>` / `<c-t>` | Open in vsplit / split / new tab |

If any of the in-explorer keys above ever feel off after a plugin update,
confirm with `<leader>sk` while the explorer is focused — that always reflects
the live binding.

---

## 5. Moving inside a file

### Tier 1 — core Vim motions (stable, not config-specific)

These are Vim fundamentals, unaffected by any plugin:

| Key | Action |
|---|---|
| `h j k l` | Left / down / up / right |
| `w` / `b` | Next / previous word start |
| `e` | End of word |
| `0` / `^` | Start of line / first non-blank char |
| `$` | End of line |
| `gg` / `G` | Top / bottom of file |
| `{` / `}` | Previous / next paragraph |
| `%` | Jump to matching bracket |
| `f<char>` / `t<char>` | Find / till character forward on line |
| `F<char>` / `T<char>` | Find / till character backward on line |
| `;` / `,` | Repeat last f/t forward / backward |
| `<c-d>` / `<c-u>` | Half-page down / up |
| `*` / `#` | Search word under cursor forward / backward |

Note: `j`/`k` in this config are remapped to respect wrapped lines (`gj`/`gk`
when no count is given), so moving through long soft-wrapped Markdown/prose
lines feels natural. Source: LazyVim core, `keymaps.lua:8-11`.

### Tier 2 — plugin-enhanced motions

| Key | Mode | Action | Source |
|---|---|---|---|
| `s` | normal/visual/operator | **Flash** jump — type 1-2 chars, then a label to teleport there | `editor.lua:38` |
| `S` | normal/operator/visual | Flash Treesitter — jump between syntax nodes | `editor.lua:39` |
| `r` | operator-pending | Remote Flash (act on a distant location without moving) | `editor.lua:40` |
| `R` | operator/visual | Flash Treesitter search | `editor.lua:41` |
| `<c-space>` | normal/operator/visual | Treesitter incremental selection (expand/shrink node) | `editor.lua:44-52` |
| `n` / `N` | normal/visual/operator | Next/prev search result (always searches "forward" regardless of `?`/`/`) | `keymaps.lua:68-73` |
| `]d` / `[d` | normal | Next / previous diagnostic | `keymaps.lua:135-136` |
| `]e` / `[e` | normal | Next / previous **error** diagnostic | `keymaps.lua:137-138` |
| `]w` / `[w` | normal | Next / previous **warning** diagnostic | `keymaps.lua:139-140` |
| `]f` / `[f` | normal/visual/operator | Next / previous function start (treesitter) | `treesitter.lua:149,151` |
| `]F` / `[F` | normal/visual/operator | Next / previous function **end** | `treesitter.lua:150,152` |
| `]c` / `[c` | normal/visual/operator | Next / previous class start | `treesitter.lua:149,151` |
| `]a` / `[a` | normal/visual/operator | Next / previous function parameter | `treesitter.lua:149,151` |
| `]]` / `[[` | normal | Next / previous reference to symbol under cursor | `lsp/init.lua:94-97` |
| `]t` / `[t` | normal | Next / previous TODO comment | `editor.lua:263-264` |
| `]q` / `[q` | normal | Next / previous quickfix (or Trouble item if Trouble is open) | `editor.lua:222-250` |
| `]h` / `[h` | normal | Next / previous git hunk | `editor.lua:160-173` |

`s`/`S` replace the "click where you want to go" habit from a mouse-driven
editor — 90% of long-distance jumps within a visible screen should use Flash
instead of repeated `w`/`j`.

### Marks — named bookmarks

Marks are Vim-native bookmarks (no plugin involved): `m` + a letter sets one,
`` ` `` + the letter jumps back to it. This is what happens if you type `mm`
without the leader key — you've set a mark named `m`. VSCode's closest
equivalent is bookmark extensions.

| Key | Action |
|---|---|
| `m{a-z}` | Set a mark in this buffer (e.g. `ma` sets mark `a`) |
| `m{A-Z}` | Set a **global** mark — works across files (e.g. `mA`) |
| `` `{mark} `` | Jump to the mark's exact line *and column* |
| `'{mark}` | Jump to the first non-blank char of the mark's line |
| `` ``` `` | Jump back to where you were before the last jump |
| `` `. `` | Jump to the last change in this buffer |
| `` `^ `` | Jump to where you last exited insert mode |
| `<leader>sm` | Marks picker — browse/jump to all marks (snacks picker) |
| `:marks` | List all marks (built-in) |
| `:delmarks a` / `:delmarks!` | Delete mark `a` / all lowercase marks in buffer |

Related: the **jumplist** tracks everywhere you've jumped (searches, `gg`/`G`,
`gd`, marks…) — `<c-o>` goes back, `<c-i>` goes forward, like VSCode's
"Go Back / Go Forward" (`Ctrl+-` / `Ctrl+Shift+-`). Browse it with
`<leader>sj` (jumps picker).

Practical pattern: `mA` in a file you keep returning to (global, survives
switching files), `` `A `` to snap back. For quick within-screen jumps prefer
Flash (`s`); marks earn their keep across files and longer distances.

### Folding — collapse code blocks

VSCode's "Fold Region" (`Cmd+Option+[`). The fold *commands* are Vim
built-ins and always work; what varies is how folds get *created* (the
`foldmethod` option). **This config has no fold customization**, so you're
on Neovim's default `foldmethod=manual` — no folds exist until you make one
yourself with `zf`.

| Key | Action | VSCode equivalent |
|---|---|---|
| `za` | Toggle fold under cursor | `Cmd+Option+[` / `]` (toggle) |
| `zo` / `zc` | Open / close fold under cursor | Fold / unfold region |
| `zR` | Open **all** folds in file | `Cmd+K Cmd+J` (unfold all) |
| `zM` | Close **all** folds in file | `Cmd+K Cmd+0` (fold all) |
| `zj` / `zk` | Jump to next / previous fold | — |
| `zf` + motion | Create a fold (manual method), e.g. `zfip` folds a paragraph; or visual-select lines then `zf` | Fold selection |
| `zd` | Delete fold under cursor (manual folds only) | — |

Quick automatic option with zero setup: `:set foldmethod=indent` folds by
indentation for the current buffer.

**Upgrade recipe — syntax-aware treesitter folds** (functions, classes,
blocks fold at real code boundaries). Add to
`nvim/lua/config/options.lua` (ch. 14):

```lua
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99 -- start with all folds open
```

`foldlevel = 99` matters — without it every file opens fully folded.
(snacks.nvim doesn't handle folding, so this treesitter expr is the standard
companion in a config like yours.) If you apply this, manual `zf`/`zd` stop
applying — folds come from the syntax tree instead, and `za`/`zR`/`zM`
work on them exactly the same.

---

## 6. Editing and modification

Vim's core idea: **operator + motion = command**. `d` (delete) + `w` (word) =
`dw` (delete word). `c` (change) + `$` (to end of line) = `c$`. This
composability is what replaces most of VSCode's keyboard-shortcut sprawl —
you learn ~10 operators and ~15 motions/text-objects and multiply them.

| Combo | Action |
|---|---|
| `dd` | Delete line |
| `yy` | Yank (copy) line |
| `p` / `P` | Paste after / before cursor |
| `cw` | Change word |
| `ciw` | Change inner word (cursor anywhere in the word) |
| `x` | Delete character |
| `r<char>` | Replace single character |
| `>>` / `<<` | Indent / outdent line |
| `.` | Repeat last change |
| `o` / `O` | Open new line below / above, enter insert mode |

### Text objects — enhanced by mini.ai

Beyond Vim's built-in `iw`, `i"`, `i(`, this config's **mini.ai** adds
treesitter-aware objects (source: `coding.lua:37-71`):

| Object | Selects |
|---|---|
| `if` / `af` | Inner / around function |
| `ic` / `ac` | Inner / around class |
| `io` / `ao` | Inner / around code block/conditional/loop |
| `iu` / `au` | Inner / around function call ("usage") |
| `ig` / `ag` | Inner / around whole buffer |
| `ih` (via gitsigns, `editor.lua:186`) | Git hunk |

Use them like any text object: `dif` deletes a function body, `vaf` selects
the whole function, `cac` changes an entire class.

### Auto-pairs and comments

- **mini.pairs** auto-closes `(`, `[`, `{`, quotes as you type in insert mode
  (`coding.lua:5-23`) — no separate keymap, it's just always on.
- `gcc` toggles a line comment; `gc` + motion (e.g. `gcap`) comments a
  paragraph; `gco`/`gcO` add a new commented line below/above (LazyVim core,
  `keymaps.lua:91-92`, comment engine from `ts-comments.nvim`,
  `coding.lua:28-32`).

### I miss multi-cursor

Neovim has no literal multi-cursor, but three tools cover the same ground:

1. **Block visual mode** (`<c-v>`): select a rectangular column, then
   `I` to insert text at the start of every line in the block, or `A` to
   append at the end, then `Esc` to apply to all lines at once. This is your
   direct replacement for "add cursor to end of each line."
2. **`:%s/old/new/g`**: substitute across the whole file (`:%s/old/new/gc`
   to confirm each one). This is your replacement for "select all
   occurrences" when you know the exact text.
3. **`*` then `cgn` then `.`**: search the word under cursor with `*`,
   change the first match with `cgn`, then press `.` to repeat that same
   change on each subsequent match — this is the closest Vim-native
   equivalent to "select next occurrence, type once, apply everywhere."
4. **`<leader>sr`** (grug-far): a dedicated search-and-replace UI across
   multiple files, pre-filled with the current file's extension as a filter.
   This is your Cmd+Shift+H (project-wide replace). Source:
   `editor.lua:9-24`.

---

## 7. Code navigation — LSP

This is what replaces "Go to Definition", "Find All References", and
inline error squiggles from VSCode. It comes from the built-in `vim.lsp`
client plus your language servers (ch. 12), routed through the snacks picker
for anything that returns a list.

| Key | Action | VSCode equivalent |
|---|---|---|
| `gd` | Goto definition (opens picker if multiple) | `F12` |
| `gr` | Find references | `Shift+F12` |
| `gI` | Goto implementation | `Cmd+F12` |
| `gy` | Goto type definition | — |
| `gD` | Goto declaration | — |
| `K` | Hover documentation | Hover tooltip |
| `gK` | Signature help | Parameter hints |
| `<c-k>` (insert mode) | Signature help while typing | Parameter hints while typing |
| `<leader>ca` | Code action | `Cmd+.` |
| `<leader>cA` | Source action | `Cmd+.` (source actions) |
| `<leader>cr` | Rename symbol | `F2` |
| `<leader>cR` | Rename file (and update imports) | rename in Explorer |
| `<leader>co` | Organize imports | "Organize Imports" |
| `<leader>cc` | Run codelens | — |
| `<leader>cC` | Refresh & display codelens | — |
| `<leader>cl` | LSP info for buffer | — |
| `]]` / `[[` | Next / previous reference to symbol under cursor | — |

Source: `lazyvim/plugins/lsp/init.lua:78-113` (core keys), plus
`gd`/`gr`/`gI`/`gy` are overridden by the snacks picker versions in
`snacks_picker.lua:147-150` when the picker extra is active (so they open a
list instead of jumping directly when there's more than one candidate).

### Diagnostics (inline errors/warnings)

| Key | Action | VSCode equivalent |
|---|---|---|
| `<leader>cd` | Show diagnostic under cursor (float) | Hover on squiggle |
| `]d` / `[d` | Next / previous diagnostic (any severity) | `F8` / `Shift+F8` |
| `]e` / `[e` | Next / previous error | — |
| `]w` / `[w` | Next / previous warning | — |

### Trouble — a persistent diagnostics/reference panel

`Trouble` gives you a dedicated sidebar list instead of a one-off picker —
closer to VSCode's Problems panel:

| Key | Action | VSCode equivalent |
|---|---|---|
| `<leader>xx` | Diagnostics (Trouble, workspace) | Problems panel |
| `<leader>xX` | Diagnostics (Trouble, current buffer) | Problems panel (file filter) |
| `<leader>cs` | Symbols outline (Trouble) | Outline view |
| `<leader>cS` | LSP references/definitions (Trouble) | — |
| `<leader>xL` / `<leader>xQ` | Location list / quickfix list (Trouble) | — |

Source: `lazyvim/plugins/editor.lua:216-222`.

### Todo comments

| Key | Action |
|---|---|
| `<leader>xt` | TODO/FIX/etc comments (Trouble) |
| `<leader>xT` | Only TODO/FIX/FIXME (Trouble) |
| `<leader>st` | TODO comments (picker) |
| `<leader>sT` | Only TODO/FIX/FIXME (picker) |
| `]t` / `[t` | Jump to next / previous TODO comment |

Source: `lazyvim/plugins/editor.lua:262-268` (core) and
`snacks_picker.lua:164-167` (picker variants, override the plain
`<leader>st`/`sT` above since the picker extra loads after).

---

## 8. Refactoring, formatting, linting

Three separate systems work together here, and it's worth knowing which is
which so you know where to look when something misbehaves:

1. **conform.nvim** does the actual code *formatting* (reindenting,
   reformatting) using external formatter binaries (`stylua`, `prettier`,
   `gofumpt`, etc. — see ch. 12 for the per-language list), and runs
   automatically on save because LazyVim registers it as the format-on-save
   handler.
2. **nvim-lint** runs external *linters* (`hadolint`, `markdownlint-cli2`,
   `tflint`, etc.) asynchronously on save/read/leaving insert mode and feeds
   results into the same diagnostics you see with `]d` — it never touches
   your file's text, only reports problems.
3. **The LSP server** itself (ch. 7/12) supplies code actions, renames, and
   sometimes its own formatting fallback if conform has no formatter
   configured for that filetype.

| Key | Action |
|---|---|
| `<leader>ca` | Code action (rename var, extract, add missing import, etc. — varies by language) |
| `<leader>cr` | Rename symbol |
| `<leader>cf` | Format buffer (force, via conform) |
| `<leader>cF` | Format injected languages (e.g. code fences inside Markdown) |
| `<leader>uf` | Toggle format-on-save (buffer scope) |
| `<leader>uF` | Toggle format-on-save (global) |

Sources: `<leader>cf`/`ca`/`cr` — `keymaps.lua:120-122` and
`lsp/init.lua:88,92`; `<leader>uf`/`uF` toggle — `keymaps.lua:145-146`;
`<leader>cF` — `formatting.lua:26-33` (conform.nvim spec).

**Troubleshooting formatting/linting:**

- `:ConformInfo` — shows which formatter(s) conform picked for the current
  buffer and whether they ran successfully.
- `:LspInfo` — shows which language server(s) are attached to the current
  buffer.
- `:Mason` — opens the UI listing installed/missing formatters, linters, and
  LSP servers (see ch. 11).

### Fixing lint errors with Claude Code

`coder/claudecode.nvim` (`nvim/lua/plugins/claudecode.lua`) connects Neovim
to the Claude Code CLI over the same IDE protocol the official VS Code
extension uses. Once the split is open, Claude can read your LSP/lint
diagnostics directly (via its `getDiagnostics` tool) — you don't need to
copy-paste error messages.

| Key | Action |
|---|---|
| `<leader>ac` | Toggle Claude Code terminal split (auto-connects to this nvim) |
| `<leader>af` | Focus the Claude split |
| `<leader>as` (visual) | Send selected lines to Claude as context |
| `<leader>aa` | Accept Claude's proposed diff |
| `<leader>ad` | Deny Claude's proposed diff |

Workflow: open the file with squiggles, `<leader>ac`, ask *"fix the lint
errors in this file"*, review the diff it proposes, `<leader>aa` to accept
or `<leader>ad` to reject. For one specific error, visually select the
offending lines and `<leader>as` first.

Source: `nvim/lua/plugins/claudecode.lua`.

---

## 9. Git

Three complementary layers: inline hunk signs/actions (gitsigns), a full TUI
(lazygit), and browser links (snacks gitbrowse).

### gitsigns — inline hunk operations

| Key | Action |
|---|---|
| `]h` / `[h` | Next / previous hunk (or native diff nav `]c`/`[c` if in diff mode) |
| `]H` / `[H` | Last / first hunk |
| `<leader>ghs` | Stage hunk |
| `<leader>ghr` | Reset (undo) hunk |
| `<leader>ghS` | Stage whole buffer |
| `<leader>ghu` | Undo last stage-hunk |
| `<leader>ghR` | Reset whole buffer |
| `<leader>ghp` | Preview hunk inline |
| `<leader>ghb` | Blame current line (full) |
| `<leader>ghB` | Blame current buffer |
| `<leader>ghd` / `<leader>ghD` | Diff this file / diff against `~` |
| `ih` (operator/visual) | Select current hunk as a text object |
| `<leader>uG` | Toggle git signs in the gutter |

Source: `lazyvim/plugins/editor.lua:159-201`.

### lazygit — full terminal git client

| Key | Action | VSCode equivalent |
|---|---|---|
| `<leader>gg` | Open lazygit (rooted at git root) | Source Control panel |
| `<leader>gG` | Open lazygit (rooted at cwd) | — |

Source: `lazyvim/config/keymaps.lua:168-171` — guarded by
`vim.fn.executable("lazygit")`, which is why it works: you have `lazygit`
installed via Homebrew.

### History and browsing

| Key | Action |
|---|---|
| `<leader>gl` / `<leader>gL` | Git log (root / cwd) |
| `<leader>gb` | Git blame for current line (as a log) |
| `<leader>gf` | File history for current file |
| `<leader>gB` | Open current line/file on GitHub/GitLab in browser |
| `<leader>gY` | Copy the browse URL instead of opening it |

Source: `lazyvim/config/keymaps.lua:173-180`.

### Git pickers — fuzzy-find changes and files

These come from the snacks picker (your active picker), not gitsigns:

| Key | Action |
|---|---|
| `<leader>gd` | Picker over all changed hunks in the repo, with diff preview |
| `<leader>gD` | Same, but diffed against `origin` and grouped by file |
| `<leader>gs` | Git status — pick among modified/untracked files |
| `<leader>gS` | Git stash — browse and apply stashes |

Source: `lazyvim/plugins/extras/editor/snacks_picker.lua:75-78`.

### A review-then-commit workflow

1. `]h` to hop between changes in the current file; `<leader>ghp` to peek at
   each diff inline (or `<leader>gd` to sweep every hunk repo-wide).
2. Stage the good hunks with `<leader>ghs`, discard mistakes with
   `<leader>ghr`. Both work on a **visual selection** too, so you can stage
   just part of a hunk — select the lines first, then the keymap.
3. `<leader>gg` for lazygit to write the commit.

### Not installed (but worth knowing)

For reviewing many files side-by-side (e.g. a whole PR), the usual addition
is `diffview.nvim` — nothing built-in gives a multi-file diff view.

### What `lang.git` actually adds

The `git` language extra you have enabled (`extras/lang/git.lua`) only adds
Treesitter parsers for `git_config`, `gitcommit`, `git_rebase`, `gitignore`,
and `gitattributes` (better syntax highlighting when editing those files) —
it does **not** add any new keymaps of its own. Its `cmp-git` completion
source is inert on your machine, because you use `blink.cmp`, not
`nvim-cmp`.

---

## 10. Terminal, sessions, and the rest of snacks

`snacks.nvim` is one plugin powering roughly eight different features you've
already met (picker, explorer, notifier, lazygit, dashboard) plus these:

| Key | Action | VSCode equivalent |
|---|---|---|
| `<c-/>` (normal/terminal) | Toggle floating terminal (root dir), focus/hide | `` Ctrl+` `` |
| `<leader>ft` | Open terminal (root dir) | New terminal |
| `<leader>fT` | Open terminal (cwd) | New terminal (folder-scoped) |
| `<c-h/j/k/l>` (terminal mode) | Move to window in that direction | — |

Source: `lazyvim/config/keymaps.lua:192-196` and `util.lua:19-30`.

Inside a terminal buffer, running `glow <file.md>` gives you a formatted,
colorized Markdown preview right there in the terminal — you have `glow`
installed for exactly this.

### Sessions — persistence.nvim

Session = "reopen exactly the files/windows/tabs I had open," closer to
VSCode's "Reopen Workspace":

| Key | Action |
|---|---|
| `<leader>qs` | Restore session for current directory |
| `<leader>qS` | Pick a session to restore |
| `<leader>ql` | Restore the last session, regardless of directory |
| `<leader>qd` | Stop saving the current session (don't persist this one) |

Source: `lazyvim/plugins/util.lua:48-52`.

### Scratch buffers, zen mode, notifications

| Key | Action |
|---|---|
| `<leader>.` | Toggle a scratch buffer (throwaway notes, persists across restarts) |
| `<leader>S` | Pick among multiple scratch buffers |
| `<leader>uz` | Toggle zen mode (distraction-free, hides UI chrome) |
| `<leader>uZ` / `<leader>wm` | Toggle zoom (maximize current window without hiding chrome) |
| `<leader>n` | Notification history |
| `<leader>un` | Dismiss all notifications |

Source: scratch — `util.lua:34-35`; zen/zoom — `keymaps.lua:202-203`;
notifier — `ui.lua:286-293`.

---

## 11. UI toggles and how to answer future questions yourself

Almost every visual/behavioral toggle in this config lives under
`<leader>u`, sourced wholesale from `lazyvim/config/keymaps.lua:145-165`:

| Key | Toggles |
|---|---|
| `<leader>uf` / `<leader>uF` | Format on save (buffer / global) |
| `<leader>us` | Spell check |
| `<leader>uw` | Line wrap |
| `<leader>uL` | Relative line numbers |
| `<leader>ud` | Diagnostics display |
| `<leader>ul` | Line numbers |
| `<leader>uc` | Conceal level |
| `<leader>uA` | Tabline visibility |
| `<leader>uT` | Treesitter highlighting |
| `<leader>ub` | Dark/light background |
| `<leader>uD` | Dim inactive code |
| `<leader>ua` | Animations |
| `<leader>ug` | Indent guides |
| `<leader>uS` | Smooth scroll |
| `<leader>uh` | Inlay hints (if your LSP supports them) |
| `<leader>uG` | Git signs in gutter (ch. 9) |
| `<leader>um` | Render-markdown display (ch. 12) |

### Minimap — mini.map

A VSCode-style minimap on the right edge, from **mini.map**
(`nvim/lua/plugins/minimap.lua`). It renders the buffer as dot characters
(12 columns wide, slightly transparent) and overlays search matches,
diagnostics, and git changes. It opens automatically on startup.

| Key | Action | VSCode equivalent |
|---|---|---|
| `<leader>mm` | Toggle minimap | "Toggle Minimap" |
| `<leader>mf` | Move focus into the minimap (scroll with `j`/`k`, `Esc`/`Enter` to return) | click in minimap |

To change width or disable auto-open, edit `window.width` or remove the
`map.open()` line in `minimap.lua`.

### Discovery tools — how to keep learning this config without a guide

- **`<leader>?`** — which-key: show all keymaps available from the current
  buffer.
- **`<leader>sk`** — search *every* live keymap by fuzzy text, including its
  source description. This is the single best "what does this key do"
  tool.
- **`:h <topic>`** — Neovim's built-in help; `:h motion.txt`, `:h lsp`, etc.
  are exhaustive and offline.
- **`:checkhealth`** — diagnoses your whole setup: missing binaries, broken
  providers, plugin health checks.
- **`:Lazy`** — plugin manager UI: see what's installed, update, view
  changelogs, check load times.
- **`:Mason`** — LSP/formatter/linter installer UI: see what's installed,
  install/remove more.
- **`:LazyExtras`** — browse and toggle LazyVim's built-in "extras" (the
  same 18 language modules described in ch. 12, plus dozens more like `dap`
  or `test` you haven't enabled) — this is how you'd add debugging (DAP) or
  test-runner (neotest) support later without hand-writing plugin specs.

---

## 12. Your languages — 18 extras

Enabled via `nvim/lazyvim.json`. Every one of these was chosen by you (or the
LazyVim defaults you accepted) and is live right now.

| Extra | LSP server(s) | Formatter | Notable keymaps |
|---|---|---|---|
| `formatting.prettier` | — | `prettier` for css/html/js/ts/json/yaml/markdown/vue/graphql | — |
| `lang.clangd` | `clangd` | (LSP-driven; respects `.clang-format`) | `<leader>ch` switch source/header |
| `lang.cmake` | `neocmake` | — (lint: `cmakelint`) | cmake-tools.nvim auto-loads when `CMakeLists.txt` present |
| `lang.docker` | `dockerls`, `docker_compose_language_service` | — (lint: `hadolint`) | — |
| `lang.git` | — | — | Treesitter parsers only (ch. 9) |
| `lang.go` | `gopls` | `goimports`, `gofumpt` | — |
| `lang.helm` | `helm_ls` | — | — |
| `lang.json` | `jsonls` (+ SchemaStore) | — | — |
| `lang.markdown` | `marksman` | `prettier`, `markdownlint-cli2`, `markdown-toc` | `<leader>cp` preview toggle, `<leader>um` toggle render |
| `lang.python` | `pyright` (+ `ruff` for lint/format actions) | `ruff` (via LSP) | `<leader>cv` select virtualenv |
| `lang.rust` | `rust-analyzer` (via rustaceanvim) | `rust-analyzer` (via LSP) | `<leader>cR` code action, `<leader>dr` debuggables |
| `lang.svelte` | `svelte`, `vtsls` | `prettier` | — |
| `lang.tailwind` | `tailwindcss` | — | colorized class previews in completion |
| `lang.terraform` | `terraformls` | `terraform_fmt`/`packer_fmt` | — |
| `lang.toml` | `taplo` | — | — |
| `lang.typescript` | `vtsls` | `prettier` | `gD` source definition, `gR` file references, `<leader>cM` add missing imports, `<leader>cD` fix all, `<leader>cV` select TS version |
| `lang.vue` | `vue_ls`, `vtsls` | `prettier` | — |
| `lang.yaml` | `yamlls` (+ SchemaStore) | — | — |

### Callouts

- **rustaceanvim** replaces the plain `rust_analyzer` lspconfig entry
  (explicitly disabled: `extras/lang/rust.lua:136`) and adds richer Rust
  tooling — `<leader>cR` code action and `<leader>dr` list of debuggable
  targets, both buffer-local once a `.rs` file loads
  (`extras/lang/rust.lua:63-68`).
- **crates.nvim** activates when you open `Cargo.toml` — gives inline crate
  version info/completion/actions (`extras/lang/rust.lua:20-36`).
- **venv-selector** (`<leader>cv`) lets you pick which Python virtualenv
  pyright/ruff should use, per project (`extras/lang/python.lua:96-107`).
- **markdown**: three tools cooperate — `render-markdown.nvim` draws
  headings/checkboxes/code blocks inline as you edit (toggle with
  `<leader>um`), `markdown-preview.nvim` opens a live browser preview
  (`<leader>cp`), and `glow` (installed separately) gives you a
  terminal-based preview instead when you don't want a browser tab.
- **clangd**: `<leader>ch` switches between a C/C++ source file and its
  header — a command that doesn't exist for any other language here
  (`extras/lang/clangd.lua:61-62`).
- **cmake-tools.nvim** lazy-loads itself only when a `CMakeLists.txt` exists
  in the directory tree — you won't see it do anything in non-CMake
  projects (`extras/lang/cmake.lua:43-65`).
- **SchemaStore.nvim** feeds `jsonls` and `yamlls` thousands of known JSON
  schemas (package.json, GitHub Actions, etc.) for validation/completion —
  no keymap, it's pure background wiring.
- **Mason auto-installs**: each extra above declares its own formatters/
  linters/servers in a `mason.nvim` spec block (e.g. `hadolint`,
  `markdownlint-cli2`, `tflint`, `codelldb`) — you never had to install these
  by hand; `:Mason` shows the current install state.
- **The nvm-node PATH shim** (`options.lua:9-24`, see ch. 13) exists
  precisely so Mason's own npm-based installs (like `prettier`, `pyright`,
  `vtsls`) can find a working `node`/`npm`, since your shell lazy-loads nvm
  and Neovim's child processes wouldn't otherwise see it on `PATH`.

---

## 13. What's already customized

Exactly five things differ from stock LazyVim in this config. Everything
else you've read above is the LazyVim default — if you reset these five,
you'd have a stock LazyVim install (plus your 18 chosen extras).

1. **`jj` → Escape in insert mode**
   `nvim/lua/config/keymaps.lua:6` — ported from your old VSCode
   `vim.insertModeKeyBindings` setting.

2. **Whitespace rendering + nvm-node PATH shim**
   `nvim/lua/config/options.lua:5-7` — `vim.opt.list = true` with
   `listchars = { tab = "→ ", trail = "·", nbsp = "␣" }`, ported from VSCode's
   `editor.renderWhitespace`. Paired with an infrastructure fix at
   `nvim/lua/config/options.lua:9-24`: it walks `~/.nvm/versions/node`,
   finds the newest installed Node version, and prepends its `bin/` to
   `$PATH` — needed because your shell lazy-loads nvm for performance
   (see the zsh completions/nvm commit), so Neovim itself (and Mason's
   `npm install` child processes) would otherwise start with no Node on
   `PATH` at all.

3. **Zenburn colorscheme**
   `nvim/lua/plugins/colorscheme.lua` — installs `phha/zenburn.nvim` and sets
   `colorscheme = "zenburn"`, matching the theme you used in VSCode. Delete
   this file entirely to fall back to LazyVim's default `tokyonight`.

4. **Minimap — mini.map**
   `nvim/lua/plugins/minimap.lua` — VSCode-style minimap on the right edge,
   auto-opens on startup, `<leader>mm` to toggle (see ch. 11). Delete the
   file to remove it.

5. **Claude Code integration — claudecode.nvim**
   `nvim/lua/plugins/claudecode.lua` — connects nvim to the Claude Code CLI
   over the IDE protocol so Claude can see your diagnostics; `<leader>ac`
   to toggle (see ch. 8). Delete the file to remove it.

---

## 14. How to change things

LazyVim's whole philosophy is: **your `lua/plugins/*.lua` files each return a
plugin spec table that gets merged into LazyVim's defaults.** You rarely edit
LazyVim's own files (you can't — they live in
`~/.local/share/nvim/lazy/LazyVim`, outside this repo); you add small
override files instead.

> **Gotcha: `nvim/lua/plugins/example.lua` is inert.**
> Its third line is `if true then return {} end` — LazyVim ships it as a
> reference/cheatsheet of patterns, not a file meant to run. If you copy
> keymaps or plugin specs into it and expect them to load, **they won't** —
> that early return skips everything below it. **Copy the patterns you want
> into a *new* file** (e.g. `nvim/lua/plugins/my-tweaks.lua`); never edit
> `example.lua` in place and expect it to take effect.

### Recipe: add a keymap

Add to `nvim/lua/config/keymaps.lua` (loaded automatically on `VeryLazy`):

```lua
vim.keymap.set("n", "<leader>xx", "<cmd>echo 'hi'<cr>", { desc = "My thing" })
```

### Recipe: add/change an option

Add to `nvim/lua/config/options.lua` (loaded before lazy.nvim starts):

```lua
vim.opt.relativenumber = true
```

### Recipe: add an autocmd

Add to `nvim/lua/config/autocmds.lua` (create it if it doesn't exist —
LazyVim loads it automatically like the other two config files):

```lua
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.lua",
  callback = function() print("saving a lua file") end,
})
```

### Recipe: add a brand-new plugin

New file under `nvim/lua/plugins/`, e.g. `nvim/lua/plugins/my-plugin.lua`:

```lua
return {
  { "author/plugin-name", opts = {} },
}
```

### Recipe: override an existing plugin's options

Return a spec with the same plugin name — lazy.nvim merges it:

```lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "dockerfile" } }, -- merged into existing list
  },
}
```

`colorscheme.lua` (ch. 13) is a worked example of exactly this pattern: it
overrides `opts.colorscheme` on the `LazyVim/LazyVim` "plugin" itself, and
separately declares `phha/zenburn.nvim` as a new dependency to install.

### Recipe: disable a default plugin

```lua
return {
  { "folke/todo-comments.nvim", enabled = false },
}
```

### Recipe: add/remove a language extra

Run `:LazyExtras`, move the cursor to the extra, press `x` to toggle it, then
`:Lazy sync`. This edits `nvim/lazyvim.json` for you — you rarely need to
hand-edit that file.

### Recipe: change the colorscheme

Edit `nvim/lua/plugins/colorscheme.lua` and change the `colorscheme` value
(or delete the file to go back to `tokyonight`). Browse options live with
`<leader>uC`.

### Recipe: update plugins (and the lockfile)

`:Lazy` then `U` to update everything, or `:Lazy update <plugin>` for one.
This rewrites `nvim/lazy-lock.json` — commit that file when you're happy with
the new versions, since it's what pins exact commits for reproducibility.

---

## 15. Troubleshooting + cheat sheet

### First response to "something's wrong"

| Symptom | Run this |
|---|---|
| General "is my setup OK?" | `:checkhealth` |
| A plugin update broke something | `:Lazy log` (see recent changes), or `:Lazy` then roll back |
| LSP not attaching / no hover / no gd | `:LspInfo` |
| Formatter not installed / not running | `:ConformInfo`, then `:Mason` to check the binary is installed |
| Linter not installed | `:Mason`, check for the linter binary; `:messages` for errors |
| A keymap doesn't do what this guide says | `<leader>sk`, search for the key — the live binding always wins over documentation |
| Neovim itself feels broken/slow | `:Lazy profile` for startup timing |

> **Note: kitty's `ctrl+a>v` "Dev" tab opens this Neovim config.**
> The `kitty.conf:3372` binding runs `exec nvim .` explicitly. It must stay
> `nvim`, not `vim`: the launcher's shell is `zsh -lc` — login but
> **non-interactive** — so `.zshrc` (and its `alias vim='nvim'` at
> `zshrc:156`) never loads there, and a bare `vim` would resolve to plain
> `/usr/bin/vim` with the old Vundle-based vimrc.

### Condensed cheat sheet

| Key | Action |
|---|---|
| `jj` / `Esc` | Exit insert mode |
| `:w` / `:q` / `:wq` / `:q!` | Save / quit / save+quit / quit-discard |
| `<leader>qq` | Quit all |
| `u` / `<c-r>` | Undo / redo |
| `<S-h>` / `<S-l>` | Prev / next buffer |
| `<leader>bd` | Delete buffer |
| `<c-h/j/k/l>` | Move between windows |
| `<leader>-` / `<leader>\|` | Split below / right |
| `<leader><space>` / `<leader>ff` | Find files |
| `<leader>/` | Grep project |
| `<leader>sk` | Search all keymaps |
| `<leader>e` / `<leader>E` | Explorer (root / cwd) |
| `s` / `S` | Flash jump / Flash treesitter jump |
| `m{a}` / `` `{a} `` | Set / jump to mark (uppercase = cross-file) |
| `<c-o>` / `<c-i>` | Jump back / forward (jumplist) |
| `za` / `zR` / `zM` | Toggle fold / open all / close all |
| `]d` / `[d` | Next / prev diagnostic |
| `]f` / `[f` | Next / prev function |
| `]h` / `[h` | Next / prev git hunk |
| `gd` / `gr` / `gI` / `gy` | Definition / references / implementation / type def |
| `K` | Hover docs |
| `<leader>ca` / `<leader>cr` | Code action / rename |
| `<leader>cf` | Format buffer |
| `<leader>xx` | Diagnostics (Trouble) |
| `<leader>sr` | Search & replace (grug-far) |
| `<c-v>` then `I`/`A` | Block visual insert (multi-cursor-like) |
| `<leader>gg` | Lazygit |
| `<leader>ghs` / `<leader>ghr` | Stage / reset hunk |
| `<c-/>` | Toggle terminal |
| `<leader>qs` / `<leader>ql` | Restore session (cwd / last) |
| `<leader>.` | Scratch buffer |
| `<leader>uz` | Zen mode |
| `<leader>mm` | Toggle minimap |
| `<leader>n` | Notification history |
| `<leader>?` | Which-key: buffer keymaps |
| `:checkhealth` / `:Lazy` / `:Mason` / `:LazyExtras` | Health / plugins / LSP-tools / language extras |
