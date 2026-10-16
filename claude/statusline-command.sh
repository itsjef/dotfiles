#!/bin/bash
input=$(cat)
printf '%s' "$input" | "/opt/homebrew/bin/node" "$HOME/.claude/hooks/gsd-statusline.js" >/dev/null 2>&1 &
j() { printf '%s' "$input" | jq -r "$1 // empty" 2>/dev/null; }
cwd=$(j '.workspace.current_dir // .cwd')
sep=$(printf ' \033[2m|\033[0m ')
line1=""; line2=""
add1() { line1="${line1:+$line1$sep}$1"; }
add2() { line2="${line2:+$line2$sep}$1"; }

model=$(j '.model.display_name')
[ -n "$model" ] && add1 "$(printf '\033[35m%s\033[0m' "$model")"

effort=$(j '.effort.level')
[ -n "$effort" ] && add1 "$(printf '\033[36m%s\033[0m' "$effort")"

if [ -n "$cwd" ]; then
  d=${cwd/#$HOME/~}
  n=$(printf '%s' "$d" | awk -F/ '{print NF}')
  if [ "$n" -gt 3 ]; then
    d="…/$(printf '%s' "$d" | awk -F/ '{print $(NF-1)"/"$NF}')"
  fi
  s=$(printf '\033[34m%s\033[0m' "$d")

  if git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    st=$(git --no-optional-locks -C "$cwd" status --porcelain=v2 --branch 2>/dev/null)
    branch=$(printf '%s\n' "$st" | awk '/^# branch.head/{print $3}')
    if [ "$branch" = "(detached)" ]; then
      branch="@$(git -C "$cwd" rev-parse --short=8 HEAD 2>/dev/null)"
    fi
    ab=$(printf '%s\n' "$st" | awk '/^# branch.ab/{print $3" "$4}')
    ahead=${ab%% *}; ahead=${ahead#+}; ahead=${ahead:-0}
    behind=${ab##* }; behind=${behind#-}; behind=${behind:-0}
    staged=$(printf '%s\n' "$st" | awk '/^[12] /{if (substr($2,1,1)!=".") n++} END{print n+0}')
    unstaged=$(printf '%s\n' "$st" | awk '/^[12] /{if (substr($2,2,1)!=".") n++} END{print n+0}')
    untracked=$(printf '%s\n' "$st" | awk '/^\? /{n++} END{print n+0}')
    conflicted=$(printf '%s\n' "$st" | awk '/^u /{n++} END{print n+0}')
    stash=$(git --no-optional-locks -C "$cwd" stash list 2>/dev/null | wc -l | tr -d ' ')

    s+=$(printf ' \033[32m%s\033[0m' "$branch")
    [ "$behind" -gt 0 ] && s+=$(printf ' \033[32m⇣%s\033[0m' "$behind")
    [ "$ahead" -gt 0 ] && s+=$(printf ' \033[32m⇡%s\033[0m' "$ahead")
    [ "$stash" -gt 0 ] && s+=$(printf ' \033[32m*%s\033[0m' "$stash")
    [ "$conflicted" -gt 0 ] && s+=$(printf ' \033[31m~%s\033[0m' "$conflicted")
    [ "$staged" -gt 0 ] && s+=$(printf ' \033[33m+%s\033[0m' "$staged")
    [ "$unstaged" -gt 0 ] && s+=$(printf ' \033[33m!%s\033[0m' "$unstaged")
    [ "$untracked" -gt 0 ] && s+=$(printf ' \033[34m?%s\033[0m' "$untracked")
  fi
  add1 "$s"
fi

# Prints a 10-cell bar and the percentage, colored by how full it is.
bar() {
  local used=$1 color=32 bar="" i
  if [ "$used" -ge 80 ]; then color=31; elif [ "$used" -ge 50 ]; then color=33; fi
  for i in 1 2 3 4 5 6 7 8 9 10; do
    if [ "$i" -le $(( (used + 5) / 10 )) ]; then bar+="█"; else bar+="░"; fi
  done
  printf '\033[%sm%s %s%%\033[0m' "$color" "$bar" "$used"
}

rem=$(j '.context_window.remaining_percentage | floor')
if [ -n "$rem" ]; then
  tok=$(j '.context_window.current_usage | (.input_tokens + .cache_creation_input_tokens + .cache_read_input_tokens)')
  fmt() { awk -v n="$1" 'BEGIN{ if (n>=1e6) printf "%gM", int(n/1e5)/10; else if (n>=1e3) printf "%dk", int(n/1e3+0.5); else printf "%d", n }'; }
  add2 "ctx $(bar $((100 - rem)))"
  cached=$(j '.context_window.current_usage.cache_read_input_tokens')
  [ -n "$tok" ] && add2 "$(printf '\033[2m%s\033[0m' "$(fmt "$tok")${cached:+ ($(fmt "$cached") cached)}")"
fi

cost=$(j '.cost.total_cost_usd')
[ -n "$cost" ] && add2 "$(printf '\033[33m$%.2f\033[0m' "$cost")"

if [ -n "$SSH_CONNECTION" ] || [ "$(id -u)" = 0 ]; then
  if [ "$(id -u)" = 0 ]; then color=31; else color=37; fi
  add2 "$(printf '\033[%sm%s@%s\033[0m' "$color" "$(id -un)" "$(hostname -s)")"
fi

line3=""
now=$(date +%s)
for w in five_hour:5h seven_day:7d; do
  pct=$(j ".rate_limits.${w%%:*}.used_percentage | floor")
  [ -z "$pct" ] && continue
  if [ "$pct" -ge 80 ]; then color=31; elif [ "$pct" -ge 50 ]; then color=33; else color=32; fi
  s=$(printf '%s \033[%sm%s%%\033[0m' "${w##*:}" "$color" "$pct")
  reset=$(j ".rate_limits.${w%%:*}.resets_at")
  if [ -n "$reset" ] && [ "$reset" -gt "$now" ]; then
    left=$((reset - now))
    if [ "$left" -ge 86400 ]; then t="$((left / 86400))d$((left % 86400 / 3600))h"; else t="$((left / 3600))h$((left % 3600 / 60))m"; fi
    s+=$(printf ' \033[2m↻%s\033[0m' "$t")
  fi
  limits="${limits:+$limits $(printf '\033[2m·\033[0m') }$s"
done
line3=${limits:+limit $limits}

printf '%s\n' "$line1"
line2="${line2}${line2:+${line3:+$sep}}${line3}"
[ -n "$line2" ] && printf '%s\n' "$line2"
exit 0
