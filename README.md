# Bisogni informativi e giornalismo digitale: testate native e tradizionali a confronto.
Analisi dei commenti YouTube per la classificazione dei bisogni informativi degli utenti, sviluppata come progetto empirico della tesi di laurea magistrale in Comunicazione, ICT e media (LM-59) all'Università degli Studi di Torino.

## Descrizione

Lo studio indaga i bisogni informativi degli utenti che commentano i video di due canali YouTube: **Breaking Italy**, testata nativa di piattaforma, e **La Repubblica** (playlist *Recap*), testata tradizionale o *legacy media*. Per classificare i 1933 commenti raccolti è stato adottato il modello degli **User Needs** di Dmitry Shishkin e SmartOcto (2021), che prevede otto categorie corrispondenti ad altrettanti bisogni informativi: *Update me*, *Keep me on trend*, *Educate me*, *Give me perspective*, *Divert me*, *Inspire me*, *Connect me*, *Help me*.

I commenti analizzati sono relativi a dieci video (cinque per canale) su cinque argomenti comuni: caduta di Assad in Siria, caso Paragon, trattative USA/Russia per l'Ucraina, elezioni in Germania, dazi commerciali USA.

## Domande di Ricerca

- **RQ1.** Quali sono le differenze e le analogie tra i bisogni informativi dei pubblici di una testata nativa di piattaforma e di una testata tradizionale?
- **RQ2.** Quali sono i bisogni informativi maggiormente condivisi dagli stessi utenti?

## Competenze Tecniche

- **Linguaggio e Stack:** R (tidyverse, dplyr, ggplot2, tidyr).
- **Raccolta Dati:** `tuber` per l'interfacciamento con la YouTube Data API v3; autenticazione OAuth e download massivo dei commenti con selezione delle colonne rilevanti.
- **Classificazione Assistita da IA:** Integrazione di ChatGPT come strumento di codifica automatica, con prompt strutturati per l'associazione di ogni commento a uno degli otto user need del modello.
- **Validazione della Codifica:** Calcolo del **Krippendorff's alpha** (`irr`) su un campione di 321 commenti riclassificati manualmente; analisi della matrice di confusione e calcolo di precision, recall, F1-score e balanced accuracy per classe (`caret`).
- **Analisi dell'Engagement:** Statistiche descrittive (media, mediana, quartili, minimo, massimo) del numero di like per ciascuna categoria di user need, disaggregate per autore e per puntata (`tidyverse`).
- **Visualizzazione:** Heatmap della matrice di confusione (frequenze assolute, percentuali sul totale e normalizzate per classe) e grafici a barre delle metriche di performance (`ggplot2`).
- **Export:** Esportazione automatizzata dei dataset e dei risultati in formato Excel e CSV (`writexl`, `readxl`, `readr`).

## Flusso di Lavoro dell'Analisi

1. **Raccolta dati (YouTube API):** Autenticazione OAuth tramite credenziali salvate in variabili d'ambiente (`.Renviron`); download dei commenti relativi ai dieci video target con il pacchetto `tuber`; selezione delle colonne utili (`id`, `textOriginal`, `likeCount`, `publishedAt`) ed esportazione in xlsx.
2. **Classificazione con ChatGPT (fase esterna):** Apertura dei file xlsx e aggiunta della colonna `userNeed` tramite ChatGPT, istruito a classificare ogni commento in base ai bisogni informativi del modello User Needs in base al bisogno che ha spinto l'utente a scriverlo.
3. **Preparazione e unione del dataset:** Re-importazione dei file classificati, aggiunta delle colonne `autore` e `puntata`, conversione di `likeCount` in numerico, unione in un unico dataframe con `bind_rows()` (colonna `.id = "origine"`) ed estrazione di un campione casuale stratificato (`set.seed(42)`, n = 321) per la validazione.
4. **Analisi delle frequenze:** Correzione di etichette non uniformi; tabelle di distribuzione degli user need per puntata e per autore con `pivot_wider()`, esportate in CSV.
5. **Validazione della codifica:** Confronto tra le etichette manuali e quelle assegnate da ChatGPT sul campione di 321 commenti con Krippendorff's alpha (metodo nominale); visualizzazione delle discrepanze con tre versioni della matrice di confusione (valori assoluti, percentuali sul totale, percentuali normalizzate per classe); calcolo di precision, recall, F1 e balanced accuracy per ciascuna categoria.
6. **Analisi dell'engagement:** Calcolo delle statistiche descrittive dei like per user need in tre livelli di disaggregazione — generale, per autore e per puntata — ed esportazione delle tabelle risultanti in xlsx.

## Principali Risultati

- **User need dominante:** *Give me perspective* è la categoria associata al maggior numero di commenti in nove video su dieci, per entrambi i canali, a conferma che gli utenti cercano contenuti che aiutino a formare un'opinione su argomenti complessi.
- **Analogie tra i canali:** L'ordine dei quattro user need più frequenti è identico per Breaking Italy e La Repubblica: *Give me perspective*, *Divert me*, *Connect me*, *Educate me*.
- **Differenze tra i pubblici:** *Give me perspective* supera il 50% dei commenti de La Repubblica (vs. ~39% di Breaking Italy); *Connect me* vale il 17% per Breaking Italy contro l'9% de La Repubblica, riflettendo la community affermata costruita attorno al canale dal 2011.
- **Engagement:** I commenti associati a *Help me* registrano la media di like più alta (12,5), nonostante rappresentino una delle categorie meno frequenti — segnale che le richieste pratiche rivolte alla community ottengono un alto riconoscimento tra gli utenti.
- **Performance della codifica automatica:** Le classi più performanti nella classificazione di ChatGPT sono *Give me perspective*, *Divert me* ed *Educate me*; le più problematiche *Help me* e *Keep me on trend*.

Ringrazio il professor Christopher Cepernich, relatore della tesi, e il professor Antonio Martella per il supporto metodologico e tecnico nello sviluppo del codice.
---

*Altri progetti di analisi dei dati:*
- [Analisi Statistica e Predittiva sul Palmer Penguins Dataset](https://github.com/alessio-cantoro/penguins-analysis-project)
- [I giornalisti italiani al "Breaking Italy Night"](https://github.com/alessio-cantoro/I-giornalisti-italiani-al-Breaking-Italy-Night)
