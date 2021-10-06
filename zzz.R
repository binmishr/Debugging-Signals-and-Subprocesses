#  zzz.R
#  Part of the R package, https://www.R-project.org
#

.noGenerics <- TRUE

if (.Platform$OS.type == "windows")
    utils::globalVariables(c("mc_pids", "clean_pids"), add = TRUE)

## dummy, just so we can register a finalizer
.fin.env <- new.env()

.onLoad <- function(libname, pkgname)
{
    initDefaultClusterOptions(libname)
    cores <- getOption("mc.cores", NULL)
    if(is.null(cores) && !is.na(nc <- as.integer(Sys.getenv("MC_CORES"))))
        options("mc.cores" = nc)
    if(.Platform$OS.type == "unix") reg.finalizer(.fin.env, clean_pids, TRUE)
}

.onUnload <-
function(libpath)
    library.dynam.unload("parallel", libpath)