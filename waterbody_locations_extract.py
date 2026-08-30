import pandas as pd
import requests
import os

# Folder for the Utah Fish Project (relative to this script's location)
script_dir = os.path.dirname(os.path.abspath(__file__))
folder = os.path.join(script_dir, "..", "data", "raw")

# Make sure the folder exists
os.makedirs(folder, exist_ok=True)

# ArcGIS REST endpoint
url = "https://dwrmapserv.utah.gov/dwrarcgis/rest/services/Aquatics/Aquatics_Community_Fisheries/MapServer/0/query"

# Request all records as JSON
params = {
    "where": "1=1",
    "outFields": "*",
    "f": "json"
}

# Get the data
response = requests.get(url, params=params)

# Convert response to JSON
data = response.json()

# Extract the actual records
features = data["features"]

# Convert ArcGIS records into a DataFrame
rows = []

for feature in features:
    rows.append(feature["attributes"])

df = pd.DataFrame(rows)

# Save as CSV
output_file = os.path.join(
    folder,
    "community_fisheries_raw.csv"
)

df.to_csv(output_file, index=False)

print("")
print("======================================")
print("COMMUNITY FISHERIES DATA COMPLETE!")
print("======================================")
print(f"Records collected: {len(df)}")
print(f"Saved to: {output_file}")
print("")
print("Columns:")
print(df.columns.tolist())
print("")
print(df.head())
