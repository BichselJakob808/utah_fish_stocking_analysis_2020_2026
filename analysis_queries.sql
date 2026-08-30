/* =========================================================
   Utah Fish Stocking Analysis — SQL Queries
   =========================================================
   Part 1: Basic Analysis
   Part 2: Advanced Analysis (CTEs, window functions)
   ========================================================= */


/* =========================================================
   PART 1: BASIC ANALYSIS
   =========================================================
   1. Total fish stocked by year
   2. Total fish stocked by species (all-time)
   3. Top 10 waterbodies by total fish received
   4. Average length per stocking event, by species
   5. Number of distinct waterbodies stocked per county
   6. All rainbow trout stockings in Uintah county since 2020
   ========================================================= */


-----------------------------------------------------------
-- 1. Total fish stocked by year
-----------------------------------------------------------

SELECT
    SUM(quantity) AS total_stocked_fish,
    EXTRACT(YEAR FROM stock_date) AS year
FROM stocking
GROUP BY EXTRACT(YEAR FROM stock_date)
ORDER BY year DESC;

/* 2026 - 7,912,994
   2025 - 12,239,102
   2024 - 12,615,739
   2023 - 10,499,833
   2022 - 8,226,686
   2021 - 9,513,529
   2020 - 8,098,727
*/


-----------------------------------------------------------
-- 2. Total fish stocked by species (all-time)
-----------------------------------------------------------

SELECT
    species.common_name,
    SUM(quantity) AS total_stocked_fish
FROM stocking
JOIN species
    ON stocking.species_id = species.species_id
GROUP BY species.common_name
ORDER BY total_stocked_fish DESC;

/*
Rainbow - 20,951,156
Walleye - 13,460,029
Kokanee - 11,245,328
Cutthroat - 9,303,045
Wiper - 4,131,187
Tiger Trout - 2,187,029
Splake - 1,746,319
Brown Trout - 1,647,290
Brook Trout - 1,425,268
Channel Catfish - 741,596
Muskie Tiger - 457,404
Crappie Black - 398,315
Sunfish Bluegill - 299,262
Lake Trout - 242,598
Sucker - 235,710
Grayling Arctic - 202,656
Chub - 188,515
Cutbow CTBL*RTWV - 143,979
Bass Largemouth - 47,213
Crappie White - 41,292
Grass Carp Sterile - 5,024
All Trout - 3,555
Sucker Green - 1,476
Dace - 482
Bass White - 379
Bass Smallmouth - 244
Sculpin - 192
Flannelmouth Sucker - 67
*/


-----------------------------------------------------------
-- 3. Top 10 waterbodies by total fish received
-----------------------------------------------------------

SELECT
    waterbody.name,
    SUM(quantity) AS total_stocked_fish
FROM stocking
JOIN waterbody
    ON waterbody.waterbody_id = stocking.waterbody_id
GROUP BY waterbody.name
ORDER BY total_stocked_fish DESC
LIMIT 10;

/*
1. Willard Bay Res      - 13,414,678
2. Strawberry Res       - 7,567,208
3. Flaming Gorge Res    - 6,766,105
4. Fish L               - 4,293,896
5. Jordanelle Res       - 2,371,790
6. Otter Cr Res         - 2,023,332
7. Yuba Res (Sevier Brg)- 1,523,300
8. Starvation Res       - 1,513,810
9. Panguitch L          - 1,348,377
10. Deer Cr Res         - 1,115,281
*/


-----------------------------------------------------------
-- 4. Average length per stocking event, by species
-----------------------------------------------------------

SELECT
    species.common_name,
    ROUND(AVG(average_length)::numeric, 2) AS avg_length
FROM stocking
JOIN species
    ON species.species_id = stocking.species_id
GROUP BY species.common_name
ORDER BY avg_length DESC;

/*
1. Flannelmouth Sucker - 20.05 inches
2. Bass Smallmouth     - 11.56 inches
3. All Trout           - 11.50 inches
4. Channel Catfish     - 10.92 inches
5. Lake Trout          - 10.34 inches
6. Rainbow             - 10.14 inches
7. Sucker              - 8.80 inches
8. Chub                - 8.72 inches
9. Bass White           - 8.18 inches
10. Grass Carp Sterile - 7.96 inches
11. Sucker Green       - 7.25 inches
12. Tiger Trout        - 6.85 inches
13. Wiper              - 6.20 inches
14. Muskie Tiger       - 5.59 inches
15. Crappie Black      - 5.19 inches
16. Crappie White      - 4.96 inches
17. Cutbow CTBL*RTWV   - 4.47 inches
18. Brown Trout        - 4.39 inches
19. Cutthroat          - 4.34 inches
20. Sunfish Bluegill   - 3.90 inches
21. Bass Largemouth    - 3.81 inches
22. Brook Trout        - 3.33 inches
23. Splake             - 3.26 inches
24. Kokanee            - 3.15 inches
25. Sculpin            - 3.02 inches
26. Grayling Arctic    - 2.94 inches
27. Dace               - 2.53 inches
28. Walleye            - 1.19 inches
*/


-----------------------------------------------------------
-- 5. Number of distinct waterbodies stocked per county
-----------------------------------------------------------

SELECT
    county,
    COUNT(DISTINCT waterbody.name)
FROM stocking
JOIN waterbody
    ON waterbody.waterbody_id = stocking.waterbody_id
GROUP BY county
ORDER BY count DESC;

/*
1. Duchesne     - 256 distinct waterbodies
2. Summit       - 179 distinct waterbodies
3. Sanpete      - 74 distinct waterbodies
4. Garfield     - 67 distinct waterbodies
5. Utah         - 59 distinct waterbodies
6. Uintah       - 53 distinct waterbodies
7. Salt Lake    - 40 distinct waterbodies
8. Daggett      - 40 distinct waterbodies
9. Sevier       - 39 distinct waterbodies
10. Wayne       - 34 distinct waterbodies
11. Wasatch     - 24 distinct waterbodies
12. Iron        - 23 distinct waterbodies
13. Washington  - 17 distinct waterbodies
14. Beaver      - 17 distinct waterbodies
15. Box Elder   - 16 distinct waterbodies
16. San Juan    - 16 distinct waterbodies
17. Emery       - 15 distinct waterbodies
18. Weber       - 13 distinct waterbodies
19. Cache       - 13 distinct waterbodies
20. Davis       - 13 distinct waterbodies
21. Rich        - 9 distinct waterbodies
22. Grand       - 9 distinct waterbodies
23. Tooele      - 8 distinct waterbodies
24. Kane        - 8 distinct waterbodies
25. Millard     - 8 distinct waterbodies
26. Piute       - 8 distinct waterbodies
27. Carbon      - 7 distinct waterbodies
28. Juab        - 6 distinct waterbodies
29. Morgan      - 4 distinct waterbodies
*/


-----------------------------------------------------------
-- 6. All rainbow trout stockings in Uintah county since 2020
-----------------------------------------------------------

-- Initial query returned 200+ individual stock-date records for 2020-2026
SELECT
    species.common_name,
    waterbody.county,
    stocking.stock_date
FROM stocking
JOIN species
    ON species.species_id = stocking.species_id
JOIN waterbody
    ON waterbody.waterbody_id = stocking.waterbody_id
WHERE species.common_name = 'RAINBOW'
    AND waterbody.county = 'UINTAH'
    AND stocking.stock_date >= '2020-01-01';

-- Refined to summarize totals by year
SELECT
    EXTRACT(YEAR FROM stocking.stock_date) AS year,
    SUM(quantity) AS total_rainbows
FROM stocking
JOIN species
    ON species.species_id = stocking.species_id
JOIN waterbody
    ON waterbody.waterbody_id = stocking.waterbody_id
WHERE species.common_name = 'RAINBOW'
    AND waterbody.county = 'UINTAH'
    AND stocking.stock_date >= '2020-01-01'
GROUP BY EXTRACT(YEAR FROM stocking.stock_date)
ORDER BY year DESC;

/*
2026 - 19,919 Rainbow trout
2025 - 93,289 Rainbow trout
2024 - 78,183 Rainbow trout
2023 - 120,395 Rainbow trout
2022 - 132,688 Rainbow trout
2021 - 231,257 Rainbow trout
2020 - 112,487 Rainbow trout
*/



/* =========================================================
   PART 2: ADVANCED ANALYSIS
   =========================================================
   1. Year-over-year % change using LAG()
   2. Running total per waterbody per year (SUM() OVER PARTITION BY)
   3. Rank waterbodies within each county (RANK() OVER PARTITION BY)
   4. CTE comparing drought years (2020-2022) vs. other years
   5. Species diversity per waterbody
   6. Waterbodies stocked before 2022 but not since (anti-join)
   ========================================================= */


-----------------------------------------------------------
-- 1. Year-over-year % change in total fish stocked, using LAG()
-----------------------------------------------------------

WITH yearly_totals AS (
    SELECT
        SUM(quantity) AS total_fish,
        EXTRACT(YEAR FROM stock_date) AS year
    FROM stocking
    GROUP BY EXTRACT(YEAR FROM stock_date)
),
yearly_with_previous AS (
    SELECT
        year,
        total_fish,
        LAG(total_fish) OVER (ORDER BY year) AS previous_year
    FROM yearly_totals
)
SELECT
    year,
    total_fish,
    previous_year,
    ROUND(((total_fish - previous_year)::numeric / previous_year) * 100, 2) AS yoy_percent_change
FROM yearly_with_previous
ORDER BY year;

/*
2020 - N/A
2021 - +17.47%
2022 - -13.53%
2023 - +27.63%
2024 - +20.15%
2025 - -2.99%
2026 - -35.35%

2021: Fish stocking increased 17.47%
2022: Decreased 13.53%
2023: Increased 27.63%
2024: Increased 20.15%
2025: Slight decrease of 2.99%
2026: Large decrease of 35.35%
*/


-----------------------------------------------------------
-- 2. Running total of fish stocked per waterbody per year
--    (SUM() OVER PARTITION BY ... ORDER BY ...)
-----------------------------------------------------------

WITH waterbody_yearly_totals AS (
    SELECT
        waterbody.name,
        EXTRACT(YEAR FROM stocking.stock_date) AS year,
        SUM(stocking.quantity) AS total_fish
    FROM stocking
    JOIN waterbody
        ON waterbody.waterbody_id = stocking.waterbody_id
    GROUP BY
        waterbody.name,
        EXTRACT(YEAR FROM stocking.stock_date)
)
SELECT
    name,
    year,
    total_fish,
    SUM(total_fish) OVER (
        PARTITION BY name
        ORDER BY year
    ) AS running_total
FROM waterbody_yearly_totals
WHERE name = 'SALEM POND'
ORDER BY name, year;

/*
Result was 1000+ rows across all waterbodies; narrowed to Salem Pond for illustration.

Salem Pond — Running Total of Fish Stocked
Year   Fish Stocked   Running Total
2020   13,261         13,261
2021   19,253         32,514
2022   26,903         59,417
2023   27,524         86,941
2024   31,879         118,820
2025   31,201         150,021
2026   19,610         169,631

47% increase over 6 years
*/


-----------------------------------------------------------
-- 3. Rank waterbodies within each county by total fish received
--    (RANK() OVER PARTITION BY county ...)
-----------------------------------------------------------

WITH waterbody_totals AS (
    SELECT
        waterbody.county,
        waterbody.name,
        SUM(stocking.quantity) AS total_fish
    FROM stocking
    JOIN waterbody
        ON waterbody.waterbody_id = stocking.waterbody_id
    GROUP BY
        waterbody.county,
        waterbody.name
),
ranked_waterbodies AS (
    SELECT
        county,
        name,
        total_fish,
        RANK() OVER (
            PARTITION BY county
            ORDER BY total_fish DESC
        ) AS waterbody_rank
    FROM waterbody_totals
)
SELECT
    county,
    name,
    total_fish,
    waterbody_rank
FROM ranked_waterbodies
WHERE waterbody_rank = 1
ORDER BY total_fish DESC;

/* Full result set was 1000+ rows (all ranks, all counties);
   filtered to waterbody_rank = 1 to show each county's top performer.

Willard Bay Reservoir in Box Elder County was the highest-stocked county-leading
waterbody, receiving 13,414,678 fish from 2020 through 2026. Strawberry Reservoir
and Flaming Gorge Reservoir followed with 7,567,208 and 6,766,105 fish, respectively.
*/


-----------------------------------------------------------
-- 4. CTE comparing average fish per event in "drought years"
--    (2020-2022) vs. other years
-----------------------------------------------------------

WITH stocking_periods AS (
    SELECT
        CASE
            WHEN EXTRACT(YEAR FROM stock_date) BETWEEN 2020 AND 2022
                THEN 'Drought Years (2020-2022)'
            ELSE 'Other Years'
        END AS period,
        quantity
    FROM stocking
)
SELECT
    period,
    ROUND(AVG(quantity), 2) AS average_fish_per_event
FROM stocking_periods
GROUP BY period
ORDER BY period;

/*
Average fish stocked per event:
2020-2022 (Drought Years): 3,452
2023-2026 (Other Years):   4,600

Result: Stocking events averaged about 1,148 more fish per event
during 2023-2026 compared to the 2020-2022 period.
*/


-----------------------------------------------------------
-- 5. Species diversity per waterbody:
--    distinct species count / total stocking events
-----------------------------------------------------------

-- First pass (unfiltered) — waterbodies with only 1-2 events can score a
-- misleading 1.00, so the metric needed a minimum event threshold.
SELECT
    waterbody.name,
    COUNT(DISTINCT stocking.species_id) AS distinct_species,
    COUNT(*) AS total_stocking_events,
    ROUND(
        COUNT(DISTINCT stocking.species_id)::numeric / COUNT(*),
        4
    ) AS species_diversity
FROM stocking
JOIN waterbody
    ON waterbody.waterbody_id = stocking.waterbody_id
GROUP BY waterbody.name
ORDER BY species_diversity DESC
LIMIT 50;

-- Refined: require at least 5 stocking events, limit to top 15
SELECT
    waterbody.name,
    COUNT(DISTINCT stocking.species_id) AS distinct_species,
    COUNT(*) AS total_stocking_events,
    ROUND(
        COUNT(DISTINCT stocking.species_id)::numeric / COUNT(*),
        4
    ) AS species_diversity
FROM stocking
JOIN waterbody
    ON waterbody.waterbody_id = stocking.waterbody_id
GROUP BY waterbody.name
HAVING COUNT(*) >= 5
ORDER BY species_diversity DESC
LIMIT 15;

/*
Highest Diversity Score:
Red L GR-33: 4 distinct species across 6 stocking events
Diversity Score: 0.6667

Red L GR-33 had the highest species diversity score among qualifying waterbodies
(minimum 5 stocking events), representing 4 distinct species across 6 stocking events.
*/


-----------------------------------------------------------
-- 6. Waterbodies stocked before 2022 but not since
--    (anti-join using NOT EXISTS or LEFT JOIN ... WHERE NULL)
-----------------------------------------------------------

-- Version A: NOT EXISTS anti-join
SELECT DISTINCT
    waterbody.name,
    waterbody.county
FROM waterbody
JOIN stocking
    ON waterbody.waterbody_id = stocking.waterbody_id
WHERE stocking.stock_date < '2022-01-01'
    AND NOT EXISTS (
        SELECT 1
        FROM stocking
        WHERE stocking.waterbody_id = waterbody.waterbody_id
            AND stocking.stock_date >= '2022-01-01'
    )
ORDER BY waterbody.county, waterbody.name;

-- Version B: LEFT JOIN ... WHERE NULL anti-join (same result, different approach)
SELECT DISTINCT
    waterbody.name,
    waterbody.county
FROM waterbody
JOIN stocking
    ON waterbody.waterbody_id = stocking.waterbody_id
LEFT JOIN stocking AS recent_stocking
    ON waterbody.waterbody_id = recent_stocking.waterbody_id
    AND recent_stocking.stock_date >= '2022-01-01'
WHERE stocking.stock_date < '2022-01-01'
    AND recent_stocking.waterbody_id IS NULL
ORDER BY waterbody.county, waterbody.name;

/*
50 total waterbodies across 18 counties.
Most affected: Duchesne (10), Uintah (7), Daggett (6), Summit (6).

Both the NOT EXISTS and LEFT JOIN approaches returned identical results.
*/
