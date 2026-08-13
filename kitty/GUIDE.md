# Your kitty Guide (iTerm2 + tmux, in one app)

Generated 2026-08-06 against kitty.conf on this machine — regenerate if config changes.

This documents **your actual config** at `~/dotfiles/kitty.conf` (symlinked to
`~/.config/kitty/kitty.conf` by `bootstrap.sh:59-60`), not generic kitty docs.
The config this guide is grounded in is `kitty.conf` at the **repo root**, not
inside this `kitty/` directory. That file is 3492 lines long, but only three
regions are actually live: `:5` (theme include), `:1180-1262` (a window-border
block that's mostly superseded later), and `:3306-3492` (your personal
settings block). Everything else — roughly 3000 lines — is kitty's own
commented-out reference template, shipped as documentation, not config.

If a key isn't in a table in this guide, you didn't wire it up — with one
exception: kitty's stock `ctrl+shift` defaults are all still live and
inventoried in chapter 10.

**Table convention** (used throughout): `Key | Action | Source`. `Source` is a
bare `kitty.conf` line number unless prefixed with another filename (e.g.
`zshrc:271`).

---

## 0. How to use this guide

Read chapters 1-8 top to bottom — that's your daily driver. Chapters 9-14 are
reference material: appearance internals, the stock-kitty inventory, how to
change things, the quick access dropdown, and troubleshooting.

**60-second orientation:**

- Your prefix is `ctrl+a`, exactly like `tmux.conf:19` (`set -g prefix C-a`).
  If you know tmux, you already know half this config.
- Three key layers coexist and don't conflict: the `ctrl+a` **prefix**
  (sequential, tmux-style), plain **cmd** shortcuts (iTerm2-style, always
  active), and kitty's stock **ctrl+shift** defaults (chapter 10).
- kitty **windows** = tmux **panes**. kitty **tabs** = tmux **windows**. (kitty
  also has OS windows — separate app windows — which tmux has no equivalent
  for; you don't use them here.)
- Remote control is on (`allow_remote_control yes`, line 3369), so `kitten @`
  commands work from inside any pane kitty spawned — that's what lets the Dev
  tab rename itself (chapter 7).

**Notation:** `ctrl+a>t` means press `ctrl+a`, release, then press `t`
(sequential, like a tmux prefix chord). `cmd+shift+c` means hold all three
simultaneously. "prefix" always means `ctrl+a`.

---

## 1. The mental model — one app instead of iTerm2 + tmux

kitty replaces the iTerm2-terminal-emulator + tmux-multiplexer combo with a
single app. Your config deliberately layers tmux muscle memory over kitty's
own model, plus an iTerm2-flavored `cmd` layer for anything tmux never had.

### Habit migration

| tmux/iTerm2 habit                                 | Source of habit   | kitty equivalent                                | Source     |
| ------------------------------------------------- | ----------------- | ----------------------------------------------- | ---------- |
| `C-a` prefix                                      | `tmux.conf:19`    | `ctrl+a` prefix                                 | —          |
| `C-a C-a` sends literal prefix                    | `tmux.conf:20`    | `ctrl+a>ctrl+a` sends literal `\x01`            | 3404       |
| `bind \|` / `bind _` split                        | `tmux.conf:24,26` | `ctrl+a>shift+backslash` / `ctrl+a>shift+minus` | 3406-3407  |
| `bind h/j/k/l resize 10`                          | `tmux.conf:27-30` | `ctrl+a>h/l/k/j resize_window ... 5`            | 3414-3417  |
| `setw mode-keys vi`                               | `tmux.conf:33`    | vi-style keys in the scrollback pager           | 3330, 3453 |
| iTerm2 `Cmd+D` / `Cmd+Shift+D` (split)            | iTerm2 default    | `cmd+d` / `cmd+shift+d`                         | 3456-3457  |
| iTerm2 `Cmd+K` (clear) / `Cmd+Enter` (fullscreen) | iTerm2 default    | `cmd+k` / `cmd+enter`                           | 3469, 3471 |

Note the resize step differs: tmux resized by 10 cells, your kitty binding
resizes by 5 (3414-3417) — same keys, gentler step.

### Three key layers, one config

1. **`ctrl+a` prefix chords** — tmux muscle memory, defined explicitly in your
   personal block (3352-3453).
2. **`cmd` shortcuts** — iTerm2 muscle memory, also explicit in your personal
   block (3362-3365, 3378-3387, 3456-3485).
3. **Stock `ctrl+shift` (`kitty_mod`) defaults** — kitty ships these
   uncommented out of the box; your config never disables them
   (`clear_all_shortcuts` is never set). See chapter 10.

Vocabulary shift from tmux: what tmux calls a **pane** is a kitty **window**;
what tmux calls a **window** is a kitty **tab**. Keep this straight or every
other chapter will read backwards. In this guide, "pane" and "kitty window"
are used interchangeably for the split regions inside one tab, matching how
you'd talk about them coming from tmux; "tab" always means the kitty tab bar
at the top of the screen (3488-3490), never an OS-level window.

Why layer three key systems instead of picking one? Because each one covers
a different gap: the `ctrl+a` prefix reuses two decades of tmux muscle
memory for pane/tab management; the `cmd` layer reuses iTerm2 muscle memory
for the things tmux never had (native window resize, fullscreen, clipboard);
and the stock `ctrl+shift` layer is simply never turned off, so anything
this config forgot to rebind is still reachable the "normal" kitty way. You
don't have to choose — all three answer at once, and this guide documents
all three so you're never stuck wondering which layer owns a given key.

> **Gotcha 7: `ctrl+a` shadows readline's beginning-of-line.**
> In plain bash/zsh, `Ctrl-A` normally jumps the cursor to the start of the
> line. Since kitty intercepts `ctrl+a` as the prefix, that readline binding
> is unreachable directly. Double-tap it instead: `ctrl+a>ctrl+a` sends a
> literal `\x01` through to the shell (3404) — same trick as `tmux.conf:20`'s
> `bind C-a send-prefix`. This also matters if you nest tmux inside kitty over
> SSH: double-tap to get the keystroke past kitty's own prefix and into the
> remote session.

---

## 2. Panes — create, close, navigate, swap

### Create

| Key                             | Action              | Source |
| ------------------------------- | ------------------- | ------ |
| `ctrl+a>shift+backslash` (`\|`) | vsplit, cwd=current | 3406   |
| `ctrl+a>shift+minus` (`_`)      | hsplit, cwd=current | 3407   |
| `ctrl+a>backslash`              | vsplit, cwd=current | 3408   |
| `ctrl+a>minus`                  | hsplit, cwd=current | 3409   |
| `ctrl+minus` (no prefix)        | hsplit, cwd=current | 3412   |
| `cmd+d`                         | vsplit, cwd=current | 3456   |
| `cmd+shift+d`                   | hsplit, cwd=current | 3457   |

### Navigate

| Key                           | Action                               | Source    |
| ----------------------------- | ------------------------------------ | --------- |
| `ctrl+a>left/down/up/right`   | move focus in direction              | 3419-3422 |
| `shift+left/right/up/down`    | move focus (no prefix)               | 3427-3430 |
| `cmd+alt+left/right/up/down`  | move focus (no prefix)               | 3458-3461 |
| `ctrl+alt+left/right/up/down` | move focus (fallback, see Gotcha 10) | 3464-3467 |

### Cycle, swap, close

| Key              | Action                           | Source |
| ---------------- | -------------------------------- | ------ |
| `ctrl+a>o`       | cycle to next window             | 3424   |
| `ctrl+a>m`       | swap current window with another | 3433   |
| `ctrl+a>x`       | close window, with confirmation  | 3435   |
| `ctrl+backspace` | close window, with confirmation  | 3436   |

Both close bindings run `close_window_with_confirmation` — kitty prompts
before killing a pane that has a running foreground process (so an
accidental `ctrl+a>x` mid-`vim`-session or mid-`claude`-session doesn't lose
work silently). If the pane is just sitting at a shell prompt with nothing
running, the confirmation is skipped and it closes immediately.

> **Gotcha 9: `ctrl+minus` is layout-dependent on macOS.**
> Unshifted `-`/`_` key combos can get eaten by macOS input-source or window-
> manager handling depending on layout and app focus. The shifted variants
> (`ctrl+a>shift+minus`, `ctrl+a>shift+backslash`) are the reliable ones;
> treat 3408/3409/3411/3412 as convenience fallbacks, not primaries.

> **Gotcha 10: `cmd+alt+arrows` is stolen by Raycast.**
> The config's own comment at 3462-3463 says it plainly: Raycast's window
> management grabs `Cmd+Alt+arrow` globally before kitty ever sees the
> keystroke. `ctrl+alt+arrows` (3464-3467) is the working fallback bound to
> the same action. (Raycast's own config, `Raycast.rayconfig`, lives in this
> repo if you want to check or change its bindings.)

> **Gotcha 11: `|` and `&` are written as shifted characters, US-layout only.**
> `ctrl+a>shift+backslash` produces `|` and `ctrl+a>shift+7` produces `&`
> (chapter 4) only on a US keyboard layout, where those characters sit on
> those physical keys. On a different layout, the physical key you need to
> press for "shift + the key that makes `|`" will differ.

---

## 3. Layouts and resizing

`enabled_layouts` (3344):

```
splits:equalize_on_close=true,tall:bias=70,fat:bias=70,grid,stack
```

The **first** entry is the startup default — `splits`, freeform manual
splitting, with `equalize_on_close=true` meaning remaining panes re-balance
their sizes when one closes. `tall:bias=70` and `fat:bias=70` give the main
pane 70% of the space in those layouts. `grid` and `stack` take no options
here (grid arranges panes evenly in a grid; stack shows one pane fullscreen
at a time — this is your "zoom").

### Switch layout

| Key            | Action                                                | Source |
| -------------- | ----------------------------------------------------- | ------ |
| `ctrl+a>t`     | Tall — big main pane left, others stacked right       | 3352   |
| `ctrl+a>f`     | Fat — big main pane on top, others side by side below | 3353   |
| `ctrl+a>g`     | Grid — equal panes, good for tailing several logs     | 3354   |
| `ctrl+a>s`     | Splits — freeform manual splits (the default)         | 3355   |
| `ctrl+a>space` | Cycle to next layout                                  | 3356   |
| `ctrl+a>z`     | Toggle stack layout (zoom current pane)               | 3425   |

### Resize

| Key                      | Action                                                     | Source    |
| ------------------------ | ---------------------------------------------------------- | --------- |
| `ctrl+a>r`               | Enter interactive resize mode (arrows/hjkl, Esc to exit)   | 3358      |
| `ctrl+a>equal`           | Reset all pane sizes to equal                              | 3360      |
| `cmd+left/right/up/down` | One-keystroke resize narrower/wider/taller/shorter         | 3362-3365 |
| `ctrl+a>h/l/k/j`         | One-keystroke resize narrower/wider/taller/shorter, step 5 | 3414-3417 |

Resizing is only meaningful in `splits`, `tall`, and `fat` — panes in `grid`
are always equal-sized and `stack` shows one pane at a time, so resize
commands are effectively a no-op in those two.

Interactive resize mode (`ctrl+a>r`, 3358) is worth calling out separately
from the one-keystroke resizes: it's a **modal** state, closer to tmux's
resize-mode-after-prefix behavior than to a single chord. Once you enter it,
arrow keys or `h`/`j`/`k`/`l` repeatedly grow/shrink the focused pane without
needing to repeat the prefix each time; `Esc` (or any non-resize key) exits
back to normal mode. Use it when you want to make several adjustments in a
row; use the one-keystroke `cmd+arrows` or `ctrl+a>h/l/k/j` (3414-3417) when
you just need a single nudge.

---

## 4. Tabs — your tmux windows

### Manage

| Key                    | Action                            | Source |
| ---------------------- | --------------------------------- | ------ |
| `ctrl+a>c`             | New tab, cwd = current pane's cwd | 3438   |
| `ctrl+a>shift+7` (`&`) | Close tab                         | 3441   |
| `ctrl+a>comma`         | Set/rename tab title              | 3442   |

### Navigate

| Key             | Action                                 | Source    |
| --------------- | -------------------------------------- | --------- |
| `ctrl+a>n`      | Next tab                               | 3439      |
| `ctrl+a>p`      | Previous tab                           | 3440      |
| `ctrl+a>1`..`9` | Go to tab 1-9                          | 3443-3451 |
| `cmd+1`..`8`    | Go to tab 1-8                          | 3477-3484 |
| `cmd+9`         | Go to the **last** tab (`goto_tab -1`) | 3485      |

### Appearance

| Setting              | Value               | Source |
| -------------------- | ------------------- | ------ |
| `tab_bar_edge`       | `top`               | 3488   |
| `tab_bar_style`      | `powerline`         | 3489   |
| `tab_title_template` | `"{index}:{title}"` | 3490   |

> **Gotcha 12: `cmd+9` is asymmetric with `ctrl+a>9`.**
> `ctrl+a>9` always jumps to literal tab index 9 (`goto_tab 9`, 3451). `cmd+9`
> jumps to whatever tab is _last_ (`goto_tab -1`, 3485), matching iTerm2's
> "last tab" convention for `Cmd+9`. If you have fewer than 9 tabs open,
> these two keys can land you in completely different places. (See Gotcha 11
> for why `&` needs a US keyboard layout, same as `ctrl+a>shift+7` here.)

---

## 5. Scrollback, copy, and prompt jumping

| Setting/Key                       | Value/Action                                                                    | Source    |
| --------------------------------- | ------------------------------------------------------------------------------- | --------- |
| `copy_on_select`                  | `yes` — mouse-selecting text copies it, like iTerm2                             | 3327      |
| `scrollback_lines`                | `10000`                                                                         | 3328      |
| `scrollback_pager`                | `less --chop-long-lines --RAW-CONTROL-CHARS +INPUT_LINE_NUMBER` (vi-style keys) | 3330      |
| `ctrl+a>[`                        | Open scrollback in the pager (copy-mode-ish)                                    | 3453      |
| `cmd+k`                           | Clear screen + scrollback up to cursor                                          | 3469      |
| `cmd+shift+up` / `cmd+shift+down` | Jump to previous/next shell prompt                                              | 3473-3474 |
| `ctrl+a>e`                        | Show the last command's output in the pager                                     | 3391      |

The last three rows depend on **shell integration** (default `enabled`,
commented template line ~2178) — kitty's shell hooks that mark where each
prompt starts and where each command's output begins/ends. Without it, "jump
to previous prompt" and "show last command's output" have nothing to jump to.

> **Gotcha 13: these silently no-op inside tmux or plain SSH.**
> Shell integration relies on kitty-specific escape sequences and terminfo
> that a plain `ssh` session, or a shell already living inside `tmux`, doesn't
> have. `zshrc:148-151` is the fix for the SSH case: when `$KITTY_WINDOW_ID`
> is set (i.e. you're inside kitty), it prepends kitty's bundled binaries to
> `PATH` and aliases `ssh` to `kitten ssh` — that's what carries kitty's
> terminfo and shell-integration hooks to the remote host. Without that
> alias, `cmd+shift+up/down` and `ctrl+a>e` simply do nothing once you've
> SSH'd out.

---

## 6. Hints and broadcast

| Key        | Action                                                                | Source |
| ---------- | --------------------------------------------------------------------- | ------ |
| `ctrl+a>y` | Pick a line on screen (hints overlay), copy it to the clipboard       | 3393   |
| `ctrl+a>/` | Pick a file path on screen, insert it at the current prompt           | 3395   |
| `ctrl+a>u` | Pick and open a URL on screen                                         | 3397   |
| `ctrl+a>b` | Open a broadcast pane: typed input goes to **every** pane in this tab | 3399   |

`ctrl+a>y` and `ctrl+a>/` both use `kitten hints`, but with different
`--program` targets: `--program @` (3393) sends the picked text to the
**clipboard**; `--program -` (3395) **types it into the shell** at the
current prompt instead. Same picker mechanic, different destination — `@`
when you want to paste it somewhere else, `-` when you want to keep working
with it in the terminal.

All three hint pickers (`--type line`, `--type path`, `--type url`) overlay
short jump-labels on every matching candidate visible in the current pane's
scrollback — press the label to act on that match, same interaction model
as flash.nvim if you've used that. `ctrl+a>u`'s URL picker has no
`--program` flag at all, because `kitten hints --type url` already knows
what to do with a URL: it opens it in your default browser directly.

`ctrl+a>b`'s broadcast pane (3399) is the one binding in this chapter that
opens something new rather than acting on existing text — it spawns a pane
whose keystrokes fan out to every other pane in the current tab, useful for
running the same command (e.g. a restart, a `git pull`) across several
panes at once without retyping it in each.

---

## 7. Workspace launchers — Dev tab and Logs tab

`allow_remote_control yes` (3369, comment at 3368) is the enabler behind these
— it's what lets `kitten @` reach into a running kitty instance to rename a
tab from a spawned shell.

Both launchers use kitty's `combine` action, which is kitty's way of running
several actions as one keypress — each step after a `:` runs in sequence
against the state left by the previous step.

### `ctrl+a>v` (3372) — the Dev tab

This is a single `combine` chain of two steps:

1. **New tab**, `cwd=current`, running
   `/opt/homebrew/bin/zsh -lc 'kitten @ set-tab-title "$(basename "$(git rev-parse --show-toplevel 2>/dev/null || pwd)")"; exec nvim .'`
   — it renames the tab to the git repo's top-level directory name (or the
   plain cwd if not in a repo), then `exec nvim .`.
2. **hsplit**, `bias=30`, `cwd=current`, `--keep-focus` — a full-width
   shell taking the bottom 30%; `--keep-focus` leaves the cursor in the
   nvim pane on top instead of following the new shell.

### `ctrl+a>shift+l` (3374) — the Logs tab

Also a `combine` chain: new tab titled "Logs", three more shells launched
into it, then `goto_layout grid` — four shells tiled evenly, ready to tail
logs in parallel. Unlike the Dev tab, there's no self-renaming trick here —
the title is static (`--tab-title Logs`), and none of the four panes runs
anything beyond a bare interactive shell, so this launcher has nothing
equivalent to Gotcha 1 to worry about; every pane it opens is a normal
interactive `zsh` session with your full `.zshrc` (aliases, PATH, prompt)
already applied.

> **Gotcha 1: step 1 must say `exec nvim .`, not `exec vim .`.**
> Step 1's shell command runs under `zsh -lc` — a **login** shell (sources
> `.zprofile`) but explicitly **non-interactive** (`-c`, not `-i`), so
> `.zshrc` is never sourced and the `alias vim='nvim'` at `zshrc:156` never
> applies. A bare `vim` here would resolve to plain `/usr/bin/vim` with the
> old Vundle-based `~/.vimrc` — which is why the binding calls `nvim`
> explicitly. Contrast: the Claude Code launches at 3378 and 3379 use
> `zsh -lic` — the `i` makes them **interactive**, so `.zshrc` (and its
> aliases/PATH setup) does apply there.

> **Gotcha 8: `kitten @` needs a working control channel — and background
> launches don't inherit one.**
> Processes kitty spawns get `KITTY_LISTEN_ON` in their environment, which
> is how step 1's shell reaches `kitten @`. There is also a real socket:
> `listen_on unix:/tmp/kitty` (3371) makes kitty listen on
> `/tmp/kitty-<pid>`, reachable from outside kitty via
> `kitten @ --to unix:/tmp/kitty-<pid>`. The trap: for `--type=background`
> launches (like `cmd+j`'s `toggle-stack.py`, 3497), `KITTY_LISTEN_ON` is an
> inherited file descriptor (`fd:N`) that Python's `subprocess` closes, so
> every `kitten @` call from the script fails silently. The script therefore
> derives the socket path from its parent pid (kitty itself) and passes it
> explicitly with `--to` — see `kitty/toggle-stack.py`.

---

## 8. Claude Code and job control

| Key           | Action                                                                                                               | Source |
| ------------- | -------------------------------------------------------------------------------------------------------------------- | ------ |
| `cmd+shift+c` | vsplit, `bias=40`, `cwd=current`, launch `zsh -lic 'claude; exec zsh -il'` — pane drops to a shell when claude exits | 3378   |
| `ctrl+a>a`    | Same as above                                                                                                        | 3379   |
| `cmd+f`       | Send the literal text `fg\r` — resumes a suspended job                                                               | 3383   |
| `cmd+shift+f` | Send `\x18j` (Ctrl-X j) — fires the fzf job picker                                                                   | 3387   |
| `cmd+/`       | `search_scrollback` — open scrollback in the pager, search with `/`                                                  | 3400   |
| `cmd+enter`   | Toggle fullscreen                                                                                                    | 3471   |

The `Cmd+Shift+F` picker isn't a kitty feature — it's a zsh ZLE widget,
`fzf-job-picker`, defined at `zshrc:244-271` and bound to `^Xj` at
`zshrc:271`. kitty's `cmd+shift+f` (3387) just sends that same keystroke
sequence into the active pane. The widget lists background jobs via
`jobs -l` with a live `ps` preview (state/CPU/elapsed); `Enter` resumes the
selected job, `Ctrl-K` kills it.

The intended loop: `Ctrl-Z` inside vim or `claude` suspends it to the
background; `cmd+f` resumes it directly if it's the only suspended job
(sends `fg` + Enter); `cmd+shift+f` opens the picker instead when you have
multiple suspended jobs and need to choose which one to bring back.

> **Gotcha: Ctrl-Z used to leave the shell with broken keys.**
> TUIs like nvim and `claude` enable kitty's enhanced keyboard protocol and
> can leave it active when suspended with `Ctrl-Z`, so the shell receives
> CSI-u encoded keys — `Ctrl-A`/`Ctrl-E`/`Esc` stop working at the prompt.
> Fixed on the zsh side: a `precmd` hook (`_kitty_kbd_reset`, `zshrc`) pops
> the protocol state (`\e[<u`) before every prompt, so the shell always
> starts in legacy key encoding. It only runs when `$KITTY_WINDOW_ID` is
> set, i.e. inside kitty.

Why this exists at all: `ctrl+a>a` and `cmd+shift+c` (3378-3379) each spawn a
_fresh_ `claude` process in a new pane — fine for starting a new session, but
wasteful if you already have one running and just stepped away from it with
`Ctrl-Z`. The `fg`/job-picker pair is the faster path back to a session
that's still alive in the background, in the same pane you left it in,
instead of spinning up a second one.

---

## 9. Appearance and shell

| Setting                                          | Value                                                                                                                | Source    |
| ------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------- | --------- |
| `shell`                                          | `/opt/homebrew/bin/zsh --login`                                                                                      | 3309      |
| `env SHELL`                                      | `/opt/homebrew/bin/zsh`                                                                                              | 3310      |
| `font_family`                                    | `Fira Code`                                                                                                          | 3313      |
| `bold_font` / `italic_font` / `bold_italic_font` | `auto`                                                                                                               | 3314-3316 |
| `font_size`                                      | `13.0`                                                                                                               | 3317      |
| `symbol_map`                                     | Nerd Font private-use ranges routed to `FiraCode Nerd Font` (iTerm2 "Non-ASCII font" equivalent, comments 3318-3319) | 3320      |
| `macos_option_as_alt`                            | `left` (left Option = Meta, right Option stays normal)                                                               | 3325      |
| `copy_on_select`                                 | `yes`                                                                                                                | 3327      |
| `scrollback_lines`                               | `10000`                                                                                                              | 3328      |
| `scrollback_pager`                               | vi-style `less` invocation                                                                                           | 3330      |
| `window_border_width`                            | `1px`                                                                                                                | 3333      |
| `draw_minimal_borders`                           | `yes`                                                                                                                | 3334      |
| `window_margin_width` / `window_padding_width`   | `0`                                                                                                                  | 3335-3336 |
| `inactive_text_alpha`                            | `-0.8` (negative = only fades when >1 pane visible; semantics documented in-file at 1264-1274)                       | 3339      |
| theme include                                    | `include current-theme.conf` (`:5`, Zenburn, managed via `shipwright.nvim`)                                          | :5        |
| `active_border_color`                            | `#f0dfaf`                                                                                                            | 1248      |
| `inactive_border_color`                          | `#3f3f3f`                                                                                                            | 1253      |
| tab bar (top, powerline, `{index}:{title}`)      | see chapter 4                                                                                                        | 3488-3490 |

> **Gotcha 2: dead duplicates earlier in the file.**
> `window_border_width 2.5pt` (1180), `draw_minimal_borders no` (1188), and
> `inactive_text_alpha 0.35` (1262) are all set _earlier_ in the file, inside
> the mostly-template window-border section — and all three are silently
> overridden by the real values later in the personal block (3333, 3334,
> 3339 respectively; kitty applies "last assignment wins" across the whole
> file). Editing the 1180s does nothing observable; the effective values are
> always the ones at 3333/3334/3339.

> **Gotcha 3: `current-theme.conf` is not in this repo.**
> `include current-theme.conf` (:5) only resolves because
> `~/.config/kitty/current-theme.conf` exists on disk _outside_ the repo —
> a search of this repo turns up no `current-theme.conf` anywhere. On a
> fresh machine, bootstrapping this repo alone gives you a broken `include`
> and no color palette. **Fix:** either run `kitten themes Zenburn` on the
> new machine to regenerate the file, or start tracking
> `current-theme.conf` in this repo so `bootstrap.sh` carries it over too.

> **Exception: the dark-mode palette IS tracked.**
> `kitty/dark-theme.auto.conf` (in this repo) is the Zenburn palette kitty
> auto-loads when macOS is in dark mode, symlinked to
> `~/.config/kitty/dark-theme.auto.conf` by `bootstrap.sh` like
> `kitty.conf`. It diverges from stock Zenburn in
> one spot: `color1` is the classic Zenburn red `#cc9393` (4.09:1 contrast
> on the `#3f3f3f` background) instead of `#705050` (1.48:1), which made
> red text — git diff deletions, errors — nearly invisible in dark mode.

> **Gotcha 5: the theme leaves border colors unset.**
> Zenburn's `current-theme.conf` doesn't define `active_border_color` or
> `inactive_border_color` at all, so the values actually in effect for pane
> borders are the ones set directly in `kitty.conf` at 1248 and 1253 — not
> anything coming from the theme.

---

## 10. What's still stock kitty

`kitty_mod` is never overridden in this config — it's still the shipped
default, `ctrl+shift` (commented template line ~2520). `clear_all_shortcuts`
is likewise never set (commented template line ~2526). That means **every**
stock kitty shortcut is still live, layered underneath your personal
`ctrl+a`/`cmd` bindings.

> **Gotcha 6: your personal bindings don't replace kitty's defaults — they
> add to them.** Nothing in this config disables the stock layer, so
> `ctrl+shift+*` shortcuts work everywhere alongside `ctrl+a>*` and `cmd+*`.

The following are inventoried directly from the commented `# map` lines
present in this file's own template (not from memory) — grep for `# map` if
you want the full list, this is the high-value subset:

| Key                                        | Action                                | Template line |
| ------------------------------------------ | ------------------------------------- | ------------- |
| `kitty_mod+c` (fallback `cmd+c`)           | Copy to clipboard                     | 2579 (2592)   |
| `kitty_mod+v` (fallback `cmd+v`)           | Paste from clipboard                  | 2596 (2597)   |
| `kitty_mod+enter` (fallback `cmd+enter`\*) | New window                            | 2735 (2736)   |
| `kitty_mod+n` (fallback `cmd+n`)           | New OS window                         | 2766 (2767)   |
| `kitty_mod+w`                              | Close window                          | 2775          |
| `kitty_mod+]` / `kitty_mod+[`              | Next / previous window                | 2780 / 2784   |
| `kitty_mod+t` (fallback `cmd+t`)           | New tab                               | 2886 (2887)   |
| `kitty_mod+q` (fallback `cmd+w`)           | Close tab                             | 2891 (2892)   |
| `kitty_mod+right` / `kitty_mod+left`       | Next / previous tab                   | 2874 / 2880   |
| `kitty_mod+l`                              | Next layout                           | 2934          |
| `kitty_mod+equal` / `kitty_mod+minus`      | Increase / decrease font size         | 2961 / 2970   |
| `kitty_mod+1`..`9`                         | First..ninth window (window, not tab) | 2805-2846     |

\* `kitty_mod+enter`/`cmd+enter` new-window (2735-2736) is stock, but your
personal block redefines plain `cmd+enter` to `toggle_fullscreen` (3471) —
last assignment wins, so on this machine `cmd+enter` alone triggers
fullscreen, not a new window. Use `kitty_mod+enter` (`ctrl+shift+enter`) for
the stock new-window behavior instead.

For the complete, authoritative stock keymap (including anything not listed
above), don't trust memory — run `kitty --debug-config`, which prints the
fully effective config and every active mapping straight from the running
binary.

---

## 11. What's already customized

Everything below is the _entire_ diff from stock kitty. Read top to bottom
and you've read the whole personal layer:

| Area                                                                       | Lines      |
| -------------------------------------------------------------------------- | ---------- |
| Shell (Homebrew zsh, login)                                                | 3309-3310  |
| Font (Fira Code + Nerd Font symbol map)                                    | 3313-3320  |
| macOS/general behavior (Option-as-Meta, copy-on-select, scrollback)        | 3325-3330  |
| Borders (width, minimal, margin/padding, inactive fade)                    | 3333-3339  |
| Layouts (`enabled_layouts`)                                                | 3344       |
| Prefix system (layouts, resize, splits, nav, tabs, scrollback)             | 3352-3453  |
| Workspace launchers (Dev tab, Logs tab, remote control)                    | 3369-3374  |
| Claude Code + job control                                                  | 3378-3387  |
| Hints + broadcast                                                          | 3391-3399  |
| iTerm2 `cmd` layer (splits, nav, clear, fullscreen, prompt jump, tab jump) | 3455-3485  |
| Tab bar appearance                                                         | 3488-3490  |
| Theme include                                                              | :5         |
| Border colors                                                              | 1248, 1253 |

Every other line in `kitty.conf` — the roughly 3000 lines outside this
table's ranges — is kitty's stock commented template, untouched.

Read top-to-bottom, the personal block tells a story: shell and font first
(the basics any terminal needs), then macOS/border/layout cosmetics, then
the bulk of it — the `ctrl+a` prefix system that turns kitty into a tmux
stand-in — followed by the two `combine`-chain launchers that are the most
"yours" thing in the file, then Claude/job-control glue, then the iTerm2
`cmd` layer for everything tmux never modeled. If you're hunting for where a
particular habit lives, that ordering is a decent map even before you check
line numbers.

> **Gotcha 4: kitty isn't in the Brewfile.**
> `bootstrap.sh:59-60` only symlinks the config file into place — it never
> installs the kitty app itself. On a brand-new machine you need
> `brew install --cask kitty` by hand before any of this config does
> anything.

---

## 12. How to change things

**Principle: last assignment wins.** kitty reads the whole file top to
bottom and the final value for any setting/keymap sticks. Add new settings
to the **bottom of the personal block**, right before the closing `#: }}}`
at line 3492 — never edit the commented template above it. That's exactly
how the dead duplicates in Gotcha 2 happened: someone (or a stale draft)
touched the template's copy at 1180-1262 instead of the real values further
down.

### Recipes (copy an existing line as a pattern)

- **Add a plain keybinding** — copy the shape of 3391:
  `map <key> <action>`
- **Add a prefix binding** — copy the shape of 3414:
  `map ctrl+a><key> <action>`
- **Unbind a stock shortcut** — `map <key> no_op`
- **Change font or size** — edit 3313-3317 directly
- **Change layout order/defaults** — edit `enabled_layouts` at 3344
- **Build a new workspace-launcher tab** — copy the `combine` chain at 3374
  (simpler) or 3372 (with the self-renaming trick) as a template
- **Change theme** — run `kitten themes <name>` (rewrites `current-theme.conf`,
  which `:5` includes — see Gotcha 3 about that file's repo status)
- **Reload config without restarting kitty** — the stock bindings are
  commented in the template under "Reload kitty.conf" (3223): `kitty_mod+f5`
  and `ctrl+cmd+,`, both mapped to `load_config_file` (3225-3226). Neither is
  uncommented in your personal block, so verify what's actually live with
  `kitty --debug-config` before relying on either key. `kitten @ load-config`
  is also available from any remote-control-enabled pane (3369) as an
  alternative that doesn't require a keybinding at all.

---

## 13. Quake-style quick access terminal

Set up 2026-08-13. A dropdown terminal (Guake/Quake style) that slides in
from the top of the screen on a global hotkey, on top of whatever app you're
in, and hides when it loses focus.

This is **not** wired through `kitty.conf` — it's kitty's built-in
`quick-access-terminal` kitten (added in kitty 0.42), configured by its own
file:

| Piece      | Where                                                                                                             |
| ---------- | ----------------------------------------------------------------------------------------------------------------- |
| Config     | `kitty/quick-access-terminal.conf` (repo), symlinked to `~/.config/kitty/quick-access-terminal.conf`              |
| Toggle cmd | `kitten quick-access-terminal`                                                                                    |
| Hotkey     | macOS Services: System Settings → Keyboard → Keyboard Shortcuts → Services → General → "Quick access to kitty" |

Current settings in `quick-access-terminal.conf`: `edge top` (drops from the
top edge), `lines 25` (height in terminal lines), `background_opacity 0.9`,
and `hide_on_focus_loss yes` (click anywhere else and it vanishes, classic
Guake behavior). The window otherwise inherits everything from your normal
`kitty.conf` — same font, theme, and shell.

Ways to toggle it:

- The global hotkey bound in System Settings (works from any app).
- Run `kitten quick-access-terminal` in any terminal — first run shows it,
  running it again hides it.
- `ctrl+d` inside the dropdown closes it entirely.

> **Gotcha: "Quick access to kitty" missing from the Services list.** The
> service is declared by a _nested_ helper app,
> `/Applications/kitty.app/Contents/kitty-quick-access.app`, which macOS
> doesn't always index on its own — the Services pane's "General" category
> simply doesn't appear. Fix (what was done on 2026-08-13): force-register
> the helper and flush the Services cache, then fully quit and reopen System
> Settings (it caches the list):
>
> ```sh
> /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister \
>   -f /Applications/kitty.app/Contents/kitty-quick-access.app
> /System/Library/CoreServices/pbs -flush
> ```
>
> If it still doesn't show, log out and back in. Fallback that skips the
> Services system entirely: bind a Raycast hotkey to run
> `/Applications/kitty.app/Contents/MacOS/kitten quick-access-terminal`.

> **Gotcha: dropdown doesn't span the full screen width.** The panel sizes
> itself to the screen area macOS reports as available, which _excludes an
> always-visible Dock_ — with the Dock pinned to the left edge, the dropdown
> started ~10% in from the left. There's no kitty option to overlap the
> Dock; fixed on 2026-08-13 by enabling Dock auto-hide
> (`defaults write com.apple.dock autohide -bool true && killall Dock`),
> after which the dropdown gets the full width. Revert with the same command
> and `-bool false`. The dropdown computes its geometry at process start, so
> after any Dock change, close it fully (`ctrl+d`) and toggle it back up.

To change the dropdown's look or behavior, edit
`kitty/quick-access-terminal.conf` — options are documented in
`kitten quick-access-terminal --help` and the shipped default config at
`/Applications/kitty.app/Contents/Resources/doc/kitty/html/_downloads/*/quick_access_terminal.conf`.
Notable ones not currently set: `edge` accepts `bottom`/`left`/`right`/`center`,
`kitty_override name=value` tweaks kitty settings just for this window (e.g.
`kitty_override font_size=20`), and `start_as_hidden yes` if you ever launch
it at login. Changes take effect the next time the dropdown process starts
(quit it with `ctrl+d`, then toggle it back up).

---

## 14. Troubleshooting + cheat sheet

### Discovery tools — how to keep learning this config without a guide

- **`kitty --debug-config`** — prints the fully resolved config plus every
  active keymap, straight from the running binary. This is the single source
  of truth when this guide and reality disagree (config changes after
  2026-08-06, for instance).
- **`kitty +kitten show_key`** — run it, then press any key combo; it prints
  the exact escape sequence kitty received. Use this when a binding "doesn't
  fire" and you need to know whether the terminal even saw the keystroke.
- **`kitten @ ls`** — dumps the live tab/window tree as JSON (needs
  `allow_remote_control yes`, already on at 3369). Useful for confirming
  which pane `kitten @` commands like the Dev tab's self-rename are actually
  targeting.
- **`kitty +kitten themes`** — browse and preview installed/bundled themes
  interactively, the same mechanism `kitten themes Zenburn` uses non-
  interactively (chapter 9, chapter 12).

### First response to "something's wrong"

| Symptom                                       | Run this                                                                                                                                                                                   |
| --------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Need the fully effective config + live keymap | `kitty --debug-config`                                                                                                                                                                     |
| Need to see exactly what a keypress sends     | `kitty +kitten show_key`                                                                                                                                                                   |
| Need to inspect the live pane/tab tree        | `kitten @ ls`                                                                                                                                                                              |
| Not sure which flag inspects raw input        | Prefer `kitty --debug-config` and `kitty +kitten show_key` over guessing at flag names — let their live output be the tiebreaker over anything documentation (including this guide) claims |

> **Gotcha: the Dev-tab launcher never sees `.zshrc` aliases.** See chapter
> 7, Gotcha 1 in full — short version: it runs a non-interactive `zsh -lc`,
> so `.zshrc`'s `alias vim='nvim'` (zshrc:156) never loads; the binding must
> call `exec nvim .` explicitly (and does).

> **Gotcha: missing `current-theme.conf` breaks bootstrap on a new machine.**
> See chapter 9, Gotcha 3 — the theme file only exists on this machine's
> `~/.config/kitty/`, not in the repo. Run `kitten themes Zenburn` after
> bootstrapping elsewhere, or start tracking the file here.

> **Gotcha: shell-integration keys go dead over SSH or inside tmux.** See
> chapter 5, Gotcha 13 — `cmd+shift+up/down` and `ctrl+a>e` need kitty's
> terminfo/hooks on the remote end; `zshrc:148-151`'s `kitten ssh` alias is
> what carries that over.

### Condensed cheat sheet

| Key                                  | Action                                           |
| ------------------------------------ | ------------------------------------------------ |
| `ctrl+a>ctrl+a`                      | Send literal Ctrl-A through                      |
| `ctrl+a>\|` / `ctrl+a>_`             | vsplit / hsplit                                  |
| `ctrl+minus`                         | hsplit, no prefix (Ctrl+\ left free for SIGQUIT) |
| `cmd+d`                              | vsplit                                           |
| `ctrl+a>left/down/up/right`          | Move focus                                       |
| `shift+arrows`                       | Move focus, no prefix                            |
| `cmd+alt+arrows` / `ctrl+alt+arrows` | Move focus (Raycast fallback)                    |
| `ctrl+a>o`                           | Cycle panes                                      |
| `ctrl+a>m`                           | Swap panes                                       |
| `ctrl+a>x` / `ctrl+backspace`        | Close pane                                       |
| `ctrl+a>t/f/g/s`                     | Tall / Fat / Grid / Splits layout                |
| `ctrl+a>space`                       | Next layout                                      |
| `ctrl+a>z`                           | Toggle zoom (stack)                              |
| `cmd+j`                              | Toggle lower pane(s); cursor follows — lower when revealed, top when hidden (`kitty/toggle-stack.py`) |
| `ctrl+a>r`                           | Interactive resize                               |
| `ctrl+a>equal`                       | Reset pane sizes                                 |
| `cmd+arrows`                         | Resize one step                                  |
| `ctrl+a>h/l/k/j`                     | Resize one step (5 cells)                        |
| `ctrl+a>c`                           | New tab                                          |
| `ctrl+a>&`                           | Close tab                                        |
| `ctrl+a>,`                           | Rename tab                                       |
| `ctrl+a>n` / `ctrl+a>p`              | Next / previous tab                              |
| `ctrl+a>1..9`                        | Goto tab N                                       |
| `cmd+1..8`                           | Goto tab N                                       |
| `cmd+9`                              | Goto last tab                                    |
| `ctrl+a>[`                           | Scrollback pager                                 |
| `cmd+k`                              | Clear screen + scrollback                        |
| `cmd+shift+up/down`                  | Jump to prev/next prompt                         |
| `ctrl+a>e`                           | Show last command's output                       |
| `ctrl+a>y`                           | Hint-copy a line                                 |
| `ctrl+a>/`                           | Hint-insert a path at prompt                     |
| `ctrl+a>u`                           | Hint-open a URL                                  |
| `ctrl+a>b`                           | Broadcast to all panes in tab                    |
| `ctrl+a>v`                           | Dev tab (nvim on top, shell below)               |
| `ctrl+a>shift+l`                     | Logs tab (4-shell grid)                          |
| `cmd+shift+c` / `ctrl+a>a`           | Launch Claude Code                               |
| `cmd+f`                              | Resume suspended job                             |
| `cmd+shift+f`                        | Job picker                                       |
| `cmd+/`                              | Search scrollback in pager                       |
| `cmd+enter`                          | Toggle fullscreen                                |
| `kitty --debug-config`               | Effective config + live keymap                   |
| `kitten @ ls`                        | Pane/tab tree                                    |
| `kitty +kitten show_key`             | Inspect raw keypress                             |
