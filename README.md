# SQMxplore

Interactive Shiny dashboard for visualizing and exploring [SqueezeMeta](https://github.com/jtamames/SqueezeMeta) metagenomics results.

## Features

- **Project** — loads SQM (full) and SQMlite projects, displays a structured summary including reads, contigs, ORFs, taxonomy coverage and most abundant taxa
- **Plots** — interactive barplots and heatmaps for taxonomy (all ranks) and functions (COG, KEGG, PFAM, external DBs), with search, count type selection, rescaling options, and adjustable size/font; bins barplot
- **Tables** — browsable, downloadable tables for assembly (contigs, ORFs), taxonomy (all ranks), functions (COG, KEGG, PFAM, external DBs) and bins; multiple metrics; COG and KEGG tables include Name and Path annotation columns
- **Krona** — generates and displays interactive Krona taxonomy charts inline, with per-sample filtering and HTML download
- **Pathways** — overlays functional abundance data onto KEGG pathway maps using `exportPathway` from SQMtools; supports per-sample coloring, log scale, fold-change between sample groups, and hierarchical pathway browser with search
- **Multivariate** — ordination analysis (PCA and NMDS) on taxonomy or functional abundance data, with multiple normalization and distance options, quality warnings, and interactive biplot

---

## Requirements

### System dependencies

If you are installing inside a **conda environment** you may get errors about `knitr`, `rmarkdown`, `xfun`, `highr`, `htmlwidgets` or `DT` failing to compile from source. The most reliable fix is to use the Posit Package Manager (RSPM), which provides precompiled R binaries for Linux and avoids all compilation issues:

**Ubuntu 20.04 (focal):**
```r
options(repos = c(RSPM = "https://packagemanager.posit.co/cran/__linux__/focal/latest"))
install.packages(c("xfun", "highr", "knitr", "rmarkdown", "htmlwidgets", "DT"))
```

**Ubuntu 22.04 (jammy):**
```r
options(repos = c(RSPM = "https://packagemanager.posit.co/cran/__linux__/jammy/latest"))
install.packages(c("xfun", "highr", "knitr", "rmarkdown", "htmlwidgets", "DT"))
```

To check your Ubuntu version: `lsb_release -cs`

This downloads precompiled binaries instead of compiling from source, bypassing all system library dependency issues. After running the above, proceed with the regular `install.packages` commands below.

### R (≥ 4.1)

Install the required R packages:

```r
install.packages(c(
  "shiny",
  "shinyjs",
  "shinyFiles",
  "bslib",
  "DT"
))
```

Install **SQMtools** from CRAN:

```r
install.packages("SQMtools")
```

Or install the latest development version from the SqueezeMeta repository:

```r
install.packages(
  "/path/to/SqueezeMeta/lib/SQMtools",
  repos = NULL,
  type  = "source"
)
```

### plotly (required for Plots tab)

```r
install.packages("plotly")
```

### vegan (optional, required for Multivariate tab)

```r
install.packages("vegan")
```

### pathview (optional, required for Pathways tab)

`pathview` is a Bioconductor package that downloads and annotates KEGG pathway maps. It also installs `KEGGREST` as a dependency.

```r
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("pathview")
```

The Pathways tab requires an **internet connection** at generation time — `pathview` downloads the pathway map image from the KEGG servers on each run.

`ggpattern` and `magick` are **not required**. SQMxplore generates its own inline color scale legend. Do not attempt to install `ggpattern` — it depends on `sf` → `s2` / `units`, which require system GIS libraries (GDAL, PROJ) that are rarely available in conda environments.

### KronaTools (optional, required for Krona tab)

If SqueezeMeta is already installed in your environment, KronaTools is likely already available — check before installing:

```bash
which ktImportText
```

If it prints a path, no further action is needed. SQMxplore detects it automatically.

If it is not available, install it manually (recommended over conda if you are having network issues):

```bash
wget https://github.com/marbl/Krona/releases/download/v2.8.1/KronaTools-2.8.1.tar.gz
tar xzf KronaTools-2.8.1.tar.gz
cd KronaTools-2.8.1
./install.pl --prefix ~/.local
ktUpdateTaxonomy.sh
```

Or via conda if your network allows it:

```bash
conda install -c bioconda krona
ktUpdateTaxonomy.sh
```

---

## Installation

Clone this repository:

```bash
git clone https://github.com/jtamames/SQMxplore.git
cd SQMxplore
```

---

## Usage

Launch the app from R:

```r
shiny::runApp("app.R")
```

Or from the command line:

```bash
Rscript -e 'shiny::runApp("app.R")'
```

**If you get a `'browser' must be a non-empty character string` error** (common on servers or SSH sessions without a desktop environment), disable the automatic browser launch:

```r
shiny::runApp("app.R", launch.browser = FALSE)
```

To make the app accessible from another machine on the network:

```r
shiny::runApp("app.R", host = "0.0.0.0", port = 3838, launch.browser = FALSE)
```

Then open `http://<server-ip>:3838` in your local browser.

### Loading a project

1. Go to the **Project** tab
2. Click **Select directory** and choose your SqueezeMeta project directory
3. The app will auto-detect the project type from `creator.txt`:
   - **SqueezeMeta projects** (created with `SqueezeMeta.pl`): point to the project root directory
   - **SQMlite projects** (created with `sqm2tables.py`, `sqmreads2tables.py` or `combine-sqm-tables.py`): point to the tables directory
4. Click **Load**

If the tables directory cannot be detected automatically, a manual directory selector will appear.

---

## Project types

| Type | Load function | Features |
|------|--------------|----------|
| SQM (full) | `loadSQM` | All tabs, all plots, taxonomy/function search, bins |
| SQMlite | `loadSQMlite` | Plots, Tables, Krona, Pathways, Multivariate; no contig/ORF/bin detail; no subset functions |

---

## Tabs

### Project
Displays a structured summary of the loaded project: sample list, read counts, contig and ORF statistics, taxonomic classification coverage, most abundant taxa per rank.

### Plots

Select a plot type from the sidebar. Available types depend on the data present in the loaded project.

**Taxonomy (barplot)** — stacked barplot of the most abundant taxa at the selected rank.

- Choose rank (Phylum → Species), count type, and number of taxa
- Optionally search for specific taxa by name (SQM full only); comma-separated, empty means top N
- Filter options: Ignore unmapped, Ignore unclassified, Ignore ambiguous, Rescale to 100%
- Format controls (top bar): width, height, font size, colour palette, label width

**Taxonomy (heatmap)** — interactive heatmap of the most abundant taxa.

- Same rank, count type and number of taxa selectors as the barplot
- Filter options: Ignore unmapped, Ignore unclassified, Ignore ambiguous
- Rescale selector in the sidebar: None, Log₁₀(x+1), Z-score — row order is always computed on raw values and stays stable when rescaling
- Format controls (top bar): width, height, font size, colour palette
- Hover to see exact values; row height is fixed at 28 px/taxon for consistent cell size

**COG / KEGG / PFAM / external databases** — interactive heatmap of the most abundant functions.

- Search by function ID or keyword; comma-separated, empty means top N
- Optional category filter (COG category or KEGG hierarchy) where available
- Count type, number of functions and rescale (None, Log₁₀(x+1), Z-score) selectors in the sidebar
- Row order is computed on raw values and stays stable when rescaling
- Format controls (top bar): width, height, font size, colour palette, label width
- Hover to see function name, sample and exact value; full function names shown in row labels (truncated at 80 characters)

**Binning** — barplot of bin abundances (SQM full only).

All plots support a **sample selector** to restrict the analysis to a subset of samples. Use the **Download PNG** button to export (for plotly-based plots, use the camera button in the plot toolbar instead).

### Tables
Four independent category selectors:

- **Assembly** — Contigs table, ORFs table (SQM full only)
- **Taxonomy** — select rank and metric (percentages, raw abundances)
- **Functions** — select database and metric (raw abundances, percentages, base counts, CPM, TPM, copy number); COG and KEGG tables include Name and Path annotation columns
- **Bins** — bins summary table (SQM full only)

Taxonomy and function tables include a **Filter samples** selector. Use **Download CSV** to export the current view.

### Krona
Generates an interactive Krona taxonomy chart using `exportKrona` from SQMtools and `ktImportText` from KronaTools. Optionally filter by sample before generating. The chart is displayed inline and can be downloaded as a self-contained HTML file.

### Pathways
Overlays KEGG functional abundance data onto pathway maps using `exportPathway` from SQMtools (a wrapper for the `pathview` Bioconductor package). Requires an internet connection.

- **Pathway browser** — hierarchical tree organised by the 6 top-level KEGG categories (Metabolism, Genetic Information Processing, Environmental Information Processing, Cellular Processes, Organismal Systems, Human Diseases), with subcategories and search filter
- **Count type** — copy number, TPM, raw abundances, percentages, or base counts
- **Mode** — all samples together (multi-colour map), one PNG per sample, or log2 fold-change between two groups of samples
- **Legend** — inline color scale bar per sample, built from the same parameters used to generate the map
- **Download** — exports all generated PNGs as a zip file

### Multivariate
Ordination analysis on taxonomy or functional abundance data. Requires the `vegan` R package.

**Analysis types:**

- **PCA** — Principal Component Analysis via `vegan::rda()`. Displays a biplot with sample scores and feature loadings (arrows). The percentage of variance explained by each axis is shown on the axis labels. Optionally show feature labels on arrow tips.
- **NMDS** — Non-metric Multidimensional Scaling via `vegan::metaMDS()`. Displays sample scores with the stress value annotated on the plot.

**Data options:**
- **Data type** — taxonomy (any rank) or functions (any database: COG, KEGG, PFAM, external)
- **Metric** — any available count type (raw abundances, percentages, TPM, copy number, etc.)
- **Number of features** — uses the N most abundant features (by mean across samples)
- **Exclude Unclassified** — removes rows labelled Unclassified, Unmapped or No database
- **Exclude ambiguous taxa** — removes any row whose name starts with "unclassified" (e.g. "unclassified Pseudomonadota")

**Normalization (PCA only):**
- **CLR** — centered log-ratio with pseudocount +1; the recommended option for compositional metagenomics data
- **Log10** — log10(x + 1); useful when preserving relative scale
- **Raw** — no transformation; suitable for data already normalized (TPM, percentages). Note: may cause PC1 to reflect sequencing depth rather than community composition

**Distance (NMDS only):**
- **Bray-Curtis** — standard ecological distance on proportions; recommended for most metagenomics datasets
- **Jaccard** — presence/absence version of Bray-Curtis
- **Hellinger** — square root of relative abundances followed by Euclidean distance; reduces the influence of dominant features
- **Euclidean** — Euclidean distance on raw counts

**Quality warnings** are displayed below the plot when:
- Only 2 samples (PCA is trivial)
- PC1 explains >90% of variance (nearly one-dimensional data)
- PC1+PC2 explain <50% of variance (limited representation)
- PC1+PC2 explain <30% of variance (poor representation)
- Raw normalization selected (risk of sequencing depth artefact)
- NMDS stress <0.01 (too few samples for meaningful ordination)
- NMDS stress >0.2 (ordination may not be reliable)

---

## Dependencies summary

| Package | Source | Required for |
|---------|--------|--------------|
| shiny | CRAN | Core |
| shinyjs | CRAN | Core |
| shinyFiles | CRAN | Core |
| bslib | CRAN | Core |
| DT | CRAN | Core |
| SQMtools | CRAN / SqueezeMeta repo | Core |
| plotly | CRAN | Plots tab |
| pandoc | conda-forge / system | Needed by DT in conda envs |
| vegan | CRAN | Multivariate tab |
| pathview | Bioconductor | Pathways tab |
| KEGGREST | Bioconductor (auto with pathview) | Pathways tab |
| KronaTools (`ktImportText`) | conda / GitHub | Krona tab |

---

## Server deployment (remote access)

This section explains how to make SQMxplore accessible to remote users via **Shiny Server**, running permanently on a Linux machine.

### 1. Install R packages on the server

All packages must be installed as root so Shiny Server can find them:

```bash
# Install cmake first — required to compile the 'fs' R package
sudo apt-get install -y cmake

sudo R -e "install.packages(c('shiny','shinyjs','shinyFiles','bslib','DT','plotly','SQMtools','vegan'), repos='https://cran.rstudio.com/')"

# Optional: pathview and Biostrings (required by SQMtools)
# Note: use single quotes for the outer string to avoid bash interpreting '!'
sudo R -e 'install.packages("BiocManager", repos="https://cran.rstudio.com/")'
sudo R -e 'BiocManager::install(c("pathview", "Biostrings"))'
```

If you are on Ubuntu inside a conda environment and get compilation errors, use RSPM precompiled binaries first (see [System dependencies](#system-dependencies) above).

> **Note:** these commands must be run **outside** any conda environment, so that the system R (typically `/usr/bin/R`) is used. Shiny Server uses the system R, not the one inside the conda environment. Run `conda deactivate` before proceeding, and verify with `which R`.

### 2. Install Shiny Server

```bash
# Check https://posit.co/download/shiny-server/ for the latest version
wget https://download3.rstudio.org/ubuntu-18.04/x86_64/shiny-server-1.5.21.1012-amd64.deb
sudo dpkg -i shiny-server-1.5.21.1012-amd64.deb
```

### 3. Deploy the app

```bash
sudo mkdir -p /srv/shiny-server/sqmxplore
sudo cp /path/to/app.R /srv/shiny-server/sqmxplore/
```

### 4. Configure Shiny Server

Edit `/etc/shiny-server/shiny-server.conf`:

```
run_as shiny;

server {
  listen 3838;

  location /sqmxplore {
    app_dir /srv/shiny-server/sqmxplore;
    log_dir /var/log/shiny-server;
  }
}
```

### 5. Grant data access to the shiny user

The `shiny` system user needs read access to the SqueezeMeta project directories:

```bash
# Option A: add shiny to the group that owns the data
sudo usermod -aG your_data_group shiny

# Option B: grant read access explicitly
sudo chmod -R o+rX /path/to/your/sqm/projects
```

Also make sure the `shiny` user can traverse your home directory if the projects are inside it:

```bash
chmod o+x /home/your_username
```

> **Note on directory navigation in the app:** the file browser shows two roots: `home` (which maps to `/home/shiny`, the Shiny Server user's home — typically empty) and `root` (which maps to `/`). To reach your project data, choose **root** and then navigate to the full path: `root → home → your_username → your_project`.

### 6. Start and enable the service

```bash
sudo systemctl start shiny-server
sudo systemctl enable shiny-server   # start automatically on reboot
sudo systemctl status shiny-server   # verify it is running
```

### 7. Open the firewall port

```bash
sudo ufw allow 3838/tcp
```

### 8. Access the app

Users on the same network can now open:

```
http://<server-ip>:3838/sqmxplore
```

To find the server IP: `hostname -I`

---

## Remote access from outside the local network

### Option A: SSH tunnel (no server config needed, encrypted)

The remote user runs this on their own machine:

```bash
ssh -L 3838:localhost:3838 user@server-ip
```

Then opens `http://localhost:3838/sqmxplore` in their browser. No firewall changes needed beyond standard SSH access.

### Option B: nginx reverse proxy with HTTPS (permanent, production)

```bash
sudo apt-get install -y nginx certbot python3-certbot-nginx
```

Create `/etc/nginx/sites-available/sqmxplore`:

```nginx
server {
    listen 80;
    server_name sqmxplore.yourdomain.org;

    location /sqmxplore/ {
        proxy_pass http://localhost:3838/sqmxplore/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_read_timeout 3600;
    }
}
```

```bash
sudo ln -s /etc/nginx/sites-available/sqmxplore /etc/nginx/sites-enabled/
sudo systemctl restart nginx
sudo certbot --nginx -d sqmxplore.yourdomain.org
```

Users then access `https://sqmxplore.yourdomain.org/sqmxplore`.

### Option C: ngrok (quick demo, no domain needed)

```bash
# Install from https://ngrok.com, then:
ngrok http 3838
```

ngrok prints a temporary public URL (e.g. `https://abc123.ngrok.io`). The tunnel stays alive as long as the process runs.

---

## Troubleshooting (server)

**App does not load / blank page**
```bash
tail -f /var/log/shiny-server/*.log
```

**Missing R packages** — the log will show `Error in library(...)`. Install as root (see step 1).

**shiny user cannot read project files**
```bash
sudo chmod -R o+rX /path/to/sqm/project
```

**`app_cache` permission errors in the log**

If the log shows repeated warnings about `/srv/shiny-server/sqmxplore/app_cache`, fix ownership:
```bash
sudo chown -R shiny:shiny /srv/shiny-server/sqmxplore/
sudo systemctl restart shiny-server
```

**Port 3838 not reachable**
```bash
sudo ufw status
sudo ufw allow 3838/tcp
ss -tlnp | grep 3838
```

**KronaTools not found by shiny user**
```bash
sudo -u shiny which ktImportText
# If not found, add KronaTools bin to /etc/environment
```

---

## Citation

If you use SqueezeMeta or SQMtools in your research, please cite:

- Tamames & Puente-Sánchez (2019). SqueezeMeta, a highly portable metagenomics pipeline based on simultaneous coassembly of multiple samples. *Frontiers in Microbiology*. doi:[10.3389/fmicb.2018.03349](https://doi.org/10.3389/fmicb.2018.03349)
- Puente-Sánchez et al. (2020). SQMtools: automated processing and visual analysis of 'omics data with R and anvi'o. *BMC Bioinformatics*. doi:[10.1186/s12859-020-03703-2](https://doi.org/10.1186/s12859-020-03703-2)

---

## License

MIT
