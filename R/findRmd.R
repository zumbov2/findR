#' Find R Markdown files by content with pattern matching
#'
#' \code{findRmd} scans all directories and subdirectories of a given path for R Markdown files (.Rmd) containing
#'     a specific pattern.  Hits can be copied to a new folder.
#'
#' @param pattern a pattern (regular expression) to search for.
#' @param path a character vector, path to be scanned. The default corresponds to the working directory, getwd().
#' @param case.sensitive a logical value. If \code{TRUE}, pattern-matching is case-sensitive.
#' @param show.results a logical value. If \code{TRUE}, results are printed after completion.
#' @param copy a logical value. If \code{TRUE}, all matching R Markdown files are copied to \code{folder}.
#' @param folder a character vector, path or name of new folder to copy matching R Markdown files to.
#' @param overwrite a logical value. If \code{TRUE}, existing destination files are overwritten.
#' @examples
#'# Find all R Markdown files in the package folder that contain a ggplot bar chart
#'findRmd(path = system.file(package = "findR"), pattern = "geom_bar")
#'
#'# Save results in a data frame and show hits
#'dt <- findRmd(path = system.file(package = "findR"), pattern = "geom_bar", show.results = TRUE)
#'dt
#'
#' @export

findRmd <- function(path = ".",
                    pattern = "Hello World",
                    case.sensitive = TRUE,
                    show.results = TRUE,
                    copy = FALSE,
                    folder = "findRmd",
                    overwrite = TRUE) {

  # Get all R Markdown files in subdirectories
  fls <- list.files(path, pattern = "\\.rmd$", full.names = T, recursive = T, ignore.case = T)

  if (length(fls) > 0) {

    # Scan R Markdown files for pattern
    hits <- NULL

    for (i in 1:length(fls)) {

      if (case.sensitive == FALSE) {

        pattern <- tolower(pattern)
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
    message(paste0("Number of R markdown files scanned: ", length(fls)))

    if (!is.null(hits)) {

      message(paste0("Number of R markdown files with matching content: ", length(unique(hits$path_to_file))))
      message(paste0("Total number of matches: ", nrow(hits)))

      # Print Results
      if (show.results == TRUE) hits

    } else {

      message("Number of R markdown files with matching content: 0")
      message("Total number of matches: 0")

    }

  } else {

    # Messages 2
    message(paste0("No R markdown files found!"))

  }

}
