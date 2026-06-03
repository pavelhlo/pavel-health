#!/bin/bash
# sync.sh — Synchronizace krevního tlaku do GitHub
# Repozitář: https://github.com/pavelhlo/pavel-health

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "======================================"
echo "🩺 SYNC KREVNÍHO TLAKU → GITHUB"
echo "======================================"

# 1. Spustit Python script pro generování JSON
echo ""
echo "📊 Generuji tlak_data.json z Excelu..."
python3 "$SCRIPT_DIR/sync_blood_pressure.py"

# 2. Git: přidat změny
echo ""
echo "📦 Připravuji git commit..."
git -C "$SCRIPT_DIR" add tlak_data.json

# 3. Commitnout jen pokud jsou změny
if git -C "$SCRIPT_DIR" diff --cached --quiet; then
    echo "ℹ️  Žádné změny v tlak_data.json — skip commit."
else
    DATUM=$(date '+%Y-%m-%d %H:%M')
    git -C "$SCRIPT_DIR" commit -m "🩺 Aktualizace dat: $DATUM"
    echo "✅ Commit vytvořen."
fi

# 4. Push na GitHub
echo ""
echo "🚀 Pushuji na GitHub..."
git -C "$SCRIPT_DIR" push origin main

echo ""
echo "======================================"
echo "✅ HOTOVO! Data jsou na GitHubu."
echo "======================================"
