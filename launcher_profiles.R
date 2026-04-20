# R/builtin_profiles.R
# Built-in execution profiles for SqueezeMeta pipelines.
# To add custom profiles, extend the list returned by get_builtin_profiles().

get_builtin_profiles <- function() {
  list(
    list(
      name        = "Standard Metagenome",
      description = "Balanced configuration for Illumina short-read data",
      parameters  = list(
        threads          = 8,
        assembler        = "megahit",
        mode             = "coassembly",
        mapper           = "bowtie",
        consensus        = 50,
        assembly_options = "",
        skip_binning     = FALSE
      )
    ),
    list(
      name        = "Nanopore Metagenome",
      description = "Optimised for Oxford Nanopore long-read data",
      parameters  = list(
        threads          = 8,
        assembler        = "canu",
        mode             = "coassembly",
        mapper           = "minimap2-ont",
        consensus        = 20,
        assembly_options = "stopOnLowCoverage=2 minInputCoverage=0",
        skip_binning     = FALSE
      )
    )
  )
}

# Return a profile by exact name, or NULL if not found.
get_profile_by_name <- function(name) {
  profiles <- get_builtin_profiles()
  idx      <- which(sapply(profiles, function(p) p$name == name))
  if (length(idx) == 0) return(NULL)
  profiles[[idx[1]]]
}
