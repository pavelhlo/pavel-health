#!/bin/bash
# health_sync.sh — Kompletní sync krevního tlaku → GitHub
# Spouštěno přes macOS launchd každé ráno v 8:00

GITHUB_TOKEN="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"
REPO_DIR="/Users/pavel.hlousek/Documents/Claude"
LOG="$REPO_DIR/git_push.log"

log() { echo "$(date '+%Y-%m-%d %H:%M:%S') — $1" >> "$LOG"; }

log "=== Spouštím sync ==="
cd "$REPO_DIR" || { log "❌ Složka nenalezena"; exit 1; }

# 1. Generuj JSON z Excelu
log "📊 Generuji tlak_data.json..."
if python3 "$REPO_DIR/sync_blood_pressure.py" >> "$LOG" 2>&1; then
    log "✅ JSON vygenerován."
else
    log "❌ Python script selhal."
    exit 1
fi

# 2. Synchronizuj index.html
if [ -f "$REPO_DIR/pavel_evening_ritual_v2.html" ]; then
    cp "$REPO_DIR/pavel_evening_ritual_v2.html" "$REPO_DIR/index.html"
fi

# 3. Odstraň případné zbylé git lock soubory
rm -f .git/HEAD.lock .git/index.lock 2>/dev/null && log "🔓 Lock soubory odstraněny." || true

# 4. Git: přidej změny
git add tlak_data.json index.html pavel_evening_ritual_v2.html 2>> "$LOG"

# 5. Commitni jen pokud jsou změny
if git diff --cached --quiet; then
    log "ℹ️  Žádné změny — skip commitu."
    exit 0
fi

DATUM=$(date '+%Y-%m-%d %H:%M')
git commit -m "🩺 Aktualizace: $DATUM" >> "$LOG" 2>&1
log "📦 Commit vytvořen."

# 6. Push na GitHub
REMOTE_URL="https://pavelhlo:${GITHUB_TOKEN}@github.com/pavelhlo/pavel-health.git"
if git push "$REMOTE_URL" main >> "$LOG" 2>&1; then
    log "🚀 ✅ Push úspěšný — data jsou na GitHubu."
else
    log "❌ Push selhal. Zkontroluj git_push.log."
    exit 1
fi
