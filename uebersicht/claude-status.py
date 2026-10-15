#!/usr/bin/env python3
"""Print Claude Code activity and plan usage as one JSON line for simple-bar-lite.

Activity comes from the per-session files that Claude Status Bar.app's hooks
write to ~/.claude/statusbar/state.d. Usage comes from the OAuth usage endpoint
(the same data as /usage), cached for USAGE_TTL seconds because it is
rate-limited; on failure the last cached values are returned marked stale.
"""
import json
import os
import subprocess
import time
import urllib.request

HOME = os.path.expanduser("~")
STATE_DIR = os.path.join(HOME, ".claude", "statusbar", "state.d")
CACHE = os.path.join(HOME, ".cache", "claude-status", "usage.json")
USAGE_URL = "https://api.anthropic.com/api/oauth/usage"
USAGE_TTL = 300
RETRY_TTL = 60
BUSY = ("thinking", "tool", "permission")


def alive(pid):
    try:
        os.kill(pid, 0)
        return True
    except PermissionError:
        return True
    except (OSError, TypeError):
        return False


def sessions():
    result = []
    try:
        names = os.listdir(STATE_DIR)
    except OSError:
        return result
    for name in names:
        if not name.endswith(".json"):
            continue
        try:
            with open(os.path.join(STATE_DIR, name)) as f:
                s = json.load(f)
        except (OSError, ValueError):
            continue
        if s.get("state") in BUSY and alive(s.get("pid")):
            result.append(s)
    return result


def token():
    out = subprocess.run(
        ["security", "find-generic-password", "-s", "Claude Code-credentials", "-w"],
        capture_output=True, text=True, timeout=10, check=True,
    ).stdout
    return json.loads(out)["claudeAiOauth"]["accessToken"]


def fetch_usage():
    req = urllib.request.Request(USAGE_URL, headers={
        "Authorization": "Bearer " + token(),
        "anthropic-beta": "oauth-2025-04-20",
        "User-Agent": "claude-code/simple-bar-lite",
    })
    with urllib.request.urlopen(req, timeout=10) as r:
        data = json.load(r)
    pick = lambda k: {
        "pct": round((data.get(k) or {}).get("utilization") or 0),
        "resetsAt": (data.get(k) or {}).get("resets_at"),
    }
    return {"five": pick("five_hour"), "seven": pick("seven_day")}


def usage():
    cached = {}
    try:
        with open(CACHE) as f:
            cached = json.load(f)
    except (OSError, ValueError):
        pass
    now = time.time()
    ttl = USAGE_TTL if cached.get("ok") else RETRY_TTL
    if now - cached.get("checkedAt", 0) < ttl:
        return cached.get("usage"), not cached.get("ok")
    try:
        fresh, ok = fetch_usage(), True
    except Exception:
        fresh, ok = cached.get("usage"), False
    os.makedirs(os.path.dirname(CACHE), exist_ok=True)
    tmp = CACHE + ".tmp"
    with open(tmp, "w") as f:
        json.dump({"checkedAt": now, "ok": ok, "usage": fresh}, f)
    os.replace(tmp, CACHE)
    return fresh, not ok


def main():
    now = int(time.time())
    busy = sorted(sessions(), key=lambda s: s.get("ts", 0), reverse=True)
    # A session waiting on permission needs attention, so it wins over a busy one.
    busy.sort(key=lambda s: s.get("state") != "permission")
    active = None
    if busy:
        s = busy[0]
        started = s.get("startedAt") or 0
        active = {
            "state": s.get("state"),
            "label": s.get("label") or s.get("state"),
            "project": s.get("project", ""),
            "elapsed": now - started if started else None,
        }
    u, stale = usage()
    print(json.dumps({"active": active, "others": max(len(busy) - 1, 0), "usage": u, "stale": stale}))


if __name__ == "__main__":
    main()
