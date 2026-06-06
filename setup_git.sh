#!/bin/bash
# setup_git.sh — Jednorázové nastavení git repozitáře
# Spusť jednou z terminálu: bash ~/Documents/Claude/setup_git.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "======================================"
echo "🔧 NASTAVENÍ GIT REPOZITÁŘE"
echo "======================================"

# 1. Inicializace git (pokud ještě není)
if [ ! -d "$SCRIPT_DIR/.git" ]; then
    echo "📁 Inicializuji git repozitář..."
    git init
    git branch -M main
else
    echo "ℹ️  Git repozitář již existuje."
fi

# 2. Nastavení uživatele (pokud není globálně nastaven)
if [ -z "$(git config --global user.name)" ]; then
    git config user.name "Pavel Hlousek"
    git config user.email "pavel.hlousek@me.com"
    echo "👤 Git uživatel nastaven."
fi

# 3. Přidat remote origin (pokud ještě není)
if git remote get-url origin &>/dev/null; then
    echo "ℹ️  Remote 'origin' již nastaven: $(git remote get-url origin)"
else
    git remote add origin https://github.com/pavelhlo/pavel-health.git
    echo "🔗 Remote nastaven na: https://github.com/pavelhlo/pavel-health.git"
fi

# 4. Vytvořit .gitignore
cat > .gitignore << 'EOF'
# Dočasné soubory
~$*
*.tmp
.DS_Store

# Citlivá data — nepushovat
*.key
*.pem
EOF
echo "📝 .gitignore vytvořen."

# 5. První commit pokud není žádná historie
if ! git log --oneline -1 &>/dev/null; then
    git add tlak_data.json sync_blood_pressure.py sync.sh .gitignore
    git commit -m "🚀 První commit: sync krevního tlaku"
    echo "✅ První commit vytvořen."
fi

echo ""
echo "======================================"
echo "✅ NASTAVENÍ HOTOVO!"
echo ""
echo "Nyní spusť:"
echo "  bash ~/Documents/Claude/sync.sh"
echo ""
echo "Pokud push selže kvůli přihlášení, GitHub"
echo "tě vyzve k zadání jména a Personal Access Tokenu."
echo "Token vytvoříš na: https://github.com/settings/tokens"
echo "  → Generate new token (classic)"
echo "  → Scope: repo (zaškrtnout)"
echo "======================================"
