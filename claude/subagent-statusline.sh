#!/bin/bash
# One row per subagent: name · model · effort · description · tokens
jq -c '
  def short: sub("^claude-"; "") | split("-") | map(select(test("^[0-9]{8}$") | not))
    | (.[0][:1] | ascii_upcase) + .[0][1:] + " " + (.[1:] | join("."));
  def tok: if . >= 1000 then "\((. / 1000 | round))k" else tostring end;
  .tasks[] | {id, content: ([
    (.name // .agentType),
    (.model | select(.) | "\u001b[35m\(short)\u001b[0m"),
    (.effort | select(.) | "\u001b[36m\(.)\u001b[0m"),
    .description,
    "\u001b[2m\(.tokenCount | tok) tok\u001b[0m"
  ] | map(select(. != null and . != "")) | join(" \u001b[2m·\u001b[0m "))}
'
