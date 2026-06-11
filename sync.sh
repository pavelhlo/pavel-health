#!/bin/bash

python3 /Users/pavel.hlousek/Documents/Claude/sync_blood_pressure.py

cd /Users/pavel.hlousek/Documents/Claude
git add pavel_evening_ritual_v2.html tlak_data.json
git commit -m "UI Update: Add calendar view and day status tracking - $(date '+%Y-%m-%d %H:%M')"
git push origin main

echo "✅ Hotovo!"
