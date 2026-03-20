library(shiny)
library(shinyjs)
library(shinyFiles)
library(bslib)
library(SQMtools)
library(DT)
`%||%` <- function(a, b) if (!is.null(a)) a else b
# ─────────────────────────────────────────────
#  LIGHT THEME
# ─────────────────────────────────────────────
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
# ─────────────────────────────────────────────
#  CSS
# ─────────────────────────────────────────────
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
  background: linear-gradient(90deg, #0e4a82 0%, #1a6eb5 100%) !important;
  border-bottom: 3px solid #1a9e6e !important;
  padding: 0.5rem 1.5rem !important;
}
.navbar-brand {
  font-family: 'IBM Plex Mono', monospace !important;
  font-weight: 600;
  color: #ffffff !important;
  letter-spacing: 0.05em;
  font-size: 1.1rem;
}
.nav-link { color: rgba(255,255,255,0.65) !important; font-size: 0.85rem; }
.nav-link:hover { color: #ffffff !important; }
.nav-link.active { color: #ffffff !important; border-bottom: 2px solid #1a9e6e; }
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
  # Taxonomy: needs at least one rank with data
  has_tax <- any(sapply(c("phylum","class","order","family","genus","species"), function(r)
    tryCatch(has_data(proj$taxa[[r]]$percent), error = function(e) FALSE)
  ))
  if (has_tax) choices <- c(choices, "Taxonomy (barplot)" = "taxonomy_bar")
  # Functions: COG, KEGG, PFAM, plus any extra databases
  all_dbs <- tryCatch(names(proj$functions), error = function(e) character(0))
  for (db in all_dbs) {
    tbl <- tryCatch(proj$functions[[db]]$abund, error = function(e) NULL)
    if (has_data(tbl)) {
      val   <- paste0("func_", tolower(db))
      label <- paste(db, "functions")
      choices <- c(choices, setNames(val, label))
    }
  }
  # Bins
  has_bins <- tryCatch(has_data(proj$bins$table), error = function(e) FALSE)
  if (has_bins) choices <- c(choices, "Binning" = "bins")
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
  ),
  "5. Organismal Systems" = list(
    "5.1 Immune system" = list(
      list(id="04640", name="Hematopoietic cell lineage"),
      list(id="04610", name="Complement and coagulation cascades"),
      list(id="04611", name="Platelet activation"),
      list(id="04613", name="Neutrophil extracellular trap formation"),
      list(id="04620", name="Toll-like receptor signaling pathway"),
      list(id="04621", name="NOD-like receptor signaling pathway"),
      list(id="04622", name="RIG-I-like receptor signaling pathway"),
      list(id="04623", name="Cytosolic DNA-sensing pathway"),
      list(id="04625", name="C-type lectin receptor signaling pathway"),
      list(id="04650", name="Natural killer cell mediated cytotoxicity"),
      list(id="04612", name="Antigen processing and presentation"),
      list(id="04660", name="T cell receptor signaling pathway"),
      list(id="04658", name="Th1 and Th2 cell differentiation"),
      list(id="04659", name="Th17 cell differentiation"),
      list(id="04657", name="IL-17 signaling pathway"),
      list(id="04662", name="B cell receptor signaling pathway"),
      list(id="04664", name="Fc epsilon RI signaling pathway"),
      list(id="04666", name="Fc gamma R-mediated phagocytosis"),
      list(id="04670", name="Leukocyte transendothelial migration"),
      list(id="04062", name="Chemokine signaling pathway")
    ),
    "5.2 Endocrine system" = list(
      list(id="04911", name="Insulin secretion"),
      list(id="04910", name="Insulin signaling pathway"),
      list(id="04922", name="Glucagon signaling pathway"),
      list(id="04920", name="Adipocytokine signaling pathway"),
      list(id="03320", name="PPAR signaling pathway"),
      list(id="04912", name="GnRH signaling pathway"),
      list(id="04915", name="Estrogen signaling pathway"),
      list(id="04914", name="Progesterone-mediated oocyte maturation"),
      list(id="04917", name="Prolactin signaling pathway"),
      list(id="04921", name="Oxytocin signaling pathway"),
      list(id="04918", name="Thyroid hormone synthesis"),
      list(id="04919", name="Thyroid hormone signaling pathway")
    ),
    "5.3 Circulatory system" = list(
      list(id="04260", name="Cardiac muscle contraction"),
      list(id="04261", name="Adrenergic signaling in cardiomyocytes"),
      list(id="04270", name="Vascular smooth muscle contraction")
    ),
    "5.4 Digestive system" = list(
      list(id="04970", name="Salivary secretion"),
      list(id="04971", name="Gastric acid secretion"),
      list(id="04972", name="Pancreatic secretion"),
      list(id="04976", name="Bile secretion"),
      list(id="04973", name="Carbohydrate digestion and absorption"),
      list(id="04974", name="Protein digestion and absorption"),
      list(id="04975", name="Fat digestion and absorption"),
      list(id="04979", name="Cholesterol metabolism")
    ),
    "5.5 Excretory system" = list(
      list(id="04960", name="Aldosterone-regulated sodium reabsorption"),
      list(id="04961", name="Endocrine and other factor-regulated calcium reabsorption"),
      list(id="04962", name="Vasopressin-regulated water reabsorption"),
      list(id="04964", name="Proximal tubule bicarbonate reclamation"),
      list(id="04966", name="Collecting duct acid secretion")
    ),
    "5.6 Nervous system" = list(
      list(id="04726", name="Serotonergic synapse"),
      list(id="04727", name="GABAergic synapse"),
      list(id="04725", name="Cholinergic synapse"),
      list(id="04728", name="Dopaminergic synapse"),
      list(id="04724", name="Glutamatergic synapse"),
      list(id="04723", name="Retrograde endocannabinoid signaling"),
      list(id="04720", name="Long-term potentiation"),
      list(id="04730", name="Long-term depression"),
      list(id="04722", name="Neurotrophin signaling pathway")
    ),
    "5.7 Sensory system" = list(
      list(id="04744", name="Phototransduction"),
      list(id="04740", name="Olfactory transduction"),
      list(id="04742", name="Taste transduction")
    ),
    "5.8 Development and regeneration" = list(
      list(id="04360", name="Axon guidance"),
      list(id="04380", name="Osteoclast differentiation")
    ),
    "5.9 Aging" = list(
      list(id="04211", name="Longevity regulating pathway"),
      list(id="04213", name="Longevity regulating pathway - multiple species")
    ),
    "5.10 Environmental adaptation" = list(
      list(id="04710", name="Circadian rhythm"),
      list(id="04713", name="Circadian entrainment"),
      list(id="04711", name="Circadian rhythm - fly"),
      list(id="04714", name="Thermogenesis")
    )
  ),
  "6. Human Diseases" = list(
    "6.1 Cancer: overview" = list(
      list(id="05200", name="Pathways in cancer"),
      list(id="05202", name="Transcriptional misregulation in cancer"),
      list(id="05206", name="MicroRNAs in cancer"),
      list(id="05205", name="Proteoglycans in cancer"),
      list(id="05230", name="Central carbon metabolism in cancer"),
      list(id="05231", name="Choline metabolism in cancer")
    ),
    "6.2 Cancer: specific types" = list(
      list(id="05210", name="Colorectal cancer"),
      list(id="05212", name="Pancreatic cancer"),
      list(id="05225", name="Hepatocellular carcinoma"),
      list(id="05226", name="Gastric cancer"),
      list(id="05214", name="Glioma"),
      list(id="05216", name="Thyroid cancer"),
      list(id="05221", name="Acute myeloid leukemia"),
      list(id="05220", name="Chronic myeloid leukemia"),
      list(id="05218", name="Melanoma"),
      list(id="05211", name="Renal cell carcinoma"),
      list(id="05219", name="Bladder cancer"),
      list(id="05215", name="Prostate cancer"),
      list(id="05213", name="Endometrial cancer"),
      list(id="05224", name="Breast cancer"),
      list(id="05222", name="Small cell lung cancer"),
      list(id="05223", name="Non-small cell lung cancer")
    ),
    "6.3 Immune diseases" = list(
      list(id="05310", name="Asthma"),
      list(id="05322", name="Systemic lupus erythematosus"),
      list(id="05323", name="Rheumatoid arthritis"),
      list(id="05320", name="Autoimmune thyroid disease"),
      list(id="05321", name="Inflammatory bowel disease"),
      list(id="05330", name="Allograft rejection"),
      list(id="05332", name="Graft-versus-host disease")
    ),
    "6.4 Neurodegenerative diseases" = list(
      list(id="05010", name="Alzheimer disease"),
      list(id="05012", name="Parkinson disease"),
      list(id="05014", name="Amyotrophic lateral sclerosis"),
      list(id="05016", name="Huntington disease"),
      list(id="05017", name="Spinocerebellar ataxia"),
      list(id="05020", name="Prion disease")
    ),
    "6.5 Substance dependence" = list(
      list(id="05030", name="Cocaine addiction"),
      list(id="05031", name="Amphetamine addiction"),
      list(id="05032", name="Morphine addiction"),
      list(id="05033", name="Nicotine addiction"),
      list(id="05034", name="Alcoholism")
    ),
    "6.6 Cardiovascular diseases" = list(
      list(id="05418", name="Fluid shear stress and atherosclerosis"),
      list(id="05410", name="Hypertrophic cardiomyopathy"),
      list(id="05412", name="Arrhythmogenic right ventricular cardiomyopathy"),
      list(id="05414", name="Dilated cardiomyopathy")
    ),
    "6.7 Infectious diseases: bacterial" = list(
      list(id="05120", name="Epithelial cell signaling in Helicobacter pylori infection"),
      list(id="05130", name="Pathogenic Escherichia coli infection"),
      list(id="05132", name="Salmonella infection"),
      list(id="05131", name="Shigellosis"),
      list(id="05135", name="Yersinia infection"),
      list(id="05133", name="Pertussis"),
      list(id="05134", name="Legionellosis"),
      list(id="05150", name="Staphylococcus aureus infection"),
      list(id="05152", name="Tuberculosis"),
      list(id="05100", name="Bacterial invasion of epithelial cells")
    ),
    "6.8 Infectious diseases: viral" = list(
      list(id="05166", name="Human T-cell leukemia virus 1 infection"),
      list(id="05170", name="Human immunodeficiency virus 1 infection"),
      list(id="05161", name="Hepatitis B"),
      list(id="05160", name="Hepatitis C"),
      list(id="05171", name="Coronavirus disease - COVID-19"),
      list(id="05164", name="Influenza A"),
      list(id="05162", name="Measles"),
      list(id="05168", name="Herpes simplex virus 1 infection"),
      list(id="05163", name="Human cytomegalovirus infection"),
      list(id="05169", name="Epstein-Barr virus infection"),
      list(id="05165", name="Human papillomavirus infection")
    ),
    "6.9 Infectious diseases: parasitic" = list(
      list(id="05140", name="Leishmaniasis"),
      list(id="05142", name="Chagas disease"),
      list(id="05143", name="African trypanosomiasis"),
      list(id="05144", name="Malaria"),
      list(id="05145", name="Toxoplasmosis"),
      list(id="05146", name="Amoebiasis")
    )
  )
)
ui <- page_navbar(
  title = "SQMxplore",
  theme = sqm_theme,
  navbar_options = navbar_options(theme = "dark", bg = "#0e4a82"),
  header = tagList(useShinyjs(), tags$head(tags$style(HTML(custom_css)))),
  nav_panel("Project",
    layout_sidebar(fillable = FALSE,
      sidebar = sidebar(width = 300, open = TRUE,
        tags$div(class = "form-label mt-1", "Project directory"),
        shinyDirButton("dir_project", "Select directory", "Choose the project directory",
          multiple = FALSE, class = "btn-default w-100 mb-1"),
        tags$div(class = "path-info", textOutput("path_project", inline = TRUE)),
        uiOutput("project_info_ui"), uiOutput("manual_tables_ui"),
        actionButton("load_project", "Load", class = "btn-primary w-100 mb-2"),
        uiOutput("project_status_ui")
      ),
      tags$div(style = "padding: 1rem;", uiOutput("project_summary_ui"))
    )
  ),
  nav_panel("Plots",
    layout_sidebar(
      sidebar = sidebar(width = 250,
        tags$div(class = "sidebar-box",
          tags$div(class = "form-label", "Plot type"),
          uiOutput("plot_type_ui")
        ),
        uiOutput("plot_controls_ui"),
        tags$div(style = "margin-top:5px;",
          downloadButton("download_plot", "Download PNG", class = "btn-outline-secondary w-100"))
      ),
      card(
        card_header(div(style = "display:flex; justify-content:space-between; align-items:center;",
          span("Visualization"), uiOutput("plot_status_badge"))),
        card_body(class = "p-2", uiOutput("sqm_plot_ui"))
      )
    )
  ),
  nav_panel("Tables",
    layout_sidebar(
      sidebar = sidebar(width = 270,
        uiOutput("tbl_assembly_ui"),
        uiOutput("tbl_taxonomy_ui"),
        uiOutput("tbl_functions_ui"),
        uiOutput("tbl_bins_ui"),

        uiOutput("table_sample_filter"),
        tags$div(style = "margin-top:5px;",
          downloadButton("download_table", "Download CSV", class = "btn-outline-secondary w-100"))
      ),
      card(card_header("Data"), card_body(class = "p-2", DTOutput("data_table")))
    )
  ),
  nav_panel("Krona",
    layout_sidebar(
      sidebar = sidebar(width = 250,
        uiOutput("krona_ktcheck_ui"),
        tags$hr(class = "section-divider"),
        tags$div(class = "form-label mt-1", "Filter samples"),
        uiOutput("krona_sample_filter_ui"),
        tags$hr(class = "section-divider"),
        actionButton("do_krona", "Generate Krona", class = "btn-primary w-100 mt-1"),
        tags$div(style = "margin-top:5px;", uiOutput("krona_download_ui")),
        tags$div(style = "margin-top:10px;", uiOutput("krona_status_ui"))
      ),
      card(
        card_header(div(style = "display:flex; justify-content:space-between; align-items:center;",
          span("Krona Chart"), uiOutput("krona_badge_ui"))),
        card_body(class = "p-0", uiOutput("krona_view_ui"))
      )
    )
  ),
  nav_panel("Pathways",
    layout_sidebar(
      sidebar = sidebar(width = 270,
        uiOutput("pw_pathview_check_ui"),
        tags$hr(class = "section-divider"),
        tags$div(class = "sidebar-box",
          tags$div(class = "form-label", "KEGG Pathway"),
          uiOutput("pw_pathway_select_ui"),
          tags$div(class = "form-label", style = "margin-top:4px;", "Count type"),
          selectInput("pw_count", NULL,
            choices = c("Copy number" = "copy_number", "TPM" = "tpm",
                        "Raw abundances" = "abund", "Percentages" = "percent",
                        "Base counts" = "bases"),
            selected = "copy_number")
        ),
        tags$div(class = "sidebar-box",
          tags$div(class = "form-label", "Mode"),
          radioButtons("pw_mode", NULL,
            choices = c("All samples together" = "together",
                        "One per sample"       = "split",
                        "Fold-change"          = "foldchange"),
            selected = "together"),
          uiOutput("pw_foldchange_ui")
        ),
        tags$div(class = "sidebar-box",
          checkboxInput("pw_log_scale", "Log scale", value = FALSE)
        ),
        tags$hr(class = "section-divider"),
        actionButton("do_pathway", "Generate map", class = "btn-primary w-100 mt-1"),
        tags$div(style = "margin-top:5px;", uiOutput("pw_download_ui")),
        tags$div(style = "margin-top:10px;", uiOutput("pw_status_ui"))
      ),
      card(
        card_header(div(style = "display:flex; justify-content:space-between; align-items:center;",
          span("KEGG Pathway Map"), uiOutput("pw_badge_ui"))),
        card_body(class = "p-2", uiOutput("pw_view_ui"))
      )
    )
  ),
  nav_panel("Multivariate",
    layout_sidebar(
      sidebar = sidebar(width = 270,
        uiOutput("mv_sidebar_controls"),
        tags$hr(class = "section-divider"),
        actionButton("do_pca", "Run analysis", class = "btn-primary w-100"),
        tags$div(style = "margin-top:5px;", uiOutput("mv_download_ui")),
        tags$div(style = "margin-top:10px;", uiOutput("mv_status_ui"))
      ),
      card(
        card_header(div(style = "display:flex; justify-content:space-between; align-items:center;",
          uiOutput("mv_card_title_ui"), uiOutput("mv_badge_ui"))),
        card_body(class = "p-2",
          tags$div(
            style = "display:flex; gap:8px; align-items:center; margin-bottom:6px; flex-wrap:wrap; padding:2px;",
            tags$div(style = "font-size:0.75rem; color:var(--muted); white-space:nowrap;", "W:"),
            numericInput("mv_plot_width",  NULL, value = 700, min = 300, max = 1600, step = 50, width = "75px"),
            tags$div(style = "font-size:0.75rem; color:var(--muted); white-space:nowrap;", "H:"),
            numericInput("mv_plot_height", NULL, value = 500, min = 200, max = 1200, step = 50, width = "75px"),
            tags$div(style = "font-size:0.75rem; color:var(--muted); white-space:nowrap;", "Font:"),
            numericInput("mv_font_size",   NULL, value = 11,  min = 6,   max = 24,   step = 1,  width = "65px"),
            uiOutput("mv_feat_labels_ui")
          ),
          uiOutput("mv_plot_ui")
        )
      )
    )
  )
)
server <- function(input, output, session) {
  roots        <- c(home = normalizePath("~"), root = "/")
  sqm_data     <- reactiveVal(NULL)
  status       <- reactiveVal("idle")
  tables_path  <- reactiveVal(NULL)
  need_manual  <- reactiveVal(FALSE)
  creator_name <- reactiveVal(NULL)
  is_sqm_full  <- reactiveVal(FALSE)

  # ── Dynamic plot type selector — only shows available options ──
  output$plot_type_ui <- renderUI({
    proj <- sqm_data()
    choices <- if (is.null(proj)) {
      c("Taxonomy (barplot)" = "taxonomy_bar")
    } else {
      available_plot_types(proj)
    }
    cur <- isolate(input$plot_type)
    selected <- if (!is.null(cur) && cur %in% choices) cur else choices[[1]]
    selectInput("plot_type", NULL, choices = choices, selected = selected)
  })

  # ── Dynamic table type selector — only shows available options ──
  # ── Build each category box (only shown when choices exist) ──
  make_table_box <- function(label, input_id, choices) {
    if (length(choices) == 0) return(NULL)
    tags$div(class = "sidebar-box", style = "margin-bottom:6px;",
      tags$div(class = "form-label", label),
      selectInput(input_id, NULL, choices = choices)
    )
  }

  output$tbl_assembly_ui <- renderUI({
    req(sqm_data())
    ch <- avail_assembly(sqm_data())
    make_table_box("Assembly", "tbl_assembly", ch)
  })
  output$tbl_taxonomy_ui <- renderUI({
    req(sqm_data()); proj <- sqm_data()
    ch <- avail_taxonomy(proj)
    if (length(ch) == 0) return(NULL)
    # Default rank for metric detection
    rank0 <- sub("^tax_", "", ch[[1]])
    metrics <- avail_tax_metrics(proj, rank0)
    tags$div(class = "sidebar-box", style = "margin-bottom:6px;",
      tags$div(class = "form-label", "Taxonomy"),
      selectInput("tbl_taxonomy", NULL, choices = ch),
      tags$div(class = "form-label", style = "margin-top:4px;", "Metric"),
      selectInput("tbl_tax_metric", NULL, choices = metrics,
                  selected = if ("percent" %in% metrics) "percent" else metrics[[1]])
    )
  })
  output$tbl_functions_ui <- renderUI({
    req(sqm_data()); proj <- sqm_data()
    ch <- avail_functions(proj)
    if (length(ch) == 0) return(NULL)
    db0 <- toupper(sub("^fun_", "", ch[[1]]))
    metrics <- avail_fun_metrics(proj, db0)
    tags$div(class = "sidebar-box", style = "margin-bottom:6px;",
      tags$div(class = "form-label", "Functions"),
      selectInput("tbl_functions", NULL, choices = ch),
      tags$div(class = "form-label", style = "margin-top:4px;", "Metric"),
      selectInput("tbl_fun_metric", NULL, choices = metrics,
                  selected = if ("abund" %in% metrics) "abund" else metrics[[1]])
    )
  })
  output$tbl_bins_ui <- renderUI({
    req(sqm_data())
    if (length(avail_bins(sqm_data())) == 0) return(NULL)
    tags$div(class = "sidebar-box", style = "margin-bottom:6px;",
      tags$div(class = "form-label", "Bins"),
      actionButton("tbl_bins_btn", "Bins table",
        class = "btn-default w-100",
        style = "font-size:0.75rem; font-family:'IBM Plex Sans',sans-serif; font-weight:400; height:26px; padding:2px 8px; text-align:left; letter-spacing:0;")
    )
  })

  # ── active_table: a reactiveVal updated by each selector.
  #    assembly/taxonomy/functions use ignoreInit=TRUE (multi-option selectors).
  #    bins uses a dedicated actionButton to avoid the single-option problem.
  active_tbl_rv <- reactiveVal("none")

  observeEvent(input$tbl_assembly,  ignoreNULL=TRUE, ignoreInit=TRUE,
    { active_tbl_rv(input$tbl_assembly) })
  observeEvent(input$tbl_taxonomy,  ignoreNULL=TRUE, ignoreInit=TRUE, {
    active_tbl_rv(input$tbl_taxonomy)
    # Update metric choices for new rank
    proj <- sqm_data(); req(proj)
    rank <- sub("^tax_", "", input$tbl_taxonomy)
    metrics <- avail_tax_metrics(proj, rank)
    cur <- isolate(input$tbl_tax_metric)
    sel <- if (!is.null(cur) && cur %in% metrics) cur else
           if ("percent" %in% metrics) "percent" else metrics[[1]]
    updateSelectInput(session, "tbl_tax_metric", choices = metrics, selected = sel)
  })
  observeEvent(input$tbl_functions, ignoreNULL=TRUE, ignoreInit=TRUE, {
    active_tbl_rv(input$tbl_functions)
    # Update metric choices for new DB
    proj <- sqm_data(); req(proj)
    db <- toupper(sub("^fun_", "", input$tbl_functions))
    metrics <- avail_fun_metrics(proj, db)
    cur <- isolate(input$tbl_fun_metric)
    sel <- if (!is.null(cur) && cur %in% metrics) cur else
           if ("abund" %in% metrics) "abund" else metrics[[1]]
    updateSelectInput(session, "tbl_fun_metric", choices = metrics, selected = sel)
  })
  observeEvent(input$tbl_bins_btn,  ignoreNULL=TRUE, ignoreInit=TRUE,
    { active_tbl_rv("bins") })

  # Initialise on project load
  observeEvent(sqm_data(), {
    proj <- sqm_data(); req(proj)
    first <- c(avail_assembly(proj), avail_taxonomy(proj),
               avail_functions(proj), avail_bins(proj))
    if (length(first) > 0) active_tbl_rv(first[[1]])
  })

  active_table <- reactive({ active_tbl_rv() })

  shinyDirChoose(input, "dir_project",       roots = roots)
  shinyDirChoose(input, "dir_manual_tables", roots = roots)
  path_project <- reactive({ req(input$dir_project); parseDirPath(roots, input$dir_project) })
  output$path_project <- renderText({ tryCatch(path_project(), error = function(e) "") })
  observeEvent(path_project(), {
    proj_dir <- path_project(); req(nchar(proj_dir) > 0)
    need_manual(FALSE); tables_path(NULL); creator_name(NULL)
    creator_file <- file.path(proj_dir, "creator.txt")
    if (file.exists(creator_file)) {
      creator <- trimws(readLines(creator_file, n = 1, warn = FALSE))
      creator_name(creator)
      if (grepl("SqueezeMeta", creator, ignore.case = TRUE)) {
        tables_path(proj_dir)
      } else {
        tp <- file.path(proj_dir, "tables")
        if (dir.exists(tp)) tables_path(tp) else need_manual(TRUE)
      }
    } else {
      need_manual(TRUE)
      showNotification("creator.txt not found. Please select the tables directory manually.",
        type = "warning", duration = 6)
    }
  })
  observeEvent(input$dir_manual_tables, {
    tp <- tryCatch(parseDirPath(roots, input$dir_manual_tables), error = function(e) NULL)
    req(tp); if (nchar(tp) > 0) { tables_path(tp); need_manual(FALSE) }
  })
  output$project_info_ui <- renderUI({
    req(path_project())
    proj_dir <- path_project()
    creator_file <- file.path(proj_dir, "creator.txt")
    creator_txt <- if (file.exists(creator_file)) trimws(readLines(creator_file, n=1, warn=FALSE)) else "unknown"
    tp <- tables_path()
    tagList(
      tags$div(class = "path-info",
        tags$span(style = "color:#7a90a8;", "Created by: "),
        tags$span(style = "color:#1a6eb5; font-weight:600;", creator_txt)),
      if (!is.null(tp)) tags$div(class = "path-info",
        tags$span(style = "color:#7a90a8;", "Tables: "), tp,
        if (dir.exists(tp)) tags$span(style = "color:#1a9e6e; margin-left:4px;", "\u2713")
        else tags$span(style = "color:#c0392b; margin-left:4px;", "\u2715 not found"))
    )
  })
  output$manual_tables_ui <- renderUI({
    req(need_manual())
    tagList(
      tags$div(class = "path-info", style = "color:#c0392b;", "Tables directory could not be found automatically."),
      tags$div(class = "form-label", "Select tables directory"),
      shinyDirButton("dir_manual_tables", "Select tables", "Choose the tables directory",
        multiple = FALSE, class = "btn-default w-100 mb-1")
    )
  })
  observeEvent(input$load_project, {
    tp <- tables_path()
    if (is.null(tp) || !dir.exists(tp)) {
      showNotification("Directory not available. Please select it manually.", type = "error", duration = 8); return()
    }
    status("loading")
    tryCatch({
      is_sqm <- grepl("SqueezeMeta", creator_name() %||% "", ignore.case = TRUE)
      proj <- if (is_sqm) loadSQM(tp) else loadSQMlite(tp)
      sqm_data(proj); is_sqm_full(is_sqm); status("ready")



    }, error = function(e) { status("error"); showNotification(paste("Error:", e$message), type = "error", duration = 8) })
  })
  output$project_status_ui <- renderUI({
    s <- status()
    col <- switch(s, idle="#7a90a8", loading="#3b9ede", ready="#1a9e6e", error="#c0392b")
    ico <- switch(s, idle="\u25cb", loading="\u25cc", ready="\u25cf", error="\u2715")
    tags$div(style="font-size:0.8rem;",
      tags$span(style=paste0("color:",col,"; margin-right:5px;"), ico),
      tags$span(style="color:#7a90a8;", "Status: "),
      tags$span(style=paste0("color:",col,"; font-weight:600;"), toupper(s)))
  })
  parse_tsv_block <- function(lines) {
    lines <- lines[nchar(trimws(lines)) > 0]; if (length(lines)==0) return(NULL)
    split_line <- function(l) trimws(unlist(strsplit(sub("^\t","",l),"\t")))
    rows <- lapply(lines, split_line); max_cols <- max(sapply(rows, length))
    rows <- lapply(rows, function(r){length(r)<-max_cols; r[is.na(r)]<-""; r})
    as.data.frame(do.call(rbind, rows), stringsAsFactors=FALSE)
  }
  make_html_table <- function(df) {
    if (is.null(df)||nrow(df)<2) return(NULL)
    header <- as.character(df[1,]); body <- df[-1,,drop=FALSE]
    th_cells <- paste0('<th>',ifelse(header=="","",header),'</th>',collapse="")
    tr_rows <- apply(body,1,function(row) paste0('<tr>',paste0('<td>',row,'</td>',collapse=""),'</tr>'))
    HTML(paste0('<table class="sqm-table"><thead><tr>',th_cells,'</tr></thead><tbody>',paste(tr_rows,collapse=""),'</tbody></table>'))
  }
  make_kv_table <- function(lines) {
    rows <- lapply(lines, function(l) {
      l <- sub("^\t+","",l); parts <- strsplit(l,"\t")[[1]]
      if(length(parts)>=2) tags$tr(tags$td(trimws(sub(":$","",parts[1]))), tags$td(trimws(parts[2])))
    })
    rows <- Filter(Negate(is.null), rows); if(length(rows)==0) return(NULL)
    tags$table(class="sqm-table", tags$thead(tags$tr(tags$th("Metric"),tags$th("Value"))), tags$tbody(tagList(rows)))
  }
  make_taxcov_table <- function(lines) {
    rows <- lapply(lines, function(l) {
      l <- sub("^\t+","",l); parts <- strsplit(l,"\t")[[1]]
      if(length(parts)>=2) tags$tr(tags$td(trimws(sub(":$","",parts[1]))), tags$td(trimws(parts[2])))
    })
    rows <- Filter(Negate(is.null), rows); if(length(rows)==0) return(NULL)
    tags$table(class="sqm-table", tags$thead(tags$tr(tags$th("Rank"),tags$th("Value"))), tags$tbody(tagList(rows)))
  }
  sqm_section <- function(title, ...) tags$div(class="sqm-section",
    tags$div(class="sqm-section-header",title), tags$div(class="sqm-section-body",...))
  output$project_summary_ui <- renderUI({
    proj <- sqm_data()
    if (is.null(proj)) return(tags$div(style="color:var(--muted);font-size:0.85rem;padding:1rem;","No project loaded yet."))

    panels <- list()

    # ── Project name badge (both SQM and SQMlite) ──
    project_name <- tryCatch(proj$misc$project_name %||% "", error=function(e) "")
    if (nchar(project_name)>0) panels[["name"]] <- tags$div(
      style="margin-bottom:12px;display:flex;align-items:center;gap:10px;",
      tags$span(style="font-family:'IBM Plex Mono',monospace;font-size:0.75rem;color:var(--muted);text-transform:uppercase;letter-spacing:0.06em;","Project"),
      tags$span(class="project-badge",style="font-size:0.85rem;padding:3px 10px;",project_name))

    if (is_sqm_full()) {
      # ── Full SQM: parse capture.output(summary()) ──
      raw <- tryCatch(capture.output(summary(proj)), error=function(e) NULL)
      if (!is.null(raw)) {
        sections <- list(); current <- NULL; buf <- c(); sep_pat <- "^\\s*-{5,}\\s*$"
        for (ln in raw) {
          if (grepl("BASE PROJECT NAME:",ln)||grepl(sep_pat,ln)) next
          sec_match <- regmatches(ln, regexpr("^\\t([A-Za-z][A-Za-z0-9 /]+):\\s*$",ln))
          if (length(sec_match)>0) {
            if(!is.null(current)) sections[[current]]<-buf
            current<-trimws(sub(":","",sub("^\t","",sec_match))); buf<-c()
          } else buf <- c(buf,ln)
        }
        if (!is.null(current)) sections[[current]] <- buf
        reads_key <- names(sections)[tolower(names(sections))=="reads"]
        if (length(reads_key)>0) {
          lines <- sections[[reads_key[1]]]; data_lines <- lines[nchar(trimws(lines))>0]
          if (length(data_lines)>=2) {
            df <- parse_tsv_block(c(sub("^\t\t","\tMetric\t",data_lines[1]), data_lines[-1]))
            df[,1] <- sub("^Mapping to ORFs$","Reads with ORFs",df[,1])
            df[,1] <- sub("^Percent$","Percent of reads with ORFs",df[,1])
            desired <- c("Input reads","Reads with ORFs","Percent of reads with ORFs")
            body <- df[-1,,drop=FALSE]; body <- body[match(desired,body[,1]),,drop=FALSE]; body <- body[!is.na(body[,1]),,drop=FALSE]
            panels[["READS"]] <- sqm_section("Reads", make_html_table(rbind(df[1,,drop=FALSE],body)))
          }
        }
        contigs_key <- names(sections)[tolower(names(sections))=="contigs"]
        if (length(contigs_key)>0) {
          lines <- sections[[contigs_key[1]]]; lines <- lines[nchar(trimws(lines))>0]
          kv_lines <- lines[grepl(":\t",lines)&!grepl("\t\t",lines)&sapply(strsplit(lines,"\t"),function(x) sum(nchar(trimws(x))>0))==2]
          abund_start <- which(grepl("Most abundant taxa",lines)); abund_lines <- c()
          if (length(abund_start)>0) { abund_lines <- lines[(abund_start+1):length(lines)]; abund_lines <- abund_lines[nchar(trimws(abund_lines))>0] }
          tax_ranks <- c("Superkingdom","Phylum","Class","Order","Family","Genus","Species")
          tax_rank_pat <- paste0("^\t(",paste(tax_ranks,collapse="|"),"):\t")
          is_tax_kv <- grepl(tax_rank_pat,kv_lines)
          body_parts <- list()
          if (length(kv_lines[!is_tax_kv])>0) body_parts[["kv"]] <- make_kv_table(kv_lines[!is_tax_kv])
          if (length(kv_lines[is_tax_kv])>0) {
            body_parts[["taxcovlabel"]]<-tags$div(class="sqm-subsection-label","Taxonomic classification")
            body_parts[["taxcov"]]<-make_taxcov_table(kv_lines[is_tax_kv])
          }
          if (length(abund_lines)>=2) {
            body_parts[["abundlabel"]] <- tags$div(class="sqm-subsection-label","Most abundant taxa")
            df_abund <- parse_tsv_block(c(sub("^\t\t","\tRank\t",abund_lines[1]),abund_lines[-1]))
            species_rows <- which(trimws(df_abund[-1,1])=="Species")+1
            if (length(species_rows)>0) for(ri in species_rows) df_abund[ri,-1]<-paste0("<em>",df_abund[ri,-1],"</em>")
            body_parts[["abund"]] <- make_html_table(df_abund)
          }
          panels[["CONTIGS"]] <- sqm_section("Contigs", tagList(body_parts))
        }
        orfs_key <- names(sections)[tolower(names(sections))=="orfs"]
        if (length(orfs_key)>0) {
          lines <- sections[[orfs_key[1]]]; data_lines <- lines[nchar(trimws(lines))>0]
          if (length(data_lines)>=2) panels[["ORFS"]] <- sqm_section("ORFs",
            make_html_table(parse_tsv_block(c(sub("^\t\t","\tMetric\t",data_lines[1]),data_lines[-1]))))
        }
      }
    } else {
      # ── SQMlite: capture.output(summary()) produces tab-delimited text
      # Format:
      #   BASE PROJECT NAME: ...
      #   \t\tS1\tS2\t...          <- sample header
      #   TOTAL READS\t...\t...
      #   TOTAL ORFs\t...\t...
      #   ---...---
      #   TAXONOMY:
      #   Classified reads:
      #   \t\tS1\tS2\t...
      #   Superkingdom\t...\t...
      #   ...
      #   Most abundant taxa (ignoring Unclassified):
      #   \t\tS1\tS2\t...
      #   Superkingdom\tval\t...
      #   ...
      #   ---...---
      #   FUNCTIONS:
      #   Classified ORFs:
      #   \t\tS1\tS2\t...
      #   KEGG\t...\t...
      #   COG\t...\t...

      raw <- tryCatch(capture.output(summary(proj)), error = function(e) NULL)
      if (!is.null(raw)) {
        sep_pat <- "^\\s*-{5,}\\s*$"
        raw <- raw[!grepl(sep_pat, raw)]  # strip separator lines

        # ── Helper: parse a block of tab lines into header + body df ──
        parse_lite_block <- function(lines) {
          lines <- lines[nchar(trimws(lines)) > 0]
          if (length(lines) < 2) return(NULL)
          # First line is the sample header: "\t\tS1\tS2\t..."
          hdr   <- trimws(unlist(strsplit(sub("^\t\t?", "", lines[1]), "\t")))
          body  <- do.call(rbind, lapply(lines[-1], function(l) {
            parts <- unlist(strsplit(l, "\t"))
            # first element may be empty if line starts with \t
            if (parts[1] == "") parts <- parts[-1]
            length(parts) <- length(hdr) + 1
            parts[is.na(parts)] <- ""
            parts
          }))
          df <- as.data.frame(body, stringsAsFactors = FALSE)
          colnames(df) <- c("Metric", hdr)
          df
        }

        # ── Extract project name ──
        name_line <- grep("BASE PROJECT NAME:", raw, value = TRUE)
        if (length(name_line) > 0 && nchar(project_name) == 0) {
          project_name <- trimws(sub(".*BASE PROJECT NAME:\\s*", "", name_line[1]))
          # update badge if not already set
          panels[["name"]] <- tags$div(
            style = "margin-bottom:12px;display:flex;align-items:center;gap:10px;",
            tags$span(style = "font-family:'IBM Plex Mono',monospace;font-size:0.75rem;color:var(--muted);text-transform:uppercase;letter-spacing:0.06em;", "Project"),
            tags$span(class = "project-badge", style = "font-size:0.85rem;padding:3px 10px;", project_name))
        }

        # ── Overview block: TOTAL READS + TOTAL ORFs ──
        # Lines before the first section header (TAXONOMY: / FUNCTIONS:)
        first_sec <- grep("^\\t?(TAXONOMY|FUNCTIONS):", raw)
        overview_lines <- if (length(first_sec) > 0) raw[seq_len(first_sec[1] - 1)] else raw
        # Keep only lines with numeric data (contain digits after a tab)
        data_lines <- overview_lines[grepl("^\t", overview_lines) & grepl("[0-9]", overview_lines)]
        # Find sample header line (\t\t...)
        hdr_idx <- which(grepl("^\t\t", overview_lines))
        if (length(hdr_idx) > 0 && length(data_lines) > 0) {
          hdr_line  <- overview_lines[hdr_idx[1]]
          hdr_parts <- trimws(unlist(strsplit(sub("^\t\t?", "", hdr_line), "\t")))
          tbl_rows <- lapply(data_lines, function(l) {
            parts <- unlist(strsplit(sub("^\t", "", l), "\t"))
            length(parts) <- length(hdr_parts) + 1
            parts[is.na(parts)] <- ""
            tags$tr(tagList(lapply(parts, tags$td)))
          })
          th_cells <- tagList(c(list(tags$th("Metric")), lapply(hdr_parts, tags$th)))
          panels[["OVERVIEW"]] <- sqm_section("Overview",
            tags$table(class = "sqm-table",
              tags$thead(tags$tr(th_cells)),
              tags$tbody(tagList(tbl_rows))))
        }

        # ── TAXONOMY section ──
        tax_start <- grep("^\\t?TAXONOMY:", raw)
        fun_start <- grep("^\\t?FUNCTIONS:", raw)
        if (length(tax_start) > 0) {
          tax_end  <- if (length(fun_start) > 0) fun_start[1] - 1 else length(raw)
          tax_body <- raw[(tax_start[1] + 1):tax_end]

          # Classified reads sub-block
          cr_start <- grep("Classified reads", tax_body)
          ma_start <- grep("Most abundant taxa", tax_body)

          tax_panels <- list()

          if (length(cr_start) > 0) {
            cr_end   <- if (length(ma_start) > 0) ma_start[1] - 1 else length(tax_body)
            cr_lines <- tax_body[(cr_start[1] + 1):cr_end]
            cr_lines <- cr_lines[nchar(trimws(cr_lines)) > 0]
            cr_df    <- parse_lite_block(c(cr_lines[grepl("^\t\t", cr_lines)][1],
                                           cr_lines[!grepl("^\t\t", cr_lines)]))
            if (!is.null(cr_df)) {
              cr_rows <- apply(cr_df, 1, function(r) tags$tr(tagList(lapply(r, tags$td))))
              th_cr   <- tagList(c(list(tags$th("Rank")), lapply(colnames(cr_df)[-1], tags$th)))
              tax_panels[["cr_lbl"]] <- tags$div(class = "sqm-subsection-label", "Classified reads")
              tax_panels[["cr"]] <- tags$table(class = "sqm-table",
                tags$thead(tags$tr(th_cr)), tags$tbody(tagList(cr_rows)))
            }
          }

          if (length(ma_start) > 0) {
            ma_lines <- tax_body[(ma_start[1] + 1):length(tax_body)]
            ma_lines <- ma_lines[nchar(trimws(ma_lines)) > 0]
            ma_df    <- parse_lite_block(c(ma_lines[grepl("^\t\t", ma_lines)][1],
                                           ma_lines[!grepl("^\t\t", ma_lines)]))
            if (!is.null(ma_df)) {
              # italicise species row
              sp_row <- which(trimws(ma_df[, 1]) == "Species")
              if (length(sp_row) > 0)
                ma_df[sp_row, -1] <- lapply(ma_df[sp_row, -1], function(v) paste0("<em>", v, "</em>"))
              ma_rows <- apply(ma_df, 1, function(r) tags$tr(tagList(lapply(r, tags$td))))
              th_ma   <- tagList(c(list(tags$th("Rank")), lapply(colnames(ma_df)[-1], tags$th)))
              tax_panels[["ma_lbl"]] <- tags$div(class = "sqm-subsection-label", "Most abundant taxa (ignoring Unclassified)")
              tax_panels[["ma"]] <- tags$table(class = "sqm-table",
                tags$thead(tags$tr(th_ma)), tags$tbody(tagList(ma_rows)))
            }
          }

          if (length(tax_panels) > 0)
            panels[["TAXONOMY"]] <- sqm_section("Taxonomy", tagList(tax_panels))
        }

        # ── FUNCTIONS section ──
        if (length(fun_start) > 0) {
          fun_body <- raw[(fun_start[1] + 1):length(raw)]
          fun_body <- fun_body[nchar(trimws(fun_body)) > 0]
          # Remove "Classified ORFs:" label line
          fun_body <- fun_body[!grepl("Classified ORFs", fun_body)]
          fun_df   <- parse_lite_block(c(fun_body[grepl("^\t\t", fun_body)][1],
                                         fun_body[!grepl("^\t\t", fun_body)]))
          if (!is.null(fun_df)) {
            fun_rows <- apply(fun_df, 1, function(r) tags$tr(tagList(lapply(r, tags$td))))
            th_fun   <- tagList(c(list(tags$th("Database")), lapply(colnames(fun_df)[-1], tags$th)))
            panels[["FUNCTIONS"]] <- sqm_section("Functions",
              tags$div(class = "sqm-subsection-label", "Classified ORFs"),
              tags$table(class = "sqm-table",
                tags$thead(tags$tr(th_fun)), tags$tbody(tagList(fun_rows))))
          }
        }

        panels[["note"]] <- tags$div(
          style = "font-size:0.75rem;color:var(--muted);margin-top:8px;font-family:'IBM Plex Mono',monospace;",
          "\u2139 Loaded as SQMlite \u2014 contig, ORF and bin details not available.")
      }
    }

    # ── Samples (both object types) ──
    samples <- tryCatch(proj$samples, error=function(e) NULL)
    if (!is.null(samples)) panels[["samples"]] <- sqm_section("Samples",
      tags$div(style="padding-top:2px;", tagList(lapply(samples,function(s) tags$span(class="project-badge",s)))))

    tagList(panels)
  })
  output$plot_controls_ui <- renderUI({
    pt <- input$plot_type; if (is.null(pt)) return(NULL)
    rank_choices <- c("Phylum"="phylum","Class"="class","Order"="order","Family"="family","Genus"="genus","Species"="species")
    if (pt == "taxonomy_bar") {
      tax_counts <- if (!is.null(sqm_data())) available_tax_counts(sqm_data()) else c("Percentage (percent)"="percent")
      avail_ranks <- if (!is.null(sqm_data())) available_tax_ranks(sqm_data()) else rank_choices
      tagList(
        tags$div(class="sidebar-box",
          tags$div(class="form-label","Taxonomic rank"), selectInput("tax_rank",NULL,choices=avail_ranks),
          if (is_sqm_full()) tagList(
            tags$div(class="form-label",style="margin-top:4px;","Search taxa"),
            tags$div(class="func-search-box", tags$span(class="search-icon","\U0001f50d"),
              textInput("tax_search",NULL,placeholder="")),
            tags$div(class="func-search-hint","Comma-separated. Empty \u2192 top N taxa."),
            uiOutput("tax_search_status")
          ) else tags$div(class="func-search-hint",style="color:#c0392b;","\u26a0 Taxonomy search requires a full SQM object.")
        ),
        tags$div(class="sidebar-box",style="margin-top:8px;",
          tags$div(class="form-label","Count type"),
          selectInput("tax_count",NULL,choices=tax_counts,selected=if("percent"%in%tax_counts)"percent" else tax_counts[[1]]),
          tags$div(class="form-label",style="margin-top:4px;","No. of taxa"),
          numericInput("n_taxa",NULL,value=15,min=1,max=200,step=1)
        ),
        tags$div(class="sidebar-box",style="margin-top:8px;",
          tags$div(style="display:grid;grid-template-columns:1fr 1fr;gap:0;",
            checkboxInput("tax_ignore_unmapped","Ignore unmapped",value=FALSE),
            checkboxInput("tax_ignore_unclassified","Ignore unclassified",value=FALSE),
            checkboxInput("tax_no_partial_classifications","No partial classif.",value=FALSE),
            checkboxInput("tax_rescale","Rescale",value=FALSE)
          )
        ),
        tags$div(class="sidebar-box",style="margin-top:8px;",
          tags$div(style="font-family:'IBM Plex Mono',monospace;font-size:0.68rem;font-weight:600;letter-spacing:0.08em;text-transform:uppercase;color:var(--blue);margin-bottom:5px;","Format plot"),
          tags$div(style="display:grid;grid-template-columns:1fr 1fr;gap:4px;",
            tags$div(tags$div(class="form-label","Width (px)"),  numericInput("tax_plot_width", NULL,value=800,min=200,max=3000,step=50)),
            tags$div(tags$div(class="form-label","Height (px)"), numericInput("tax_plot_height",NULL,value=560,min=200,max=3000,step=50))
          ),
          tags$div(class="form-label",style="margin-top:4px;","Max scale value"),
          numericInput("tax_max_scale_value",NULL,value=NA,min=0,step=1),
          tags$div(class="form-label",style="margin-top:4px;","Font size"),
          numericInput("tax_base_size",NULL,value=11,min=6,max=24,step=1)
        )
      )
    } else if (pt %in% c("func_cog","func_kegg","func_pfam")) {
      fun_label <- switch(pt,func_cog="COG",func_kegg="KEGG",func_pfam="PFAM")
      tagList(
        tags$div(class="sidebar-box",
          if (is_sqm_full()) tagList(
            tags$div(class="form-label",paste("Search",fun_label,"functions")),
            tags$div(class="func-search-box", tags$span(class="search-icon","\U0001f50d"),
              textInput("func_search",NULL,placeholder=paste0("e.g. ",switch(pt,func_cog="COG0001, transport",func_kegg="K00001, ribosome",func_pfam="PF00001, kinase")))),
            tags$div(class="func-search-hint","Comma-separated. Empty \u2192 top N functions."),
            uiOutput("func_search_status")
          ) else tags$div(class="func-search-hint",style="color:#c0392b;","\u26a0 Function search requires a full SQM object.")
        ),
        tags$div(class="sidebar-box",style="margin-top:8px;",
          tags$div(class="form-label","Count type"), uiOutput("func_count_ui"),
          tags$div(class="form-label",style="margin-top:4px;","No. of functions"), uiOutput("n_funcs_ui")
        ),
        tags$div(class="sidebar-box",style="margin-top:8px;",
          tags$div(style="font-family:'IBM Plex Mono',monospace;font-size:0.68rem;font-weight:600;letter-spacing:0.08em;text-transform:uppercase;color:var(--blue);margin-bottom:5px;","Format plot"),
          tags$div(style="display:grid;grid-template-columns:1fr 1fr;gap:4px;",
            tags$div(tags$div(class="form-label","Width (px)"),  numericInput("func_plot_width", NULL,value=800,min=200,max=3000,step=50)),
            tags$div(tags$div(class="form-label","Height (px)"), numericInput("func_plot_height",NULL,value=560,min=200,max=3000,step=50))
          ),
          tags$div(class="form-label",style="margin-top:4px;","Font size"),
          numericInput("func_base_size",NULL,value=11,min=6,max=24,step=1)
        )
      )
    } else NULL
  })
  output$func_search_status <- renderUI({
    pt <- input$plot_type; req(pt %in% c("func_cog","func_kegg","func_pfam")); req(sqm_data())
    pattern <- build_func_pattern(input$func_search %||% ""); if (is.null(pattern)) return(NULL)
    fun_level <- switch(pt,func_cog="COG",func_kegg="KEGG",func_pfam="PFAM")
    n <- tryCatch({ ps <- subsetFun(sqm_data(),fun=pattern,ignore_case=TRUE,fixed=FALSE); nrow(ps$functions[[fun_level]]$abund) }, error=function(e) 0L)
    if (n==0) tags$div(class="func-nomatch-badge","\u2715 No matches")
    else tags$div(class="func-match-badge",paste0("\u2713 ",n," function",if(n!=1)"s" else ""))
  })
  output$tax_search_status <- renderUI({
    req(input$plot_type=="taxonomy_bar"); req(sqm_data())
    search_text <- trimws(input$tax_search %||% ""); if (nchar(search_text)==0) return(NULL)
    rank <- input$tax_rank %||% "phylum"
    all_taxa <- tryCatch(rownames(sqm_data()$taxa[[rank]]$abund), error=function(e) character(0))
    terms <- trimws(unlist(strsplit(search_text,"[,;]+")));  terms <- terms[nchar(terms)>0]
    matched <- unique(unlist(lapply(terms,function(t) all_taxa[grepl(t,all_taxa,ignore.case=TRUE)])))
    if (length(matched)==0) tags$div(class="func-nomatch-badge","\u2715 No matches")
    else tags$div(class="func-match-badge",paste0("\u2713 ",length(matched)," taxon",if(length(matched)!=1)"a" else ""))
  })
  output$n_funcs_ui   <- renderUI({ numericInput("n_funcs",NULL,value=20,min=1,max=200,step=1) })
  output$func_count_ui <- renderUI({
    pt <- input$plot_type; req(pt %in% c("func_cog","func_kegg","func_pfam"))
    fun_level <- switch(pt,func_cog="COG",func_kegg="KEGG",func_pfam="PFAM")
    counts <- if (!is.null(sqm_data())) available_func_counts(sqm_data(),fun_level) else c("Copy number"="copy_number")
    selectInput("func_count",NULL,choices=counts,selected=if("copy_number"%in%counts)"copy_number" else counts[[1]])
  })
  output$sqm_plot_ui <- renderUI({
    pt <- input$plot_type
    is_tax  <- !is.null(pt) && pt=="taxonomy_bar"
    is_func <- !is.null(pt) && pt %in% c("func_cog","func_kegg","func_pfam")
    h <- if(is_tax) input$tax_plot_height %||% 560 else if(is_func) input$func_plot_height %||% 560 else 560
    w <- if(is_tax) input$tax_plot_width  %||% 800 else if(is_func) input$func_plot_width  %||% 800 else NULL
    style <- if(!is.null(w)) paste0("width:",w,"px; overflow-x:auto;") else "width:100%;"
    tags$div(style=style,
      plotOutput("sqm_plot", width=if(!is.null(w)) paste0(w,"px") else "100%", height=paste0(h,"px")))
  })
  plot_reactive <- reactive({
    req(sqm_data()); proj <- sqm_data(); pt <- input$plot_type
    req(!is.null(pt) && pt != "none")
    if (pt=="taxonomy_bar") {
      search_text <- if(is_sqm_full()) trimws(input$tax_search %||% "") else ""
      if (nchar(search_text)>0) {
        rank <- input$tax_rank %||% "phylum"
        all_taxa <- tryCatch(rownames(proj$taxa[[rank]]$abund),error=function(e) character(0))
        terms <- trimws(unlist(strsplit(search_text,"[,;]+")));  terms <- terms[nchar(terms)>0]
        matched <- unique(unlist(lapply(terms,function(t) all_taxa[grepl(t,all_taxa,ignore.case=TRUE)])))
        if (length(matched)==0) { showNotification(paste0("No taxa found matching: \"",search_text,"\""),type="warning",duration=5); return(NULL) }
        proj_sub <- tryCatch(subsetTax(proj,rank=rank,tax=matched),error=function(e) NULL)
        if (is.null(proj_sub)) { showNotification("subsetTax failed.",type="error",duration=5); return(NULL) }
        plotTaxonomy(proj_sub,rank=rank,count=input$tax_count,N=input$n_taxa,base_size=input$tax_base_size %||% 11,
          ignore_unmapped=isTRUE(input$tax_ignore_unmapped),ignore_unclassified=isTRUE(input$tax_ignore_unclassified),
          no_partial_classifications=isTRUE(input$tax_no_partial_classifications),rescale=isTRUE(input$tax_rescale),
          max_scale_value=if(is.na(input$tax_max_scale_value)) NULL else input$tax_max_scale_value)
      } else {
        plotTaxonomy(proj,rank=input$tax_rank,count=input$tax_count,N=input$n_taxa,base_size=input$tax_base_size %||% 11,
          ignore_unmapped=isTRUE(input$tax_ignore_unmapped),ignore_unclassified=isTRUE(input$tax_ignore_unclassified),
          no_partial_classifications=isTRUE(input$tax_no_partial_classifications),rescale=isTRUE(input$tax_rescale),
          max_scale_value=if(is.na(input$tax_max_scale_value)) NULL else input$tax_max_scale_value)
      }
    } else if (pt %in% c("func_cog","func_kegg","func_pfam")) {
      fun_level <- switch(pt,func_cog="COG",func_kegg="KEGG",func_pfam="PFAM")
      req(nchar(input$func_count %||% "") > 0)
      req(!is.null(input$n_funcs))
      search_text <- if(is_sqm_full()) trimws(input$func_search %||% "") else ""
      if (nchar(search_text)>0) {
        pattern <- build_func_pattern(search_text)
        proj_sub <- tryCatch(subsetFun(proj,fun=pattern,ignore_case=TRUE,fixed=FALSE),error=function(e) NULL)
        n_matches <- if(!is.null(proj_sub)) tryCatch(nrow(proj_sub$functions[[fun_level]]$abund),error=function(e) 0L) else 0L
        if (n_matches==0) { showNotification(paste0("No ",fun_level," functions found matching: \"",search_text,"\""),type="warning",duration=5); return(NULL) }
        plotFunctions(proj_sub,fun_level=fun_level,count=input$func_count,N=input$n_funcs,base_size=input$func_base_size %||% 11)
      } else {
        plotFunctions(proj,fun_level=fun_level,count=input$func_count,N=input$n_funcs,base_size=input$func_base_size %||% 11)
      }
    } else if (pt=="bins") { plotBins(proj) }
  })
  output$sqm_plot <- renderPlot({ plot_reactive() }, bg="#ffffff")
  output$plot_status_badge <- renderUI({
    if (is.null(sqm_data())) tags$span(class="badge",style="background:#eef2f7;color:#7a90a8;font-size:0.72rem;border:1px solid #d0dae6;","No project")
    else tags$span(class="badge",style="background:rgba(26,158,110,0.1);color:#1a9e6e;font-size:0.72rem;border:1px solid rgba(26,158,110,0.3);","\u25cf Ready")
  })
  output$download_plot <- downloadHandler(
    filename = function() paste0("sqm_plot_",Sys.Date(),".png"),
    content  = function(file) {
      pt <- isolate(input$plot_type)
      is_tax  <- !is.null(pt) && pt=="taxonomy_bar"
      is_func <- !is.null(pt) && pt %in% c("func_cog","func_kegg","func_pfam")
      w <- if(is_tax) isolate(input$tax_plot_width  %||% 800) else if(is_func) isolate(input$func_plot_width  %||% 800) else 1400
      h <- if(is_tax) isolate(input$tax_plot_height %||% 560) else if(is_func) isolate(input$func_plot_height %||% 560) else 900
      png(file,width=w,height=h,res=150,bg="#ffffff"); print(plot_reactive()); dev.off()
    }
  )
  output$table_sample_filter <- renderUI({
    req(sqm_data())
    tt <- active_table() %||% ""
    if (!startsWith(tt, "tax_") && !startsWith(tt, "fun_")) return(NULL)
    samples <- tryCatch(sqm_data()$samples, error = function(e) NULL)
    req(samples)
    tagList(
      tags$hr(class = "section-divider"),
      tags$div(class = "form-label", "Filter samples"),
      checkboxGroupInput("selected_samples", NULL, choices = samples, selected = samples)
    )
  })
  # ── Helper: enrich function table with Name / Path columns ──
  # File format: header row is "\tName\tPath" (first col empty = row ID)
  #              data rows:    "K00001\talcohol dehydrogenase...\tMetabolism;..."
  enrich_fun_table <- function(proj, db, d) {
    ids <- rownames(d)

    # SQMtools stores names in proj$misc$<DB>_names and paths in proj$misc$<DB>_paths
    names_vec <- tryCatch(proj$misc[[paste0(db, "_names")]], error = function(e) NULL)
    paths_vec <- tryCatch(proj$misc[[paste0(db, "_paths")]], error = function(e) NULL)

    if (!is.null(names_vec) && length(names_vec) > 0) {
      name_col <- names_vec[ids]; name_col[is.na(name_col)] <- ""
      if (!is.null(paths_vec) && length(paths_vec) > 0) {
        path_col <- paths_vec[ids]; path_col[is.na(path_col)] <- ""
        return(cbind(Name = name_col, Path = path_col, d))
      }
      return(cbind(Name = name_col, d))
    }
    d
  }


  get_table_data <- reactive({
    req(sqm_data())
    proj <- sqm_data()
    tt   <- active_table()
    req(!is.null(tt) && tt != "none")
    smp  <- input$selected_samples
    tryCatch({
      if      (tt == "contigs") as.data.frame(proj$contigs$table)
      else if (tt == "orfs")    as.data.frame(proj$orfs$table)
      else if (tt == "bins")    as.data.frame(proj$bins$table)
      else if (startsWith(tt, "tax_")) {
        rank   <- sub("^tax_", "", tt)
        metric <- input$tbl_tax_metric %||% "abund"
        d <- as.data.frame(proj$taxa[[rank]][[metric]])
        if (!is.null(smp) && length(smp) > 0) d[, colnames(d) %in% smp, drop = FALSE] else d
      }
      else if (startsWith(tt, "fun_")) {
        db     <- toupper(sub("^fun_", "", tt))
        metric <- input$tbl_fun_metric %||% "abund"
        d  <- as.data.frame(proj$functions[[db]][[metric]])
        if (!is.null(smp) && length(smp) > 0) d <- d[, colnames(d) %in% smp, drop = FALSE]
        enrich_fun_table(proj, db, d)
      }
    }, error = function(e) NULL)
  })
  output$data_table <- renderDT({
    df <- get_table_data(); req(df)
    tt <- active_table()
    row_label <- if      (tt == "contigs")          "Contig"
                 else if (tt == "orfs")             "ORF"
                 else if (tt == "bins")             "Bin"
                 else if (startsWith(tt, "tax_"))   "Taxon"
                 else if (startsWith(tt, "fun_"))   "Function"
                 else                               ""
    # Set row names as a proper column with the right header
    df <- cbind(setNames(data.frame(rownames(df), stringsAsFactors=FALSE), row_label), df)
    num_cols <- which(sapply(df, is.numeric)) - 1L  # 0-based for DT
    # Use rowCallback to format all numeric cells after render
    fmt_callback <- JS(paste0(
      "function(row, data, index) {",
      "  var ncols = ", length(which(sapply(df, is.numeric))), ";",
      "  var start = ", ncol(df) - length(which(sapply(df, is.numeric))), ";",
      "  for (var i = start; i < data.length; i++) {",
      "    var n = parseFloat(data[i]);",
      "    if (!isNaN(n)) {",
      "      var fmt = Math.abs(n) >= 10000 ? n.toExponential(3) : parseFloat(n.toFixed(3)).toString();",
      "      $('td:eq(' + i + ')', row).html(fmt);",
      "    }",
      "  }",
      "}"
    ))
    datatable(df, rownames=FALSE,
      options=list(pageLength=20, scrollX=TRUE, dom="lfrtip",
                   rowCallback = fmt_callback),
      class="compact hover stripe")
  })
  output$download_table <- downloadHandler(
    filename = function() paste0("sqm_", isolate(active_table()) %||% "table", "_", Sys.Date(), ".csv"),
    content  = function(file) {
      df <- get_table_data(); req(df)
      tt <- isolate(active_table())
      row_label <- if      (tt == "contigs")        "Contig"
                   else if (tt == "orfs")           "ORF"
                   else if (tt == "bins")           "Bin"
                   else if (startsWith(tt, "tax_")) "Taxon"
                   else if (startsWith(tt, "fun_")) "Function"
                   else                             ""
      df <- cbind(setNames(data.frame(rownames(df), stringsAsFactors=FALSE), row_label), df)
      write.csv(df, file, row.names=FALSE)
    }
  )
  # ─────────────────────────────────────────
  #  KRONA
  # ─────────────────────────────────────────
  krona_file   <- reactiveVal(NULL)
  krona_status <- reactiveVal("idle")
  kt_available <- reactive({
    system("ktImportText", ignore.stdout=TRUE, ignore.stderr=TRUE) == 0
  })
  output$krona_ktcheck_ui <- renderUI({
    if (kt_available()) {
      tags$div(style="font-size:0.8rem;",
        tags$span(style="color:#1a9e6e;margin-right:5px;","\u25cf"),
        tags$span(style="color:#7a90a8;","KronaTools: "),
        tags$span(style="color:#1a9e6e;font-weight:600;","AVAILABLE"))
    } else {
      tagList(
        tags$div(style="font-size:0.8rem;",
          tags$span(style="color:#c0392b;margin-right:5px;","\u2715"),
          tags$span(style="color:#7a90a8;","KronaTools: "),
          tags$span(style="color:#c0392b;font-weight:600;","NOT FOUND")),
        tags$div(class="path-info",style="margin-top:4px;color:#c0392b;",
          "ktImportText must be in PATH. ",
          tags$a(href="https://github.com/marbl/Krona",target="_blank",style="color:#1a6eb5;","Install KronaTools"))
      )
    }
  })
  output$krona_sample_filter_ui <- renderUI({
    req(sqm_data()); samples <- tryCatch(sqm_data()$samples,error=function(e) NULL); req(samples)
    checkboxGroupInput("krona_samples",NULL,choices=samples,selected=samples)
  })
  observeEvent(input$do_krona, {
    req(sqm_data())
    if (!kt_available()) { showNotification("ktImportText not found. Please install KronaTools.",type="error",duration=8); return() }
    krona_status("generating"); krona_file(NULL)
    tryCatch({
      proj <- sqm_data(); all_samples <- proj$samples; sel_samples <- input$krona_samples
      if (!is.null(sel_samples) && !setequal(sel_samples,all_samples)) proj <- subsetSamples(proj,sel_samples)
      out_file <- file.path(tempdir(),paste0("sqmxplore_krona_",format(Sys.time(),"%Y%m%d%H%M%S"),".html"))
      exportKrona(proj, output_name=out_file)
      if (file.exists(out_file)) { krona_file(out_file); krona_status("ready") }
      else { krona_status("error"); showNotification("Krona file was not generated.",type="error",duration=8) }
    }, error=function(e) { krona_status("error"); showNotification(paste("Krona error:",e$message),type="error",duration=10) })
  })
  output$krona_status_ui <- renderUI({
    s <- krona_status()
    col <- switch(s,idle="#7a90a8",generating="#3b9ede",ready="#1a9e6e",error="#c0392b")
    ico <- switch(s,idle="\u25cb",generating="\u25cc",ready="\u25cf",error="\u2715")
    lbl <- switch(s,idle="IDLE",generating="GENERATING\u2026",ready="READY",error="ERROR")
    tags$div(style="font-size:0.8rem;",
      tags$span(style=paste0("color:",col,";margin-right:5px;"),ico),
      tags$span(style="color:#7a90a8;","Status: "),
      tags$span(style=paste0("color:",col,";font-weight:600;"),lbl))
  })
  output$krona_badge_ui <- renderUI({
    s <- krona_status()
    if (s=="ready") tags$span(class="badge",style="background:rgba(26,158,110,0.1);color:#1a9e6e;font-size:0.72rem;border:1px solid rgba(26,158,110,0.3);","\u25cf Ready")
    else if (s=="generating") tags$span(class="badge",style="background:rgba(59,158,222,0.1);color:#3b9ede;font-size:0.72rem;border:1px solid rgba(59,158,222,0.3);","\u25cc Generating\u2026")
    else tags$span(class="badge",style="background:#eef2f7;color:#7a90a8;font-size:0.72rem;border:1px solid #d0dae6;","No chart")
  })
  output$krona_view_ui <- renderUI({
    kf <- krona_file()
    if (is.null(kf)||!file.exists(kf)) return(tags$div(
      style="color:var(--muted);font-size:0.85rem;padding:2rem;text-align:center;",
      tags$div(style="font-size:2rem;margin-bottom:8px;","\U0001f310"),
      tags$div("Select samples and click ",tags$strong("Generate Krona")," to build the chart.")))
    static_name <- paste0("krona_",basename(kf))
    addResourcePath(static_name, dirname(kf))
    # Read Krona HTML and patch it so the top bar is not clipped inside the iframe
    html_raw <- paste(readLines(kf, warn = FALSE), collapse = "
")
    # Krona uses position:fixed for #options — change to position:absolute so it
    # stays within the iframe document flow and is never clipped by the frame edge
    patch_css <- paste0(
      "<style>",
      "#options { position: absolute !important; top: 0 !important; }",
      "body { padding-top: 0 !important; margin-top: 0 !important; }",
      "canvas { margin-top: 0 !important; }",
      "</style>"
    )
    html_patched <- sub("</head>", paste0(patch_css, "</head>"), html_raw, fixed = TRUE)
    # Encode as data URI and serve via srcdoc to avoid cross-origin issues
    tags$iframe(
      srcdoc = html_patched,
      style  = "width:100%; height:760px; border:none; display:block;",
      id     = "krona_iframe"
    )
  })
  output$krona_download_ui <- renderUI({
    req(krona_status()=="ready")
    downloadButton("download_krona","Download HTML",class="btn-outline-secondary w-100")
  })
  output$download_krona <- downloadHandler(
    filename = function() paste0("krona_",Sys.Date(),".html"),
    content  = function(file) { kf<-krona_file(); req(kf,file.exists(kf)); file.copy(kf,file) }
  )

  # ═══════════════════════════════════════════════════════
  # Pathways tab — exportPathway (SQMtools wrapper for pathview)
  # ═══════════════════════════════════════════════════════
  pw_status   <- reactiveVal("idle")   # idle | generating | ready | error
  pw_img_dir   <- reactiveVal(NULL)     # tempdir where PNGs were written
  pw_img_files <- reactiveVal(NULL)    # character vector of PNG paths
  pw_legend    <- reactiveVal(NULL)    # list: colors, min, max, log_sc, cnt, fc
  pw_nodes     <- reactiveVal(NULL)    # data.frame: ko_ids, x, y, w, h, label, name
  pw_pathway_choices <- reactiveVal(NULL)  # named vector: "Name [id]" = "id"

  # ── Pathway tree is static; just signal ready on project load ──
  observeEvent(sqm_data(), {
    req(sqm_data())
    pw_pathway_choices(TRUE)   # just a flag to trigger renderUI
  })

  # ── Pathway selector: populated on project load ──
  output$pw_pathway_select_ui <- renderUI({
    # Show placeholder if project not loaded
    if (is.null(pw_pathway_choices()) || is.null(sqm_data())) {
      return(tags$div(style="font-size:0.78rem; color:var(--muted); padding:4px 0;",
        "Load a project to browse pathways."))
    }

    # Build collapsible tree from KEGG_HIERARCHY
    # Uses HTML details/summary — no JS needed
    search_box <- tags$input(
      id = "pw_search", type = "text",
      placeholder = "Search pathway\u2026",
      oninput = "filterPwTree(this.value)",
      style = paste0(
        "width:100%; box-sizing:border-box; padding:3px 6px;",
        "font-size:0.78rem; border:1px solid var(--border);",
        "border-radius:4px; margin-bottom:6px;",
        "background:var(--surface); color:var(--text);"))

    # Build tree HTML
    tree_items <- lapply(names(KEGG_HIERARCHY), function(l1) {
      l2_items <- lapply(names(KEGG_HIERARCHY[[l1]]), function(l2) {
        pathways <- KEGG_HIERARCHY[[l1]][[l2]]
        pw_links <- lapply(pathways, function(pw) {
          tags$div(
            class = "pw-item",
            "data-id" = pw$id,
            "data-name" = tolower(paste(pw$name, pw$id)),
            style = "padding:2px 4px 2px 8px; cursor:pointer; font-size:0.75rem; border-radius:3px;",
            onclick = sprintf(
              "event.stopPropagation(); Shiny.setInputValue('pw_pathway_id','%s',{priority:'event'}); document.querySelectorAll('.pw-item').forEach(function(el){el.style.background=''}); this.style.background='var(--accent-light)'; document.getElementById('pw_selected_label').textContent='%s [%s]';",
              pw$id, gsub("'", "\\\\'", pw$name), pw$id),
            tags$span(style="color:var(--muted); margin-right:4px; font-family:monospace;", pw$id),
            pw$name
          )
        })
        tags$details(
          style = "margin-left:8px;",
          tags$summary(
            style = paste0(
              "font-size:0.75rem; font-weight:600; color:var(--muted);",
              "cursor:pointer; padding:2px 2px; list-style:none;",
              "display:flex; align-items:center; gap:4px;"),
            tags$span(class="pw-chevron", style="font-size:0.6rem;", "\u25b6"),
            l2
          ),
          pw_links
        )
      })
      tags$details(
        open = NA,  # start closed
        style = "margin-bottom:2px;",
        tags$summary(
          style = paste0(
            "font-size:0.8rem; font-weight:700; color:var(--text);",
            "cursor:pointer; padding:3px 2px; list-style:none;",
            "display:flex; align-items:center; gap:4px;",
            "border-bottom:1px solid var(--border);"),
          tags$span(class="pw-chevron", style="font-size:0.65rem;", "\u25b6"),
          l1
        ),
        l2_items
      )
    })

    selected_label <- tags$div(
      id = "pw_selected_label",
      style = paste0(
        "font-size:0.75rem; color:var(--muted); font-style:italic;",
        "margin-bottom:4px; min-height:1.2em;"),
      if (!is.null(input$pw_pathway_id) && nchar(input$pw_pathway_id) > 0)
        paste0("Selected: ", input$pw_pathway_id)
      else
        "None selected"
    )

    tree_css <- tags$style(HTML(
      "details[open] > summary .pw-chevron { transform: rotate(90deg); }
       .pw-item:hover { background: var(--accent-light) !important; }
       details > summary { outline: none; }
       details > summary::-webkit-details-marker { display: none; }"
    ))

    search_js <- tags$script(HTML(
      "function filterPwTree(q) {
        q = q.toLowerCase().trim();
        document.querySelectorAll('.pw-item').forEach(function(el) {
          var match = !q || el.getAttribute('data-name').includes(q);
          el.style.display = match ? '' : 'none';
        });
        document.querySelectorAll('details').forEach(function(d) {
          var vis = Array.from(d.querySelectorAll('.pw-item')).some(function(el) {
            return el.style.display !== 'none';
          });
          d.style.display = vis ? '' : 'none';
          if (q && vis) d.open = true;
          else if (!q) { d.style.display = ''; }
        });
      }"
    ))

    tagList(
      tree_css,
      search_box,
      selected_label,
      tags$div(
        style = paste0(
          "max-height:320px; overflow-y:auto; border:1px solid var(--border);",
          "border-radius:4px; padding:4px; background:var(--surface);"),
        tree_items
      ),
      search_js
    )
  })

  pathview_available <- reactive({
    requireNamespace("pathview", quietly = TRUE)
  })

  output$pw_pathview_check_ui <- renderUI({
    if (pathview_available()) {
      tags$div(style = "font-size:0.82rem; padding:6px 0;",
        tags$span(style = "color:#1a9e6e; margin-right:5px;", "\u2714"),
        tags$span(style = "color:#7a90a8;", "pathview: "),
        tags$span(style = "color:#1a9e6e; font-weight:600;", "available"))
    } else {
      tags$div(style = "font-size:0.82rem; padding:6px 0;",
        tags$span(style = "color:#c0392b; margin-right:5px;", "\u2715"),
        tags$span(style = "color:#7a90a8;", "pathview: "),
        tags$span(style = "color:#c0392b; font-weight:600;", "NOT FOUND"),
        tags$div(class = "path-info", style = "margin-top:4px; color:#c0392b;",
          "Install with: ",
          tags$code(style = "font-size:0.75rem;",
            'BiocManager::install("pathview")'))
      )
    }
  })

  # Show fold-change group pickers only in foldchange mode
  output$pw_foldchange_ui <- renderUI({
    req(input$pw_mode == "foldchange")
    req(sqm_data())
    samples <- tryCatch(sqm_data()$samples, error = function(e) NULL)
    req(samples)
    tagList(
      tags$div(class = "form-label", style = "margin-top:6px;", "Group A (reference)"),
      checkboxGroupInput("pw_fc_groupA", NULL, choices = samples,
                         selected = samples[1]),
      tags$div(class = "form-label", style = "margin-top:4px;", "Group B"),
      checkboxGroupInput("pw_fc_groupB", NULL, choices = samples,
                         selected = if (length(samples) > 1) samples[2] else samples[1])
    )
  })

  observeEvent(input$do_pathway, {
    req(sqm_data())
    if (!pathview_available()) {
      showNotification(
        'pathview not installed. Run: BiocManager::install("pathview")',
        type = "error", duration = 10)
      return()
    }
    pid <- trimws(input$pw_pathway_id %||% "")
    if (nchar(pid) == 0) {
      showNotification("Please select a KEGG Pathway from the dropdown.", type = "warning", duration=6)
      return()
    }
    pw_status("generating"); pw_img_files(NULL)

    tryCatch({
      proj   <- sqm_data()
      outdir <- file.path(tempdir(), paste0("sqmxplore_pw_", format(Sys.time(), "%Y%m%d%H%M%S")))
      dir.create(outdir, showWarnings = FALSE)

      mode    <- input$pw_mode
      log_sc  <- isTRUE(input$pw_log_scale)
      cnt     <- input$pw_count %||% "copy_number"
      fc_grps <- NULL
      if (mode == "foldchange") {
        grpA <- input$pw_fc_groupA; grpB <- input$pw_fc_groupB
        if (length(grpA) == 0 || length(grpB) == 0) {
          showNotification("Select at least one sample for each fold-change group.",
                           type = "warning", duration = 6)
          pw_status("idle"); return()
        }
        fc_grps <- list(grpA, grpB)
      }

      # Pre-compute sample colors so map and legend are consistent
      smp_for_colors <- tryCatch(proj$misc$samples, error=function(e) character(0))
      if (is.null(smp_for_colors) || length(smp_for_colors)==0)
        smp_for_colors <- tryCatch(colnames(proj$functions$KEGG$abund), error=function(e) character(0))
      n_smp_ep <- length(smp_for_colors)
      auto_cols <- if (n_smp_ep == 1) "#E41A1C" else
        hcl(h = seq(15, 375, length.out = n_smp_ep + 1)[seq_len(n_smp_ep)], c = 100, l = 55)

      exportPathway(
        proj,
        pathway_id         = pid,
        count              = cnt,
        split_samples      = (mode == "split"),
        log_scale          = log_sc,
        fold_change_groups = fc_grps,
        sample_colors      = if (mode != "foldchange") auto_cols else NULL,
        output_dir         = outdir,
        output_suffix      = paste0("sqmxplore_", pid)
      )

      # ── Parse KGML to extract node positions for image map ──
      # Use pathview's own node.info parser on the downloaded XML — same coords pathview uses
      xml_nodes <- tryCatch({
        if (!requireNamespace("xml2", quietly=TRUE)) stop("xml2 not available")
        xml_path <- file.path(outdir, paste0("ko", pid, ".xml"))
        if (!file.exists(xml_path)) {
          pathview::download.kegg(pathway.id=pid, species="ko", kegg.dir=outdir)
        }
        if (!file.exists(xml_path)) stop("XML not downloaded")

        # Also download the original KEGG PNG to measure its dimensions
        png_orig <- file.path(outdir, paste0("ko", pid, ".png"))
        if (!file.exists(png_orig)) {
          pathview::download.kegg(pathway.id=pid, species="ko", kegg.dir=outdir,
                                  file.type="png")
        }
        # Get scale factor: output PNG vs original KEGG PNG
        scale_x <- 1; scale_y <- 1
        if (file.exists(png_orig) && requireNamespace("png", quietly=TRUE)) {
          orig_dim <- dim(png::readPNG(png_orig))  # [height, width, channels]
          orig_w <- orig_dim[2]; orig_h <- orig_dim[1]
          # Find the output PNG (multi or single)
          out_pngs <- list.files(outdir, pattern=paste0("sqmxplore_",pid,".*[.]png$"),
                                 full.names=TRUE)
          out_pngs <- out_pngs[!grepl("[.]legend[.]", basename(out_pngs))]
          if (length(out_pngs) > 0) {
            out_dim <- dim(png::readPNG(out_pngs[1]))
            out_w <- out_dim[2]; out_h <- out_dim[1]
            scale_x <- out_w / orig_w
            scale_y <- out_h / orig_h

          }
        }

        doc <- xml2::read_xml(xml_path)
        entries <- xml2::xml_find_all(doc, ".//entry[@type='ortholog']")
        proj_kos <- tryCatch(
          paste0("ko:", rownames(proj$functions$KEGG$abund)),
          error=function(e) character(0))
        rows <- lapply(entries, function(e) {
          ko_names <- trimws(xml2::xml_attr(e, "name"))

          g <- xml2::xml_find_first(e, "graphics")
          if (is.na(xml2::xml_attr(g, "x"))) return(NULL)
          x <- as.numeric(xml2::xml_attr(g, "x")) * scale_x
          y <- as.numeric(xml2::xml_attr(g, "y")) * scale_y
          w <- as.numeric(xml2::xml_attr(g, "width"))  * scale_x
          h <- as.numeric(xml2::xml_attr(g, "height")) * scale_y
          if (anyNA(c(x,y,w,h))) return(NULL)
          label <- xml2::xml_attr(g, "name")
          list(ko_names=ko_names, x=x, y=y, w=w, h=h, label=label)
        })
        rows <- Filter(Negate(is.null), rows)
        if (length(rows) == 0) return(NULL)
        df <- data.frame(
          ko_names = sapply(rows, `[[`, "ko_names"),
          x        = sapply(rows, `[[`, "x"),
          y        = sapply(rows, `[[`, "y"),
          w        = sapply(rows, `[[`, "w"),
          h        = sapply(rows, `[[`, "h"),
          label    = sapply(rows, `[[`, "label"),
          stringsAsFactors = FALSE
        )
        # Deduplicate: same position = same box painted by pathview
        pos_key <- paste(round(df$x), round(df$y), sep=",")
        df <- df[!duplicated(pos_key), ]
        df
      }, error = function(e) { message("XML parse error: ", e$message); NULL })
      pw_nodes(xml_nodes)

      # Collect PNGs written by pathview (exclude legends and base map)
      pngs_all <- list.files(outdir, pattern = "[.]png$", full.names = TRUE)
      pngs_all <- pngs_all[!grepl("[.]legend[.]", basename(pngs_all))]
      # pathview writes the original base PNG (ko<pid>.png) alongside the output —
      # exclude it: keep only files that contain the output_suffix in the name
      suffix_pat <- paste0("sqmxplore_", pid)
      pngs_all <- pngs_all[grepl(suffix_pat, basename(pngs_all), fixed=TRUE)]
      # In "together" mode with >1 sample, prefer the .multi.png over per-sample PNGs
      if (mode != "split" && length(pngs_all) > 1) {
        multi <- pngs_all[grepl("[.]multi[.]png$", basename(pngs_all))]
        if (length(multi) > 0) pngs_all <- multi
      }

      if (length(pngs_all) == 0) {
        pw_status("error")
        showNotification(
          paste0("No images were generated for pathway ", pid,
                 ". Check that the pathway ID is valid and has KEGG KO annotations."),
          type = "error", duration = 10)
      } else {
        # Compute legend info from the same parameters used in exportPathway
        samples_used <- tryCatch(proj$misc$samples, error=function(e) character(0))
        if (is.null(samples_used) || length(samples_used)==0) samples_used <- tryCatch(colnames(proj$functions$KEGG$abund), error=function(e) character(0))
        n_smp  <- length(samples_used)
        s_cols <- auto_cols  # reuse colors computed for exportPathway call
        # Compute min/max from KEGG data (same logic as exportPathway)
        mat <- tryCatch({
          if (cnt == "percent") {
            100 * t(t(proj$functions$KEGG$abund) / proj$total_reads)
          } else {
            proj$functions$KEGG[[cnt]]
          }
        }, error = function(e) NULL)
        if (!is.null(mat) && mode == "foldchange" && !is.null(fc_grps)) {
          ps  <- 0.001
          mat <- mat + ps
          log2FC <- log(apply(mat[, fc_grps[[2]], drop=FALSE], 1, median) /
                        apply(mat[, fc_grps[[1]], drop=FALSE], 1, median), 2)
          mv <- max(abs(log2FC), na.rm=TRUE)
          leg_min <- -mv; leg_max <- mv; leg_log <- FALSE
        } else if (!is.null(mat)) {
          if (log_sc) mat <- log(mat + 0.001, 10)
          # Replicate pathview's node.map aggregation: sum KOs per node
          # so the scale matches what is actually painted on the map
          node_sums <- tryCatch({
            xml_path2 <- file.path(outdir, paste0("ko", pid, ".xml"))
            if (file.exists(xml_path2) && requireNamespace("xml2", quietly=TRUE)) {
              doc2    <- xml2::read_xml(xml_path2)
              entries2 <- xml2::xml_find_all(doc2, ".//entry[@type='ortholog']")
              sums <- lapply(entries2, function(e) {
                kos <- unique(sub("^ko:", "", trimws(unlist(strsplit(
                  trimws(xml2::xml_attr(e, "name")), "[[:space:]]+")))))
                kos_in <- kos[kos %in% rownames(mat)]
                if (length(kos_in) == 0) return(NULL)
                colSums(mat[kos_in, , drop=FALSE], na.rm=TRUE)
              })
              sums <- do.call(rbind, Filter(Negate(is.null), sums))
              if (!is.null(sums) && nrow(sums) > 0) sums else mat
            } else mat
          }, error=function(e) mat)
          leg_min <- min(node_sums, na.rm=TRUE)
          leg_max <- max(node_sums, na.rm=TRUE)
          leg_log <- log_sc
        } else {
          leg_min <- 0; leg_max <- 1; leg_log <- log_sc
        }
        pw_legend(list(
          colors  = s_cols,
          samples = samples_used,
          min     = leg_min,
          max     = leg_max,
          log_sc  = leg_log,
          cnt     = cnt,
          mode    = mode,
          fc_grps = fc_grps
        ))
        pw_img_dir(outdir)
        pw_img_files(pngs_all)
        pw_status("ready")
      }
    }, error = function(e) {
      pw_status("error")
      showNotification(paste("Pathway error:", e$message), type = "error", duration = 12)
    })
  })

  output$pw_view_ui <- renderUI({
    s <- pw_status()
    if (s == "idle") return(
      tags$div(style = "color:var(--muted); font-size:0.85rem; padding:2rem; text-align:center;",
        tags$div(style = "font-size:2rem; margin-bottom:8px;", "\U0001f5fa\ufe0f"),
        tags$div("Enter a KEGG Pathway ID and click ",
                 tags$strong("Generate map"), "."),
        tags$div(style = "margin-top:6px; font-size:0.78rem;",
          "Example IDs: 00910 (Nitrogen), 00630 (Glyoxylate), 01100 (Metabolic pathways)")))
    if (s == "generating") return(
      tags$div(style = "color:var(--muted); font-size:0.85rem; padding:2rem; text-align:center;",
        tags$div(style = "font-size:1.5rem; margin-bottom:8px;", "\u25cc"),
        tags$div("Generating pathway map\u2026 (downloading map from KEGG servers)")))
    if (s == "error") return(
      tags$div(style = "color:#c0392b; font-size:0.85rem; padding:2rem; text-align:center;",
        tags$div(style = "font-size:1.5rem; margin-bottom:8px;", "\u2715"),
        tags$div("Generation failed. See notification for details.")))
    # ready
    imgs    <- pw_img_files(); req(imgs)
    out_dir <- pw_img_dir()
    leg     <- pw_legend()
    # Serve the output dir as a static resource
    res_name <- paste0("pw_", basename(out_dir))
    addResourcePath(res_name, out_dir)
    nodes <- pw_nodes()
    kegg_names <- tryCatch(sqm_data()$misc$KEGG_names, error=function(e) NULL)

    # CSS tooltip that follows the cursor — fast, styleable, no delay
    tooltip_css <- tags$style(HTML("
      #pw-tooltip {
        position: fixed; pointer-events: none; z-index: 9999;
        background: rgba(20,30,50,0.92); color: #f0f4f8;
        padding: 5px 9px; border-radius: 5px; font-size: 0.75rem;
        max-width: 320px; line-height: 1.4; display: none;
        box-shadow: 0 2px 8px rgba(0,0,0,0.3);
        white-space: pre-wrap; word-break: break-word;
      }
    "))
    tooltip_div <- tags$div(id="pw-tooltip")
    tooltip_js  <- tags$script(HTML("
      (function() {
        var tip = document.getElementById('pw-tooltip');
        if (!tip) return;
        document.addEventListener('mousemove', function(e) {
          tip.style.left = (e.clientX + 14) + 'px';
          tip.style.top  = (e.clientY + 14) + 'px';
        });
      })();
      function pwShowTip(el) {
        var tip = document.getElementById('pw-tooltip');
        if (tip) { tip.textContent = el.getAttribute('data-tip'); tip.style.display = 'block'; }
      }
      function pwHideTip() {
        var tip = document.getElementById('pw-tooltip');
        if (tip) tip.style.display = 'none';
      }
    "))

    # Build data matrix for value lookup (same logic as exportPathway)
    pw_mat <- tryCatch({
      proj <- sqm_data(); req(proj)
      cnt_local <- leg$cnt %||% "copy_number"
      m <- if (cnt_local == "percent") {
        100 * t(t(proj$functions$KEGG$abund) / proj$total_reads)
      } else {
        proj$functions$KEGG[[cnt_local]]
      }
      if (!is.null(leg$log_sc) && leg$log_sc) log(m + 0.001, 10) else m
    }, error=function(e) NULL)

    # Serialize node tooltip data to JSON for JS overlay
    build_node_json <- function() {
      if (is.null(nodes) || nrow(nodes) == 0) return("[]")
      rows_json <- apply(nodes, 1, function(r) {
        ko_ids <- trimws(unlist(strsplit(r["ko_names"], "[[:space:]]+")))
        ko_ids <- unique(sub("^ko:", "", ko_ids))
        if (!is.null(kegg_names)) {
          nms <- unique(na.omit(kegg_names[ko_ids]))
        } else nms <- character(0)
        ko_str   <- paste(ko_ids, collapse=", ")
        name_str <- if (length(nms)>0) paste(nms, collapse=" / ") else r["label"]
        tip <- if (nchar(trimws(name_str))>0) paste0(ko_str, "\n", name_str) else ko_str
        if (!is.null(pw_mat)) {
          val_rows <- pw_mat[rownames(pw_mat) %in% ko_ids, , drop=FALSE]
          if (nrow(val_rows) > 0) {
            col_sums <- colSums(val_rows, na.rm=TRUE)
            val_str  <- paste(sapply(names(col_sums), function(s) {
              v <- col_sums[[s]]
              fv <- if (abs(v) >= 10000) formatC(v, digits=3, format="e")
                    else formatC(v, digits=3, format="g")
              paste0(s, ": ", fv)
            }), collapse="\n")
            tip <- paste0(tip, "\n\u2014\n", val_str)
          } else {
            tip <- paste0(tip, "\n\u2014\n(not in data)")
          }
        }
        x <- as.numeric(r["x"]); y <- as.numeric(r["y"])
        w <- as.numeric(r["w"]); h <- as.numeric(r["h"])
        tip_esc <- gsub('"', '\\\\"', gsub("\n", "\\\\n", tip))
        sprintf('{"x":%g,"y":%g,"w":%g,"h":%g,"tip":"%s"}', x, y, w, h, tip_esc)
      })
      paste0("[", paste(rows_json, collapse=","), "]")
    }

    make_img_map <- function(fname, map_id) {
      img_src <- paste0(res_name, "/", fname)
      if (is.null(nodes) || nrow(nodes) == 0) {
        return(tags$div(style="margin-bottom:12px;",
          tags$img(src=img_src, id=map_id,
            style="max-width:100%; border:1px solid var(--border); border-radius:6px;",
            alt=fname)))
      }
      node_json <- build_node_json()
      # Canvas overlay: positioned absolutely over the img, scaled via JS
      tagList(
        tags$div(style="margin-bottom:12px; position:relative; display:inline-block; width:100%;",
          tags$img(src=img_src, id=map_id,
            style="max-width:100%; display:block; border:1px solid var(--border); border-radius:6px; box-shadow:0 1px 4px rgba(0,0,0,.08);",
            alt=fname),
          tags$canvas(id=paste0(map_id,"_canvas"),
            style="position:absolute; top:0; left:0; width:100%; height:100%; cursor:crosshair;")
        ),
        tags$script(HTML(sprintf('
          (function() {
            var nodes = %s;
            var img   = document.getElementById("%s");
            var canvas= document.getElementById("%s_canvas");
            function setup() {
              canvas.width  = img.offsetWidth;
              canvas.height = img.offsetHeight;
              var scaleX = img.offsetWidth  / img.naturalWidth;
              var scaleY = img.offsetHeight / img.naturalHeight;
              canvas.addEventListener("mousemove", function(e) {
                var rect = canvas.getBoundingClientRect();
                var mx = (e.clientX - rect.left);
                var my = (e.clientY - rect.top);
                var hit = null;
                for (var i=0; i<nodes.length; i++) {
                  var n = nodes[i];
                  var x1 = (n.x - n.w/2) * scaleX;
                  var y1 = (n.y - n.h/2) * scaleY;
                  var x2 = (n.x + n.w/2) * scaleX;
                  var y2 = (n.y + n.h/2) * scaleY;
                  if (mx>=x1 && mx<=x2 && my>=y1 && my<=y2) { hit=n; break; }
                }
                if (hit) {
                  var tip = document.getElementById("pw-tooltip");
                  if (tip) { tip.textContent = hit.tip.replace(/\\\\n/g,"\\n"); tip.style.display="block"; }
                } else { pwHideTip(); }
              });
              canvas.addEventListener("mouseleave", pwHideTip);
            }
            if (img.complete) { setup(); }
            else { img.addEventListener("load", setup); }
            window.addEventListener("resize", function() {
              if (img.complete) setup();
            });
          })();
        ', node_json, map_id, map_id)))
      )
    }
    img_tags <- lapply(seq_along(imgs), function(i) {
      make_img_map(basename(imgs[[i]]), paste0("pwmap_", i))
    })
    # Prepend tooltip infrastructure once
    img_tags <- c(list(tooltip_css, tooltip_div, tooltip_js), img_tags)

    # ── Inline legend ──
    cnt_labels <- c(abund="Raw abundance", percent="Percentage", bases="Bases",
                    tpm="TPM", copy_number="Copy number")
    cnt_lbl <- if (!is.null(leg) && leg$cnt %in% names(cnt_labels))
                 cnt_labels[leg$cnt] else leg$cnt

    legend_ui <- if (!is.null(leg)) {
      fmt_val <- function(v) {
        if (!is.null(leg$log_sc) && leg$log_sc) paste0("10^", round(v, 2))
        else formatC(v, digits=3, format="g")
      }
      if (leg$mode == "foldchange" && !is.null(leg$fc_grps)) {
        fc_colors <- c("red", "green")
        grad <- paste0("linear-gradient(to top, ", fc_colors[1], ", white, ", fc_colors[2], ")")
        tags$div(style="display:flex; align-items:flex-start; gap:12px;",
          tags$div(style="display:flex; align-items:stretch; gap:4px;",
            tags$div(style="display:flex; flex-direction:column; justify-content:space-between; font-size:0.65rem; color:var(--muted); text-align:right; height:120px;",
              tags$span(fmt_val(leg$max)), tags$span("0"), tags$span(fmt_val(leg$min))),
            tags$div(style=paste0("width:18px; height:120px; border-radius:3px; border:1px solid var(--border); background:", grad, ";"))
          ),
          tags$div(style="font-size:0.72rem; color:var(--muted); padding-top:4px;",
            tags$div(paste0("Log2FC ", cnt_lbl)),
            tags$div(style="margin-top:8px;",
              tags$span(style=paste0("display:inline-block;width:10px;height:10px;background:", fc_colors[2], ";border-radius:2px;margin-right:4px;")),
              "Group B > Group A"),
            tags$div(style="margin-top:4px;",
              tags$span(style=paste0("display:inline-block;width:10px;height:10px;background:", fc_colors[1], ";border-radius:2px;margin-right:4px;")),
              "Group A > Group B")
          )
        )
      } else {
        # Shared numeric scale, one color bar per sample
        n_ticks <- 5
        tick_vals <- seq(leg$max, leg$min, length.out = n_ticks)
        bar_tags <- lapply(seq_along(leg$colors), function(i) {
          col <- leg$colors[i]
          grad <- paste0("linear-gradient(to top, white, ", col, ")")
          tags$div(style="display:flex; flex-direction:column; align-items:center; gap:3px;",
            tags$div(style=paste0("width:14px; height:120px; border-radius:3px; border:1px solid var(--border); background:", grad, ";")),
            tags$div(style="font-size:0.65rem; color:var(--muted); max-width:50px; text-align:center; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;",
              leg$samples[i])
          )
        })
        tags$div(style="display:flex; align-items:flex-start; gap:6px;",
          tags$div(style="display:flex; flex-direction:column; justify-content:space-between; font-size:0.65rem; color:var(--muted); text-align:right; height:120px; padding-right:3px;",
            lapply(tick_vals, function(v) tags$span(fmt_val(v)))),
          tags$div(style="display:flex; gap:4px; align-items:flex-start;", bar_tags),
          tags$div(style="font-size:0.72rem; color:var(--muted); padding-top:4px; padding-left:4px;",
            cnt_lbl,
            if (!is.null(leg$log_sc) && leg$log_sc) " (log10)" else "")
        )
      }
    } else NULL

    tags$div(style="padding:8px;",
      img_tags,
      if (!is.null(legend_ui))
        tags$div(style="margin-top:8px; padding:10px; background:var(--surface); border:1px solid var(--border); border-radius:6px;",
          legend_ui)
    )
  })

  output$pw_status_ui <- renderUI({
    s <- pw_status()
    col <- switch(s, idle="#7a90a8", generating="#3b9ede", ready="#1a9e6e", error="#c0392b")
    ico <- switch(s, idle="\u25cb", generating="\u25cc", ready="\u25cf", error="\u2715")
    lbl <- switch(s, idle="IDLE", generating="GENERATING\u2026", ready="READY", error="ERROR")
    tags$div(style = "font-size:0.8rem;",
      tags$span(style = paste0("color:", col, "; margin-right:5px;"), ico),
      tags$span(style = "color:#7a90a8;", "Status: "),
      tags$span(style = paste0("color:", col, "; font-weight:600;"), lbl))
  })

  output$pw_badge_ui <- renderUI({
    s <- pw_status()
    if (s == "ready")
      tags$span(class="badge",
        style="background:rgba(26,158,110,0.1);color:#1a9e6e;font-size:0.72rem;border:1px solid rgba(26,158,110,0.3);",
        "\u25cf Ready")
    else if (s == "generating")
      tags$span(class="badge",
        style="background:rgba(59,158,222,0.1);color:#3b9ede;font-size:0.72rem;border:1px solid rgba(59,158,222,0.3);",
        "\u25cc Generating\u2026")
    else
      tags$span(class="badge",
        style="background:#eef2f7;color:#7a90a8;font-size:0.72rem;border:1px solid #d0dae6;",
        "No map")
  })

  output$pw_download_ui <- renderUI({
    req(pw_status() == "ready")
    downloadButton("download_pw_zip", "Download PNGs (.zip)",
                   class = "btn-outline-secondary w-100")
  })

  output$download_pw_zip <- downloadHandler(
    filename = function() paste0("pathway_", trimws(input$pw_pathway_id), "_", Sys.Date(), ".zip"),
    content  = function(file) {
      imgs <- pw_img_files(); req(imgs)
      zip(file, files = imgs, flags = "-j")  # -j: junk paths, filenames only
    }
  )

  # ═══════════════════════════════════════════════════════
  # Multivariate tab — PCA via vegan::rda
  # ═══════════════════════════════════════════════════════
  mv_status  <- reactiveVal("idle")   # idle | ready | error
  mv_pca_res <- reactiveVal(NULL)     # list: rda object + metadata

  output$mv_feat_labels_ui <- renderUI({
    req(input$mv_method %||% "pca" == "pca")
    tags$div(style = "display:flex; align-items:center; gap:4px;",
      tags$input(id = "mv_show_feat_labels", type = "checkbox",
        style = "margin:0; width:13px; height:13px; cursor:pointer;",
        checked = if (isTRUE(input$mv_show_feat_labels)) NA else NULL,
        onclick = "Shiny.setInputValue('mv_show_feat_labels', this.checked, {priority:'event'});"),
      tags$label(`for` = "mv_show_feat_labels",
        style = "font-size:0.75rem; color:var(--muted); cursor:pointer; margin:0;",
        "Feature labels"))
  })

  output$mv_card_title_ui <- renderUI({
    method <- input$mv_method %||% "pca"
    span(if (method == "nmds") "NMDS" else "PCA")
  })

  # ── Unified sidebar controls (sidebar-box style, method-conditional) ──
  output$mv_sidebar_controls <- renderUI({
    req(sqm_data()); proj <- sqm_data()
    method    <- input$mv_method    %||% "pca"
    data_type <- input$mv_data_type %||% "taxonomy"
    is_pca    <- method == "pca"

    # Rank/DB choices
    if (data_type == "taxonomy") {
      rdb_choices <- available_tax_ranks(proj)
      rdb_label   <- "Rank"
    } else {
      rdb_choices <- avail_functions(proj)
      rdb_label   <- "Database"
    }

    # Metric choices
    rdb_val <- input$mv_rank_db
    if (!is.null(rdb_val) && nchar(rdb_val) > 0) {
      metrics <- if (data_type == "taxonomy") {
        rank <- sub("^tax_", "", rdb_val)
        avail_tax_metrics(proj, rank)
      } else {
        db <- toupper(sub("^fun_", "", rdb_val))
        avail_fun_metrics(proj, db)
      }
    } else {
      metrics <- c()
    }

    # Samples
    samples <- tryCatch(proj$misc$samples, error = function(e) NULL)

    tagList(
      # ── Box 1: Analysis type ──
      tags$div(class = "sidebar-box",
        tags$div(class = "form-label", "Analysis type"),
        selectInput("mv_method", NULL,
          choices = c("PCA" = "pca", "NMDS" = "nmds"), selected = method)),

      # ── Box 2: Data type + Rank/DB ──
      tags$div(class = "sidebar-box",
        tags$div(class = "form-label", "Data type"),
        selectInput("mv_data_type", NULL,
          choices = c("Taxonomy" = "taxonomy", "Functions" = "functions"),
          selected = data_type),
        if (length(rdb_choices) > 0) tagList(
          tags$div(class = "form-label", style = "margin-top:4px;", rdb_label),
          selectInput("mv_rank_db", NULL, choices = rdb_choices,
            selected = input$mv_rank_db))
      ),

      # ── Box 3: Metric + Distance/Normalization + N features + Exclude unclassified ──
      tags$div(class = "sidebar-box",
        if (length(metrics) > 0) tagList(
          tags$div(class = "form-label", "Metric"),
          selectInput("mv_metric", NULL, choices = metrics,
            selected = if (!is.null(input$mv_metric) && input$mv_metric %in% metrics)
              input$mv_metric
            else if ("abund" %in% metrics) "abund" else metrics[[1]])),
        if (is_pca) tagList(
          tags$div(class = "form-label", style = "margin-top:4px;", "Normalization"),
          selectInput("mv_norm", NULL,
            choices = c("CLR" = "clr",
                        "Log10 + pseudocount" = "log",
                        "Raw" = "raw"),
            selected = input$mv_norm %||% "clr")),
        if (!is_pca) tagList(
          tags$div(class = "form-label", style = "margin-top:4px;", "Distance"),
          selectInput("mv_dist", NULL,
            choices = c("Bray-Curtis" = "bray", "Jaccard"    = "jaccard",
                        "Hellinger"  = "hellinger", "Euclidean" = "euclidean"),
            selected = input$mv_dist %||% "bray")),
        tags$div(class = "form-label", style = "margin-top:4px;", "Number of features"),
        numericInput("mv_n_features", NULL,
          value = input$mv_n_features %||% 100, min = 5, max = 5000, step = 10),
        tags$div(style = "margin-top:6px;",
          checkboxInput("mv_exclude_unclassified", "Exclude Unclassified",
            value = isTRUE(input$mv_exclude_unclassified %||% TRUE))),
        checkboxInput("mv_exclude_ambiguous", "Exclude ambiguous taxa",
          value = isTRUE(input$mv_exclude_ambiguous %||% FALSE))
      ),

      # (Feature labels checkbox moved to plot controls bar)

      # ── Box 5: Samples — inline chips ──
      if (!is.null(samples))
        tags$div(class = "sidebar-box",
          tags$div(class = "form-label", "Samples"),
          tags$div(style = "display:flex; flex-wrap:wrap; gap:2px; margin-top:2px;",
            lapply(samples, function(s) {
              is_sel <- is.null(input$mv_samples) || s %in% input$mv_samples
              tags$label(
                style = paste0(
                  "display:inline-flex; align-items:center; gap:3px;",
                  "font-size:0.72rem; padding:2px 5px; border-radius:3px; cursor:pointer;",
                  "border:1px solid ", if (is_sel) "#3b9ede" else "var(--border)", ";",
                  "background:", if (is_sel) "rgba(59,158,222,0.08)" else "transparent", ";"),
                tags$input(
                  type = "checkbox", name = "mv_samples", value = s,
                  checked = if (is_sel) NA else NULL,
                  style = "margin:0; width:11px; height:11px;",
                  onclick = paste0(
                    "var cb=this; var vals=[];",
                    "document.querySelectorAll('input[name=mv_samples]').forEach(function(el){",
                    "if(el.checked) vals.push(el.value);});",
                    "Shiny.setInputValue('mv_samples', vals, {priority:'event'});",
                    "var lbl=cb.closest('label');",
                    "lbl.style.borderColor=cb.checked?'#3b9ede':'var(--border)';",
                    "lbl.style.background=cb.checked?'rgba(59,158,222,0.08)':'transparent';")),
                s)
            })
          )
        )
    )
  })

  # ── Run PCA ──
  observeEvent(input$do_pca, {
    req(sqm_data(), input$mv_rank_db, input$mv_metric)
    method <- input$mv_method %||% "pca"
    if (!requireNamespace("vegan", quietly = TRUE)) {
      showNotification("Package 'vegan' is required. Install with: install.packages('vegan')",
                       type = "error", duration = 10)
      return()
    }
    mv_status("idle"); mv_pca_res(NULL)

    tryCatch({
      proj    <- sqm_data()
      rdb     <- input$mv_rank_db
      metric  <- input$mv_metric
      n_feat  <- max(5L, as.integer(input$mv_n_features %||% 100))
      excl_u  <- isTRUE(input$mv_exclude_unclassified)
      sel_smp <- input$mv_samples

      # ── Get matrix ──
      mat <- if (input$mv_data_type == "taxonomy") {
        rank <- sub("^tax_", "", rdb)
        as.matrix(proj$taxa[[rank]][[metric]])
      } else {
        db <- toupper(sub("^fun_", "", rdb))
        as.matrix(proj$functions[[db]][[metric]])
      }

      # Filter samples
      if (!is.null(sel_smp) && length(sel_smp) > 0)
        mat <- mat[, colnames(mat) %in% sel_smp, drop = FALSE]
      if (ncol(mat) < 2) stop("At least 2 samples are required.")

      # Remove unclassified rows
      excl_amb <- isTRUE(input$mv_exclude_ambiguous)
      if (excl_u) {
        excl_pat <- c("Unclassified", "Unmapped", "No database", "")
        mat <- mat[!rownames(mat) %in% excl_pat, , drop = FALSE]
      }
      if (excl_amb) {
        mat <- mat[!grepl("^unclassified", rownames(mat), ignore.case = TRUE), , drop = FALSE]
      }

      # Select N most abundant features (by row mean)
      row_means <- rowMeans(mat, na.rm = TRUE)
      top_idx   <- order(row_means, decreasing = TRUE)[seq_len(min(n_feat, nrow(mat)))]
      mat       <- mat[top_idx, , drop = FALSE]
      if (nrow(mat) < 2) stop("Not enough features after filtering.")

      # ── Normalization (PCA only — NMDS uses raw mat via distance metric) ──
      mat_t <- if (method == "pca") {
        norm <- input$mv_norm %||% "clr"
        t(switch(norm,
          clr = { mat_ps <- mat + 1; apply(mat_ps, 2, function(x) log(x) - mean(log(x))) },
          log = log10(mat + 1),
          raw = mat
        ))
      } else {
        t(mat)  # NMDS: raw counts, distance metric handles everything
      }  # samples as rows

      if (method == "pca") {
        # ── PCA via vegan::rda ──
        ord <- vegan::rda(mat_t, scale = FALSE)
        eig    <- ord$CA$eig
        var_ex <- round(100 * eig / sum(eig), 1)
        # ── PCA quality warnings ──
        pca_warns <- c()
        pc1    <- var_ex[1]
        pc1pc2 <- var_ex[1] + var_ex[2]
        n_smp  <- nrow(mat_t)
        if (n_smp <= 2)
          pca_warns <- c(pca_warns,
            "Only 2 samples: PCA is trivial and results are not meaningful.")
        if (pc1 > 90)
          pca_warns <- c(pca_warns,
            paste0("PC1 explains ", pc1, "% of variance: data variation is nearly one-dimensional. The 2D biplot adds little information."))
        if (pc1pc2 < 30)
          pca_warns <- c(pca_warns,
            paste0("PC1+PC2 explain only ", pc1pc2, "% of variance: the biplot captures very little of the total variation and may be misleading."))
        else if (pc1pc2 < 50)
          pca_warns <- c(pca_warns,
            paste0("PC1+PC2 explain ", pc1pc2, "% of variance: less than half the total variation is represented in this plot."))
        norm_used <- input$mv_norm %||% "clr"
        if (norm_used == "raw")
          pca_warns <- c(pca_warns,
            "Raw data (no normalization): PC1 may reflect sequencing depth differences rather than community composition. Consider using CLR or log normalization.")

        mv_pca_res(list(
          method     = "pca",
          ord        = ord,
          var_ex     = var_ex,
          mat_t      = mat_t,
          pca_warns  = if (length(pca_warns) > 0) pca_warns else NULL
        ))

      } else {
        # ── NMDS via vegan::metaMDS ──
        # Use Bray-Curtis on CLR-transformed data
        dist_sel <- input$mv_dist %||% "bray"
        if (ncol(mat) < 3) stop("NMDS requires at least 3 samples.")
        # mat_t = t(mat) for NMDS (raw counts, samples as rows)
        dist_mat <- if (dist_sel == "euclidean") {
          # Euclidean on raw counts
          vegan::vegdist(mat_t, method = "euclidean")
        } else if (dist_sel == "hellinger") {
          # Hellinger: sqrt of relative abundances
          hell <- vegan::decostand(mat_t, method = "hellinger")
          vegan::vegdist(hell, method = "euclidean")
        } else {
          # Bray-Curtis and Jaccard directly on raw counts
          vegan::vegdist(mat_t, method = dist_sel,
                         binary = (dist_sel == "jaccard"))
        }
        nmds_warnings <- character(0)
        ord <- withCallingHandlers(
          vegan::metaMDS(dist_mat, k = 2, trymax = 100,
                         trace = FALSE, autotransform = FALSE),
          warning = function(w) {
            nmds_warnings <<- c(nmds_warnings, conditionMessage(w))
            invokeRestart("muffleWarning")
          }
        )
        stress_warn <- if (ord$stress < 0.01)
          "Warning: stress is near zero — you may have too few samples for a meaningful NMDS."
        else if (ord$stress > 0.2)
          "Warning: stress > 0.2 — ordination may not be reliable. Consider increasing sample size."
        else NULL
        mv_pca_res(list(
          method      = "nmds",
          ord         = ord,
          mat_t       = mat_t,
          stress      = round(ord$stress, 4),
          stress_warn = stress_warn
        ))
      }
      mv_status("ready")
    }, error = function(e) {
      mv_status("error")
      showNotification(paste("Analysis error:", e$message), type = "error", duration = 10)
    })
  })


  # ── Plot ──
  mv_plot <- reactive({
    req(mv_pca_res(), mv_status() == "ready")
    res     <- mv_pca_res()
    method  <- res$method
    fs      <- input$mv_font_size %||% 11
    show_fl <- isTRUE(input$mv_show_feat_labels)

    if (method == "pca") {
      pca     <- res$ord
      var_ex  <- res$var_ex
      sc_sites <- vegan::scores(pca, display = "sites",   choices = 1:2)
      sc_sp    <- vegan::scores(pca, display = "species", choices = 1:2)

      df_sites <- data.frame(PC1 = sc_sites[,1], PC2 = sc_sites[,2],
                              sample = rownames(sc_sites))
      df_sp    <- data.frame(PC1 = sc_sp[,1],    PC2 = sc_sp[,2],
                              feat = rownames(sc_sp))

      scale_f <- 0.7 * max(abs(df_sites[,1:2])) / max(abs(df_sp[,1:2]))
      df_sp$PC1 <- df_sp$PC1 * scale_f
      df_sp$PC2 <- df_sp$PC2 * scale_f

      xlab <- paste0("PC1 (", var_ex[1], "%)")
      ylab <- paste0("PC2 (", var_ex[2], "%)")
      title <- "PCA biplot"

      p <- ggplot2::ggplot() +
        ggplot2::geom_hline(yintercept = 0, colour = "#cccccc", linewidth = 0.4) +
        ggplot2::geom_vline(xintercept = 0, colour = "#cccccc", linewidth = 0.4) +
        ggplot2::geom_segment(data = df_sp,
          ggplot2::aes(x = 0, y = 0, xend = PC1, yend = PC2),
          arrow = ggplot2::arrow(length = ggplot2::unit(0.15, "cm"), type = "closed"),
          colour = "#3b9ede", alpha = 0.5, linewidth = 0.4) +
        ggplot2::geom_point(data = df_sites,
          ggplot2::aes(x = PC1, y = PC2), colour = "#e44c3a", size = 3) +
        ggplot2::geom_text(data = df_sites,
          ggplot2::aes(x = PC1, y = PC2, label = sample),
          vjust = -0.8, size = fs / 3.5, colour = "#333333") +
        { if (show_fl)
            ggplot2::geom_text(data = df_sp,
              ggplot2::aes(x = PC1, y = PC2, label = feat),
              size = fs / 4.5, colour = "#3b9ede", alpha = 0.8, hjust = 0.5, vjust = -0.5)
          else ggplot2::geom_blank() } +
        ggplot2::labs(x = xlab, y = ylab, title = title)

    } else {
      # NMDS
      sc <- vegan::scores(res$ord, display = "sites")
      df_sites <- data.frame(MDS1 = sc[,1], MDS2 = sc[,2],
                              sample = rownames(sc))
      stress_lbl <- paste0("Stress = ", res$stress)

      p <- ggplot2::ggplot(df_sites, ggplot2::aes(x = MDS1, y = MDS2)) +
        ggplot2::geom_hline(yintercept = 0, colour = "#cccccc", linewidth = 0.4) +
        ggplot2::geom_vline(xintercept = 0, colour = "#cccccc", linewidth = 0.4) +
        ggplot2::geom_point(colour = "#e44c3a", size = 3) +
        ggplot2::geom_text(ggplot2::aes(label = sample),
          vjust = -0.8, size = fs / 3.5, colour = "#333333") +
        ggplot2::annotate("text", x = Inf, y = -Inf, label = stress_lbl,
          hjust = 1.1, vjust = -0.5, size = fs / 3.5,
          colour = if (!is.null(res$stress_warn)) "#c0392b" else "#7a90a8") +
        ggplot2::labs(x = "MDS1", y = "MDS2", title = "NMDS ordination")
    }

    p +
      ggplot2::theme_bw(base_size = fs) +
      ggplot2::theme(
        plot.title   = ggplot2::element_text(size = fs + 1, face = "bold"),
        panel.grid   = ggplot2::element_blank(),
        panel.border = ggplot2::element_rect(colour = "#cccccc"))
  })


  output$mv_plot_out <- renderPlot({ mv_plot() },
    width  = function() input$mv_plot_width  %||% 700,
    height = function() input$mv_plot_height %||% 500)

  output$mv_plot_ui <- renderUI({
    s <- mv_status()
    if (s == "idle") return(
      tags$div(style = "color:var(--muted); font-size:0.85rem; padding:2rem; text-align:center;",
        tags$div(style = "font-size:2rem; margin-bottom:8px;", "🧮"),
        tags$div("Select options and click ", tags$strong("Run analysis"), ".")))
    if (s == "error") return(
      tags$div(style = "color:#c0392b; font-size:0.85rem; padding:2rem; text-align:center;",
        tags$div(style = "font-size:1.5rem; margin-bottom:8px;", "✕"),
        tags$div("Analysis failed. See notification for details.")))
    uiOutput("mv_plot_sized")
  })
  output$mv_plot_sized <- renderUI({
    res <- mv_pca_res()
    warn_banner <- if (!is.null(res)) {
      msgs <- if (res$method == "nmds") {
        if (!is.null(res$stress_warn)) res$stress_warn else character(0)
      } else {
        if (!is.null(res$pca_warns)) res$pca_warns else character(0)
      }
      if (length(msgs) > 0)
        tags$div(
          style = paste0(
            "margin-top:6px; padding:6px 10px; font-size:0.78rem;",
            "background:rgba(196,57,43,0.08); border:1px solid rgba(196,57,43,0.3);",
            "border-radius:4px; color:#c0392b;"),
          lapply(msgs, function(m) tags$div(
            tags$span(style="margin-right:5px;", "⚠"), m))
        )
      else NULL
    } else NULL
    tagList(
      tags$div(
        style = paste0("width:", input$mv_plot_width %||% 700, "px; max-width:100%;"),
        plotOutput("mv_plot_out",
          width  = "100%",
          height = paste0(input$mv_plot_height %||% 500, "px"))),
      warn_banner
    )
  })


  output$mv_status_ui <- renderUI({
    s <- mv_status()
    col <- switch(s, idle="#7a90a8", ready="#1a9e6e", error="#c0392b")
    ico <- switch(s, idle="\u25cb", ready="\u25cf", error="\u2715")
    lbl <- switch(s, idle="IDLE", ready="READY", error="ERROR")
    tags$div(style = "font-size:0.8rem;",
      tags$span(style = paste0("color:", col, "; margin-right:5px;"), ico),
      tags$span(style = "color:#7a90a8;", "Status: "),
      tags$span(style = paste0("color:", col, "; font-weight:600;"), lbl))
  })

  output$mv_badge_ui <- renderUI({
    s <- mv_status()
    if (s == "ready")
      tags$span(class="badge",
        style="background:rgba(26,158,110,0.1);color:#1a9e6e;font-size:0.72rem;border:1px solid rgba(26,158,110,0.3);",
        "\u25cf Ready")
    else
      tags$span(class="badge",
        style="background:#eef2f7;color:#7a90a8;font-size:0.72rem;border:1px solid #d0dae6;",
        "No plot")
  })

  output$mv_download_ui <- renderUI({
    req(mv_status() == "ready")
    downloadButton("download_mv_png", "Download PNG", class = "btn-outline-secondary w-100")
  })

  output$download_mv_png <- downloadHandler(
    filename = function() paste0("pca_", Sys.Date(), ".png"),
    content  = function(file) {
      p <- mv_plot()
      w <- (input$mv_plot_width  %||% 700) / 100
      h <- (input$mv_plot_height %||% 500) / 100
      ggplot2::ggsave(file, plot = p, width = w, height = h, dpi = 150)
    }
  )
}
shinyApp(ui = ui, server = server)
