---
paths:
  - "**/*.nix"
---

Order attribute sets in these tiers, names as listed, others alphabetically:

1. `imports`, `options`, `config`; system before user; base before extensions.
2. `inherit`, `enable`, `package`, then discriminators and guards.
3. Knobs the owner retunes often, under `# retuned often`.
4. The rest, with a comment-headed group of related keys as one entry.

Keep any meaningful order
(execution, display, file format, idiom),
in sets and lists alike; sort other lists alphabetically.
Comment a deviation whose reason is not obvious.

Blank lines go around multi-line entries and comment-headed groups.

Name each file after its one feature.
