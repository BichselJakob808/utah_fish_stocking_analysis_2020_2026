# Utah Fish Stocking Analysis | 2020–2026

I fish a lot, and I'd always wondered how the state actually decides where to put fish. Utah's Division of Wildlife Resources publishes every stocking event it's ever run, so I used that as the basis for a project that would let me practice the full analytics workflow end to end: pulling raw data myself, building a real database around it, writing SQL against it, and turning the results into a dashboard someone could actually use.

This isn't a cleaned-up sample dataset. It's messy, it has quirks, and I had to make real decisions about how to handle those quirks. That's most of what this README is about.

<img width="1398" height="794" alt="Final_Screenshot" src="https://github.com/user-attachments/assets/d2f7cb0b-c992-455e-a81f-27618cfd2a39" />



---

## The short version

Across 2020–2026, Utah stocked just over 69 million fish into 1,075 waterbodies, spanning 28 species and nearly 17,000 individual stocking events. A few things stood out once I actually got into the numbers:

- 2024 was the busiest year on record (12.6M fish). 2026 dropped off sharply, down to 7.9M — the lowest of any year in the dataset.
- Three species — Rainbow, Walleye, and Kokanee — account for most of the volume. Everything else is a much smaller slice.
- Willard Bay Reservoir alone got almost twice as many fish as the next closest waterbody.
- Duchesne County has stocked activity in 256 different waterbodies — more than any other county by a wide margin.
- I found 50 waterbodies that were stocked regularly before 2022 and haven't been touched since. I don't know why, but it's the kind of thing worth flagging to someone who does.

---

## Why I built it this way

I wanted the project to actually mirror how this work gets done in practice, not just show off a finished chart. So I split it into five stages, and each one taught me something I didn't expect going in.

### Pulling the data myself (Python)

The DWR site lets you search stocking records, but there's no clean bulk download — you get an HTML table per query. I wrote a Python script using pandas and requests that loops through each year from 2020 to 2026, grabs that year's table, tags it with the year, and stacks everything into one combined CSV. It's not glamorous code, but it's the difference between "here's a dataset I found" and "here's a dataset I actually went and got."

### Cleaning it up (Excel)

Once I had the raw CSV, I went through it manually in Excel before touching a database. Waterbody names were inconsistent (abbreviations like "Res" and "L" everywhere), some numeric fields needed a second look, and I wanted to catch anything obviously wrong before it became a permanent part of my schema. This step felt tedious at the time, but skipping it would have meant chasing the same errors three steps later inside SQL, which is a much worse place to find them.

### Designing the database (PostgreSQL)

I didn't want one giant flat table, so I split the data into three related tables — `species`, `waterbody`, and `stocking` — with `stocking` holding the actual events and pointing back to the other two through foreign keys. This is a small-scale version of a star schema, and building it by hand (instead of just dumping a CSV into a single table) is what let me write the more interesting SQL later — joins, rankings, and window functions all depend on having the data properly normalized first.

```
species                    waterbody
   │                            │
   │ species_id      waterbody_id │
   └──────────┐        ┌─────────┘
              ↓        ↓
             stocking
   (event_id, stock_date, quantity, average_length)
```

### Asking real questions in SQL

Instead of just aggregating for the sake of it, I wrote each query to answer something I actually wanted to know. A few examples of how the questions got more interesting as I went:

- *Basic:* How many fish were stocked each year? Which species get stocked the most? → `GROUP BY`, `SUM()`, `COUNT(DISTINCT)`
- *A bit further:* Did stocking activity change meaningfully from one year to the next? → `LAG()` to calculate year-over-year percent change
- *Further still:* Which waterbody gets the most fish *within its own county*, not just statewide? → `RANK() OVER (PARTITION BY county)`
- *The one I'm most proud of:* Which waterbodies used to get stocked but don't anymore? → a `LEFT JOIN` anti-join comparing pre-2022 activity against everything since

That last one wasn't something I planned from the start — it came from noticing gaps while I was looking at the running totals, then going back to write a query specifically to confirm the pattern.

### Building something someone could actually use (Power BI)

The dashboard isn't just "here are some charts." Each visual maps to a specific question:

| What I wanted to know | What answers it |
|---|---|
| How much is being stocked overall? | KPI cards + yearly trend |
| Where is the effort actually going? | Top 10 waterbodies, top species, county breakdown |
| What's changed, and does it need a closer look? | Year-over-year trend, moving average, filters |

The yearly trend chart pairs raw totals with a 3-year moving average, because looking at the bars alone made single unusual years (like the 2026 drop) look more dramatic than the underlying trend actually supports. The moving average is there specifically to separate "this year was weird" from "something is actually changing."

I added Year, County, Waterbody, and Species filters so the dashboard isn't just a static snapshot of my findings — someone can click into whatever slice they care about and get the same analysis I did, without needing to write a query themselves.

---

## Two decisions I made on purpose

**The "ALL TROUT" category.** Some records, mostly in earlier years, just say "ALL TROUT" instead of naming a specific species. I could have dropped those rows or guessed at a species, but both felt like they'd quietly corrupt the analysis. I kept them as their own unspecified category instead, which means species-level numbers (like the Rainbow Trout total) are accurate, but they don't capture every trout ever stocked — just the ones that were actually identified as a specific species.

**No point map.** I originally wanted to plot every waterbody by exact coordinates using a DWR ArcGIS layer. The problem: that layer's waterbody names didn't reliably match the names in my stocking data, and forcing a match would have meant either silently mismatching some locations or spending a lot of time hand-reconciling names with no guarantee I'd catch every error. I decided accurate county-level data was more trustworthy than a good-looking map built on shaky matches, so the dashboard shows stocking activity aggregated by county instead of by exact point location.

---

## Numbers, if you want to check my work

**Total fish stocked by year**

| Year | Total Fish |
|---|---|
| 2020 | 8,098,727 |
| 2021 | 9,513,529 |
| 2022 | 8,226,686 |
| 2023 | 10,499,833 |
| 2024 | 12,615,739 |
| 2025 | 12,239,102 |
| 2026 | 7,912,994 |

**Most stocked species**

| Species | Total Stocked |
|---|---|
| Rainbow | 20,951,156 |
| Walleye | 13,460,029 |
| Kokanee | 11,245,328 |
| Cutthroat | 9,303,045 |
| Wiper | 4,131,187 |

**Top waterbodies**

| Waterbody | Total Stocked |
|---|---|
| Willard Bay Res | 13,414,678 |
| Strawberry Res | 7,567,208 |
| Flaming Gorge Res | 6,766,105 |
| Fish L | 4,293,896 |
| Jordanelle Res | 2,371,790 |

**Distinct waterbodies stocked, by county**

| County | Waterbodies Stocked |
|---|---|
| Duchesne | 256 |
| Summit | 179 |
| Sanpete | 74 |
| Garfield | 67 |
| Utah | 59 |

---

## Tools, for reference

- **Python** (pandas, requests) — pulling the raw data from DWR
- **Excel** — cleaning and reviewing before it hit a database
- **PostgreSQL** — schema design, joins, CTEs, window functions
- **Power BI** — the dashboard itself, plus DAX for the moving average and KPI measures
- **GitHub** — this repo

## Skills touched along the way

Python data extraction, requests/API handling, pandas, Excel-based data cleaning, relational schema design, primary/foreign keys, SQL joins, `GROUP BY`/`HAVING`, `LAG()`, `RANK() OVER (PARTITION BY ...)`, `SUM() OVER()`, CTEs, anti-joins, Power BI dashboard design, DAX.

## Project structure

```
Utah-Fish-Stocking-Analysis/
│
├── data/
│   ├── raw/
│   └── processed/
│
├── python/
│   └── extract_fish_stocking.py
│
├── sql/
│   ├── create_tables.sql
│   └── analysis_queries.sql
│
├── powerbi/
│   └── utah_fish_stocking_dashboard.pbix
│
├── docs/
│   └── dashboard-screenshot.png
│
└── README.md
```

## Want to look closer?

1. Open `powerbi/utah_fish_stocking_dashboard.pbix` in Power BI Desktop to play with the actual dashboard
2. `sql/analysis_queries.sql` has every query mentioned above, with comments explaining what question each one was written to answer
3. The findings above are the highlights — the SQL file has the full detail if you want to dig further

---

**Jakob Bichsel**
Data Analytics Portfolio Project
