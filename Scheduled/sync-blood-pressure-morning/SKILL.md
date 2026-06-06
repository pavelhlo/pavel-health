---
name: sync-blood-pressure-morning
description: Automaticky synchronizuje krevní tlak a pushuje na GitHub každé ráno v 8:00
---

Spusť shell script pro synchronizaci a push na GitHub:

```bash
/Users/pavel.hlousek/Documents/Claude/sync.sh
```

Tento script:
1. Spustí Python script pro čtení Excelu
2. Vygeneruje/aktualizuje tlak_data.json
3. Commitne a pushne na GitHub
4. Aplikace si pak JSON stáhne automaticky

Pokud se objeví chyba s Git přihlášením, zkontroluj jestli máš GitHub Desktop nebo SSH klíč nastavený.