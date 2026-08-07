#!/usr/bin/env python3
"""Cmd+J: toggle the bottom pane(s) via the stack layout, moving the cursor
with the direction — into the revealed lower pane when opening, back to the
top pane when closing. Launched from kitty.conf as a background process with
--allow-remote-control, so `kitten @` talks to kitty over the unix socket
from `listen_on` (/tmp/kitty-<pid>). KITTY_LISTEN_ON is useless here: for
background launches it's an inherited fd (fd:N) that Python's subprocess
closes, so the socket path is derived from the parent pid — kitty itself."""

import glob
import json
import os
import subprocess
import sys

KITTEN = "/Applications/kitty.app/Contents/MacOS/kitten"


def socket_addr():
    candidate = f"/tmp/kitty-{os.getppid()}"
    if os.path.exists(candidate):
        return f"unix:{candidate}"
    sockets = sorted(glob.glob("/tmp/kitty-*"), key=os.path.getmtime)
    if sockets:
        return f"unix:{sockets[-1]}"
    sys.exit(1)


SOCKET = socket_addr()


def kitten(*args, check=True, capture=False):
    return subprocess.run(
        [KITTEN, "@", "--to", SOCKET, *args],
        check=check,
        capture_output=capture,
        text=True,
    )


def focused_tab():
    out = kitten("ls", "--match-tab", "state:focused", capture=True).stdout
    for os_win in json.loads(out):
        for tab in os_win["tabs"]:
            return tab
    return None


def main():
    tab = focused_tab()
    if tab is None or len(tab["windows"]) < 2:
        return
    if tab["layout"] == "stack":
        # Opening: restore the split layout, then drop the cursor into the
        # pane below the top one (fall back to the last window if there is
        # no bottom neighbor, e.g. side-by-side splits).
        kitten("last-used-layout")
        r = kitten("focus-window", "--match", "neighbor:bottom", check=False)
        if r.returncode != 0:
            kitten("focus-window", "--match", f"id:{tab['windows'][-1]['id']}")
    else:
        # Closing: put the cursor on the top (first) pane, then stack so
        # only that pane stays visible.
        kitten("focus-window", "--match", f"id:{tab['windows'][0]['id']}")
        kitten("goto-layout", "stack")


if __name__ == "__main__":
    try:
        main()
    except subprocess.CalledProcessError as e:
        sys.exit(e.returncode)
