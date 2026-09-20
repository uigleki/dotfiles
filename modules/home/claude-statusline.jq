# Codex status_line_style.rs: Catppuccin Latte scope colors, softened to 85% saturation.
# Matches this repository's light terminal theme; no runtime theme detection.
def color($kind):
  {model: "213;144;48", mode: "131;64;218", usage: "236;105;30",
   limit: "190;24;60", path: "72;154;54"}[$kind] as $rgb
  | "\u001b[38;2;\($rgb)m\(.)\u001b[0m";
def human:
  if . < 1e3 then tostring
  else (if . < 1e6 then [./1e3, "K"] else [./1e6, "M"] end)
    | (.[0] | if . < 10 then 100 elif . < 100 then 10 else 1 end) as $p
    | "\(.[0]*$p|round/$p)\(.[1])"
  end;
def rate($l; $fmt): select(.used_percentage != null)
  | "\($l) \(100 - .used_percentage | [0, ., 100] | sort | .[1] | round)%"
  + (.resets_at | if . then " until \(strflocaltime($fmt))" else " left" end)
  | color("limit");
[ ([ (.model.display_name // empty), (.effort.level // empty) ] | join(" ") | select(length > 0) | color("model")),
  (select(.fast_mode) | "Fast" | color("mode")),
  (.context_window | select(.used_percentage != null)
    | "\(.used_percentage|round)%" + (.context_window_size | if . then " of \(human)" else "" end)
    | color("usage")),
  (.rate_limits.five_hour | rate("5h"; "%H:%M")),
  (.rate_limits.seven_day | rate("7d"; "%a %H:%M")),
  (.workspace.current_dir // empty | sub("^\($ENV.HOME)(?=/|$)"; "~") | color("path"))
] | join("\u001b[2m · \u001b[0m")
