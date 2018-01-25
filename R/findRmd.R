#' Find R Markdown files by content with pattern matching
#'
#' \code{findRmd} scans all directories and subdirectories of a given path for R Markdown files with content
#'     that matches a specific pattern. Hits can be copied to a new folder.
#'
#' @param pattern a pattern (regular expression) to search for.
#' @param lowercase a logical value. If \code{TRUE}, all Rmd file content is converted to lower case.
#' @param path a character vector, path to be scanned. The default corresponds to the working directory, getwd().
#' @param copy a logical value. If \code{TRUE}, all matching R scripts are copied to \code{folder}.
#' @param folder a character vector, path or name of new folder to copy matching R scripts to.
#' @param overwrite a logical value. If \code{TRUE}, existing destination files are overwritten.
#' @examples
#'\dontrun{
#'# Find all R markdown files in folder 'my_rmd_files' containing a ggplot bar chart:
#'findRmd(path = "my_rmd_files", pattern = "geom_bar")
#'
#'# Copy R markdown files with matching content to a new folder:
#'findRmd(path = "my_rmd_files", pattern = "geom_bar", copy = T, folder = "my_bar_rmd_files")
#'}
#' @export

findRmd <- function(path = ".", pattern = "hello world", lowercase = FALSE, copy = FALSE, folder = "findRmd", overwrite = TRUE) {

  # Get all subdirectories
  drs <- list.dirs(path = path)

  # Get all R Markdown files in subdirectories
  fls <- list.files(drs, pattern = "\\.Rmd$|\\.RMD$|\\.rmd$|\\.Rmarkdown$", full.names = T)

  if (length(fls) > 0) {

    # Scan R Markdown files for pattern
    hits <- NULL

    for (i in 1:length(fls)) {

      if (lowercase == TRUE) {

        a <- tolower(readLines(fls[i], warn = F))

      } else {

        a <- readLines(fls[i], warn = F)

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

          file.copy(hits$path_to_file[i], folder, overwrite = overwrite)

        }

        }

    }

    # Messages 1
    message(paste0("Number of directories scanned: ", length(drs)))
    message(paste0("Number of Rmd files scanned: ", length(fls)))
    message(paste0("Number of Rmd files with matches: ", length(unique(hits$path_to_file))))
    message(paste0("Total number of matches: ", nrow(hits)))
    hits

  } else {

    # Messages 2
    message(paste0("Number of directories scanned: ", length(drs)))
    message(paste0("No R Markdown files found!"))

  }
}


