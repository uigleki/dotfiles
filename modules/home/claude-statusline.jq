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
def rate($l): .used_percentage // empty | "\($l) \(100 - . | [0, ., 100] | sort | .[1] | round)% left" | color("limit");
[ ([ (.model.display_name // empty), (.effort.level // empty) ] | join(" ") | select(length > 0) | color("model")),
  ("Fast \(if .fast_mode then "on" else "off" end)" | color("mode")),
  (.context_window.used_percentage // empty | "Context \(.|round)% used" | color("usage")),
  (.context_window.context_window_size // empty | "\(.|human) window" | color("usage")),
  (.rate_limits.five_hour | rate("5h")),
  (.rate_limits.seven_day | rate("weekly")),
  (.workspace.current_dir // empty | sub("^\($ENV.HOME)(?=/|$)"; "~") | color("path"))
] | join("\u001b[2m · \u001b[0m")
