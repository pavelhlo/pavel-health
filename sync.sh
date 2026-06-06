#!/bin/bash

# Spusť Python script
python3 /Users/pavel.hlousek/Documents/Claude/sync_blood_pressure.py

# Pushni VŠECHNY změny na GitHub
cd /Users/pavel.hlousek/Documents/Claude
git add -A
git commit -m "Update: Blood pressure data sync - $(date '+%Y-%m-%d %H:%M')"
git push

echo "✅ Hotovo! Všechna data jsou na GitHubu"
