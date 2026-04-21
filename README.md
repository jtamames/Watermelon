# Watermelon

Interactive Shiny dashboard for running, visualizing and exploring [SqueezeMeta](https://github.com/jtamames/SqueezeMeta) metagenomics results.

## Features

- **Run** — launch SqueezeMeta, sqm_reads or sqm_longreads pipelines directly from the browser, monitor progress in real time, and automatically load results when the run finishes
- **Load** — loads SQM (full) and SQMlite projects, displays a structured summary including reads, contigs, ORFs, taxonomy coverage and most abundant taxa
- **Plots** — interactive barplots and heatmaps for taxonomy (all ranks) and functions (COG, KEGG, PFAM, external DBs), with search, count type selection, rescaling options, and adjustable size/font; bins barplot
- **Tables** — browsable, downloadable tables for assembly (contigs, ORFs), taxonomy (all ranks), functions (COG, KEGG, PFAM, external DBs) and bins; multiple metrics; COG and KEGG tables include Name and Path annotation columns
- **Krona** — generates and displays interactive Krona taxonomy charts inline, with per-sample filtering and HTML download
- **Pathways** — overlays functional abundance data onto KEGG pathway maps using `exportPathway` from SQMtools; supports per-sample coloring, log scale, fold-change between sample groups, and hierarchical pathway browser with search
- **Multivariate** — ordination analysis (PCA and NMDS) on taxonomy or functional abundance data, with multiple normalization and distance options, quality warnings, and interactive biplot

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
conda activate SqueezeMeta
Rscript -e 'shiny::runApp("app.R", launch.browser=FALSE)'
```

When the app starts, you will see a message like:

```
Listening on http://127.0.0.1:6186
```

Open that URL in your browser. The port number may vary each time.

To use a fixed port or make the app accessible from another machine on the network:

```bash
Rscript -e 'shiny::runApp("app.R", host="0.0.0.0", port=3838, launch.browser=FALSE)'
```

Then open `http://<server-ip>:3838` in your local browser.

> **Important:** the SqueezeMeta conda environment must be active before launching the app, both for the visualisation features and for the Run tab to be able to find `SqueezeMeta.pl` and related scripts in the PATH.

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

---

## Usage

### Run tab — launching a pipeline

The **Run** tab lets you configure and launch a SqueezeMeta pipeline without leaving the browser.

#### Configuring a run

**Project Setup**

- **Project name** — name for the output directory that will be created inside the working directory.
- **Program** — choose between `SqueezeMeta` (Illumina / short reads), `sqm_reads` (read-level, no assembly) or `sqm_longreads` (Oxford Nanopore long reads).
- **Execution mode** — (SqueezeMeta only) `coassembly`, `sequential`, `merged` or `seqmerge`.

**Input Files**

- **Samples file (-s)** — the samples file listing your FASTQ files and their metadata.
- **Input directory (-f)** — directory containing the FASTQ files.
- **Working directory** — directory where the project folder will be created.

**Profile** (SqueezeMeta only)

Pre-defined parameter sets for common use cases:

- *Standard Metagenome* — default settings for Illumina short-read data (megahit assembler, bowtie mapper).
- *Nanopore Metagenome* — optimised for ONT long reads (canu assembler, minimap2-ont mapper, adjusted consensus parameters).

Loading a profile overwrites the current advanced settings. You can then fine-tune individual parameters manually.

**Advanced settings**

- **Filtering** — optionally run Trimmomatic quality trimming before assembly, with configurable parameters.
- **Assembly** — assembler (`megahit`, `spades`, `rnaspades`, `canu`, `flye`), assembly options, minimum contig length, singletons.
- **Annotation** — disable individual annotation databases (COG, KEGG, PFAM); enable eukaryote mode or double-pass diamond; add external databases.
- **Mapping** — mapper (`bowtie`, `bwa`, `minimap2-ont`, `minimap2-pb`, `minimap2-sr`) and extra mapping options.
- **Binning** — skip binning, run only binning, or choose which binners to use (Concoct, Metabat2, MaxBin).
- **Performance** — number of threads.

#### Starting and monitoring the run

Click **▶ Run** to start the pipeline. The execution log streams output in real time. The current pipeline step (e.g. `STEP4 -> HOMOLOGY SEARCHES`) is displayed in large text above the log so you can follow progress at a glance.

Click **■ Abort** to stop the pipeline at any point (a confirmation dialog will appear).

#### Automatic loading of results

When the pipeline finishes successfully, Watermelon automatically:

1. Runs `sqm2tables.py` (or `sqmreads2tables.py` for sqm_reads / sqm_longreads) to generate the SQMlite tables, streaming its output to the log.
2. Loads the project with `loadSQM` or `loadSQMlite` from SQMtools.
3. Reveals the analysis tabs (Plots, Tables, Krona, Pathways, Multivariate) and switches to the **Load** tab to show the project summary.

If the tables directory already exists from a previous run, step 1 is skipped.

---

### Load tab — loading an existing project

1. Go to the **Load** tab.
2. Choose load mode: **Load project** (for a SqueezeMeta project directory) or **Load tables** (for a directory of SQMlite tables).
3. Click **Select directory** and choose the appropriate directory.
4. The app auto-detects the project type from `creator.txt`:
   - **SqueezeMeta projects** (`SqueezeMeta.pl`): point to the project root directory.
   - **SQMlite projects** (`sqm2tables.py`, `sqmreads2tables.py`, `combine-sqm-tables.py`): point to the tables directory.
5. Click **Load**.

If the tables directory cannot be detected automatically, a manual directory selector will appear.

---

## Project types

| Type | Load function | Features |
|------|--------------|----------|
| SQM (full) | `loadSQM` | All tabs, all plots, taxonomy/function search, bins |
| SQMlite | `loadSQMlite` | Plots, Tables, Krona, Pathways, Multivariate; no contig/ORF/bin detail |

---

## Tabs

### Plots

Select a category (Taxonomy / Functions / MAGs) and then a plot type from the sidebar.

**Taxonomy (barplot)** — stacked barplot of the most abundant taxa at the selected rank.

- Choose rank (Phylum → Species), count type, and number of taxa.
- Optionally search for specific taxa by name (SQM full only); comma-separated, empty means top N.
- Filter options: Ignore unmapped, Ignore unclassified, Ignore ambiguous, Rescale to 100%.
- Format controls (top bar): width, height, font size, colour palette, label width.

**Taxonomy (heatmap)** — interactive heatmap of the most abundant taxa.

**COG / KEGG / PFAM / external databases** — interactive heatmap of the most abundant functions, with search by ID or keyword, optional category filter, count type and rescale selectors.

**MAGs** — barplot of bin abundances (SQM full only).

All plots support a **sample selector** to restrict the analysis to a subset of samples.

### Tables

Four independent category selectors: Assembly (contigs, ORFs), Taxonomy (all ranks), Functions (COG, KEGG, PFAM, external DBs) and Bins. Use **Download CSV** to export the current view.

### Krona

Generates an interactive Krona taxonomy chart using `exportKrona` from SQMtools and `ktImportText` from KronaTools. Optionally filter by sample before generating. Displayed inline and downloadable as self-contained HTML.

### Pathways

Overlays KEGG functional abundance data onto pathway maps using `exportPathway` from SQMtools (wraps the `pathview` Bioconductor package). Requires an internet connection. Supports per-sample coloring, fold-change mode and log scale.

### Multivariate

Ordination analysis (PCA and NMDS) on taxonomy or functional abundance data, with multiple normalization and distance options and quality warnings.

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
| processx | CRAN | Run tab |
| plotly | CRAN | Plots tab |
| vegan | CRAN | Multivariate tab |
| xml2 | CRAN | Pathways tab |
| pathview | Bioconductor | Pathways tab |
| KronaTools (`ktImportText`) | conda / GitHub | Krona tab |

---

## Server deployment (remote access)

This section explains how to make Watermelon accessible to remote users via **Shiny Server**, running permanently on a Linux machine.

### 1. Install R packages on the server

All packages must be installed as root so Shiny Server can find them:

```bash
sudo apt-get install -y cmake liblzma-dev
sudo R -e "install.packages(c('shiny','shinyjs','shinyFiles','bslib','DT','plotly','SQMtools','vegan','xml2','processx'), repos='https://cran.rstudio.com/')"
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

> **Note on the Run tab in server mode:** when running under Shiny Server, the `shiny` user must have access to the SqueezeMeta conda environment and `SqueezeMeta.pl` must be in its PATH. Add the conda `bin` directory to `/etc/environment` or configure `run_as` to use a user with the environment active.

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

## Troubleshooting

**App does not load / blank page**
```bash
tail -f /var/log/shiny-server/*.log
```

**Missing R packages** — the log will show `Error in library(...)`. Install as root (see step 1).

**`SqueezeMeta.pl` not found (Run tab)**

Verify the conda environment is active and the executable is on the PATH:
```r
Sys.which("SqueezeMeta.pl")   # should return a path, not ""
Sys.getenv("PATH")            # should include the conda env bin directory
```
Always launch the app from inside an active conda environment:
```bash
conda activate SqueezeMeta
Rscript -e 'shiny::runApp("app.R", launch.browser=FALSE)'
```

**`processx` error on run start** — make sure `processx` is installed:
```bash
conda activate SqueezeMeta
R -e "install.packages('processx', repos='https://cran.rstudio.com/')"
```

**shiny user cannot read project files**
```bash
sudo chmod -R o+rX /path/to/sqm/project
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
