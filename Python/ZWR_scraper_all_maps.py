import requests
from bs4 import BeautifulSoup
import json
import pandas as pd

# List of maps and their corresponding URLs and JSON <script> IDs
maps = {
    "Spaceland": {
        "url": "https://zwr.gg/leaderboards/iw/ee-speedrun/spaceland/",
        "script_id": "iw-spaceland-ee-speedrun-dc-all-cards-1-board"
    },
    "Rave": {
        "url": "https://zwr.gg/leaderboards/iw/ee-speedrun/rave-in-the-redwoods/",
        "script_id": "iw-rave-in-the-redwoods-ee-speedrun-dc-all-cards-1-board"
    },
    "Shaolin": {
        "url": "https://zwr.gg/leaderboards/iw/ee-speedrun/shaolin-shuffle/",
        "script_id": "iw-shaolin-shuffle-ee-speedrun-dc-all-cards-1-board"
    },    
    "Attack": {
        "url": "https://zwr.gg/leaderboards/iw/ee-speedrun/attack-of-the-radioactive-thing/",
        "script_id": "iw-attack-of-the-radioactive-thing-ee-speedrun-dc-all-cards-1-board"
    },
    "Beast": {
        "url": "https://zwr.gg/leaderboards/iw/ee-speedrun/beast-from-beyond/",
        "script_id": "iw-beast-from-beyond-ee-speedrun-dc-all-cards-1-board"
    }    
}

all_data = []

for map_name, info in maps.items():
    print(f"🌍 Scraping {map_name}...")
    response = requests.get(info["url"])
    soup = BeautifulSoup(response.text, 'html.parser')
    script_tag = soup.find('script', id=info["script_id"], type='application/json')
    if not script_tag:
        print(f"❌ Couldn't find JSON for {map_name}")
        continue

    data_json = json.loads(script_tag.string)

    for rank_group in data_json.values():
        for entry in rank_group:
            try:
                all_data.append({
                    "Player": entry["player1"]["name"],
                    "Time": entry["achieved"],
                    "Date": entry["added"],
                    "Platform": entry["platform"],
                    "Country": entry["player1"]["flag"],
                    "Map": map_name
                })
            except KeyError as e:
                print(f"⚠️ Skipping entry due to missing key: {e}")

# Create combined CSV
df = pd.DataFrame(all_data)
df.to_csv("zwr_combined_leaderboard.csv", index=False)
print(f"✅ Scraped {len(df)} records from {len(maps)} maps into zwr_combined_leaderboard.csv")
