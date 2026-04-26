# Data Visualization Design

When to reference: building dashboards, analytics views, charts, KPI cards, reports, or any UI showing numeric data.

## Choosing the Right Chart

Wrong chart type is worse than no chart. Pick by the comparison you're trying to support:

| Comparison | Chart |
|---|---|
| Quantities across **categories** | **Bar chart** (horizontal if labels are long) |
| Change over **time** | **Line chart** (continuous x-axis) |
| Parts of a **whole** | **Bar (stacked)** preferred — pie only with 2–5 slices and big differences |
| **Correlation** between two variables | **Scatter plot** |
| **Cumulative** total over time | **Area chart** |
| **Trend at a glance** (no axes) | **Sparkline** in a KPI card |
| **Distribution** | **Histogram** or **box plot** |
| **Geographic** distribution | **Choropleth** or symbol map |
| **Hierarchy** of magnitudes | **Treemap** |

### Pie chart caveat

Humans are bad at comparing angles. Pies only work with 2–5 slices that differ noticeably in size. With slices of similar size, switch to a bar chart. Avoid 3D pies entirely — they distort proportion.

## Dashboard Design Principles

### Lead with the most important metric

Top-left is prime real estate (per F-pattern scanning). Put the KPI that matters most there. Below or beside it, supporting metrics. Detail charts come further down.

### Group related metrics

Revenue metrics together. User metrics together. Use cards or visual regions (background tint, border) to define groups.

### Always provide context

A number alone is meaningless. "Revenue: $1.2M" — vs. what?

- **Comparison**: "↑ 15% vs. last month"
- **Goal**: "Goal: $1.5M (80% there)"
- **Trend**: a small sparkline showing the trajectory
- **Benchmark**: industry average, your peers

A dashboard without context is a dashboard you have to interpret yourself. Provide the answer to "is this good or bad?"

### Don't overload

20 charts on one screen is overwhelming. The pattern:

1. **Top level**: 4–6 key metrics, big numbers, with trend/comparison
2. **Mid level**: 2–4 charts showing the most-watched dynamics
3. **Drill-down**: detail views accessible via click, not pre-rendered

If everything is important, nothing is.

### Consistent scales

If two charts show the same metric over different periods, use the **same y-axis scale** so they're visually comparable. Misaligned scales mislead.

### Color meaning is not arbitrary

- **Green** = good / up / positive
- **Red** = bad / down / negative
- **Gray** = neutral / unchanged
- **Blue** = informational

**Don't reverse these conventions.** A red bar going up looks alarming even if "up" is good in your context. Pick colors that match the *connotation*, not just the brand.

For categorical data (no inherent good/bad), use a categorical palette designed for distinction (ColorBrewer "Set2" / "Tableau 10").

### Color-blind safe palettes

Roughly 8% of men have red-green color blindness. Don't rely on red vs. green alone:

- Use **shape** or **icon** in addition to color (▲ ▼)
- Use **text labels** for series in line charts
- Use a color-blind safe palette for categorical data (Viridis, Cividis for sequential; ColorBrewer for categorical)

## KPI Cards

The unit of dashboard real estate. Anatomy:

```
┌─────────────────────────┐
│ Revenue                 │   ← label (top-left, small/muted)
│ $1.2M           ↑ 15%   │   ← value (large) + delta
│ ▁▂▄▆▇▆▇▅▆▇             │   ← sparkline (optional)
│ vs. last month          │   ← comparison context
└─────────────────────────┘
```

- **Label** (~14px, muted color): what is this number?
- **Value** (~32–40px, bold): the number itself
- **Delta** (~16px, green/red with arrow): change vs. comparison
- **Sparkline**: optional trend visualization
- **Context line** (~12px, muted): "vs. last month", "Goal: $1.5M"

Keep cards visually consistent in size and structure across the dashboard.

## Tables vs. Charts

Tables are charts too. Use them when:
- The user needs to read or copy exact values
- There are too many categories for a chart to be readable
- The data has multiple dimensions that need to be filtered/sorted
- Precision matters more than pattern

Use charts when patterns or trends matter more than exact numbers.

## Anti-Patterns

- **Chart junk** — 3D effects, drop shadows, gridlines everywhere, ornamental imagery. Tufte's rule: maximize the data-ink ratio.
- **Truncated y-axis on bar charts** — bar charts must start at zero. Truncating distorts magnitude.
- **Too many colors** — distinct categorical palettes max out around 8 categories. More than that, group into "Other."
- **Sorting alphabetically** when sorting by value would tell a story
- **Numbers without units** ("1.2" — million? thousand? percent?)
- **Pie chart with 12 slices**
- **No empty/loading/error states for charts** — see `state-design.md`. A chart that flashes "No data" mid-load destroys trust.
- **Auto-rotating dashboards** — let users control what they see; don't force a carousel of charts.

## Quick Audit

For any dashboard, ask:
- [ ] Does each metric have a comparison or context?
- [ ] Is the most important metric in the top-left?
- [ ] Could a stranger understand what each chart shows in 2 seconds?
- [ ] Are the right chart types used (no pie with 12 slices, no truncated bars)?
- [ ] Does color follow convention (green up, red down)?
- [ ] Is the dashboard usable for color-blind viewers?
- [ ] Does it work when data is missing or loading?
