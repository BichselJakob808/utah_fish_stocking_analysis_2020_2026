import pandas as pd
import os

# Folder where we want to save the data (relative to this script's location)
script_dir = os.path.dirname(os.path.abspath(__file__))
folder = os.path.join(script_dir, "..", "data", "raw")

# Make sure the folder exists
os.makedirs(folder, exist_ok=True)

# Store each year's data here
all_data = []

# Collect data from 2020 through 2026
for year in range(2020, 2027):

    print(f"Getting data for {year}...")

    url = f"https://dwrapps.utah.gov/fishstocking/Fish?y={year}"

    try:
        # Read the first table on the webpage
        df = pd.read_html(url)[0]

        # Add the year
        df["Year"] = year

        # Add the data to our collection
        all_data.append(df)

        print(f"Success! {len(df)} records collected.")

    except Exception as e:
        print(f"ERROR getting {year}: {e}")


# Combine all seven years
final_df = pd.concat(all_data, ignore_index=True)

# Full path for the CSV
output_file = os.path.join(
    folder,
    "utah_fish_stocking_2020_2026.csv"
)

# Save the CSV
final_df.to_csv(output_file, index=False)

print("")
print("======================================")
print("DATA COLLECTION COMPLETE!")
print("======================================")
print(f"Total records: {len(final_df)}")
print(f"Saved to: {output_file}")
print("")
print("First 5 rows:")
print(final_df.head())
