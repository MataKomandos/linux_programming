#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Użycie: $0 <sciezka_do_katalogu>"
    exit 1
fi

KATALOG=$1
USUNIETE_PLIK_LICZNIK=0
SAFE_MODE=false
CZAS=$2
PLIK=$3

trap 'echo -e "\nKoniec. Usunięto plików: $USUNIETE_PLIK_LICZNIK"; exit' SIGINT

trap 'SAFE_MODE=$([ "$SAFE_MODE" = "false" ] && echo "true" || echo "false"); echo "Safe Mode: $SAFE_MODE"' SIGUSR1


echo "Monitorowanie katalogu: $KATALOG (Safe Mode: $SAFE_MODE)"

while true; do
    LICZBA_PLIKOW=$(ls -1 "$KATALOG" 2>/dev/null | wc -l)

    if [ "$LICZBA_PLIKOW" -gt $PLIK ]; then
        NAJSTARSZY=$(ls -rt "$KATALOG" | head -1)
        SCIEZKA="$KATALOG/$NAJSTARSZY"

        if [ "$SAFE_MODE" = "true" ]; then
            echo "[OSTRZEŻENIE] Przekroczono limit (5)! Safe Mode aktywny - nie usuwam: $NAJSTARSZY"
        else
            rm "$SCIEZKA"
            ((USUNIETE_PLIK_LICZNIK++))
            echo "$(date '+%Y-%m-%d %H:%M:%S') Usunięto: $NAJSTARSZY" >> report.log
            echo "Usunięto plik: $NAJSTARSZY"
        fi
    fi

    sleep $CZAS
done