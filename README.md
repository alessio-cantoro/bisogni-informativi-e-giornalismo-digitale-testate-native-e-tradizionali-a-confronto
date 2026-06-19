# Bisogni informativi su YouTube: Breaking Italy vs La Repubblica

Questo repository contiene il codice R sviluppato per la tesi di laurea magistrale in **Comunicazione, ICT e Media** (LM-59) presso l'Università degli Studi di Torino.

## Descrizione

La ricerca analizza i bisogni informativi degli utenti che commentano i video di due canali YouTube: **Breaking Italy**, testata nativa di piattaforma, e **La Repubblica** (playlist *Recap*), testata tradizionale o *legacy media*. Per classificare i commenti si è adottato il modello degli **User Needs** di Dmitry Shishkin e SmartOcto (2021), che prevede otto categorie corrispondenti ad altrettanti bisogni informativi: *Update me*, *Keep me on trend*, *Educate me*, *Give me perspective*, *Divert me*, *Inspire me*, *Connect me*, *Help me*.

Sono stati raccolti e analizzati **1933 commenti** relativi a dieci video (cinque per canale), su cinque argomenti comuni: caduta di Assad in Siria, caso Paragon, trattative USA/Russia per l'Ucraina, elezioni in Germania, dazi commerciali USA.

## Struttura del file

Lo script `analisi_userneed_youtube.R` è organizzato in sei sezioni sequenziali:

| Sezione | Contenuto |
|---------|-----------|
| 1 | Installazione e caricamento dei pacchetti |
| 2 | Raccolta dei commenti via YouTube API (pacchetto `tuber`) |
| 3 | Preparazione e unione del dataset (dopo classificazione con ChatGPT) |
| 4 | Analisi delle frequenze degli user need per puntata e per autore |
| 5 | Validazione della codifica: Krippendorff's alpha e matrice di confusione |
| 6 | Analisi dell'engagement: statistiche descrittive dei like per user need |

> **Nota sul flusso di lavoro:** tra la sezione 2 e la sezione 3 è presente una fase esterna a R: i file `.xlsx` esportati sono stati aperti e la colonna `userNeed` è stata aggiunta tramite ChatGPT, che ha associato ciascun commento a uno degli otto bisogni informativi.

## Tecnologie e pacchetti utilizzati

- **R** / RStudio
- [`tuber`](https://cran.r-project.org/package=tuber) — raccolta commenti via YouTube Data API v3
- [`tidyverse`](https://www.tidyverse.org/) — manipolazione e visualizzazione dei dati
- [`irr`](https://cran.r-project.org/package=irr) — calcolo del Krippendorff's alpha
- [`caret`](https://cran.r-project.org/package=caret) — matrice di confusione e metriche di performance
- [`writexl`](https://cran.r-project.org/package=writexl) / [`readxl`](https://cran.r-project.org/package=readxl) — import/export file Excel

## Configurazione

Le credenziali per l'accesso alla YouTube Data API v3 non sono incluse nel codice. Per replicare la raccolta dati:

1. Creare un progetto nella [Google Cloud Console](https://console.cloud.google.com/) e abilitare la YouTube Data API v3.
2. Aggiungere le credenziali al file `~/.Renviron`:
```
YT_CLIENT_ID=<tuo_client_id>
YT_CLIENT_SECRET=<tuo_client_secret>
```
3. Riavviare R. Lo script legge le variabili con `Sys.getenv()`.

Aggiungere `.httr-oauth` al `.gitignore` per evitare di esporre il token di autenticazione.

## Riferimenti

- Shishkin, D., Tran, M., Loumeau, J., Murray, J. (2021). *User Needs Model 2.0*. SmartOcto & BBC.
- Ten Teije, S., Woudstra, A. (2023). *User Needs 2.0*. SmartOcto.

---

*Altri progetti di analisi dei dati:*
- [Analisi esplorativa del dataset Palmer Penguins](https://github.com/alessio-cantoro/penguins-analysis-project)
- [I giornalisti italiani al Breaking Italy Night](https://github.com/alessio-cantoro/I-giornalisti-italiani-al-Breaking-Italy-Night)
