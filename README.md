# Utah Fish Stocking Analysis | 2020–2026

## Project Overview

This project analyzes fish stocking activity across Utah from **2020 through 2026** using data published by the Utah Division of Wildlife Resources (DWR).

The project demonstrates an end-to-end data analytics workflow:

- Data extraction using Python
- Data cleaning and preparation in Excel
- Relational database design in PostgreSQL
- SQL analysis using joins, aggregations, CTEs, and window functions
- Data visualization and dashboard development in Power BI

The primary goal was to identify stocking trends, heavily stocked species and waterbodies, geographic patterns, and changes in stocking activity over time.

---

## Tools Used

**Python**
- Pandas
- Requests
- Web data extraction
- CSV creation

**Microsoft Excel**
- Data cleaning
- Data formatting
- Column standardization
- Data review and preparation

**PostgreSQL**
- Relational database design
- Data loading
- SQL analysis
- JOINs
- Aggregations
- CTEs
- Window functions

**Power BI**
- Data visualization
- Dashboard development
- Interactive filtering

**GitHub**
- Project documentation
- Version control

---

## Data Source

The primary dataset was collected from the **Utah Division of Wildlife Resources Fish Stocking Report**.

The analysis covers: **2020, 2021, 2022, 2023, 2024, 2025, and 2026**

The dataset contains information including:

- Waterbody
- County
- Fish species
- Stocking date
- Quantity stocked
- Average fish length

---

## Project Workflow

### 1. Python Data Extraction

Python was used to collect the yearly fish stocking data from the Utah DWR website.

The extraction script loops through each year from 2020 through 2026, reads the stocking table, adds the corresponding year, combines the datasets, and exports the final dataset to CSV.

```
Utah DWR Fish Stocking Reports
            ↓
      Python / Pandas
            ↓
      2020–2026 Data
            ↓
          CSV
            ↓
       Excel Cleaning
            ↓
       PostgreSQL
```

> The Python extraction code is included in the `python/` folder.

### 2. Excel Data Cleaning

Excel was used to review and prepare the extracted data before loading it into PostgreSQL.

Cleaning and preparation included:

- Reviewing column names
- Standardizing data
- Checking dates and numeric fields
- Reviewing waterbody and species names
- Identifying potential data-quality issues
- Preparing the data for database loading

### 3. PostgreSQL Database

The cleaned data was organized into a relational database consisting of three primary tables:

```
species
   │
   │ species_id
   ↓
stocking
   │
   │ waterbody_id
   ↓
waterbody
```

**Species** — Contains the unique fish species.
Example fields: `species_id`, `common_name`

**Waterbody** — Contains waterbody information.
Example fields: `waterbody_id`, `name`, `county`

**Stocking** — Contains individual stocking events.
Example fields: `event_id`, `waterbody_id`, `species_id`, `stock_date`, `quantity`, `average_length`

The `stocking` table connects to both the `species` and `waterbody` tables through foreign keys.

---

## SQL Analysis

SQL was used to answer a series of analytical questions.

**Basic Analysis**
- Total fish stocked by year
- Total fish stocked by species
- Top 10 waterbodies by total fish received
- Average fish length per stocking event by species
- Number of distinct waterbodies stocked per county
- Rainbow trout stockings in Uintah County by year

**Advanced SQL Analysis**
- Year-over-year percentage change using `LAG()`
- Running total of fish stocked per waterbody using `SUM() OVER()`
- Ranking waterbodies within each county using `RANK() OVER()`
- Comparison of average fish stocked per event during 2020–2022 versus later years using a CTE
- Species diversity by waterbody
- Waterbodies stocked before 2022 but not since using a `LEFT JOIN` anti-join

---

## Key Findings

### Total Fish Stocked by Year

| Year | Total Fish |
|------|-----------:|
| 2020 | 8,098,727 |
| 2021 | 9,513,529 |
| 2022 | 8,226,686 |
| 2023 | 10,499,833 |
| 2024 | 12,615,739 |
| 2025 | 12,239,102 |
| 2026 | 7,912,994 |

> The highest annual stocking total occurred in 2024, with 12.6 million fish stocked.

### Most Stocked Species

The five species with the highest total stocking quantities were:

1. Rainbow — 20,951,156
2. Walleye — 13,460,029
3. Kokanee — 11,245,328
4. Cutthroat — 9,303,045
5. Wiper — 4,131,187

### Top Waterbodies

The five waterbodies receiving the most fish were:

1. Willard Bay Res — 13,414,678
2. Strawberry Res — 7,567,208
3. Flaming Gorge Res — 6,766,105
4. Fish L — 4,293,896
5. Jordanelle Res — 2,371,790

### County Analysis

Duchesne County had the highest number of distinct stocked waterbodies with 256, followed by:

- Summit — 179
- Sanpete — 74
- Garfield — 67
- Utah — 59

---

## Data Quality Considerations

### "ALL TROUT"

The source data contains an `ALL TROUT` category, particularly in the earlier years.

This category was retained because it represents legitimate stocking activity. However, it was treated as an unspecified trout category rather than as a specific biological species.

For species-specific analysis, this distinction is important because `ALL TROUT` cannot reliably be attributed to Rainbow, Brown, Cutthroat, or other specific trout species.

### Waterbody Geographic Data

Additional waterbody information was explored using a Utah DWR ArcGIS REST endpoint. However, the waterbody data did not consistently match the naming conventions in the stocking dataset.

Because of the inconsistent matching, geographic coordinates were not used for the final Power BI dashboard.

Instead, the project uses county and waterbody-level analysis to maintain data accuracy.

---

## Power BI Dashboard

The final Power BI dashboard focuses on the most useful analytical results from the SQL analysis.

Potential dashboard elements include:

- Total fish stocked
- Fish stocked by year
- Fish stocked by species
- Top stocked waterbodies
- Stocking activity by county
- Year-over-year changes
- Interactive filters for year, county, species, and waterbody

> A map visualization was intentionally excluded because reliable geographic coordinates could not be consistently matched to the stocking records.

---

## Skills Demonstrated

This project demonstrates practical experience with:

`Python data extraction` · `Pandas` · `REST/API data collection` · `CSV data handling` · `Excel data cleaning` · `Relational database design` · `PostgreSQL` · `Primary and foreign keys` · `SQL JOINs` · `SUM()` · `AVG()` · `COUNT(DISTINCT)` · `GROUP BY` · `ORDER BY` · `LIMIT` · `CTEs` · `LAG()` · `RANK() OVER()` · `SUM() OVER()` · `PARTITION BY` · `CASE` · `HAVING` · `LEFT JOIN` · `Data quality analysis` · `Power BI dashboard development`

---

## Project Structure

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
└── README.md
```

---

## Author

**Jakob Bichsel**
*Data Analytics Portfolio Project*
