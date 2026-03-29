#!/bin/bash
input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name')
DIR=$(echo "$input" | jq -r '.workspace.current_dir')

# Shorten path: replace HOME with ~, show ~/first/.../last-1/last if > 4 parts
shorten_path() {
    local path="$1"
    local home="${HOME:-/root}"
    # Replace leading home dir with ~
    if [[ "$path" == "$home"* ]]; then
        path="~${path#$home}"
    fi
    IFS='/' read -ra parts <<< "$path"
    local count=${#parts[@]}
    if [ "$count" -le 4 ]; then
        echo "$path"
    else
        local p2="${parts[$((count-2))]}"
        local p1="${parts[$((count-1))]}"
        echo "${parts[0]}/${parts[1]}/.../$p2/$p1"
    fi
}

SHORT_PATH=$(shorten_path "$DIR")

# Git status with caching
CACHE_FILE="/tmp/statusline-git-cache"
CACHE_MAX_AGE=5

cache_is_stale() {
    [ ! -f "$CACHE_FILE" ] || \
    [ $(($(date +%s) - $(stat -c %Y "$CACHE_FILE" 2>/dev/null || echo 0))) -gt $CACHE_MAX_AGE ]
}

if cache_is_stale; then
    if git rev-parse --git-dir > /dev/null 2>&1; then
        BRANCH=$(git branch --show-current 2>/dev/null)
        STAGED=$(git diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
        MODIFIED=$(git diff --numstat 2>/dev/null | wc -l | tr -d ' ')
        echo "$BRANCH|$STAGED|$MODIFIED" > "$CACHE_FILE"
    else
        echo "||" > "$CACHE_FILE"
    fi
fi

IFS='|' read -r BRANCH STAGED MODIFIED < "$CACHE_FILE"

# Line 1: model, path, git
if [ -n "$BRANCH" ]; then
    echo "[$MODEL] 📁 $SHORT_PATH | 🌿 $BRANCH +$STAGED ~$MODIFIED"
else
    echo "[$MODEL] 📁 $SHORT_PATH"
fi

# Build a progress bar given a percentage (0-100) and width
make_bar() {
    local pct="$1" width="${2:-10}"
    local filled=$(( pct * width / 100 ))
    local empty=$(( width - filled ))
    local bar=""
    [ "$filled" -gt 0 ] && printf -v f "%${filled}s" && bar="${f// /▓}"
    [ "$empty" -gt 0 ] && printf -v e "%${empty}s" && bar="${bar}${e// /░}"
    echo "$bar"
}

# Format seconds-until-reset as "Xh Ym" or "Ym"
format_reset() {
    local resets_at="$1"
    local now secs_left h_left m_left
    now=$(date +%s)
    secs_left=$(( resets_at - now ))
    if [ "$secs_left" -le 0 ]; then
        echo "resetting"
        return
    fi
    h_left=$(( secs_left / 3600 ))
    m_left=$(( (secs_left % 3600) / 60 ))
    if [ "$h_left" -gt 0 ]; then
        echo "${h_left}h ${m_left}m"
    else
        echo "${m_left}m"
    fi
}

# Line 2: rate limit usage (only for Pro/Max subscribers, absent before first API response)
FIVE_H_PCT=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
FIVE_H_RESET=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
SEVEN_D_PCT=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
SEVEN_D_RESET=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

if [ -n "$FIVE_H_PCT" ] || [ -n "$SEVEN_D_PCT" ]; then
    LINE2=""

    if [ -n "$FIVE_H_PCT" ]; then
        PCT=$(printf '%.0f' "$FIVE_H_PCT")
        BAR=$(make_bar "$PCT")
        RESET_STR=""
        [ -n "$FIVE_H_RESET" ] && RESET_STR=" → $(format_reset "$FIVE_H_RESET")"
        LINE2="5h: $BAR ${PCT}%${RESET_STR}"
    fi

    if [ -n "$SEVEN_D_PCT" ]; then
        PCT=$(printf '%.0f' "$SEVEN_D_PCT")
        BAR=$(make_bar "$PCT")
        RESET_STR=""
        [ -n "$SEVEN_D_RESET" ] && RESET_STR=" → $(format_reset "$SEVEN_D_RESET")"
        SEVEN_D_STR="7d: $BAR ${PCT}%${RESET_STR}"
        [ -n "$LINE2" ] && LINE2="$LINE2 | $SEVEN_D_STR" || LINE2="$SEVEN_D_STR"
    fi

    echo "$LINE2"
fi
