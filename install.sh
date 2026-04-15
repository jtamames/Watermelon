#!/bin/bash
# Watermelon installer
# Installs all R dependencies inside the active conda environment
# Usage:
#   conda activate SqueezeMeta
#   bash install.sh

set -e

echo "============================================"
echo " Watermelon dependency installer"
echo "============================================"
echo ""

# ── Check we are inside a conda environment ────
if [ -z "$CONDA_PREFIX" ]; then
  echo "ERROR: No conda environment is active."
  echo "Please activate your SqueezeMeta environment first:"
  echo "  conda activate SqueezeMeta"
  exit 1
fi

echo "Active conda environment: $CONDA_PREFIX"
echo ""

# ── Check R is available ───────────────────────
if ! command -v Rscript &> /dev/null; then
  echo "ERROR: Rscript not found in the active conda environment."
  echo "Install R with: conda install -c conda-forge r-base"
  exit 1
fi

R_VERSION=$(Rscript -e 'cat(as.character(getRversion()))')
echo "R version: $R_VERSION"
echo ""

# ── 1. System libraries ────────────────────────
if command -v apt-get &> /dev/null; then
  echo "[1/3] Installing system libraries..."
  sudo apt-get install -y \
    cmake zip \
    libcurl4-openssl-dev libssl-dev libxml2-dev \
    libfontconfig1-dev libharfbuzz-dev libfribidi-dev \
    libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev \
    liblzma-dev 2>/dev/null \
    || echo "  (skipped — no sudo access)"
  echo "  ✓ System libraries done"
else
  echo "[1/3] Skipping system libraries (apt-get not available)"
fi

# Make cmake visible without overriding conda's R
# Find cmake location and add only that directory
CMAKE_DIR=$(dirname "$(which cmake 2>/dev/null || find /usr -name cmake -type f 2>/dev/null | head -1)")
if [ -n "$CMAKE_DIR" ] && [ "$CMAKE_DIR" != "." ]; then
  export PATH="$PATH:$CMAKE_DIR"
fi
echo ""

# ── 2. R packages (CRAN) ───────────────────────
echo "[2/3] Installing R packages from CRAN..."
Rscript -e "
  repos <- 'https://cran.rstudio.com/'
  pkgs <- c('shiny', 'shinyjs', 'shinyFiles', 'bslib', 'DT', 'plotly',
            'SQMtools', 'vegan', 'ggplot2', 'htmlwidgets', 'xml2')
  missing <- pkgs[!sapply(pkgs, requireNamespace, quietly = TRUE)]
  if (length(missing) > 0) {
    cat('  Installing:', paste(missing, collapse=', '), '\n')
    install.packages(missing, repos=repos)
    still_missing <- missing[!sapply(missing, requireNamespace, quietly = TRUE)]
    if (length(still_missing) > 0)
      stop('Failed to install: ', paste(still_missing, collapse=', '))
  } else {
    cat('  All CRAN packages already installed\n')
  }
"
echo "  ✓ CRAN packages installed"
echo ""

# ── 3. R packages (Bioconductor) ──────────────
echo "[3/3] Installing Bioconductor packages (pathview, Biostrings)..."
Rscript -e "
  if (!requireNamespace('BiocManager', quietly=TRUE))
    install.packages('BiocManager', repos='https://cran.rstudio.com/')
  BiocManager::install(ask = FALSE, update = FALSE)
  pkgs <- c('pathview', 'Biostrings')
  missing <- pkgs[!sapply(pkgs, requireNamespace, quietly = TRUE)]
  if (length(missing) > 0) {
    cat('  Installing:', paste(missing, collapse=', '), '\n')
    BiocManager::install(missing, ask = FALSE)
    still_missing <- missing[!sapply(missing, requireNamespace, quietly = TRUE)]
    if (length(still_missing) > 0)
      warning('Failed to install: ', paste(still_missing, collapse=', '),
              ' — Pathways tab will not be available.')
  } else {
    cat('  Bioconductor packages already installed\n')
  }
"
echo "  ✓ Bioconductor packages installed"
echo ""

echo "============================================"
echo " Installation complete!"
echo ""
echo " To run Watermelon:"
echo "   conda activate SqueezeMeta"
echo "   cd /path/to/watermelon"
echo "   Rscript -e 'shiny::runApp(\"app.R\", launch.browser=FALSE)'"
echo "============================================"
