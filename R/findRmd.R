#' Find R Markdown files by content with pattern matching
#'
#' \code{findRmd} scans all directories and subdirectories of a given path for R Markdown files (.Rmd) containing
#'     a specific pattern.  Hits can be copied to a new folder.
#'
#' @param pattern a pattern (regular expression) to search for.
#' @param lowercase a logical value. If \code{TRUE}, Rmd file content is converted to lowercase before pattern matching.
#' @param path a character vector, path to be scanned. The default corresponds to the working directory, getwd().
#' @param copy a logical value. If \code{TRUE}, all matching R Markdown files are copied to \code{folder}.
#' @param folder a character vector, path or name of new folder to copy matching R Markdown files to.
#' @param overwrite a logical value. If \code{TRUE}, existing destination files are overwritten.
#' @examples
#'\dontrun{
#'# Find all of your R Markdown files with a ggplot2 scatterplot
#'findRmd(path = "my_files", pattern = "geom_point")
#'
#'# Save the hits to a new folder
#'findRmd(path = "my_files", pattern = "geom_point", copy = TRUE, folder = "Rmd_scatterplot")
#'}
#'\dontshow{
#'# Find all R Markdown files in the package folder that contain a ggplot bar chart
#'findRmd(path = system.file(package = "findR"), pattern = "geom_bar")
#'
#'# Copy the hits to a new folder
#'findRmd(path = system.file(package = "findR"), pattern = "geom_bar", copy = TRUE, folder = file.path(tempdir(), "r2"))
#'list.files(file.path(tempdir(), "r2"))
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
    message(paste0("Number of R markdown files scanned: ", length(fls)))

    if (!is.null(hits)) {

      message(paste0("Number of R markdown files with matching content: ", length(unique(hits$path_to_file))))
      message(paste0("Total number of matches: ", nrow(hits)))

      hits

    } else {

      message("Number of R markdown files with matching content: 0")
      message("Total number of matches: 0")

    }

  } else {

    # Messages 2
    message(paste0("Number of directories scanned: ", length(drs)))
    message(paste0("No R markdown files found!"))

  }

}
