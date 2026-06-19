# ============================================================
# ANALISI DEI BISOGNI INFORMATIVI SUI CANALI YOUTUBE
# Breaking Italy vs La Repubblica (playlist Recap)
# Tesi di Laurea Magistrale – Comunicazione, ICT e Media
# Università degli Studi di Torino
# ============================================================
#
# FLUSSO DI LAVORO:
#   1. Installazione e caricamento dei pacchetti
#   2. Raccolta dei commenti via YouTube API (pacchetto tuber)
#        ↓ export xlsx
#   3. [FASE ESTERNA] Classificazione dei commenti con ChatGPT
#        ↓ aggiunta colonna "userNeed" nei file xlsx
#   4. Preparazione e unione del dataset classificato
#   5. Analisi delle frequenze degli user need
#   6. Validazione della codifica (Krippendorff's alpha +
#      matrice di confusione)
#   7. Analisi dell'engagement (statistiche descrittive dei like)
# ============================================================


# ============================================================
# 1. INSTALLAZIONE E CARICAMENTO DEI PACCHETTI
# ============================================================

# Eseguire solo la prima volta:
install.packages(c(
  "tuber",      # interagire con le API di YouTube
  "writexl",    # esportare oggetti in xlsx
  "readxl",     # importare file xlsx
  "dplyr",      # operazioni di data manipulation
  "readr",      # lettura di file CSV
  "openxlsx",   # lettura/scrittura xlsx avanzata
  "tidyverse",  # insieme di pacchetti per data science
  "tidyr",      # pivot e riorganizzazione dati
  "irr",        # Krippendorff's alpha e altri indici di accordo
  "reshape2",   # manipolazioni dati (melt/dcast)
  "caret",      # matrice di confusione e metriche di performance
  "sjmisc"      # funzioni di utilità per scienze sociali
))

library(tuber)
library(writexl)
library(readxl)
library(dplyr)
library(readr)
library(openxlsx)
library(tidyverse)
library(tidyr)
library(irr)
library(reshape2)
library(caret)
library(sjmisc)


# ============================================================
# 2. RACCOLTA DATI – YouTube API via tuber
# ============================================================

# SICUREZZA: non inserire le credenziali direttamente nel codice.
# Aggiungere al file ~/.Renviron (aprirlo con usethis::edit_r_environ()):
#   YT_CLIENT_ID=<tuo_client_id>
#   YT_CLIENT_SECRET=<tuo_client_secret>
# Poi riavviare R. Le variabili vengono lette con Sys.getenv().

client_id     <- Sys.getenv("YT_CLIENT_ID")
client_secret <- Sys.getenv("YT_CLIENT_SECRET")

yt_oauth(
  app_id     = client_id,
  app_secret = client_secret,
  token      = ".httr-oauth"
)

# Colonne da conservare per ogni dataset
colonne_utili <- c("id", "videoId", "textOriginal",
                   "likeCount", "publishedAt", "updatedAt")

# ------- Siria -------
siriaBY  <- get_all_comments(video_id = "HQ-L806dm3U") %>% select(all_of(colonne_utili))
siriaREP <- get_all_comments(video_id = "13V3GMGiouo") %>% select(all_of(colonne_utili))

write_xlsx(siriaBY,  "siriaBY.xlsx")
write_xlsx(siriaREP, "siriaREP.xlsx")

# ------- Paragon -------
paragonBY  <- get_all_comments(video_id = "Dy6AXgvAMAI")  %>% select(all_of(colonne_utili))
paragonREP <- get_all_comments(video_id = "<3YozlBf4MIk>") %>% select(all_of(colonne_utili))

write_xlsx(paragonBY,  "paragonBY.xlsx")
write_xlsx(paragonREP, "paragonREP.xlsx")

# ------- Trump / Putin -------
trumpPutinBY  <- get_all_comments(video_id = "pOS_hJ5wAQM") %>% select(all_of(colonne_utili))
trumpPutinREP <- get_all_comments(video_id = "WTBAJE6G4W0") %>% select(all_of(colonne_utili))

write_xlsx(trumpPutinBY,  "trumpPutinBY.xlsx")
write_xlsx(trumpPutinREP, "trumpPutinREP.xlsx")

# ------- Elezioni Germania -------
elezioniGermaniaBY  <- get_all_comments(video_id = "l7lObhCURjE") %>% select(all_of(colonne_utili))
elezioniGermaniaREP <- get_all_comments(video_id = "ZY9KIq9Yoas") %>% select(all_of(colonne_utili))

write_xlsx(elezioniGermaniaBY,  "elezioniGermaniaBY.xlsx")
write_xlsx(elezioniGermaniaREP, "elezioniGermaniaREP.xlsx")

# ------- Dazi -------
daziBY  <- get_all_comments(video_id = "B8A1hYBgF4c") %>% select(all_of(colonne_utili))
daziREP <- get_all_comments(video_id = "8GioVCj6z8s") %>% select(all_of(colonne_utili))

write_xlsx(daziBY,  "daziBY.xlsx")
write_xlsx(daziREP, "daziREP.xlsx")


# ============================================================
# 3. PREPARAZIONE E UNIONE DEL DATASET
# ============================================================
# Dopo l'esportazione, i file xlsx sono stati aperti e la colonna
# "userNeed" è stata aggiunta da ChatGPT (operazione esterna a R).
# I file vengono ora re-importati con il prefisso X1_…X5_ che
# riflette il nome assegnato all'importazione in R.
# Adattare i percorsi ai nomi reali dei file classificati.
# ============================================================

X1_siriaBY          <- read_excel("siriaBY_classificato.xlsx")
X1_siriaREP         <- read_excel("siriaREP_classificato.xlsx")
X2_paragonBY        <- read_excel("paragonBY_classificato.xlsx")
X2_paragonREP       <- read_excel("paragonREP_classificato.xlsx")
X3_trumpPutinBY     <- read_excel("trumpPutinBY_classificato.xlsx")
X3_trumpPutinREP    <- read_excel("trumpPutinREP_classificato.xlsx")
X4_elezioniGermaniaBY  <- read_excel("elezioniGermaniaBY_classificato.xlsx")
X4_elezioniGermaniaREP <- read_excel("elezioniGermaniaREP_classificato.xlsx")
X5_daziBY           <- read_excel("daziBY_classificato.xlsx")
X5_daziREP          <- read_excel("daziREP_classificato.xlsx")

# Aggiunta delle colonne "autore" e "puntata"
X1_siriaBY$autore          <- "Breaking Italy"; X1_siriaBY$puntata          <- "Siria"
X1_siriaREP$autore         <- "Repubblica";     X1_siriaREP$puntata         <- "Siria"
X2_paragonBY$autore        <- "Breaking Italy"; X2_paragonBY$puntata        <- "Paragon"
X2_paragonREP$autore       <- "Repubblica";     X2_paragonREP$puntata       <- "Paragon"
X3_trumpPutinBY$autore     <- "Breaking Italy"; X3_trumpPutinBY$puntata     <- "trumpPutin"
X3_trumpPutinREP$autore    <- "Repubblica";     X3_trumpPutinREP$puntata    <- "trumpPutin"
X4_elezioniGermaniaBY$autore  <- "Breaking Italy"; X4_elezioniGermaniaBY$puntata  <- "elezioniGermania"
X4_elezioniGermaniaREP$autore <- "Repubblica";     X4_elezioniGermaniaREP$puntata <- "elezioniGermania"
X5_daziBY$autore           <- "Breaking Italy"; X5_daziBY$puntata           <- "Dazi"
X5_daziREP$autore          <- "Repubblica";     X5_daziREP$puntata          <- "Dazi"

# Conversione di likeCount in numerico per tutti i dataset
tutti_i_dataset <- list(
  X1_siriaBY, X1_siriaREP, X2_paragonBY, X2_paragonREP,
  X3_trumpPutinBY, X3_trumpPutinREP,
  X4_elezioniGermaniaBY, X4_elezioniGermaniaREP,
  X5_daziBY, X5_daziREP
)
nomi_dataset <- c(
  "X1_siriaBY", "X1_siriaREP", "X2_paragonBY", "X2_paragonREP",
  "X3_trumpPutinBY", "X3_trumpPutinREP",
  "X4_elezioniGermaniaBY", "X4_elezioniGermaniaREP",
  "X5_daziBY", "X5_daziREP"
)

tutti_i_dataset <- lapply(tutti_i_dataset, function(df) {
  df$likeCount <- as.numeric(df$likeCount)
  df
})
list2env(setNames(tutti_i_dataset, nomi_dataset), envir = .GlobalEnv)

# Unione in un unico dataframe
df_unito <- bind_rows(
  X1_siriaBY          = X1_siriaBY,
  X1_siriaREP         = X1_siriaREP,
  X2_paragonBY        = X2_paragonBY,
  X2_paragonREP       = X2_paragonREP,
  X3_trumpPutinBY     = X3_trumpPutinBY,
  X3_trumpPutinREP    = X3_trumpPutinREP,
  X4_elezioniGermaniaBY  = X4_elezioniGermaniaBY,
  X4_elezioniGermaniaREP = X4_elezioniGermaniaREP,
  X5_daziBY           = X5_daziBY,
  X5_daziREP          = X5_daziREP,
  .id = "origine"
)

write_xlsx(df_unito, "df_unito.xlsx")

# Estrazione campione casuale (n = 321) per la validazione manuale
set.seed(42)
campione <- df_unito[sample(nrow(df_unito), 321), ]
write_xlsx(campione, "campione_commenti_321.xlsx")


# ============================================================
# 4. ANALISI DELLE FREQUENZE
# ============================================================
# Da qui in poi si può lavorare direttamente sul file unito,
# senza dover rieseguire la raccolta dati.
# ============================================================

file_commenti <- read_csv(
  "df_unito.xlsx - Sheet1.csv",
  col_names = TRUE,
  trim_ws   = TRUE
)

# Ispezione preliminare
colnames(file_commenti)
table(file_commenti$origine)
table(file_commenti$userNeed)

# Correzione etichetta: "divert me" → "Divert me"
file_commenti$userNeed[file_commenti$userNeed == "divert me"] <- "Divert me"

# Tabella: distribuzione userNeed per puntata (origine)
file_commenti %>%
  group_by(origine, userNeed) %>%
  count() %>%
  pivot_wider(names_from = userNeed, values_from = n) %>%
  as.data.frame() %>%
  write_excel_csv2(file = "tabella_puntate_userneed.csv",
                   col_names = TRUE, delim = ";")

# Tabella: distribuzione userNeed per autore
file_commenti %>%
  group_by(autore, userNeed) %>%
  count() %>%
  pivot_wider(names_from = userNeed, values_from = n) %>%
  write_excel_csv2(file = "tabella_autore_userneed.csv",
                   col_names = TRUE, delim = ";")

# Conteggio totale commenti per autore
file_commenti %>%
  group_by(autore) %>%
  count()

# Distribuzione userNeed per la Repubblica
file_commenti %>%
  filter(autore == "Repubblica") %>%
  group_by(userNeed) %>%
  count()


# ============================================================
# 5. VALIDAZIONE DELLA CODIFICA
#    Confronto tra classificazione manuale e ChatGPT
# ============================================================

codifica_manuale <- read_csv(
  "campione_commenti_321_classificati_manualmente.xlsx - Sheet1.csv",
  col_names = TRUE,
  trim_ws   = TRUE
)

codifica_chatgpt <- read_csv(
  "campione_commenti_321_classificati_chatgpt.xlsx - Sheet1.csv",
  col_names = TRUE,
  trim_ws   = TRUE
)

# Unione sull'ID del commento
df_joined <- codifica_manuale %>%
  select(id, userNeed) %>%
  rename(manual = userNeed) %>%
  inner_join(
    codifica_chatgpt %>%
      select(id, userNeed) %>%
      rename(chatgpt = userNeed),
    by = "id"
  )

# ---------- Krippendorff's alpha (nominale) ----------
ratings <- t(as.matrix(df_joined[, c("manual", "chatgpt")]))
kripp.alpha(ratings, method = "nominal")

# ---------- Matrice di confusione (caret) ----------
df_joined$manual  <- factor(df_joined$manual)
df_joined$chatgpt <- factor(df_joined$chatgpt,
                             levels = levels(df_joined$manual))

confusionMatrix(df_joined$chatgpt, df_joined$manual)

conf_mat <- table(Manual = df_joined$manual,
                  Chatgpt = df_joined$chatgpt)
conf_df  <- as.data.frame(conf_mat)

# Heatmap: frequenze assolute
ggplot(conf_df, aes(x = Chatgpt, y = Manual, fill = Freq)) +
  geom_tile(color = "white") +
  geom_text(aes(label = Freq), size = 5) +
  scale_fill_gradient(low = "white", high = "steelblue") +
  labs(
    title = "Matrice di Confusione",
    x = "Etichette ChatGPT",
    y = "Etichette Manuali"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

# Heatmap: percentuali sul totale
conf_df$Perc <- conf_df$Freq / sum(conf_df$Freq) * 100

ggplot(conf_df, aes(x = Chatgpt, y = Manual, fill = Perc)) +
  geom_tile(color = "white") +
  geom_text(aes(label = sprintf("%.1f%%", Perc)), size = 5) +
  scale_fill_gradient(low = "white", high = "darkgreen") +
  labs(
    title = "Matrice di Confusione (%)",
    x = "Etichette ChatGPT",
    y = "Etichette Manuali"
  ) +
  theme_minimal()

# Heatmap: percentuali normalizzate per classe manuale
conf_mat_pct <- prop.table(conf_mat, margin = 2) * 100
conf_df_pct  <- as.data.frame(conf_mat_pct)
colnames(conf_df_pct) <- c("Manual", "Chatgpt", "Perc")

ggplot(conf_df_pct, aes(x = Chatgpt, y = Manual, fill = Perc)) +
  geom_tile(color = "white") +
  geom_text(aes(label = sprintf("%.1f%%", Perc)), size = 5) +
  scale_fill_gradient(low = "white", high = "steelblue") +
  labs(
    title = "Matrice di Confusione (% per classe manuale)",
    x = "Predizione ChatGPT",
    y = "Classe Manuale"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

# ---------- Precision, Recall, F1, Balanced Accuracy ----------
cm       <- confusionMatrix(df_joined$chatgpt, df_joined$manual)
by_class <- as.data.frame(cm$byClass)

# Gestione caso a due sole classi (cm$byClass restituisce un vettore)
if (is.null(rownames(by_class))) {
  by_class <- t(by_class)
  rownames(by_class) <- levels(df_joined$manual)
}

class_stats <- by_class %>%
  select(`Balanced Accuracy`, Precision, Recall, F1) %>%
  mutate(Class = rownames(by_class)) %>%
  relocate(Class)

class_stats

class_stats_long <- class_stats %>%
  pivot_longer(
    cols      = c("Balanced Accuracy", "Precision", "Recall", "F1"),
    names_to  = "Metric",
    values_to = "Value"
  )

ggplot(class_stats_long, aes(x = Class, y = Value, fill = Metric)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  labs(
    title = "Precision, Recall e F1 per Classe",
    y = "Valore",
    x = "Classe"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

# Tabelle di confronto etichette
table(df_joined$chatgpt)
table(df_joined$manual)
table(df_joined$manual, df_joined$chatgpt)

codifica_manuale %>%
  group_by(autore, userNeed) %>%
  count()

codifica_chatgpt %>%
  group_by(autore, userNeed) %>%
  count()


# ============================================================
# 6. ANALISI DELL'ENGAGEMENT – distribuzione dei like
# ============================================================

# Statistiche descrittive generali per user need
tabella_generale <- file_commenti %>%
  group_by(userNeed) %>%
  summarise(
    n            = n(),
    min_like     = min(likeCount),
    Q1           = quantile(likeCount, 0.25),
    media_like   = mean(likeCount),
    mediana_like = median(likeCount),
    Q3           = quantile(likeCount, 0.75),
    max_like     = max(likeCount)
  )

tabella_generale

# Statistiche per autore
tabella_autori <- file_commenti %>%
  group_by(autore, userNeed) %>%
  summarise(
    n            = n(),
    min_like     = min(likeCount),
    Q1           = quantile(likeCount, 0.25),
    media_like   = mean(likeCount),
    mediana_like = median(likeCount),
    Q3           = quantile(likeCount, 0.75),
    max_like     = max(likeCount)
  )

tabella_autori

# Statistiche per puntata (origine)
tabella_puntate <- file_commenti %>%
  group_by(origine, userNeed) %>%
  summarise(
    n            = n(),
    min_like     = min(likeCount),
    Q1           = quantile(likeCount, 0.25),
    media_like   = mean(likeCount),
    mediana_like = median(likeCount),
    Q3           = quantile(likeCount, 0.75),
    max_like     = max(likeCount)
  )

tabella_puntate

# Export delle tabelle di engagement
write_xlsx(tabella_generale, "engagement_userneed_generale.xlsx")
write_xlsx(tabella_autori,   "engagement_userneed_autori.xlsx")
write_xlsx(tabella_puntate,  "engagement_userneed_puntate.xlsx")
