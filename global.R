library(shiny)
library(shinyjs)
library(shinyFiles)
library(bslib)
library(SQMtools)
library(DT)
library(plotly)

# ── Watermelon logo (base64 encoded PNG) ──
WATERMELON_LOGO_B64 <- "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dh5CJEsjuN3AgDEGlDEAsNhRpftccsOo0aUWC19XO8PEh1RXaHojIxyqKvI80+nBYQe3G0UNVZXxLhRFJuqcTarT4TC5XY7SU7rhGcK4CZw5CgCAUcCfk9NJ57sgHn744fXr13dMX7ly5YQJE9olLliwYPfu3a3/5Djuxhtv/Pzzz7tasJXt27enpKS0TUlKSvJf4XaEhITMnj37d7/7ndfB70cfffTCCy90yWArBQUFOp3Oa/q777771Vdf+e/YGgyGhQsXPvTQQ/6f5C1bttxzzz0d019++eXbbrtNluXFixd//PHH9McBxe65557f//73ALB27dpFixb5Kn78+PFHH33Uq5Mjz/NPPfXU/fff35qSl5f3+OOP5+fne61nenr6m2++GeC3czGbyE/Bo0ePLlmyZOPGjZqm+a9wRkbGAw88MGvWLD9S7r8adXV1zz777KZNm7yWFUXx0Ucf/Z//+R//1egIYwwRGWM7T/9tct/5rs/WaBvXM2szdSnU6Ua7HV0OjpCTNld2RHSozToS1HijqEbH04goAACOZxwHPE+cdqZREEXGC8DzjOOBcFSvYwYjQ0SdLio21i3qhNGZ4uhMotf/vHaJdS7JgbuVaJp25MiRtimDBw++8sorOy2oqurhw4c7XiI6OrqdxnUDp9P5+eefT5s2bfv27edoqlMYY//+97+vueaa//73v/4fYABwuVz//ve/p02blpWV1b3LybJ87733Llu2jHYImhiI39PmzZvnzp3rVeMAQFXVv/zlL63vgO++++6GG27wpXEAcPTo0ZtuuqnjunzHil3MJvKFpmmvvfba3Llz169f36nGAUBOTs7DDz983333Wa3WblwuJydnxowZvjQOAGRZ/vvf/+55M3UJj840u5oJx4FLow47eFqVMSSAegKUaYwNCjfc4my8zoC9QnU0IgpDjER2o6qAIqMqc5YGYm/mFAndLpTcIEmoyKgpxOVCyYWMMZer7swZqbaGP7DX8dEH8rGcn9eE3fmUuby8PIfD0a5sx+IdB7Z5eXlOp7PjJc7jxFxTU9ODDz7odZXjfEEpXbRo0eLFizt9etvS0NBw2223bdiwoRtXfO6553bu3NmNggCQk5OzaNEiWZb9Z/voo482btx46NChhx56yO12+89cW1v7xBNP+FHYi99EXlFV9d57733jjTc6vh788913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"

# \u2500\u2500 Load COG/KEGG category files from SqueezeMeta data dir \u2500\u2500
.find_sqm_data_file <- function(fname) {
  candidates <- c()

  # 1. Active conda environment (works when launched from conda env)
  conda_prefix <- Sys.getenv("CONDA_PREFIX")
  if (nchar(conda_prefix) > 0)
    candidates <- c(candidates,
      file.path(conda_prefix, "SqueezeMeta", "data", fname),
      file.path(dirname(conda_prefix), "SqueezeMeta", "data", fname))

  # 2. Search all conda envs for all users (works when launched by shiny/root)
  conda_roots <- c(
    file.path(Sys.getenv("HOME"), "miniconda3", "envs"),
    file.path(Sys.getenv("HOME"), "anaconda3", "envs"),
    file.path(Sys.getenv("HOME"), "mambaforge", "envs"),
    file.path(Sys.getenv("HOME"), "miniforge3", "envs"),
    "/opt/miniconda3/envs", "/opt/anaconda3/envs", "/opt/conda/envs"
  )
  # Also scan home directories of real users
  user_homes <- tryCatch(
    list.dirs(c("/home", "/root"), recursive = FALSE, full.names = TRUE),
    error = function(e) character(0))
  for (h in user_homes)
    conda_roots <- c(conda_roots,
      file.path(h, "miniconda3", "envs"),
      file.path(h, "anaconda3", "envs"),
      file.path(h, "mambaforge", "envs"),
      file.path(h, "miniforge3", "envs"))

  for (root in conda_roots[dir.exists(conda_roots)]) {
    envs <- list.dirs(root, recursive = FALSE, full.names = TRUE)
    for (env in envs)
      candidates <- c(candidates,
        file.path(env, "SqueezeMeta", "data", fname))
  }

  found <- candidates[file.exists(candidates)]
  if (length(found) > 0) found[1] else NULL
}

.load_cog_categories <- function() {
  f <- .find_sqm_data_file("coglist.txt")
  if (is.null(f)) return(NULL)
  raw <- readLines(f, warn=FALSE)
  raw <- raw[!grepl("^#", raw) & nchar(trimws(raw)) > 0]
  parts <- strsplit(raw, "\t", fixed=TRUE)
  # Vectorised expand: one row per id-category pair
  ids  <- sapply(parts, function(x) if(length(x)>=1) trimws(x[1]) else NA_character_)
  cats <- sapply(parts, function(x) if(length(x)>=3) trimws(x[3]) else NA_character_)
  # Split multi-category entries
  has_pipe <- grepl("|", cats, fixed=TRUE)
  if (any(has_pipe)) {
    single <- data.frame(id=ids[!has_pipe], category=cats[!has_pipe], stringsAsFactors=FALSE)
    multi_cats <- strsplit(cats[has_pipe], "|", fixed=TRUE)
    multi_ids  <- rep(ids[has_pipe], lengths(multi_cats))
    multi_cats <- trimws(unlist(multi_cats))
    multi <- data.frame(id=multi_ids, category=multi_cats, stringsAsFactors=FALSE)
    df <- rbind(single, multi)
  } else {
    df <- data.frame(id=ids, category=cats, stringsAsFactors=FALSE)
  }
  df[!is.na(df$id) & !is.na(df$category) & nchar(trimws(df$category))>0, ]
}

.load_kegg_categories <- function() {
  f <- .find_sqm_data_file("keggfun2.txt")
  if (is.null(f)) return(NULL)
  raw <- readLines(f, warn=FALSE)
  raw <- raw[!grepl("^#", raw) & nchar(trimws(raw)) > 0]
  parts <- strsplit(raw, "\t", fixed=TRUE)
  ok <- lengths(parts) >= 4
  parts <- parts[ok]
  ids      <- sapply(parts, function(x) trimws(x[1]))
  cat_strs <- sapply(parts, function(x) trimws(x[4]))
  # Split by | to get individual pathway entries per KO
  entries  <- strsplit(cat_strs, "|", fixed=TRUE)
  rep_ids  <- rep(ids, lengths(entries))
  entries  <- trimws(unlist(entries))
  # Split each entry by ; to get hierarchy levels
  lvls <- strsplit(entries, ";", fixed=TRUE)
  l1 <- trimws(sapply(lvls, function(x) if(length(x)>=1) x[1] else NA_character_))
  l2 <- trimws(sapply(lvls, function(x) if(length(x)>=2) x[2] else NA_character_))
  l3 <- trimws(sapply(lvls, function(x) if(length(x)>=3) x[3] else NA_character_))
  data.frame(id=rep_ids, l1=l1, l2=l2, l3=l3, stringsAsFactors=FALSE)
}

COG_CATEGORIES  <- .load_cog_categories()
KEGG_CATEGORIES <- .load_kegg_categories()
KEGG_L1_SHOW <- c("Cellular Processes", "Environmental Information Processing",
                  "Genetic Information Processing", "Metabolism")
message("COG_CATEGORIES: ", if(is.null(COG_CATEGORIES)) "NOT FOUND" else paste(nrow(COG_CATEGORIES),"rows"))
message("KEGG_CATEGORIES: ", if(is.null(KEGG_CATEGORIES)) "NOT FOUND" else paste(nrow(KEGG_CATEGORIES),"rows"))

`%||%` <- function(a, b) if (!is.null(a)) a else b

# Helper: sidebar label with a hover tooltip info icon
# tip: plain string, OR named character vector (names=labels, values=descriptions) -> bullet list
help_label <- function(label, tip, style="margin-top:4px;") {
  if (is.character(tip) && length(tip) > 1 && !is.null(names(tip))) {
    bullets <- paste(mapply(function(nm, desc) paste0("\u2022 ", nm, ": ", desc), names(tip), tip), collapse="\n")
    tip_txt  <- paste0("Type of abundance measurement:\n", bullets)
  } else {
    tip_txt <- tip
  }
  tags$div(class="form-label", style=style,
    label,
    tags$span(
      style=paste0("display:inline-block; margin-left:4px; cursor:help;",
                   "color:var(--muted); font-size:0.78rem; vertical-align:middle;"),
      title=tip_txt, "\u24d8"
    )
  )
}

# Standard count type descriptions
.count_descs <- c(
  "Raw abundances"  = "Number of occurrences",
  "Base counts"     = "Accumulated length in bases",
  "Percentages"     = "Relative abundance as percentage of total",
  "CPM"             = "Normalized abundance per million reads",
  "TPM"             = "Normalized abundance per length and per million reads",
  "Copy number"     = "Number of different instances of the feature"
)
# Build a count type tooltip from a named vector of choices
.count_tip <- function(choices) {
  # choices: named vector as passed to selectInput (names=labels, values=ids)
  label_map <- c(
    abund        = "Raw abundances",
    bases        = "Base counts",
    percent      = "Percentages",
    cpm          = "CPM",
    tpm          = "TPM",
    copy_number  = "Copy number",
    percent_full = "Percentages",
    percent_sel  = "Percentages (selection)",
    tpm_full     = "TPM",
    tpm_sel      = "TPM (selection)"
  )
  ids    <- unname(choices)
  labels <- names(choices)
  # For each choice, get description
  descs <- sapply(seq_along(ids), function(i) {
    lbl <- label_map[ids[i]]
    if (is.na(lbl)) lbl <- labels[i]
    desc <- .count_descs[lbl]
    if (is.na(desc)) "" else desc
  })
  names(descs) <- labels
  descs[descs != ""]
}
# \u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500
#  LIGHT THEME
# \u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500
sqm_theme <- bs_theme(
  version      = 5,
  bg           = "#f7f9fc",
  fg           = "#1a2a3a",
  primary      = "#1a6eb5",
  secondary    = "#e8eef5",
  success      = "#1a9e6e",
  info         = "#3b9ede",
  font_scale   = 0.92,
  base_font    = font_google("IBM Plex Sans"),
  heading_font = font_google("IBM Plex Mono")
)
# \u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500
#  CSS
# \u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500
custom_css <- "
@import url('https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;600&family=IBM+Plex+Sans:wght@300;400;500&display=swap');
:root {
  --blue:   #1a6eb5;
  --teal:   #1a9e6e;
  --bg:     #f7f9fc;
  --panel:  #eef2f7;
  --card:   #ffffff;
  --border: #d0dae6;
  --muted:  #7a90a8;
  --text:   #1a2a3a;
}
body { background: var(--bg); color: var(--text); }
.navbar {
  background: #ffffff !important;
  border-bottom: 3px solid #1a6eb5 !important;
  padding: 0.75rem 1.5rem 0.75rem 0.75rem !important;
  min-height: 64px !important;
}
.navbar-brand {
  font-family: 'IBM Plex Mono', monospace !important;
  font-weight: 600;
  color: #1a2a3a !important;
  letter-spacing: 0.05em;
  font-size: 1.1rem;
  padding-left: 0 !important;
  margin-left: 0 !important;
}
.nav-link { color: rgba(26,42,58,0.55) !important; font-size: 1.05rem; padding: 0.6rem 0.9rem !important; }
.nav-link:hover { color: #1a6eb5 !important; }
.nav-link.active { color: #1a6eb5 !important; border-bottom: 2px solid #1a6eb5; font-weight: 500; }
.card {
  background: var(--card) !important;
  border: 1px solid var(--border) !important;
  border-radius: 8px !important;
  box-shadow: 0 1px 4px rgba(26,42,58,0.07) !important;
}
.card-header {
  background: var(--panel) !important;
  border-bottom: 1px solid var(--border) !important;
  font-family: 'IBM Plex Mono', monospace;
  font-size: 0.78rem;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: var(--blue) !important;
  padding: 0.6rem 1rem !important;
}
.bslib-sidebar-layout > .sidebar {
  background: var(--panel) !important;
  border-right: 1px solid var(--border) !important;
}
.form-control, .form-select {
  background: #ffffff !important;
  border: 1px solid var(--border) !important;
  color: var(--text) !important;
  font-size: 0.85rem !important;
}
.form-control:focus, .form-select:focus {
  border-color: var(--blue) !important;
  box-shadow: 0 0 0 2px rgba(26,110,181,0.12) !important;
}
.form-label {
  font-size: 0.78rem;
  color: var(--muted);
  text-transform: uppercase;
  letter-spacing: 0.05em;
  margin-bottom: 3px;
}
.btn-primary {
  background: var(--blue) !important;
  border-color: var(--blue) !important;
  color: #ffffff !important;
  font-weight: 600;
  font-size: 0.82rem;
  letter-spacing: 0.04em;
}
.btn-primary:hover { background: #1558a0 !important; }
.btn-primary.mv-stale {
  background: transparent !important;
  border: 2px solid #c0392b !important;
  box-shadow: 0 0 0 1px rgba(192,57,43,0.4) !important;
  color: #c0392b !important;
}
.btn-primary.mv-stale::after {
  content: ' ↻';
  font-size: 0.9em;
}
.btn-outline-secondary {
  border-color: var(--border) !important;
  color: var(--muted) !important;
  font-size: 0.82rem;
  background: #ffffff !important;
}
.btn-outline-secondary:hover {
  border-color: var(--blue) !important;
  color: var(--blue) !important;
}
.project-badge {
  display: inline-block;
  background: rgba(26,110,181,0.08);
  border: 1px solid rgba(26,110,181,0.25);
  color: var(--blue);
  border-radius: 4px;
  padding: 2px 8px;
  font-size: 0.75rem;
  font-family: 'IBM Plex Mono', monospace;
  margin: 2px;
}
.section-divider {
  border: none;
  border-top: 1px solid var(--border);
  margin: 10px 0;
}
.path-info {
  font-size: 0.72rem;
  color: var(--muted);
  word-break: break-all;
  font-family: 'IBM Plex Mono', monospace;
  margin-bottom: 6px;
}
.dataTables_wrapper { color: var(--text) !important; }
table.dataTable { background: #ffffff !important; color: var(--text) !important; }
table.dataTable thead th {
  background: var(--panel) !important;
  color: var(--blue) !important;
  border-bottom: 1px solid var(--border) !important;
  font-family: 'IBM Plex Mono', monospace;
  font-size: 0.75rem;
  letter-spacing: 0.05em;
}
table.dataTable tbody tr:hover { background: #eef5fc !important; }
.dataTables_filter input, .dataTables_length select {
  background: #ffffff !important;
  border: 1px solid var(--border) !important;
  color: var(--text) !important;
}
.dataTables_info, .dataTables_paginate { color: var(--muted) !important; font-size: 0.8rem; }
.paginate_button.current {
  background: var(--blue) !important;
  color: #ffffff !important;
  border-radius: 4px;
}
.btn-default {
  background: #ffffff !important;
  border: 1px solid var(--border) !important;
  color: var(--muted) !important;
  font-size: 0.82rem !important;
}
.btn-default:hover { border-color: var(--blue) !important; color: var(--blue) !important; }
.func-search-box { position: relative; }
.func-search-box .search-icon {
  position: absolute; left: 8px; top: 50%; transform: translateY(-50%);
  color: var(--muted); font-size: 0.8rem; pointer-events: none; z-index: 10;
}
.func-search-box .form-control { padding-left: 26px !important; }
.func-search-hint { font-size: 0.7rem; color: var(--muted); margin-top: 3px; line-height: 1.4; }
.func-match-badge {
  display: inline-block; background: rgba(26,158,110,0.1); border: 1px solid rgba(26,158,110,0.3);
  color: #1a9e6e; border-radius: 4px; padding: 1px 7px; font-size: 0.72rem;
  font-family: 'IBM Plex Mono', monospace; margin-top: 4px;
}
.func-nomatch-badge {
  display: inline-block; background: rgba(192,57,43,0.08); border: 1px solid rgba(192,57,43,0.25);
  color: #c0392b; border-radius: 4px; padding: 1px 7px; font-size: 0.72rem;
  font-family: 'IBM Plex Mono', monospace; margin-top: 4px;
}
.sqm-section { background: var(--card); border: 1px solid var(--border); border-radius: 8px; overflow: hidden; margin-bottom: 12px; }
.sqm-section-header {
  background: var(--panel); border-bottom: 1px solid var(--border); padding: 7px 14px;
  font-family: 'IBM Plex Mono', monospace; font-size: 0.72rem; font-weight: 600;
  letter-spacing: 0.09em; text-transform: uppercase; color: var(--blue);
}
.sqm-section-body { padding: 10px 14px; }
.sqm-table { width: 100%; border-collapse: collapse; font-size: 0.8rem; }
.sqm-table thead th {
  background: var(--panel); color: var(--blue); font-family: 'IBM Plex Mono', monospace;
  font-size: 0.72rem; letter-spacing: 0.05em; padding: 5px 10px;
  border-bottom: 1px solid var(--border); text-align: right;
}
.sqm-table thead th:first-child { text-align: left; }
.sqm-table tbody td {
  padding: 5px 10px; border-bottom: 1px solid rgba(208,218,230,0.4);
  color: var(--text); text-align: right;
}
.sqm-table tbody td:first-child { text-align: left; color: var(--muted); font-size: 0.78rem; }
.sqm-table tbody tr:last-child td { border-bottom: none; }
.sqm-table tbody tr:hover td { background: #eef5fc; }
.sqm-subsection-label {
  font-size: 0.7rem; color: var(--muted); text-transform: uppercase;
  letter-spacing: 0.06em; margin: 10px 0 5px; padding-left: 2px;
}
.sidebar-box { border: 1px solid var(--border); border-radius: 5px; padding: 7px 9px 6px; margin-bottom: 5px; }
.sidebar-box .form-label { margin-top: 0 !important; font-size: 0.72rem !important; }
.sidebar-box .form-select, .sidebar-box select, .sidebar-box input[type=text] {
  font-size: 0.78rem !important; height: 27px !important; padding: 2px 6px !important;
}
.sidebar-box .func-search-hint { font-size: 0.68rem !important; margin-top: 2px !important; line-height: 1.3 !important; }
.sidebar-box .func-match-badge, .sidebar-box .func-nomatch-badge { font-size: 0.68rem !important; padding: 1px 6px !important; }
.sidebar-box .shiny-input-container { margin-bottom: 0 !important; }
.bslib-sidebar-layout > .sidebar .form-select, .bslib-sidebar-layout > .sidebar select {
  font-size: 0.75rem !important; padding-top: 2px !important; padding-bottom: 2px !important;
  height: 26px !important; font-family: 'IBM Plex Sans', sans-serif !important;
}
.bslib-sidebar-layout > .sidebar .form-label { margin-bottom: 0px !important; margin-top: 5px !important; line-height: 1.2 !important; }
.bslib-sidebar-layout > .sidebar .shiny-input-container:has(input[type=checkbox]) { min-height: unset !important; margin-bottom: 0 !important; padding: 0 !important; }
.bslib-sidebar-layout > .sidebar .shiny-input-container:has(input[type=checkbox]) .checkbox { margin: 0 !important; }
.bslib-sidebar-layout > .sidebar .shiny-input-container:has(input[type=checkbox]) label { font-size: 0.72rem !important; line-height: 1.6 !important; }
.bslib-sidebar-layout > .sidebar { padding: 0.5rem 0.6rem !important; }
.bslib-sidebar-layout > .sidebar .shiny-input-container { margin-bottom: 0 !important; padding-bottom: 0 !important; }
.bslib-sidebar-layout > .sidebar .form-group { margin-bottom: 0 !important; }
.bslib-sidebar-layout > .sidebar .form-label, .bslib-sidebar-layout > .sidebar label { margin-bottom: 1px !important; margin-top: 5px !important; display: block; }
.bslib-sidebar-layout > .sidebar select, .bslib-sidebar-layout > .sidebar input[type=number], .bslib-sidebar-layout > .sidebar input[type=text] {
  margin-bottom: 0 !important; padding-top: 2px !important; padding-bottom: 2px !important; height: 28px !important;
}
.bslib-sidebar-layout > .sidebar .shiny-input-container:has(input[type=checkbox]) { min-height: unset !important; margin-bottom: 0 !important; padding: 0 !important; line-height: 1.4 !important; }
.bslib-sidebar-layout > .sidebar .shiny-input-container:has(input[type=checkbox]) .checkbox { margin-top: 0 !important; margin-bottom: 0 !important; }
.bslib-sidebar-layout > .sidebar hr { margin: 4px 0 !important; }
.bslib-sidebar-layout > .sidebar .btn { margin-top: 4px !important; }
.bslib-sidebar-layout > .sidebar .func-search-hint { margin-top: 1px !important; margin-bottom: 0 !important; }
.bslib-sidebar-layout > .sidebar .func-match-badge, .bslib-sidebar-layout > .sidebar .func-nomatch-badge { margin-top: 2px !important; margin-bottom: 0 !important; }
::-webkit-scrollbar { width: 5px; height: 5px; }
::-webkit-scrollbar-track { background: var(--bg); }
::-webkit-scrollbar-thumb { background: var(--border); border-radius: 3px; }
::-webkit-scrollbar-thumb:hover { background: var(--blue); }

/* ── Launcher tab ──────────────────────────────────────────────── */
#launcher-log-container {
  background: #1e1e2e;
  color: #cdd6f4;
  padding: 12px;
  font-family: 'IBM Plex Mono', monospace;
  font-size: 12px;
  height: 520px;
  overflow-y: auto;
  border-radius: 6px;
  border: 1px solid var(--border);
}
#launcher-cmd-preview {
  background: #1e1e2e;
  color: #a6e3a1;
  padding: 10px 12px;
  font-family: 'IBM Plex Mono', monospace;
  font-size: 11px;
  border-radius: 6px;
  border: 1px solid #313244;
  white-space: pre-wrap;
  word-break: break-all;
  min-height: 36px;
  margin-top: 4px;
}
.launcher-file-path {
  font-size: 0.72rem;
  color: var(--muted);
  font-family: 'IBM Plex Mono', monospace;
  word-break: break-all;
  margin: 2px 0 6px 0;
}
.launcher-status-idle     { background-color: var(--muted)   !important; }
.launcher-status-running  { background-color: var(--blue)    !important; }
.launcher-status-finished { background-color: var(--teal)    !important; }
.launcher-status-error    { background-color: #c0392b        !important; }
.launcher-status-aborted  { background-color: #d68910        !important; }
#launcher-run-bar { display:flex; gap:6px; margin-top:8px; }
"
build_func_pattern <- function(search_text) {
  search_text <- trimws(search_text)
  if (nchar(search_text) == 0) return(NULL)
  terms <- trimws(unlist(strsplit(search_text, "[,;]+")))
  terms <- terms[nchar(terms) > 0]
  if (length(terms) == 0) return(NULL)
  escaped <- gsub("([.+*?^${}()|\\[\\]\\\\])", "\\\\\\1", terms)
  paste(escaped, collapse = "|")
}
available_func_counts <- function(proj, fun_level) {
  all_counts <- c(
    "Raw abundances" = "abund",   "Percentages" = "percent",
    "Base counts"    = "bases",   "CPM"             = "cpm",
    "TPM"            = "tpm",     "Copy number"    = "copy_number"
  )
  Filter(function(ct) {
    tbl <- tryCatch(proj$functions[[fun_level]][[ct]], error = function(e) NULL)
    !is.null(tbl) && (is.matrix(tbl) || is.data.frame(tbl)) && nrow(tbl) > 0
  }, all_counts)
}
available_tax_counts <- function(proj) {
  all_counts <- c("Percentages" = "percent", "Raw abundances" = "abund")
  Filter(function(ct) {
    tbl <- tryCatch(proj$taxa$phylum[[ct]], error = function(e) NULL)
    !is.null(tbl) && (is.matrix(tbl) || is.data.frame(tbl)) && nrow(tbl) > 0
  }, all_counts)
}
has_data <- function(tbl) {
  !is.null(tbl) && (is.matrix(tbl) || is.data.frame(tbl)) && nrow(tbl) > 0
}
available_plot_types <- function(proj) {
  choices <- c()

  # Taxonomy
  has_tax <- any(sapply(c("phylum","class","order","family","genus","species"), function(r)
    tryCatch(has_data(proj$taxa[[r]]$percent), error = function(e) FALSE)
  ))
  if (has_tax) choices <- c(choices, "Taxonomy (barplot)" = "taxonomy_bar", "Taxonomy (heatmap)" = "taxonomy_heatmap")

  # Functions: COG, KEGG, PFAM, and any extra databases
  all_dbs <- tryCatch(names(proj$functions), error = function(e) character(0))
  for (db in all_dbs) {
    tbl <- tryCatch(proj$functions[[db]]$abund, error = function(e) NULL)
    if (has_data(tbl)) {
      choices <- c(choices, setNames(paste0("func_", tolower(db)), db))
      # Add COG functional classes if COG_CATEGORIES is available
      if (toupper(db) == "COG" && !is.null(COG_CATEGORIES) && nrow(COG_CATEGORIES) > 0)
        choices <- c(choices, "COG (functional classes)" = "cog_class")
      if (toupper(db) == "KEGG" && !is.null(KEGG_CATEGORIES) && nrow(KEGG_CATEGORIES) > 0)
        choices <- c(choices, "KEGG (functional classes)" = "kegg_class")
    }
  }

  # Bins
  has_bins <- tryCatch(has_data(proj$bins$table), error = function(e) FALSE)
  if (has_bins) choices <- c(choices, "MAGs" = "bins")

  if (length(choices) == 0) choices <- c("(no data)" = "none")
  choices
}
available_tax_ranks <- function(proj) {
  all_ranks <- c("Phylum"="phylum","Class"="class","Order"="order",
                 "Family"="family","Genus"="genus","Species"="species")
  Filter(function(r)
    tryCatch(has_data(proj$taxa[[r]]$percent), error = function(e) FALSE),
    all_ranks)
}
avail_assembly <- function(proj) {
  ch <- c()
  if (tryCatch(has_data(proj$contigs$table), error = function(e) FALSE)) ch <- c(ch, "Contigs" = "contigs")
  if (tryCatch(has_data(proj$orfs$table),    error = function(e) FALSE)) ch <- c(ch, "ORFs"     = "orfs")
  ch
}
avail_taxonomy <- function(proj) {
  ranks <- c("superkingdom","phylum","class","order","family","genus","species")
  ch <- c()
  for (r in ranks) {
    tbl <- tryCatch(proj$taxa[[r]]$abund, error = function(e) NULL)
    if (has_data(tbl)) ch <- c(ch, setNames(paste0("tax_",r), tools::toTitleCase(r)))
  }
  ch
}
avail_functions <- function(proj) {
  dbs <- tryCatch(names(proj$functions), error = function(e) character(0))
  ch <- c()
  for (db in dbs) {
    tbl <- tryCatch(proj$functions[[db]]$abund, error = function(e) NULL)
    if (has_data(tbl)) ch <- c(ch, setNames(paste0("fun_",tolower(db)), db))
  }
  ch
}
avail_bins <- function(proj) {
  tbl <- tryCatch(proj$bins$table, error = function(e) NULL)
  if (has_data(tbl)) c("Bins" = "bins") else c()
}
# Resolve a DB name from a lowercased selector value to the actual key in proj$functions
# e.g. "greening" -> "Greening", "cog" -> "COG", "kegg" -> "KEGG"
resolve_db_name <- function(proj, db_lower) {
  dbs <- tryCatch(names(proj$functions), error = function(e) character(0))
  match <- dbs[tolower(dbs) == tolower(db_lower)]
  if (length(match) > 0) match[[1]] else toupper(db_lower)
}
avail_tax_metrics <- function(proj, rank) {
  all_m <- c("Percentages" = "percent",
             "Raw abundances" = "abund")
  Filter(function(m) tryCatch(has_data(proj$taxa[[rank]][[m]]), error=function(e) FALSE), all_m)
}
avail_fun_metrics <- function(proj, db) {
  all_m <- c("Raw abundances" = "abund",
             "Percentages"    = "percent",
             "Base counts"    = "bases",
             "CPM"            = "cpm",
             "TPM"            = "tpm",
             "Copy number"    = "copy_number")
  Filter(function(m) tryCatch(has_data(proj$functions[[db]][[m]]), error=function(e) FALSE), all_m)
}
  c(
    "2-Oxocarboxylic acid metabolism [01210]" = "01210",
    "ABC transporters [02010]" = "02010",
    "AMPK signaling pathway [04152]" = "04152",
    "Acarbose and validamycin biosynthesis [00525]" = "00525",
    "Acridone alkaloid biosynthesis [01058]" = "01058",
    "Acute myeloid leukemia [05221]" = "05221",
    "Adherens junction [04520]" = "04520",
    "Adipocytokine signaling pathway [04920]" = "04920",
    "Adrenergic signaling in cardiomyocytes [04261]" = "04261",
    "African trypanosomiasis [05143]" = "05143",
    "Alanine, aspartate and glutamate metabolism [00250]" = "00250",
    "Alcoholism [05034]" = "05034",
    "Aldosterone-regulated sodium reabsorption [04960]" = "04960",
    "Allograft rejection [05330]" = "05330",
    "Alzheimer disease [05010]" = "05010",
    "Amino sugar and nucleotide sugar metabolism [00520]" = "00520",
    "Aminoacyl-tRNA biosynthesis [00970]" = "00970",
    "Aminobenzoate degradation [00627]" = "00627",
    "Amoebiasis [05146]" = "05146",
    "Amphetamine addiction [05031]" = "05031",
    "Amyotrophic lateral sclerosis [05014]" = "05014",
    "Antigen processing and presentation [04612]" = "04612",
    "Apelin signaling pathway [04371]" = "04371",
    "Apoptosis [04210]" = "04210",
    "Apoptosis - fly [04214]" = "04214",
    "Apoptosis - multiple species [04215]" = "04215",
    "Arabinogalactan biosynthesis - Mycobacterium [00572]" = "00572",
    "Arachidonic acid metabolism [00590]" = "00590",
    "Arginine and proline metabolism [00330]" = "00330",
    "Arginine biosynthesis [00220]" = "00220",
    "Arrhythmogenic right ventricular cardiomyopathy [05412]" = "05412",
    "Ascorbate and aldarate metabolism [00053]" = "00053",
    "Asthma [05310]" = "05310",
    "Atrazine degradation [00791]" = "00791",
    "Autoimmune thyroid disease [05320]" = "05320",
    "Autophagy - animal [04140]" = "04140",
    "Autophagy - other [04136]" = "04136",
    "Autophagy - yeast [04138]" = "04138",
    "Axon guidance [04360]" = "04360",
    "B cell receptor signaling pathway [04662]" = "04662",
    "Bacterial invasion of epithelial cells [05100]" = "05100",
    "Bacterial secretion system [03070]" = "03070",
    "Basal cell carcinoma [05217]" = "05217",
    "Basal transcription factors [03022]" = "03022",
    "Base excision repair [03410]" = "03410",
    "Benzoate degradation [00362]" = "00362",
    "Bile secretion [04976]" = "04976",
    "Biofilm formation - Escherichia coli [05112]" = "05112",
    "Biofilm formation - Pseudomonas aeruginosa [05113]" = "05113",
    "Biofilm formation - Vibrio cholerae [05111]" = "05111",
    "Biosynthesis of 12-, 14- and 16-membered macrolides [00522]" = "00522",
    "Biosynthesis of alkaloids derived from histidine and purine [01065]" = "01065",
    "Biosynthesis of alkaloids derived from ornithine, lysine and nicotinic acid [01064]" = "01064",
    "Biosynthesis of alkaloids derived from shikimate pathway [01063]" = "01063",
    "Biosynthesis of alkaloids derived from terpenoid and polyketide [01066]" = "01066",
    "Biosynthesis of amino acids [01230]" = "01230",
    "Biosynthesis of ansamycins [01051]" = "01051",
    "Biosynthesis of cofactors [01240]" = "01240",
    "Biosynthesis of enediyne antibiotics [01059]" = "01059",
    "Biosynthesis of nucleotide sugars [01250]" = "01250",
    "Biosynthesis of phenylpropanoids [01061]" = "01061",
    "Biosynthesis of plant hormones [01070]" = "01070",
    "Biosynthesis of plant secondary metabolites [01060]" = "01060",
    "Biosynthesis of secondary metabolites [01110]" = "01110",
    "Biosynthesis of siderophore group nonribosomal peptides [01053]" = "01053",
    "Biosynthesis of terpenoids and steroids [01062]" = "01062",
    "Biosynthesis of type II polyketide backbone [01056]" = "01056",
    "Biosynthesis of type II polyketide products [01057]" = "01057",
    "Biosynthesis of unsaturated fatty acids [01040]" = "01040",
    "Biosynthesis of vancomycin group antibiotics [01055]" = "01055",
    "Biotin metabolism [00780]" = "00780",
    "Bisphenol degradation [00363]" = "00363",
    "Bladder cancer [05219]" = "05219",
    "Brassinosteroid biosynthesis [00905]" = "00905",
    "Breast cancer [05224]" = "05224",
    "Butanoate metabolism [00650]" = "00650",
    "C-type lectin receptor signaling pathway [04625]" = "04625",
    "C5-Branched dibasic acid metabolism [00660]" = "00660",
    "Caffeine metabolism [00232]" = "00232",
    "Calcium signaling pathway [04020]" = "04020",
    "Cannabinoid addiction [05035]" = "05035",
    "Caprolactam degradation [00930]" = "00930",
    "Carbapenem biosynthesis [00332]" = "00332",
    "Carbohydrate digestion and absorption [04973]" = "04973",
    "Carbon fixation in photosynthetic organisms [00710]" = "00710",
    "Carbon fixation pathways in prokaryotes [00720]" = "00720",
    "Carbon metabolism [01200]" = "01200",
    "Cardiac muscle contraction [04260]" = "04260",
    "Carotenoid biosynthesis [00906]" = "00906",
    "Cell adhesion molecules [04514]" = "04514",
    "Cell cycle [04110]" = "04110",
    "Cell cycle - Caulobacter [04112]" = "04112",
    "Cell cycle - yeast [04111]" = "04111",
    "Cellular senescence [04218]" = "04218",
    "Central carbon metabolism in cancer [05230]" = "05230",
    "Chagas disease [05142]" = "05142",
    "Chemical carcinogenesis - DNA adducts [05204]" = "05204",
    "Chemical carcinogenesis - reactive oxygen species [05208]" = "05208",
    "Chemical carcinogenesis - receptor activation [05207]" = "05207",
    "Chemokine signaling pathway [04062]" = "04062",
    "Chloroalkane and chloroalkene degradation [00625]" = "00625",
    "Chlorocyclohexane and chlorobenzene degradation [00361]" = "00361",
    "Cholesterol metabolism [04979]" = "04979",
    "Choline metabolism in cancer [05231]" = "05231",
    "Cholinergic synapse [04725]" = "04725",
    "Chronic myeloid leukemia [05220]" = "05220",
    "Circadian entrainment [04713]" = "04713",
    "Circadian rhythm [04710]" = "04710",
    "Circadian rhythm - fly [04711]" = "04711",
    "Circadian rhythm - plant [04712]" = "04712",
    "Citrate cycle (TCA cycle) [00020]" = "00020",
    "Clavulanic acid biosynthesis [00331]" = "00331",
    "Cocaine addiction [05030]" = "05030",
    "Collecting duct acid secretion [04966]" = "04966",
    "Colorectal cancer [05210]" = "05210",
    "Complement and coagulation cascades [04610]" = "04610",
    "Coronavirus disease - COVID-19 [05171]" = "05171",
    "Cutin, suberine and wax biosynthesis [00073]" = "00073",
    "Cyanoamino acid metabolism [00460]" = "00460",
    "Cysteine and methionine metabolism [00270]" = "00270",
    "Cytokine-cytokine receptor interaction [04060]" = "04060",
    "Cytosolic DNA-sensing pathway [04623]" = "04623",
    "D-Alanine metabolism [00473]" = "00473",
    "D-Arginine and D-ornithine metabolism [00472]" = "00472",
    "D-Glutamine and D-glutamate metabolism [00471]" = "00471",
    "DNA replication [03030]" = "03030",
    "Degradation of aromatic compounds [01220]" = "01220",
    "Diabetic cardiomyopathy [05415]" = "05415",
    "Dilated cardiomyopathy [05414]" = "05414",
    "Dioxin degradation [00621]" = "00621",
    "Diterpenoid biosynthesis [00904]" = "00904",
    "Dopaminergic synapse [04728]" = "04728",
    "ECM-receptor interaction [04512]" = "04512",
    "Endocrine and other factor-regulated calcium reabsorption [04961]" = "04961",
    "Endocytosis [04144]" = "04144",
    "Endometrial cancer [05213]" = "05213",
    "Epithelial cell signaling in Helicobacter pylori infection [05120]" = "05120",
    "Epstein-Barr virus infection [05169]" = "05169",
    "ErbB signaling pathway [04012]" = "04012",
    "Ether lipid metabolism [00565]" = "00565",
    "Ethylbenzene degradation [00642]" = "00642",
    "Exopolysaccharide biosynthesis [00543]" = "00543",
    "Fanconi anemia pathway [03460]" = "03460",
    "Fat digestion and absorption [04975]" = "04975",
    "Fatty acid biosynthesis [00061]" = "00061",
    "Fatty acid degradation [00071]" = "00071",
    "Fatty acid elongation [00062]" = "00062",
    "Fatty acid metabolism [01212]" = "01212",
    "Fc epsilon RI signaling pathway [04664]" = "04664",
    "Fc gamma R-mediated phagocytosis [04666]" = "04666",
    "Ferroptosis [04216]" = "04216",
    "Ferroptosis [04716]" = "04716",
    "Fluid shear stress and atherosclerosis [05418]" = "05418",
    "Fluorobenzoate degradation [00364]" = "00364",
    "Focal adhesion [04510]" = "04510",
    "Folate biosynthesis [00790]" = "00790",
    "FoxO signaling pathway [04068]" = "04068",
    "Fructose and mannose metabolism [00051]" = "00051",
    "GABAergic synapse [04727]" = "04727",
    "Galactose metabolism [00052]" = "00052",
    "Gap junction [04540]" = "04540",
    "Gastric acid secretion [04971]" = "04971",
    "Gastric cancer [05226]" = "05226",
    "Geraniol degradation [00281]" = "00281",
    "Glioma [05214]" = "05214",
    "Glutamatergic synapse [04724]" = "04724",
    "Glutathione metabolism [00480]" = "00480",
    "Glycerolipid metabolism [00561]" = "00561",
    "Glycerophospholipid metabolism [00564]" = "00564",
    "Glycine, serine and threonine metabolism [00260]" = "00260",
    "Glycolysis / Gluconeogenesis [00010]" = "00010",
    "Glycosaminoglycan biosynthesis - chondroitin sulfate / dermatan sulfate [00532]" = "00532",
    "Glycosaminoglycan biosynthesis - heparan sulfate / heparin [00534]" = "00534",
    "Glycosaminoglycan biosynthesis - keratan sulfate [00533]" = "00533",
    "Glycosaminoglycan degradation [00531]" = "00531",
    "Glycosphingolipid biosynthesis - ganglio series [00604]" = "00604",
    "Glycosphingolipid biosynthesis - globo and isoglobo series [00603]" = "00603",
    "Glycosphingolipid biosynthesis - lacto and neolacto series [00601]" = "00601",
    "Glycosylphosphatidylinositol (GPI)-anchor biosynthesis [00563]" = "00563",
    "Glyoxylate and dicarboxylate metabolism [00630]" = "00630",
    "Graft-versus-host disease [05332]" = "05332",
    "HIF-1 signaling pathway [04066]" = "04066",
    "Hedgehog signaling pathway [04340]" = "04340",
    "Hedgehog signaling pathway - fly [04341]" = "04341",
    "Hematopoietic cell lineage [04640]" = "04640",
    "Hepatitis B [05161]" = "05161",
    "Hepatitis C [05160]" = "05160",
    "Hepatocellular carcinoma [05225]" = "05225",
    "Herpes simplex virus 1 infection [05168]" = "05168",
    "Hippo signaling pathway [04390]" = "04390",
    "Hippo signaling pathway - fly [04391]" = "04391",
    "Hippo signaling pathway - multiple species [04392]" = "04392",
    "Histidine metabolism [00340]" = "00340",
    "Homologous recombination [03440]" = "03440",
    "Human T-cell leukemia virus 1 infection [05166]" = "05166",
    "Human cytomegalovirus infection [05163]" = "05163",
    "Human immunodeficiency virus 1 infection [05170]" = "05170",
    "Human papillomavirus infection [05165]" = "05165",
    "Huntington disease [05016]" = "05016",
    "Hypertrophic cardiomyopathy [05410]" = "05410",
    "IL-17 signaling pathway [04657]" = "04657",
    "Inflammatory bowel disease [05321]" = "05321",
    "Inflammatory mediator regulation of TRP channels [04750]" = "04750",
    "Influenza A [05164]" = "05164",
    "Inositol phosphate metabolism [00562]" = "00562",
    "Insect hormone biosynthesis [00981]" = "00981",
    "Insulin signaling pathway [04910]" = "04910",
    "JAK-STAT signaling pathway [04630]" = "04630",
    "Kaposi sarcoma-associated herpesvirus infection [05167]" = "05167",
    "Legionellosis [05134]" = "05134",
    "Leishmaniasis [05140]" = "05140",
    "Leishmaniasis [05148]" = "05148",
    "Leukocyte transendothelial migration [04670]" = "04670",
    "Limonene and pinene degradation [00903]" = "00903",
    "Linoleic acid metabolism [00591]" = "00591",
    "Lipoarabinomannan (LAM) biosynthesis [00571]" = "00571",
    "Lipoic acid metabolism [00785]" = "00785",
    "Lipopolysaccharide biosynthesis [00540]" = "00540",
    "Long-term depression [04730]" = "04730",
    "Long-term potentiation [04720]" = "04720",
    "Longevity regulating pathway [04211]" = "04211",
    "Longevity regulating pathway - multiple species [04213]" = "04213",
    "Longevity regulating pathway - worm [04212]" = "04212",
    "Lysine biosynthesis [00300]" = "00300",
    "Lysine degradation [00310]" = "00310",
    "Lysosome [04142]" = "04142",
    "MAPK signaling pathway [04010]" = "04010",
    "MAPK signaling pathway - fly [04013]" = "04013",
    "MAPK signaling pathway - plant [04016]" = "04016",
    "MAPK signaling pathway - yeast [04011]" = "04011",
    "Malaria [05144]" = "05144",
    "Mannose type O-glycan biosynthesis [00515]" = "00515",
    "Maturity onset diabetes of the young [04950]" = "04950",
    "Measles [05162]" = "05162",
    "Meiosis - yeast [04113]" = "04113",
    "Melanoma [05218]" = "05218",
    "Metabolic pathways [01100]" = "01100",
    "Methane metabolism [00680]" = "00680",
    "MicroRNAs in cancer [05206]" = "05206",
    "Microbial metabolism in diverse environments [01120]" = "01120",
    "Mineral absorption [04978]" = "04978",
    "Mismatch repair [03430]" = "03430",
    "Mitophagy - animal [04137]" = "04137",
    "Mitophagy - yeast [04139]" = "04139",
    "Monobactam biosynthesis [00261]" = "00261",
    "Monoterpenoid biosynthesis [00902]" = "00902",
    "Morphine addiction [05032]" = "05032",
    "Mucin type O-glycan biosynthesis [00512]" = "00512",
    "N-Glycan biosynthesis [00510]" = "00510",
    "NF-kappa B signaling pathway [04064]" = "04064",
    "NOD-like receptor signaling pathway [04621]" = "04621",
    "Naphthalene degradation [00626]" = "00626",
    "Natural killer cell mediated cytotoxicity [04650]" = "04650",
    "Necroptosis [04217]" = "04217",
    "Neomycin, kanamycin and gentamicin biosynthesis [00524]" = "00524",
    "Neuroactive ligand-receptor interaction [04080]" = "04080",
    "Neurotrophin signaling pathway [04722]" = "04722",
    "Nicotinate and nicotinamide metabolism [00760]" = "00760",
    "Nicotine addiction [05033]" = "05033",
    "Nitrogen metabolism [00910]" = "00910",
    "Nitrotoluene degradation [00633]" = "00633",
    "Non-homologous end-joining [03450]" = "03450",
    "Non-small cell lung cancer [05223]" = "05223",
    "Nonribosomal peptide structures [01054]" = "01054",
    "Notch signaling pathway [04330]" = "04330",
    "Novobiocin biosynthesis [00401]" = "00401",
    "Nucleocytoplasmic transport [03013]" = "03013",
    "Nucleotide excision repair [03420]" = "03420",
    "Nucleotide metabolism [01232]" = "01232",
    "O-Antigen nucleotide sugar biosynthesis [00541]" = "00541",
    "O-Antigen repeat unit biosynthesis [00542]" = "00542",
    "Olfactory transduction [04740]" = "04740",
    "One carbon pool by folate [00670]" = "00670",
    "Oocyte meiosis [04114]" = "04114",
    "Osteoclast differentiation [04380]" = "04380",
    "Other types of O-glycan biosynthesis [00514]" = "00514",
    "Oxidative phosphorylation [00190]" = "00190",
    "PD-L1 expression and PD-1 checkpoint pathway in cancer [05235]" = "05235",
    "PI3K-Akt signaling pathway [04151]" = "04151",
    "PPAR signaling pathway [03320]" = "03320",
    "Pancreatic cancer [05212]" = "05212",
    "Pancreatic secretion [04972]" = "04972",
    "Pantothenate and CoA biosynthesis [00770]" = "00770",
    "Parasite infection [05114]" = "05114",
    "Parkinson disease [05012]" = "05012",
    "Pathogenic Escherichia coli infection [05130]" = "05130",
    "Pathways in cancer [05200]" = "05200",
    "Pathways of neurodegeneration - multiple diseases [05022]" = "05022",
    "Penicillin and cephalosporin biosynthesis [00311]" = "00311",
    "Pentose and glucuronate interconversions [00040]" = "00040",
    "Pentose phosphate pathway [00030]" = "00030",
    "Peptidoglycan biosynthesis [00550]" = "00550",
    "Peroxisome [04146]" = "04146",
    "Pertussis [05133]" = "05133",
    "Phagosome [04145]" = "04145",
    "Phenylalanine metabolism [00360]" = "00360",
    "Phenylalanine, tyrosine and tryptophan biosynthesis [00400]" = "00400",
    "Phosphatidylinositol signaling system [04070]" = "04070",
    "Phospholipase D signaling pathway [04072]" = "04072",
    "Phosphonate and phosphinate metabolism [00440]" = "00440",
    "Phosphotransferase system (PTS) [02060]" = "02060",
    "Photosynthesis [00195]" = "00195",
    "Photosynthesis - antenna proteins [00196]" = "00196",
    "Phototransduction [04744]" = "04744",
    "Phototransduction - fly [04745]" = "04745",
    "Plant hormone signal transduction [04075]" = "04075",
    "Platelet activation [04611]" = "04611",
    "Polycyclic aromatic hydrocarbon degradation [00624]" = "00624",
    "Polyketide sugar unit biosynthesis [00523]" = "00523",
    "Porphyrin metabolism [00860]" = "00860",
    "Primary bile acid biosynthesis [00120]" = "00120",
    "Primary immunodeficiency [05340]" = "05340",
    "Prion disease [05020]" = "05020",
    "Progesterone-mediated oocyte maturation [04914]" = "04914",
    "Propanoate metabolism [00640]" = "00640",
    "Prostate cancer [05215]" = "05215",
    "Proteasome [03050]" = "03050",
    "Protein digestion and absorption [04974]" = "04974",
    "Protein export [03060]" = "03060",
    "Protein processing in endoplasmic reticulum [04141]" = "04141",
    "Proteoglycans in cancer [05205]" = "05205",
    "Proximal tubule bicarbonate reclamation [04964]" = "04964",
    "Purine metabolism [00230]" = "00230",
    "Pyrimidine metabolism [00240]" = "00240",
    "Pyruvate metabolism [00620]" = "00620",
    "RIG-I-like receptor signaling pathway [04622]" = "04622",
    "RNA degradation [03018]" = "03018",
    "RNA polymerase [03020]" = "03020",
    "Rap1 signaling pathway [04015]" = "04015",
    "Ras signaling pathway [04014]" = "04014",
    "Regulation of actin cytoskeleton [04810]" = "04810",
    "Renal cell carcinoma [05211]" = "05211",
    "Retinol metabolism [00830]" = "00830",
    "Retrograde endocannabinoid signaling [04723]" = "04723",
    "Rheumatoid arthritis [05323]" = "05323",
    "Riboflavin metabolism [00740]" = "00740",
    "Ribosome [03010]" = "03010",
    "Ribosome biogenesis in eukaryotes [03008]" = "03008",
    "SNARE interactions in vesicular transport [04130]" = "04130",
    "Salivary secretion [04970]" = "04970",
    "Salmonella infection [05132]" = "05132",
    "Secondary bile acid biosynthesis [00121]" = "00121",
    "Selenocompound metabolism [00450]" = "00450",
    "Serotonergic synapse [04726]" = "04726",
    "Sesquiterpenoid and triterpenoid biosynthesis [00909]" = "00909",
    "Shigellosis [05131]" = "05131",
    "Signaling pathways regulating pluripotency of stem cells [04550]" = "04550",
    "Small cell lung cancer [05222]" = "05222",
    "Sphingolipid metabolism [00600]" = "00600",
    "Sphingolipid signaling pathway [04071]" = "04071",
    "Spinocerebellar ataxia [05017]" = "05017",
    "Spliceosome [03040]" = "03040",
    "Staphylococcus aureus infection [05150]" = "05150",
    "Starch and sucrose metabolism [00500]" = "00500",
    "Steroid biosynthesis [00100]" = "00100",
    "Steroid hormone biosynthesis [00140]" = "00140",
    "Streptomycin biosynthesis [00521]" = "00521",
    "Styrene degradation [00643]" = "00643",
    "Sulfur metabolism [00920]" = "00920",
    "Sulfur relay system [04122]" = "04122",
    "Systemic lupus erythematosus [05322]" = "05322",
    "T cell receptor signaling pathway [04660]" = "04660",
    "TGF-beta signaling pathway [04350]" = "04350",
    "TNF signaling pathway [04668]" = "04668",
    "Taste transduction [04742]" = "04742",
    "Taurine and hypotaurine metabolism [00430]" = "00430",
    "Teichoic acid biosynthesis [00552]" = "00552",
    "Terpenoid backbone biosynthesis [00900]" = "00900",
    "Th1 and Th2 cell differentiation [04658]" = "04658",
    "Th17 cell differentiation [04659]" = "04659",
    "Thermogenesis [04714]" = "04714",
    "Thiamine metabolism [00730]" = "00730",
    "Thyroid cancer [05216]" = "05216",
    "Tight junction [04530]" = "04530",
    "Toll-like receptor signaling pathway [04620]" = "04620",
    "Toxoplasmosis [05145]" = "05145",
    "Transcriptional misregulation in cancer [05202]" = "05202",
    "Tryptophan metabolism [00380]" = "00380",
    "Tuberculosis [05152]" = "05152",
    "Two-component system [02020]" = "02020",
    "Type I diabetes mellitus [04940]" = "04940",
    "Type I polyketide structures [01052]" = "01052",
    "Type II diabetes mellitus [04930]" = "04930",
    "Tyrosine metabolism [00350]" = "00350",
    "Ubiquinone and other terpenoid-quinone biosynthesis [00130]" = "00130",
    "Ubiquitin mediated proteolysis [04120]" = "04120",
    "VEGF signaling pathway [04370]" = "04370",
    "Valine, leucine and isoleucine biosynthesis [00290]" = "00290",
    "Valine, leucine and isoleucine degradation [00280]" = "00280",
    "Various types of N-glycan biosynthesis [00513]" = "00513",
    "Vascular smooth muscle contraction [04270]" = "04270",
    "Vasopressin-regulated water reabsorption [04962]" = "04962",
    "Vibrio cholerae infection [05110]" = "05110",
    "Viral carcinogenesis [05203]" = "05203",
    "Viral myocarditis [05416]" = "05416",
    "Viral protein interaction with cytokine and cytokine receptor [04061]" = "04061",
    "Vitamin B6 metabolism [00750]" = "00750",
    "Vitamin digestion and absorption [04977]" = "04977",
    "Wnt signaling pathway [04310]" = "04310",
    "Xylene degradation [00622]" = "00622",
    "Yersinia infection [05135]" = "05135",
    "Zeatin biosynthesis [00908]" = "00908",
    "alpha-Linolenic acid metabolism [00592]" = "00592",
    "beta-Alanine metabolism [00410]" = "00410",
    "cAMP signaling pathway [04024]" = "04024",
    "cGMP-PKG signaling pathway [04022]" = "04022",
    "mRNA surveillance pathway [03015]" = "03015",
    "mTOR signaling pathway [04150]" = "04150",
    "p53 signaling pathway [04115]" = "04115"
  )

# Total: 409 pathways

  c(
    "2-Oxocarboxylic acid metabolism [01210]" = "01210",
    "ABC transporters [02010]" = "02010",
    "AMPK signaling pathway [04152]" = "04152",
    "Acarbose and validamycin biosynthesis [00525]" = "00525",
    "Acridone alkaloid biosynthesis [01058]" = "01058",
    "Acute myeloid leukemia [05221]" = "05221",
    "Adherens junction [04520]" = "04520",
    "Adipocytokine signaling pathway [04920]" = "04920",
    "Adrenergic signaling in cardiomyocytes [04261]" = "04261",
    "African trypanosomiasis [05143]" = "05143",
    "Alanine, aspartate and glutamate metabolism [00250]" = "00250",
    "Alcoholism [05034]" = "05034",
    "Aldosterone-regulated sodium reabsorption [04960]" = "04960",
    "Allograft rejection [05330]" = "05330",
    "Alzheimer disease [05010]" = "05010",
    "Amino sugar and nucleotide sugar metabolism [00520]" = "00520",
    "Aminoacyl-tRNA biosynthesis [00970]" = "00970",
    "Aminobenzoate degradation [00627]" = "00627",
    "Amoebiasis [05146]" = "05146",
    "Amphetamine addiction [05031]" = "05031",
    "Amyotrophic lateral sclerosis [05014]" = "05014",
    "Antigen processing and presentation [04612]" = "04612",
    "Apelin signaling pathway [04371]" = "04371",
    "Apoptosis [04210]" = "04210",
    "Apoptosis - fly [04214]" = "04214",
    "Apoptosis - multiple species [04215]" = "04215",
    "Arabinogalactan biosynthesis - Mycobacterium [00572]" = "00572",
    "Arachidonic acid metabolism [00590]" = "00590",
    "Arginine and proline metabolism [00330]" = "00330",
    "Arginine biosynthesis [00220]" = "00220",
    "Arrhythmogenic right ventricular cardiomyopathy [05412]" = "05412",
    "Ascorbate and aldarate metabolism [00053]" = "00053",
    "Asthma [05310]" = "05310",
    "Atrazine degradation [00791]" = "00791",
    "Autoimmune thyroid disease [05320]" = "05320",
    "Autophagy - animal [04140]" = "04140",
    "Autophagy - other [04136]" = "04136",
    "Autophagy - yeast [04138]" = "04138",
    "Axon guidance [04360]" = "04360",
    "B cell receptor signaling pathway [04662]" = "04662",
    "Bacterial invasion of epithelial cells [05100]" = "05100",
    "Bacterial secretion system [03070]" = "03070",
    "Basal cell carcinoma [05217]" = "05217",
    "Basal transcription factors [03022]" = "03022",
    "Base excision repair [03410]" = "03410",
    "Benzoate degradation [00362]" = "00362",
    "Bile secretion [04976]" = "04976",
    "Biofilm formation - Escherichia coli [05112]" = "05112",
    "Biofilm formation - Pseudomonas aeruginosa [05113]" = "05113",
    "Biofilm formation - Vibrio cholerae [05111]" = "05111",
    "Biosynthesis of 12-, 14- and 16-membered macrolides [00522]" = "00522",
    "Biosynthesis of alkaloids derived from histidine and purine [01065]" = "01065",
    "Biosynthesis of alkaloids derived from ornithine, lysine and nicotinic acid [01064]" = "01064",
    "Biosynthesis of alkaloids derived from shikimate pathway [01063]" = "01063",
    "Biosynthesis of alkaloids derived from terpenoid and polyketide [01066]" = "01066",
    "Biosynthesis of amino acids [01230]" = "01230",
    "Biosynthesis of ansamycins [01051]" = "01051",
    "Biosynthesis of cofactors [01240]" = "01240",
    "Biosynthesis of enediyne antibiotics [01059]" = "01059",
    "Biosynthesis of nucleotide sugars [01250]" = "01250",
    "Biosynthesis of phenylpropanoids [01061]" = "01061",
    "Biosynthesis of plant hormones [01070]" = "01070",
    "Biosynthesis of plant secondary metabolites [01060]" = "01060",
    "Biosynthesis of secondary metabolites [01110]" = "01110",
    "Biosynthesis of siderophore group nonribosomal peptides [01053]" = "01053",
    "Biosynthesis of terpenoids and steroids [01062]" = "01062",
    "Biosynthesis of type II polyketide backbone [01056]" = "01056",
    "Biosynthesis of type II polyketide products [01057]" = "01057",
    "Biosynthesis of unsaturated fatty acids [01040]" = "01040",
    "Biosynthesis of vancomycin group antibiotics [01055]" = "01055",
    "Biotin metabolism [00780]" = "00780",
    "Bisphenol degradation [00363]" = "00363",
    "Bladder cancer [05219]" = "05219",
    "Brassinosteroid biosynthesis [00905]" = "00905",
    "Breast cancer [05224]" = "05224",
    "Butanoate metabolism [00650]" = "00650",
    "C-type lectin receptor signaling pathway [04625]" = "04625",
    "C5-Branched dibasic acid metabolism [00660]" = "00660",
    "Caffeine metabolism [00232]" = "00232",
    "Calcium signaling pathway [04020]" = "04020",
    "Cannabinoid addiction [05035]" = "05035",
    "Caprolactam degradation [00930]" = "00930",
    "Carbapenem biosynthesis [00332]" = "00332",
    "Carbohydrate digestion and absorption [04973]" = "04973",
    "Carbon fixation in photosynthetic organisms [00710]" = "00710",
    "Carbon fixation pathways in prokaryotes [00720]" = "00720",
    "Carbon metabolism [01200]" = "01200",
    "Cardiac muscle contraction [04260]" = "04260",
    "Carotenoid biosynthesis [00906]" = "00906",
    "Cell adhesion molecules [04514]" = "04514",
    "Cell cycle [04110]" = "04110",
    "Cell cycle - Caulobacter [04112]" = "04112",
    "Cell cycle - yeast [04111]" = "04111",
    "Cellular senescence [04218]" = "04218",
    "Central carbon metabolism in cancer [05230]" = "05230",
    "Chagas disease [05142]" = "05142",
    "Chemical carcinogenesis - DNA adducts [05204]" = "05204",
    "Chemical carcinogenesis - reactive oxygen species [05208]" = "05208",
    "Chemical carcinogenesis - receptor activation [05207]" = "05207",
    "Chemokine signaling pathway [04062]" = "04062",
    "Chloroalkane and chloroalkene degradation [00625]" = "00625",
    "Chlorocyclohexane and chlorobenzene degradation [00361]" = "00361",
    "Cholesterol metabolism [04979]" = "04979",
    "Choline metabolism in cancer [05231]" = "05231",
    "Cholinergic synapse [04725]" = "04725",
    "Chronic myeloid leukemia [05220]" = "05220",
    "Circadian entrainment [04713]" = "04713",
    "Circadian rhythm [04710]" = "04710",
    "Circadian rhythm - fly [04711]" = "04711",
    "Circadian rhythm - plant [04712]" = "04712",
    "Citrate cycle (TCA cycle) [00020]" = "00020",
    "Clavulanic acid biosynthesis [00331]" = "00331",
    "Cocaine addiction [05030]" = "05030",
    "Collecting duct acid secretion [04966]" = "04966",
    "Colorectal cancer [05210]" = "05210",
    "Complement and coagulation cascades [04610]" = "04610",
    "Coronavirus disease - COVID-19 [05171]" = "05171",
    "Cutin, suberine and wax biosynthesis [00073]" = "00073",
    "Cyanoamino acid metabolism [00460]" = "00460",
    "Cysteine and methionine metabolism [00270]" = "00270",
    "Cytokine-cytokine receptor interaction [04060]" = "04060",
    "Cytosolic DNA-sensing pathway [04623]" = "04623",
    "D-Alanine metabolism [00473]" = "00473",
    "D-Arginine and D-ornithine metabolism [00472]" = "00472",
    "D-Glutamine and D-glutamate metabolism [00471]" = "00471",
    "DNA replication [03030]" = "03030",
    "Degradation of aromatic compounds [01220]" = "01220",
    "Diabetic cardiomyopathy [05415]" = "05415",
    "Dilated cardiomyopathy [05414]" = "05414",
    "Dioxin degradation [00621]" = "00621",
    "Diterpenoid biosynthesis [00904]" = "00904",
    "Dopaminergic synapse [04728]" = "04728",
    "ECM-receptor interaction [04512]" = "04512",
    "Endocrine and other factor-regulated calcium reabsorption [04961]" = "04961",
    "Endocytosis [04144]" = "04144",
    "Endometrial cancer [05213]" = "05213",
    "Epithelial cell signaling in Helicobacter pylori infection [05120]" = "05120",
    "Epstein-Barr virus infection [05169]" = "05169",
    "ErbB signaling pathway [04012]" = "04012",
    "Ether lipid metabolism [00565]" = "00565",
    "Ethylbenzene degradation [00642]" = "00642",
    "Exopolysaccharide biosynthesis [00543]" = "00543",
    "Fanconi anemia pathway [03460]" = "03460",
    "Fat digestion and absorption [04975]" = "04975",
    "Fatty acid biosynthesis [00061]" = "00061",
    "Fatty acid degradation [00071]" = "00071",
    "Fatty acid elongation [00062]" = "00062",
    "Fatty acid metabolism [01212]" = "01212",
    "Fc epsilon RI signaling pathway [04664]" = "04664",
    "Fc gamma R-mediated phagocytosis [04666]" = "04666",
    "Ferroptosis [04216]" = "04216",
    "Ferroptosis [04716]" = "04716",
    "Fluid shear stress and atherosclerosis [05418]" = "05418",
    "Fluorobenzoate degradation [00364]" = "00364",
    "Focal adhesion [04510]" = "04510",
    "Folate biosynthesis [00790]" = "00790",
    "FoxO signaling pathway [04068]" = "04068",
    "Fructose and mannose metabolism [00051]" = "00051",
    "GABAergic synapse [04727]" = "04727",
    "Galactose metabolism [00052]" = "00052",
    "Gap junction [04540]" = "04540",
    "Gastric acid secretion [04971]" = "04971",
    "Gastric cancer [05226]" = "05226",
    "Geraniol degradation [00281]" = "00281",
    "Glioma [05214]" = "05214",
    "Glutamatergic synapse [04724]" = "04724",
    "Glutathione metabolism [00480]" = "00480",
    "Glycerolipid metabolism [00561]" = "00561",
    "Glycerophospholipid metabolism [00564]" = "00564",
    "Glycine, serine and threonine metabolism [00260]" = "00260",
    "Glycolysis / Gluconeogenesis [00010]" = "00010",
    "Glycosaminoglycan biosynthesis - chondroitin sulfate / dermatan sulfate [00532]" = "00532",
    "Glycosaminoglycan biosynthesis - heparan sulfate / heparin [00534]" = "00534",
    "Glycosaminoglycan biosynthesis - keratan sulfate [00533]" = "00533",
    "Glycosaminoglycan degradation [00531]" = "00531",
    "Glycosphingolipid biosynthesis - ganglio series [00604]" = "00604",
    "Glycosphingolipid biosynthesis - globo and isoglobo series [00603]" = "00603",
    "Glycosphingolipid biosynthesis - lacto and neolacto series [00601]" = "00601",
    "Glycosylphosphatidylinositol (GPI)-anchor biosynthesis [00563]" = "00563",
    "Glyoxylate and dicarboxylate metabolism [00630]" = "00630",
    "Graft-versus-host disease [05332]" = "05332",
    "HIF-1 signaling pathway [04066]" = "04066",
    "Hedgehog signaling pathway [04340]" = "04340",
    "Hedgehog signaling pathway - fly [04341]" = "04341",
    "Hematopoietic cell lineage [04640]" = "04640",
    "Hepatitis B [05161]" = "05161",
    "Hepatitis C [05160]" = "05160",
    "Hepatocellular carcinoma [05225]" = "05225",
    "Herpes simplex virus 1 infection [05168]" = "05168",
    "Hippo signaling pathway [04390]" = "04390",
    "Hippo signaling pathway - fly [04391]" = "04391",
    "Hippo signaling pathway - multiple species [04392]" = "04392",
    "Histidine metabolism [00340]" = "00340",
    "Homologous recombination [03440]" = "03440",
    "Human T-cell leukemia virus 1 infection [05166]" = "05166",
    "Human cytomegalovirus infection [05163]" = "05163",
    "Human immunodeficiency virus 1 infection [05170]" = "05170",
    "Human papillomavirus infection [05165]" = "05165",
    "Huntington disease [05016]" = "05016",
    "Hypertrophic cardiomyopathy [05410]" = "05410",
    "IL-17 signaling pathway [04657]" = "04657",
    "Inflammatory bowel disease [05321]" = "05321",
    "Inflammatory mediator regulation of TRP channels [04750]" = "04750",
    "Influenza A [05164]" = "05164",
    "Inositol phosphate metabolism [00562]" = "00562",
    "Insect hormone biosynthesis [00981]" = "00981",
    "Insulin signaling pathway [04910]" = "04910",
    "JAK-STAT signaling pathway [04630]" = "04630",
    "Kaposi sarcoma-associated herpesvirus infection [05167]" = "05167",
    "Legionellosis [05134]" = "05134",
    "Leishmaniasis [05140]" = "05140",
    "Leishmaniasis [05148]" = "05148",
    "Leukocyte transendothelial migration [04670]" = "04670",
    "Limonene and pinene degradation [00903]" = "00903",
    "Linoleic acid metabolism [00591]" = "00591",
    "Lipoarabinomannan (LAM) biosynthesis [00571]" = "00571",
    "Lipoic acid metabolism [00785]" = "00785",
    "Lipopolysaccharide biosynthesis [00540]" = "00540",
    "Long-term depression [04730]" = "04730",
    "Long-term potentiation [04720]" = "04720",
    "Longevity regulating pathway [04211]" = "04211",
    "Longevity regulating pathway - multiple species [04213]" = "04213",
    "Longevity regulating pathway - worm [04212]" = "04212",
    "Lysine biosynthesis [00300]" = "00300",
    "Lysine degradation [00310]" = "00310",
    "Lysosome [04142]" = "04142",
    "MAPK signaling pathway [04010]" = "04010",
    "MAPK signaling pathway - fly [04013]" = "04013",
    "MAPK signaling pathway - plant [04016]" = "04016",
    "MAPK signaling pathway - yeast [04011]" = "04011",
    "Malaria [05144]" = "05144",
    "Mannose type O-glycan biosynthesis [00515]" = "00515",
    "Maturity onset diabetes of the young [04950]" = "04950",
    "Measles [05162]" = "05162",
    "Meiosis - yeast [04113]" = "04113",
    "Melanoma [05218]" = "05218",
    "Metabolic pathways [01100]" = "01100",
    "Methane metabolism [00680]" = "00680",
    "MicroRNAs in cancer [05206]" = "05206",
    "Microbial metabolism in diverse environments [01120]" = "01120",
    "Mineral absorption [04978]" = "04978",
    "Mismatch repair [03430]" = "03430",
    "Mitophagy - animal [04137]" = "04137",
    "Mitophagy - yeast [04139]" = "04139",
    "Monobactam biosynthesis [00261]" = "00261",
    "Monoterpenoid biosynthesis [00902]" = "00902",
    "Morphine addiction [05032]" = "05032",
    "Mucin type O-glycan biosynthesis [00512]" = "00512",
    "N-Glycan biosynthesis [00510]" = "00510",
    "NF-kappa B signaling pathway [04064]" = "04064",
    "NOD-like receptor signaling pathway [04621]" = "04621",
    "Naphthalene degradation [00626]" = "00626",
    "Natural killer cell mediated cytotoxicity [04650]" = "04650",
    "Necroptosis [04217]" = "04217",
    "Neomycin, kanamycin and gentamicin biosynthesis [00524]" = "00524",
    "Neuroactive ligand-receptor interaction [04080]" = "04080",
    "Neurotrophin signaling pathway [04722]" = "04722",
    "Nicotinate and nicotinamide metabolism [00760]" = "00760",
    "Nicotine addiction [05033]" = "05033",
    "Nitrogen metabolism [00910]" = "00910",
    "Nitrotoluene degradation [00633]" = "00633",
    "Non-homologous end-joining [03450]" = "03450",
    "Non-small cell lung cancer [05223]" = "05223",
    "Nonribosomal peptide structures [01054]" = "01054",
    "Notch signaling pathway [04330]" = "04330",
    "Novobiocin biosynthesis [00401]" = "00401",
    "Nucleocytoplasmic transport [03013]" = "03013",
    "Nucleotide excision repair [03420]" = "03420",
    "Nucleotide metabolism [01232]" = "01232",
    "O-Antigen nucleotide sugar biosynthesis [00541]" = "00541",
    "O-Antigen repeat unit biosynthesis [00542]" = "00542",
    "Olfactory transduction [04740]" = "04740",
    "One carbon pool by folate [00670]" = "00670",
    "Oocyte meiosis [04114]" = "04114",
    "Osteoclast differentiation [04380]" = "04380",
    "Other types of O-glycan biosynthesis [00514]" = "00514",
    "Oxidative phosphorylation [00190]" = "00190",
    "PD-L1 expression and PD-1 checkpoint pathway in cancer [05235]" = "05235",
    "PI3K-Akt signaling pathway [04151]" = "04151",
    "PPAR signaling pathway [03320]" = "03320",
    "Pancreatic cancer [05212]" = "05212",
    "Pancreatic secretion [04972]" = "04972",
    "Pantothenate and CoA biosynthesis [00770]" = "00770",
    "Parasite infection [05114]" = "05114",
    "Parkinson disease [05012]" = "05012",
    "Pathogenic Escherichia coli infection [05130]" = "05130",
    "Pathways in cancer [05200]" = "05200",
    "Pathways of neurodegeneration - multiple diseases [05022]" = "05022",
    "Penicillin and cephalosporin biosynthesis [00311]" = "00311",
    "Pentose and glucuronate interconversions [00040]" = "00040",
    "Pentose phosphate pathway [00030]" = "00030",
    "Peptidoglycan biosynthesis [00550]" = "00550",
    "Peroxisome [04146]" = "04146",
    "Pertussis [05133]" = "05133",
    "Phagosome [04145]" = "04145",
    "Phenylalanine metabolism [00360]" = "00360",
    "Phenylalanine, tyrosine and tryptophan biosynthesis [00400]" = "00400",
    "Phosphatidylinositol signaling system [04070]" = "04070",
    "Phospholipase D signaling pathway [04072]" = "04072",
    "Phosphonate and phosphinate metabolism [00440]" = "00440",
    "Phosphotransferase system (PTS) [02060]" = "02060",
    "Photosynthesis [00195]" = "00195",
    "Photosynthesis - antenna proteins [00196]" = "00196",
    "Phototransduction [04744]" = "04744",
    "Phototransduction - fly [04745]" = "04745",
    "Plant hormone signal transduction [04075]" = "04075",
    "Platelet activation [04611]" = "04611",
    "Polycyclic aromatic hydrocarbon degradation [00624]" = "00624",
    "Polyketide sugar unit biosynthesis [00523]" = "00523",
    "Porphyrin metabolism [00860]" = "00860",
    "Primary bile acid biosynthesis [00120]" = "00120",
    "Primary immunodeficiency [05340]" = "05340",
    "Prion disease [05020]" = "05020",
    "Progesterone-mediated oocyte maturation [04914]" = "04914",
    "Propanoate metabolism [00640]" = "00640",
    "Prostate cancer [05215]" = "05215",
    "Proteasome [03050]" = "03050",
    "Protein digestion and absorption [04974]" = "04974",
    "Protein export [03060]" = "03060",
    "Protein processing in endoplasmic reticulum [04141]" = "04141",
    "Proteoglycans in cancer [05205]" = "05205",
    "Proximal tubule bicarbonate reclamation [04964]" = "04964",
    "Purine metabolism [00230]" = "00230",
    "Pyrimidine metabolism [00240]" = "00240",
    "Pyruvate metabolism [00620]" = "00620",
    "RIG-I-like receptor signaling pathway [04622]" = "04622",
    "RNA degradation [03018]" = "03018",
    "RNA polymerase [03020]" = "03020",
    "Rap1 signaling pathway [04015]" = "04015",
    "Ras signaling pathway [04014]" = "04014",
    "Regulation of actin cytoskeleton [04810]" = "04810",
    "Renal cell carcinoma [05211]" = "05211",
    "Retinol metabolism [00830]" = "00830",
    "Retrograde endocannabinoid signaling [04723]" = "04723",
    "Rheumatoid arthritis [05323]" = "05323",
    "Riboflavin metabolism [00740]" = "00740",
    "Ribosome [03010]" = "03010",
    "Ribosome biogenesis in eukaryotes [03008]" = "03008",
    "SNARE interactions in vesicular transport [04130]" = "04130",
    "Salivary secretion [04970]" = "04970",
    "Salmonella infection [05132]" = "05132",
    "Secondary bile acid biosynthesis [00121]" = "00121",
    "Selenocompound metabolism [00450]" = "00450",
    "Serotonergic synapse [04726]" = "04726",
    "Sesquiterpenoid and triterpenoid biosynthesis [00909]" = "00909",
    "Shigellosis [05131]" = "05131",
    "Signaling pathways regulating pluripotency of stem cells [04550]" = "04550",
    "Small cell lung cancer [05222]" = "05222",
    "Sphingolipid metabolism [00600]" = "00600",
    "Sphingolipid signaling pathway [04071]" = "04071",
    "Spinocerebellar ataxia [05017]" = "05017",
    "Spliceosome [03040]" = "03040",
    "Staphylococcus aureus infection [05150]" = "05150",
    "Starch and sucrose metabolism [00500]" = "00500",
    "Steroid biosynthesis [00100]" = "00100",
    "Steroid hormone biosynthesis [00140]" = "00140",
    "Streptomycin biosynthesis [00521]" = "00521",
    "Styrene degradation [00643]" = "00643",
    "Sulfur metabolism [00920]" = "00920",
    "Sulfur relay system [04122]" = "04122",
    "Systemic lupus erythematosus [05322]" = "05322",
    "T cell receptor signaling pathway [04660]" = "04660",
    "TGF-beta signaling pathway [04350]" = "04350",
    "TNF signaling pathway [04668]" = "04668",
    "Taste transduction [04742]" = "04742",
    "Taurine and hypotaurine metabolism [00430]" = "00430",
    "Teichoic acid biosynthesis [00552]" = "00552",
    "Terpenoid backbone biosynthesis [00900]" = "00900",
    "Th1 and Th2 cell differentiation [04658]" = "04658",
    "Th17 cell differentiation [04659]" = "04659",
    "Thermogenesis [04714]" = "04714",
    "Thiamine metabolism [00730]" = "00730",
    "Thyroid cancer [05216]" = "05216",
    "Tight junction [04530]" = "04530",
    "Toll-like receptor signaling pathway [04620]" = "04620",
    "Toxoplasmosis [05145]" = "05145",
    "Transcriptional misregulation in cancer [05202]" = "05202",
    "Tryptophan metabolism [00380]" = "00380",
    "Tuberculosis [05152]" = "05152",
    "Two-component system [02020]" = "02020",
    "Type I diabetes mellitus [04940]" = "04940",
    "Type I polyketide structures [01052]" = "01052",
    "Type II diabetes mellitus [04930]" = "04930",
    "Tyrosine metabolism [00350]" = "00350",
    "Ubiquinone and other terpenoid-quinone biosynthesis [00130]" = "00130",
    "Ubiquitin mediated proteolysis [04120]" = "04120",
    "VEGF signaling pathway [04370]" = "04370",
    "Valine, leucine and isoleucine biosynthesis [00290]" = "00290",
    "Valine, leucine and isoleucine degradation [00280]" = "00280",
    "Various types of N-glycan biosynthesis [00513]" = "00513",
    "Vascular smooth muscle contraction [04270]" = "04270",
    "Vasopressin-regulated water reabsorption [04962]" = "04962",
    "Vibrio cholerae infection [05110]" = "05110",
    "Viral carcinogenesis [05203]" = "05203",
    "Viral myocarditis [05416]" = "05416",
    "Viral protein interaction with cytokine and cytokine receptor [04061]" = "04061",
    "Vitamin B6 metabolism [00750]" = "00750",
    "Vitamin digestion and absorption [04977]" = "04977",
    "Wnt signaling pathway [04310]" = "04310",
    "Xylene degradation [00622]" = "00622",
    "Yersinia infection [05135]" = "05135",
    "Zeatin biosynthesis [00908]" = "00908",
    "alpha-Linolenic acid metabolism [00592]" = "00592",
    "beta-Alanine metabolism [00410]" = "00410",
    "cAMP signaling pathway [04024]" = "04024",
    "cGMP-PKG signaling pathway [04022]" = "04022",
    "mRNA surveillance pathway [03015]" = "03015",
    "mTOR signaling pathway [04150]" = "04150",
    "p53 signaling pathway [04115]" = "04115"
  )

# Total: 409 pathways
KEGG_HIERARCHY <- list(
  "1. Metabolism" = list(
    "1.0 Global and overview maps" = list(
      list(id="01100", name="Metabolic pathways"),
      list(id="01110", name="Biosynthesis of secondary metabolites"),
      list(id="01120", name="Microbial metabolism in diverse environments"),
      list(id="01200", name="Carbon metabolism"),
      list(id="01210", name="2-Oxocarboxylic acid metabolism"),
      list(id="01212", name="Fatty acid metabolism"),
      list(id="01230", name="Biosynthesis of amino acids"),
      list(id="01232", name="Nucleotide metabolism"),
      list(id="01250", name="Biosynthesis of nucleotide sugars"),
      list(id="01240", name="Biosynthesis of cofactors"),
      list(id="01220", name="Degradation of aromatic compounds"),
      list(id="01310", name="Nitrogen cycle"),
      list(id="01320", name="Sulfur cycle")
    ),
    "1.1 Carbohydrate metabolism" = list(
      list(id="00010", name="Glycolysis / Gluconeogenesis"),
      list(id="00020", name="Citrate cycle (TCA cycle)"),
      list(id="00030", name="Pentose phosphate pathway"),
      list(id="00040", name="Pentose and glucuronate interconversions"),
      list(id="00051", name="Fructose and mannose metabolism"),
      list(id="00052", name="Galactose metabolism"),
      list(id="00053", name="Ascorbate and aldarate metabolism"),
      list(id="00500", name="Starch and sucrose metabolism"),
      list(id="00620", name="Pyruvate metabolism"),
      list(id="00630", name="Glyoxylate and dicarboxylate metabolism"),
      list(id="00640", name="Propanoate metabolism"),
      list(id="00650", name="Butanoate metabolism"),
      list(id="00660", name="C5-Branched dibasic acid metabolism"),
      list(id="00562", name="Inositol phosphate metabolism"),
      list(id="00566", name="Sulfoquinovose metabolism")
    ),
    "1.2 Energy metabolism" = list(
      list(id="00190", name="Oxidative phosphorylation"),
      list(id="00195", name="Photosynthesis"),
      list(id="00196", name="Photosynthesis - antenna proteins"),
      list(id="00710", name="Carbon fixation by Calvin cycle"),
      list(id="00720", name="Other carbon fixation pathways"),
      list(id="00680", name="Methane metabolism"),
      list(id="00910", name="Nitrogen metabolism"),
      list(id="00920", name="Sulfur metabolism")
    ),
    "1.3 Lipid metabolism" = list(
      list(id="00061", name="Fatty acid biosynthesis"),
      list(id="00062", name="Fatty acid elongation"),
      list(id="00071", name="Fatty acid degradation"),
      list(id="00073", name="Cutin, suberine and wax biosynthesis"),
      list(id="00074", name="Mycolic acid biosynthesis"),
      list(id="00100", name="Steroid biosynthesis"),
      list(id="00120", name="Primary bile acid biosynthesis"),
      list(id="00121", name="Secondary bile acid biosynthesis"),
      list(id="00140", name="Steroid hormone biosynthesis"),
      list(id="00561", name="Glycerolipid metabolism"),
      list(id="00564", name="Glycerophospholipid metabolism"),
      list(id="00565", name="Ether lipid metabolism"),
      list(id="00600", name="Sphingolipid metabolism"),
      list(id="00590", name="Arachidonic acid metabolism"),
      list(id="00591", name="Linoleic acid metabolism"),
      list(id="00592", name="alpha-Linolenic acid metabolism"),
      list(id="01040", name="Biosynthesis of unsaturated fatty acids")
    ),
    "1.4 Nucleotide metabolism" = list(
      list(id="00230", name="Purine metabolism"),
      list(id="00240", name="Pyrimidine metabolism")
    ),
    "1.5 Amino acid metabolism" = list(
      list(id="00250", name="Alanine, aspartate and glutamate metabolism"),
      list(id="00260", name="Glycine, serine and threonine metabolism"),
      list(id="00270", name="Cysteine and methionine metabolism"),
      list(id="00280", name="Valine, leucine and isoleucine degradation"),
      list(id="00290", name="Valine, leucine and isoleucine biosynthesis"),
      list(id="00300", name="Lysine biosynthesis"),
      list(id="00310", name="Lysine degradation"),
      list(id="00220", name="Arginine biosynthesis"),
      list(id="00330", name="Arginine and proline metabolism"),
      list(id="00340", name="Histidine metabolism"),
      list(id="00350", name="Tyrosine metabolism"),
      list(id="00360", name="Phenylalanine metabolism"),
      list(id="00380", name="Tryptophan metabolism"),
      list(id="00400", name="Phenylalanine, tyrosine and tryptophan biosynthesis")
    ),
    "1.6 Other amino acids" = list(
      list(id="00410", name="beta-Alanine metabolism"),
      list(id="00430", name="Taurine and hypotaurine metabolism"),
      list(id="00440", name="Phosphonate and phosphinate metabolism"),
      list(id="00450", name="Selenocompound metabolism"),
      list(id="00460", name="Cyanoamino acid metabolism"),
      list(id="00470", name="D-Amino acid metabolism"),
      list(id="00480", name="Glutathione metabolism")
    ),
    "1.7 Glycan biosynthesis and metabolism" = list(
      list(id="00520", name="Amino sugar and nucleotide sugar metabolism"),
      list(id="00541", name="Biosynthesis of various nucleotide sugars"),
      list(id="00510", name="N-Glycan biosynthesis"),
      list(id="00513", name="Various types of N-glycan biosynthesis"),
      list(id="00512", name="Mucin type O-glycan biosynthesis"),
      list(id="00515", name="Mannose type O-glycan biosynthesis"),
      list(id="00514", name="Other types of O-glycan biosynthesis"),
      list(id="00532", name="Glycosaminoglycan biosynthesis - chondroitin sulfate"),
      list(id="00534", name="Glycosaminoglycan biosynthesis - heparan sulfate"),
      list(id="00533", name="Glycosaminoglycan biosynthesis - keratan sulfate"),
      list(id="00531", name="Glycosaminoglycan degradation"),
      list(id="00563", name="Glycosylphosphatidylinositol (GPI)-anchor biosynthesis"),
      list(id="00601", name="Glycosphingolipid biosynthesis - lacto and neolacto series"),
      list(id="00603", name="Glycosphingolipid biosynthesis - globo and isoglobo series"),
      list(id="00604", name="Glycosphingolipid biosynthesis - ganglio series"),
      list(id="00511", name="Other glycan degradation"),
      list(id="00540", name="Lipopolysaccharide biosynthesis"),
      list(id="00542", name="O-Antigen repeat unit biosynthesis"),
      list(id="00550", name="Peptidoglycan biosynthesis"),
      list(id="00552", name="Teichoic acid biosynthesis"),
      list(id="00571", name="Lipoarabinomannan (LAM) biosynthesis"),
      list(id="00572", name="Arabinogalactan biosynthesis - Mycobacterium"),
      list(id="00543", name="Exopolysaccharide biosynthesis")
    ),
    "1.8 Cofactors and vitamins" = list(
      list(id="00730", name="Thiamine metabolism"),
      list(id="00740", name="Riboflavin metabolism"),
      list(id="00750", name="Vitamin B6 metabolism"),
      list(id="00760", name="Nicotinate and nicotinamide metabolism"),
      list(id="00770", name="Pantothenate and CoA biosynthesis"),
      list(id="00780", name="Biotin metabolism"),
      list(id="00785", name="Lipoic acid metabolism"),
      list(id="00790", name="Folate biosynthesis"),
      list(id="00670", name="One carbon pool by folate"),
      list(id="00830", name="Retinol metabolism"),
      list(id="00860", name="Porphyrin metabolism"),
      list(id="00130", name="Ubiquinone and other terpenoid-quinone biosynthesis")
    ),
    "1.9 Terpenoids and polyketides" = list(
      list(id="00900", name="Terpenoid backbone biosynthesis"),
      list(id="00902", name="Monoterpenoid biosynthesis"),
      list(id="00909", name="Sesquiterpenoid and triterpenoid biosynthesis"),
      list(id="00904", name="Diterpenoid biosynthesis"),
      list(id="00906", name="Carotenoid biosynthesis"),
      list(id="00905", name="Brassinosteroid biosynthesis"),
      list(id="00981", name="Insect hormone biosynthesis"),
      list(id="00908", name="Zeatin biosynthesis"),
      list(id="00903", name="Limonene degradation"),
      list(id="00907", name="Pinene, camphor and geraniol degradation"),
      list(id="01052", name="Type I polyketide structures"),
      list(id="00522", name="Biosynthesis of 12-, 14- and 16-membered macrolides"),
      list(id="01051", name="Biosynthesis of ansamycins"),
      list(id="01059", name="Biosynthesis of enediyne antibiotics"),
      list(id="01056", name="Biosynthesis of type II polyketide backbone"),
      list(id="01057", name="Biosynthesis of type II polyketide products"),
      list(id="00253", name="Tetracycline biosynthesis"),
      list(id="00523", name="Polyketide sugar unit biosynthesis"),
      list(id="01054", name="Nonribosomal peptide structures"),
      list(id="01053", name="Biosynthesis of siderophore group nonribosomal peptides"),
      list(id="01055", name="Biosynthesis of vancomycin group antibiotics")
    ),
    "1.10 Other secondary metabolites" = list(
      list(id="00940", name="Phenylpropanoid biosynthesis"),
      list(id="00945", name="Stilbenoid, diarylheptanoid and gingerol biosynthesis"),
      list(id="00941", name="Flavonoid biosynthesis"),
      list(id="00944", name="Flavone and flavonol biosynthesis"),
      list(id="00942", name="Anthocyanin biosynthesis"),
      list(id="00943", name="Isoflavonoid biosynthesis"),
      list(id="00946", name="Degradation of flavonoids"),
      list(id="00901", name="Indole alkaloid biosynthesis"),
      list(id="00403", name="Indole diterpene alkaloid biosynthesis"),
      list(id="00950", name="Isoquinoline alkaloid biosynthesis"),
      list(id="00960", name="Tropane, piperidine and pyridine alkaloid biosynthesis"),
      list(id="00232", name="Caffeine metabolism"),
      list(id="00965", name="Betalain biosynthesis"),
      list(id="00966", name="Glucosinolate biosynthesis"),
      list(id="00311", name="Penicillin and cephalosporin biosynthesis"),
      list(id="00332", name="Carbapenem biosynthesis"),
      list(id="00261", name="Monobactam biosynthesis"),
      list(id="00331", name="Clavulanic acid biosynthesis"),
      list(id="00521", name="Streptomycin biosynthesis"),
      list(id="00524", name="Neomycin, kanamycin and gentamicin biosynthesis"),
      list(id="00525", name="Acarbose and validamycin biosynthesis"),
      list(id="00401", name="Novobiocin biosynthesis"),
      list(id="00333", name="Prodigiosin biosynthesis"),
      list(id="00254", name="Aflatoxin biosynthesis"),
      list(id="00975", name="Biosynthesis of various siderophores"),
      list(id="00998", name="Biosynthesis of various antibiotics"),
      list(id="00999", name="Biosynthesis of various plant secondary metabolites"),
      list(id="00997", name="Biosynthesis of various other secondary metabolites")
    ),
    "1.11 Xenobiotics biodegradation" = list(
      list(id="00362", name="Benzoate degradation"),
      list(id="00627", name="Aminobenzoate degradation"),
      list(id="00364", name="Fluorobenzoate degradation"),
      list(id="00625", name="Chloroalkane and chloroalkene degradation"),
      list(id="00361", name="Chlorocyclohexane and chlorobenzene degradation"),
      list(id="00623", name="Toluene degradation"),
      list(id="00622", name="Xylene degradation"),
      list(id="00633", name="Nitrotoluene degradation"),
      list(id="00642", name="Ethylbenzene degradation"),
      list(id="00643", name="Styrene degradation"),
      list(id="00791", name="Atrazine degradation"),
      list(id="00930", name="Caprolactam degradation"),
      list(id="00363", name="Bisphenol degradation"),
      list(id="00621", name="Dioxin degradation"),
      list(id="00626", name="Naphthalene degradation"),
      list(id="00624", name="Polycyclic aromatic hydrocarbon degradation"),
      list(id="00365", name="Furfural degradation"),
      list(id="00984", name="Steroid degradation"),
      list(id="00980", name="Metabolism of xenobiotics by cytochrome P450"),
      list(id="00982", name="Drug metabolism - cytochrome P450"),
      list(id="00983", name="Drug metabolism - other enzymes")
    )
  ),
  "2. Genetic Information Processing" = list(
    "2.1 Transcription" = list(
      list(id="03020", name="RNA polymerase"),
      list(id="03022", name="Basal transcription factors"),
      list(id="03040", name="Spliceosome")
    ),
    "2.2 Translation" = list(
      list(id="03010", name="Ribosome"),
      list(id="00970", name="Aminoacyl-tRNA biosynthesis"),
      list(id="03013", name="Nucleocytoplasmic transport"),
      list(id="03015", name="mRNA surveillance pathway"),
      list(id="03008", name="Ribosome biogenesis in eukaryotes")
    ),
    "2.3 Folding, sorting and degradation" = list(
      list(id="03060", name="Protein export"),
      list(id="04141", name="Protein processing in endoplasmic reticulum"),
      list(id="04130", name="SNARE interactions in vesicular transport"),
      list(id="04120", name="Ubiquitin mediated proteolysis"),
      list(id="04122", name="Sulfur relay system"),
      list(id="03050", name="Proteasome"),
      list(id="03018", name="RNA degradation")
    ),
    "2.4 Replication and repair" = list(
      list(id="03030", name="DNA replication"),
      list(id="03410", name="Base excision repair"),
      list(id="03420", name="Nucleotide excision repair"),
      list(id="03430", name="Mismatch repair"),
      list(id="03440", name="Homologous recombination"),
      list(id="03450", name="Non-homologous end-joining"),
      list(id="03460", name="Fanconi anemia pathway")
    ),
    "2.5 Chromosome" = list(
      list(id="03082", name="ATP-dependent chromatin remodeling"),
      list(id="03083", name="Polycomb repressive complex")
    )
  ),
  "3. Environmental Information Processing" = list(
    "3.1 Membrane transport" = list(
      list(id="02010", name="ABC transporters"),
      list(id="02060", name="Phosphotransferase system (PTS)"),
      list(id="03070", name="Bacterial secretion system")
    ),
    "3.2 Signal transduction" = list(
      list(id="02020", name="Two-component system"),
      list(id="04010", name="MAPK signaling pathway"),
      list(id="04011", name="MAPK signaling pathway - yeast"),
      list(id="04013", name="MAPK signaling pathway - fly"),
      list(id="04016", name="MAPK signaling pathway - plant"),
      list(id="04012", name="ErbB signaling pathway"),
      list(id="04014", name="Ras signaling pathway"),
      list(id="04015", name="Rap1 signaling pathway"),
      list(id="04310", name="Wnt signaling pathway"),
      list(id="04330", name="Notch signaling pathway"),
      list(id="04340", name="Hedgehog signaling pathway"),
      list(id="04350", name="TGF-beta signaling pathway"),
      list(id="04390", name="Hippo signaling pathway"),
      list(id="04370", name="VEGF signaling pathway"),
      list(id="04371", name="Apelin signaling pathway"),
      list(id="04630", name="JAK-STAT signaling pathway"),
      list(id="04064", name="NF-kappa B signaling pathway"),
      list(id="04668", name="TNF signaling pathway"),
      list(id="04066", name="HIF-1 signaling pathway"),
      list(id="04068", name="FoxO signaling pathway"),
      list(id="04020", name="Calcium signaling pathway"),
      list(id="04070", name="Phosphatidylinositol signaling system"),
      list(id="04072", name="Phospholipase D signaling pathway"),
      list(id="04071", name="Sphingolipid signaling pathway"),
      list(id="04024", name="cAMP signaling pathway"),
      list(id="04022", name="cGMP-PKG signaling pathway"),
      list(id="04151", name="PI3K-Akt signaling pathway"),
      list(id="04152", name="AMPK signaling pathway"),
      list(id="04150", name="mTOR signaling pathway"),
      list(id="04075", name="Plant hormone signal transduction")
    ),
    "3.3 Signaling molecules and interaction" = list(
      list(id="04080", name="Neuroactive ligand-receptor interaction"),
      list(id="04060", name="Cytokine-cytokine receptor interaction"),
      list(id="04061", name="Viral protein interaction with cytokine and cytokine receptor"),
      list(id="04512", name="ECM-receptor interaction"),
      list(id="04514", name="Cell adhesion molecules")
    )
  ),
  "4. Cellular Processes" = list(
    "4.1 Transport and catabolism" = list(
      list(id="04144", name="Endocytosis"),
      list(id="04145", name="Phagosome"),
      list(id="04142", name="Lysosome"),
      list(id="04146", name="Peroxisome"),
      list(id="04140", name="Autophagy - animal"),
      list(id="04138", name="Autophagy - yeast"),
      list(id="04136", name="Autophagy - other"),
      list(id="04137", name="Mitophagy - animal"),
      list(id="04139", name="Mitophagy - yeast")
    ),
    "4.2 Cell growth and death" = list(
      list(id="04110", name="Cell cycle"),
      list(id="04111", name="Cell cycle - yeast"),
      list(id="04112", name="Cell cycle - Caulobacter"),
      list(id="04113", name="Meiosis - yeast"),
      list(id="04114", name="Oocyte meiosis"),
      list(id="04210", name="Apoptosis"),
      list(id="04214", name="Apoptosis - fly"),
      list(id="04215", name="Apoptosis - multiple species"),
      list(id="04216", name="Ferroptosis"),
      list(id="04217", name="Necroptosis"),
      list(id="04115", name="p53 signaling pathway"),
      list(id="04218", name="Cellular senescence")
    ),
    "4.3 Cellular community - eukaryotes" = list(
      list(id="04510", name="Focal adhesion"),
      list(id="04520", name="Adherens junction"),
      list(id="04530", name="Tight junction"),
      list(id="04540", name="Gap junction"),
      list(id="04550", name="Signaling pathways regulating pluripotency of stem cells")
    ),
    "4.4 Cellular community - prokaryotes" = list(
      list(id="02024", name="Quorum sensing"),
      list(id="05111", name="Biofilm formation - Vibrio cholerae"),
      list(id="02025", name="Biofilm formation - Pseudomonas aeruginosa"),
      list(id="02026", name="Biofilm formation - Escherichia coli")
    ),
    "4.5 Cell motility" = list(
      list(id="02030", name="Bacterial chemotaxis"),
      list(id="02040", name="Flagellar assembly"),
      list(id="04814", name="Motor proteins"),
      list(id="04810", name="Regulation of actin cytoskeleton")
    )
  )
)
