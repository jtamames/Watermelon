# R/build_sm_command.R
# Builds the command-line argument vector for any SqueezeMeta program.
# Used both by run_squeezemeta() and the command-preview reactive in the UI.

#' Build the argument list for a SqueezeMeta invocation
#'
#' @return A character vector: c(executable, arg1, arg2, ...)
#' @export
build_sm_command <- function(program,
                             samples_file,
                             input_dir,
                             project_name,
                             workdir,
                             mode             = "coassembly",
                             threads          = 8,
                             run_trimmomatic  = FALSE,
                             cleaning_parameters = NULL,
                             assembler        = "megahit",
                             assembly_options = NULL,
                             min_contig_length = 200,
                             use_singletons   = FALSE,
                             no_cog           = FALSE,
                             no_kegg          = FALSE,
                             no_pfam          = TRUE,
                             eukaryotes       = FALSE,
                             doublepass       = FALSE,
                             extdb            = NULL,
                             mapper           = "bowtie",
                             mapping_options  = NULL,
                             no_bins          = FALSE,
                             only_bins        = FALSE,
                             binners          = c("concoct", "metabat2"),
                             consensus        = 50) {

  exe <- Sys.which(program)
  if (exe == "") exe <- program  # fallback: show bare name in preview

  args <- c(
    "-s", normalizePath(samples_file, mustWork = FALSE),
    "-f", normalizePath(input_dir,    mustWork = FALSE),
    "-p", project_name,
    "-t", as.character(threads)
  )

  if (program == "SqueezeMeta.pl") {
    args <- c(args, "-m", mode)
  }

  if (no_cog)    args <- c(args, "--nocog")
  if (no_kegg)   args <- c(args, "--nokegg")
  if (no_pfam)   args <- c(args, "--nopfam")
  if (eukaryotes) args <- c(args, "--euk")
  if (doublepass) args <- c(args, "--D")

  if (!is.null(extdb) && nzchar(extdb)) {
    args <- c(args, "-extdb", extdb)
  }

  if (program == "SqueezeMeta.pl" && run_trimmomatic) {
    args <- c(args, "--cleaning")
    if (!is.null(cleaning_parameters) && nzchar(cleaning_parameters)) {
      args <- c(args, "-cleaning_options", cleaning_parameters)
    }
  }

  if (program == "SqueezeMeta.pl" && !is.null(assembler) && nzchar(assembler)) {
    args <- c(args, "-a", assembler)
  }

  if (!is.null(assembly_options) && nzchar(assembly_options)) {
    args <- c(args, "-assembly_options", assembly_options)
  }

  if (!is.null(min_contig_length)) {
    args <- c(args, "-c", as.character(min_contig_length))
  }

  if (!is.null(consensus)) {
    args <- c(args, "-consensus", as.character(consensus))
  }

  if (use_singletons) args <- c(args, "--singletons")

  if (!is.null(mapper) && nzchar(mapper)) {
    args <- c(args, "-map", mapper)
  }

  if (!is.null(mapping_options) && nzchar(mapping_options)) {
    args <- c(args, "-mapping_options", mapping_options)
  }

  if (no_bins) {
    args <- c(args, "--nobins")
  } else {
    if (only_bins) args <- c(args, "--onlybins")
    if (!is.null(binners) && length(binners) > 0) {
      args <- c(args, "-binners", paste(binners, collapse = ","))
    }
  }

  c(exe, args)
}
