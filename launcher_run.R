# R/run_local.R
# Launches a SqueezeMeta pipeline as a non-blocking background process
# using the processx package.

#' Run SqueezeMeta locally
#'
#' @param ... All arguments are forwarded to build_sm_command().
#' @return A list with:
#'   - process  : processx::process object
#'   - log_file : path to the plain-text log file
#' @export
run_squeezemeta <- function(program,
                            samples_file,
                            input_dir,
                            project_name,
                            workdir,
                            mode              = "coassembly",
                            threads           = 8,
                            run_trimmomatic   = FALSE,
                            cleaning_parameters = NULL,
                            assembler         = "megahit",
                            assembly_options  = NULL,
                            min_contig_length = 200,
                            use_singletons    = FALSE,
                            no_cog            = FALSE,
                            no_kegg           = FALSE,
                            no_pfam           = TRUE,
                            eukaryotes        = FALSE,
                            doublepass        = FALSE,
                            extdb             = NULL,
                            mapper            = "bowtie",
                            mapping_options   = NULL,
                            no_bins           = FALSE,
                            only_bins         = FALSE,
                            binners           = c("concoct", "metabat2"),
                            consensus         = 50) {

  # ------------------------------------------------------------------
  # Validation
  # ------------------------------------------------------------------
  if (!file.exists(samples_file))  stop("Samples file does not exist.")
  if (!dir.exists(input_dir))      stop("Input directory does not exist.")
  if (!dir.exists(workdir))        stop("Working directory does not exist.")
  if (!nzchar(project_name))       stop("Project name cannot be empty.")

  project_path <- file.path(workdir, project_name)
  if (dir.exists(project_path)) {
    stop("Project directory already exists. Choose a different project name.")
  }

  # ------------------------------------------------------------------
  # Build command via shared helper
  # ------------------------------------------------------------------
  cmd <- build_sm_command(
    program           = program,
    samples_file      = samples_file,
    input_dir         = input_dir,
    project_name      = project_name,
    workdir           = workdir,
    mode              = mode,
    threads           = threads,
    run_trimmomatic   = run_trimmomatic,
    cleaning_parameters = cleaning_parameters,
    assembler         = assembler,
    assembly_options  = assembly_options,
    min_contig_length = min_contig_length,
    use_singletons    = use_singletons,
    no_cog            = no_cog,
    no_kegg           = no_kegg,
    no_pfam           = no_pfam,
    eukaryotes        = eukaryotes,
    doublepass        = doublepass,
    extdb             = extdb,
    mapper            = mapper,
    mapping_options   = mapping_options,
    no_bins           = no_bins,
    only_bins         = only_bins,
    binners           = binners,
    consensus         = consensus
  )

  exe  <- cmd[1]
  args <- cmd[-1]

  # ------------------------------------------------------------------
  # Log file
  # ------------------------------------------------------------------
  log_file <- file.path(workdir, paste0(project_name, "_run.log"))
  file.create(log_file)

  message(paste(rep("-", 50), collapse = ""))
  message("Launching: ", paste(c(exe, args), collapse = " "))
  message("Log file : ", log_file)
  message(paste(rep("-", 50), collapse = ""))

  # ------------------------------------------------------------------
  # Launch non-blocking process
  # ------------------------------------------------------------------
  p <- processx::process$new(
    command  = exe,
    args     = args,
    stdout   = "|",
    stderr   = "|",
    supervise = TRUE,
    wd       = normalizePath(workdir)
  )

  list(process = p, log_file = log_file)
}
