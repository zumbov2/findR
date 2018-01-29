#' Find R scripts by content with pattern matching
#'
#' \code{findRscript} scans all directories and subdirectories of a given path for R scripts (.R) containing
#'     a specific pattern.  Hits can be copied to a new folder.
#'
#' @param path a character vector, path to be scanned. The default corresponds to the working directory, getwd().
#' @param pattern a pattern (regular expression) to search for.
#' @param lowercase a logical value. If \code{TRUE}, R script content is converted to lowercase before pattern matching.
#' @param comments a logical value. If \code{FALSE}, comments (lines starting with #) are excluded from pattern matching.
#' @param copy a logical value. If \code{TRUE}, all matching R scripts are copied to \code{folder}.
#' @param folder a character vector, path or name of new folder to copy matching R scripts to.
#' @param overwrite a logical value. If \code{TRUE}, existing destination files are overwritten.
#' @examples
#'# Find all Rscripts in the package folder that use the circlize package
#'findRscript(path = system.file(package = "findR"), pattern = "circlize")
#' @export

findRscript <- function(path = ".", pattern = "hello world", lowercase = FALSE, comments = TRUE, copy = FALSE, folder = "findRscript", overwrite = TRUE) {

  # Get all R scripts in subdirectories
  fls <- list.files(path, pattern = "\\.r$", full.names = T, recursive = T, ignore.case = T)

  if (length(fls) > 0) {

    # Scan R scripts for pattern
    hits <- NULL

    for (i in 1:length(fls)) {

      if (lowercase == TRUE) {

        a <- tolower(readLines(fls[i], warn = F))

      } else {

        a <- readLines(fls[i], warn = F)

      }

      if (comments == FALSE) {

        b <- gsub(" ", "", a)
        b <- substr(b, 0, 1)
        a[b == "#"] <- ""

      }

      if (length(grep(pattern, a)) > 0) {

        path_to_file <- fls[i]
        line <- which(grepl(pattern, a))
        hit <- cbind.data.frame(path_to_file, line)
        hits <- rbind.data.frame(hits, hit)

        rm(hit)

      }

    }

    # Copy scripts to folder
    if (copy == TRUE) {

      dir.create(folder)

      if (!is.null(hits)) {

        for (i in 1:nrow(hits)) {

          file.copy(hits$path_to_file[i], folder, overwrite = overwrite, copy.date = TRUE)

        }

      }

    }

    # Messages 1
    message(paste0("Number of R scripts scanned: ", length(fls)))

    if (!is.null(hits)) {

      message(paste0("Number of R scripts with matching content: ", length(unique(hits$path_to_file))))
      message(paste0("Total number of matches: ", nrow(hits)))

      hits

    } else {

      message("Number of R scripts with matching content: 0")
      message("Total number of matches: 0")

    }

  } else {

    # Messages 2
    message(paste0("No R scripts found!"))

  }

}
