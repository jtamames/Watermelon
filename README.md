# Watermelon

Interactive Shiny dashboard for visualizing and exploring [SqueezeMeta](https://github.com/jtamames/SqueezeMeta) metagenomics results.

## Features

- **Project** — loads SQM (full) and SQMlite projects, displays a structured summary including reads, contigs, ORFs, taxonomy coverage and most abundant taxa
- **Plots** — interactive barplots and heatmaps for taxonomy (all ranks) and functions (COG, KEGG, PFAM, external DBs), with search, count type selection, rescaling options, and adjustable size/font; bins barplot
- **Tables** — browsable, downloadable tables for assembly (contigs, ORFs), taxonomy (all ranks), functions (COG, KEGG, PFAM, external DBs) and bins; multiple metrics; COG and KEGG tables include Name and Path annotation columns
- **Krona** — generates and displays interactive Krona taxonomy charts inline, with per-sample filtering and HTML download
- **Pathways** — overlays functional abundance data onto KEGG pathway maps using `exportPathway` from SQMtools; supports per-sample coloring, log scale, fold-change between sample groups, and hierarchical pathway browser with search
- **Multivariate** — ordination analysis (PCA and NMDS) on taxonomy or functional abundance data, with multiple normalization and distance options, quality warnings, and interactive biplot
- **Comparison** — statistical comparison between two sample groups (Wilcoxon, DESeq2, edgeR) with volcano plot and results table

---

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/jtamames/watermelon.git
cd watermelon
```

### 2. Install R dependencies

Make sure your SqueezeMeta conda environment is active, then run the installer:

```bash
conda activate SqueezeMeta
bash install.sh
```

The installer handles all R packages (CRAN and Bioconductor) and any required system libraries automatically.

### 3. Run the app

```bash
Rscript -e 'shiny::runApp("app.R", launch.browser=FALSE)'
```

To make the app accessible from another machine on the network:

```bash
Rscript -e 'shiny::runApp("app.R", host="0.0.0.0", port=3838, launch.browser=FALSE)'
```

Then open `http://<server-ip>:3838` in your local browser.

---

## KronaTools (optional, required for Krona tab)

If SqueezeMeta is already installed in your environment, KronaTools is likely already available — check before installing:

```bash
which ktImportText
```

If it prints a path, no further action is needed. Watermelon detects it automatically.

If it is not available, install it via conda:

```bash
conda install -c bioconda krona
ktUpdateTaxonomy.sh
```

Or manually:

```bash
wget https://github.com/marbl/Krona/releases/download/v2.8.1/KronaTools-2.8.1.tar.gz
tar xzf KronaTools-2.8.1.tar.gz
cd KronaTools-2.8.1
./install.pl --prefix ~/.local
ktUpdateTaxonomy.sh
```

---

## Usage

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
| SQMlite | `loadSQMlite` | Plots, Tables, Krona, Pathways, Multivariate, Comparison; no contig/ORF/bin detail |

---

## Tabs

### Project
Displays a structured summary of the loaded project: sample list, mapping statistics, read counts, contig and ORF statistics, taxonomic classification coverage, most abundant taxa per rank.

### Plots

Select a category (Taxonomy / Functions / MAGs) and then a plot type from the sidebar.

**Taxonomy (barplot)** — stacked barplot of the most abundant taxa at the selected rank.

- Choose rank (Phylum → Species), count type, and number of taxa
- Optionally search for specific taxa by name (SQM full only); comma-separated, empty means top N
- Filter options: Ignore unmapped, Ignore unclassified, Ignore ambiguous, Rescale to 100%
- Format controls (top bar): width, height, font size, colour palette, label width

**Taxonomy (heatmap)** — interactive heatmap of the most abundant taxa.

- Same rank, count type and number of taxa selectors as the barplot
- Filter options: Ignore unmapped, Ignore unclassified, Ignore ambiguous
- Rescale selector in the sidebar: None, Log₁₀(x+1), Z-score
- Format controls (top bar): width, height, font size, colour palette

**COG / KEGG / PFAM / external databases** — interactive heatmap of the most abundant functions.

- Search by function ID or keyword; comma-separated, empty means top N
- Optional category filter (COG category or KEGG hierarchy) where available
- Count type, number of functions and rescale (None, Log₁₀(x+1), Z-score) selectors
- Format controls (top bar): width, height, font size, colour palette, label width

**MAGs** — barplot of bin abundances (SQM full only).

All plots support a **sample selector** to restrict the analysis to a subset of samples.

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

- Browse pathways by KEGG hierarchy or search by name/ID
- Click on linked pathway boxes in the map to navigate to connected pathways
- Supports per-sample coloring, fold-change mode between two sample groups, and log scale

### Multivariate
Ordination analysis on taxonomy or functional abundance data.

- **PCA** — with CLR, log, z-score or raw normalization
- **NMDS** — with Bray-Curtis, Jaccard, Hellinger or Euclidean distance

**Quality warnings** are displayed below the plot when:
- Only 2 samples (PCA is trivial)
- PC1 explains >90% of variance (nearly one-dimensional data)
- PC1+PC2 explain <50% of variance (limited representation)
- Raw normalization selected (risk of sequencing depth artefact)
- NMDS stress >0.2 (ordination may not be reliable)

### Comparison
Statistical comparison of functional or taxonomic profiles between two user-defined sample groups.

- Define Group A and Group B by selecting samples from checkboxes
- Choose method: Wilcoxon rank-sum, DESeq2, or edgeR
- Results shown as an interactive volcano plot and a sortable table with per-sample abundance columns
- Download results as CSV

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
| vegan | CRAN | Multivariate tab |
| xml2 | CRAN | Pathways tab |
| pathview | Bioconductor | Pathways tab |
| DESeq2 | Bioconductor | Comparison tab (optional) |
| edgeR | Bioconductor | Comparison tab (optional) |
| KronaTools (`ktImportText`) | conda / GitHub | Krona tab |

---

## Server deployment (remote access)

This section explains how to make Watermelon accessible to remote users via **Shiny Server**, running permanently on a Linux machine.

### 1. Install R packages on the server

All packages must be installed as root so Shiny Server can find them:

```bash
sudo apt-get install -y cmake liblzma-dev
sudo R -e "install.packages(c('shiny','shinyjs','shinyFiles','bslib','DT','plotly','SQMtools','vegan','xml2'), repos='https://cran.rstudio.com/')"
sudo R -e 'install.packages("BiocManager", repos="https://cran.rstudio.com/")'
sudo R -e 'BiocManager::install(c("pathview", "Biostrings", "DESeq2", "edgeR"))'
```

> **Note:** run these commands **outside** any conda environment so the system R is used. Run `conda deactivate` first and verify with `which R`.

### 2. Install Shiny Server

```bash
# Check https://posit.co/download/shiny-server/ for the latest version
wget https://download3.rstudio.org/ubuntu-18.04/x86_64/shiny-server-1.5.21.1012-amd64.deb
sudo dpkg -i shiny-server-1.5.21.1012-amd64.deb
```

### 3. Deploy the app

```bash
sudo mkdir -p /srv/shiny-server/watermelon
sudo cp -r /path/to/watermelon/* /srv/shiny-server/watermelon/
```

### 4. Configure Shiny Server

Edit `/etc/shiny-server/shiny-server.conf`:

```
run_as shiny;

server {
  listen 3838;

  location /watermelon {
    app_dir /srv/shiny-server/watermelon;
    log_dir /var/log/shiny-server;
  }
}
```

### 5. Grant data access to the shiny user

```bash
# Option A: add shiny to the group that owns the data
sudo usermod -aG your_data_group shiny

# Option B: grant read access explicitly
sudo chmod -R o+rX /path/to/your/sqm/projects
```

Also make sure the `shiny` user can traverse your home directory:

```bash
chmod o+x /home/your_username
```

> **Note on directory navigation:** the file browser shows two roots: `home` (maps to `/home/shiny`, typically empty) and `root` (maps to `/`). To reach your project data, choose **root** and navigate to the full path.

### 6. Start and enable the service

```bash
sudo systemctl start shiny-server
sudo systemctl enable shiny-server
sudo systemctl status shiny-server
```

### 7. Open the firewall port

```bash
sudo ufw allow 3838/tcp
```

### 8. Access the app

```
http://<server-ip>:3838/watermelon
```

To find the server IP: `hostname -I`

---

## Remote access from outside the local network

### Option A: SSH tunnel

The remote user runs this on their own machine:

```bash
ssh -L 3838:localhost:3838 user@server-ip
```

Then opens `http://localhost:3838/watermelon` in their browser.

### Option B: nginx reverse proxy with HTTPS

```bash
sudo apt-get install -y nginx certbot python3-certbot-nginx
```

Create `/etc/nginx/sites-available/watermelon`:

```nginx
server {
    listen 80;
    server_name watermelon.yourdomain.org;

    location /watermelon/ {
        proxy_pass http://localhost:3838/watermelon/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_read_timeout 3600;
    }
}
```

```bash
sudo ln -s /etc/nginx/sites-available/watermelon /etc/nginx/sites-enabled/
sudo systemctl restart nginx
sudo certbot --nginx -d watermelon.yourdomain.org
```

### Option C: ngrok (quick demo)

```bash
ngrok http 3838
```

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

**`app_cache` permission errors**
```bash
sudo chown -R shiny:shiny /srv/shiny-server/watermelon/
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
