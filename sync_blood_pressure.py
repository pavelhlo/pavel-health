#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
SYNC BLOOD PRESSURE SCRIPT
Čte měření z Excelu a vytváří JSON pro aplikaci
Autor: Claude + Pavel
"""

import pandas as pd
import json
from datetime import datetime
import os

# ============================================================================
# KONFIGURACE
# ============================================================================

EXCEL_FILE = "Krevni_tlak_Pavel.xlsx"      # Tvůj Excel soubor
JSON_OUTPUT = "tlak_data.json"             # Výstupní JSON soubor
SHEET_NAME = "Denní log"                   # Název listu v Excelu

# ============================================================================
# FUNKCE NA ČTENÍ EXCELU
# ============================================================================

def nacti_excel():
    """
    Čte Excel soubor a vrací surová data
    """
    try:
        print(f"📖 Čtu Excel soubor: {EXCEL_FILE}")

        # Čti Excel - skip prvních 4 řádků (jsou tam headery)
        df = pd.read_excel(EXCEL_FILE, sheet_name=SHEET_NAME, skiprows=4)

        print(f"✅ Excel načten! Počet řádků: {len(df)}")
        return df

    except FileNotFoundError:
        print(f"❌ CHYBA: Soubor {EXCEL_FILE} nenalezen!")
        print(f"📍 Ujistí se, že soubor je v téže složce jako script.")
        return None
    except Exception as e:
        print(f"❌ CHYBA při čtení Excelu: {e}")
        return None


def zpracuj_data(df):
    """
    Parsuje Excel data a vytváří seznam měření
    """
    print(f"🔄 Zpracovávám data...")

    mereni = []

    # Procházej každý řádek v Excelu
    for idx, row in df.iterrows():
        # Vezmi datum (sloupec 0 = "Datum")
        datum = row.iloc[0]

        # Přeskoč řádky bez data
        if pd.isna(datum) or "2026" not in str(datum):
            continue

        # Vezmi hodnoty - sloupce odpovídají pozicím v Excelu:
        # Sloupec 7 = Ráno průměr Sys
        # Sloupec 8 = Ráno průměr Dia
        # Sloupec 16 = Večer průměr Sys
        # Sloupec 17 = Večer průměr Dia

        rano_sys = row.iloc[7]      # Ráno Systóla
        rano_dia = row.iloc[8]      # Ráno Diastóla
        rano_tep = row.iloc[9]      # Ráno Tep

        vcer_sys = row.iloc[17]     # Večer Systóla (OPRAVENO: bylo 16!)
        vcer_dia = row.iloc[18]     # Večer Diastóla (OPRAVENO: bylo 17!)
        vcer_tep = row.iloc[19]     # Večer Tep (OPRAVENO: bylo 18!)

        # Pokud máme alespoň jedno měření (ráno nebo večer)
        if not pd.isna(rano_sys) or not pd.isna(vcer_sys):
            # Vytvoř strukturu jednoho měření
            mereni_den = {
                "datum": str(datum),
                "rano": {
                    "sys": int(rano_sys) if not pd.isna(rano_sys) else None,
                    "dia": int(rano_dia) if not pd.isna(rano_dia) else None,
                    "tep": int(rano_tep) if not pd.isna(rano_tep) else None,
                },
                "vcer": {
                    "sys": int(vcer_sys) if not pd.isna(vcer_sys) else None,
                    "dia": int(vcer_dia) if not pd.isna(vcer_dia) else None,
                    "tep": int(vcer_tep) if not pd.isna(vcer_tep) else None,
                }
            }
            mereni.append(mereni_den)

    print(f"✅ Zpracováno {len(mereni)} měření")
    return mereni


def uloz_json(mereni):
    """
    Uloží měření do JSON souboru
    """
    try:
        print(f"💾 Ukládám do JSON: {JSON_OUTPUT}")

        # Vytvoř strukturu JSONu
        data = {
            "posledni_aktualizace": datetime.now().isoformat(),
            "pocet_mereni": len(mereni),
            "mereni": mereni
        }

        # Ulož JSON (s hezkou formátováním)
        with open(JSON_OUTPUT, "w", encoding="utf-8") as f:
            json.dump(data, f, ensure_ascii=False, indent=2)

        print(f"✅ JSON uložen! Soubor: {JSON_OUTPUT}")
        return True

    except Exception as e:
        print(f"❌ CHYBA při ukládání JSON: {e}")
        return False


# ============================================================================
# HLAVNÍ PROGRAM
# ============================================================================

def main():
    """Hlavní funkce - orchestruje celý proces"""

    print("\n" + "="*70)
    print("🩺 SYNCHRONIZACE KREVNÍHO TLAKU - PAVEL")
    print("="*70 + "\n")

    # 1. Čti Excel
    df = nacti_excel()
    if df is None:
        return False

    # 2. Zpracuj data
    mereni = zpracuj_data(df)
    if not mereni:
        print("⚠️  Žádná měření nenalezena!")
        return False

    # 3. Ulož JSON
    success = uloz_json(mereni)

    if success:
        print("\n" + "="*70)
        print("✅ SYNCHRONIZACE HOTOVA!")
        print("="*70)
        print(f"\n📊 Aplikace si teď čte: {JSON_OUTPUT}")
        print(f"📈 Máš {len(mereni)} měření k dispozici")
        return True
    else:
        print("\n❌ Synchronizace selhala!")
        return False


# ============================================================================
# SPUŠTĚNÍ
# ============================================================================

if __name__ == "__main__":
    main()
