#' Find R scripts by content with pattern matching
#'
#' \code{findRscript} scans all directories and subdirectories of a given path for R scripts with content
#'     that matches a specific pattern and copies the hits to a folder.
#'
#' @param path a character vector, path to be scanned. The default corresponds to the working directory, getwd().
#' @param pattern a pattern (regular expression) to search for.
#' @param lowercase a logical value. If \code{TRUE}, all R script content is converted to lower case.
#' @param comments a logical value. If \code{FALSE}, comments (lines starting with #) are excluded from pattern matching.
#' @param copy a logical value. If \code{TRUE}, all matching R scripts are copied to \code{folder}.
#' @param folder a character vector, path or name of new folder to copy matching R scripts to.
#' @param overwrite a logical value. If \code{TRUE}, existing destination files are overwritten.
#' @examples
#' # Find all R scripts with a ggplot bar chart:
#' findRscript(pattern = "geom_bar")
#' @export

findRscript <- function(path = ".", pattern = "hello world", lowercase = TRUE, comments = TRUE, copy = TRUE, folder = "findRscript", overwrite = TRUE) {

  # Get all subdirectories
  drs <- list.dirs(path = path)

  # Get all R scripts in subdirectories
  fls <- list.files(drs, pattern = "\\.r$|\\.R$", full.names = T)

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
    message(paste0("Number of directories scanned: ", length(drs)))
    message(paste0("Number of R scripts scanned: ", length(fls)))
    message(paste0("Number of R files with matches: ", length(unique(hits$path_to_file))))
    message(paste0("Total number of matches: ", nrow(hits)))
    hits

  } else {

    # Messages 2
    message(paste0("Number of directories scanned: ", length(drs)))
    message(paste0("No R scripts found!"))

  }

}
