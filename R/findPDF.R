#' Find PDF files by content with pattern matching
#'
#' \code{findPDF} scans all directories and subdirectories of a given path for PDF files (.pdf) containing
#'     a specific pattern.  Hits can be copied to a new folder.
#'
#' @param pattern a pattern (regular expression) to search for.
#' @param path a character vector, path to be scanned. The default corresponds to the working directory, getwd().
#' @param case.sensitive a logical value. If \code{TRUE}, pattern-matching is case-sensitive.
#' @param show.results a logical value. If \code{TRUE}, results are printed after completion.
#' @param copy a logical value. If \code{TRUE}, all matching PDF files are copied to \code{folder}.
#' @param folder a character vector, path or name of new folder to copy matching PDF files scripts to.
#' @param overwrite a logical value. If \code{TRUE}, existing destination files are overwritten.
#' @examples
#'# Find all PDF files in the package folder that contain the name Hanna
#'findPDF(path = system.file(package = "findR"), pattern = "Hanna")
#'
#'# Save results in a data frame and show hits
#'dt <- findPDF(path = system.file(package = "findR"), pattern = "Hanna", show.results = TRUE)
#'dt
#'
#' @export

findPDF <- function(path = ".",
                    pattern = "Hello World",
                    case.sensitive = TRUE,
                    show.results = TRUE,
                    copy = FALSE,
                    folder = "findPDF",
                    overwrite = TRUE) {

  # Get all PDF files in subdirectories
  fls <- list.files(path, pattern = "\\.pdf", full.names = T, recursive = T, ignore.case = T)

  if (length(fls) > 0) {

    # Scan all PDF files for pattern
    hits <- NULL

    for (i in 1:length(fls)) {

      if (case.sensitive == FALSE) {

        pattern <- tolower(pattern)
        a <- try(suppressMessages(tolower(pdftools::pdf_text(fls[i]))), silent = TRUE)

      } else {

        a <- try(suppressMessages(pdftools::pdf_text(fls[i])), silent = TRUE)

      }

      if (length(grep(pattern, a)) > 0) {

        path_to_file <- file.path(fls[i])
        page <- which(grepl(pattern, a))
        hit <- cbind.data.frame(path_to_file, page)
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
    message(paste0("Number of PDF files scanned: ", length(fls)))

    if (!is.null(hits)) {

      message(paste0("Number of PDF files with matching content: ", length(unique(hits$path_to_file))))
      message(paste0("Total number of matches: ", nrow(hits)))

      # Print Results
      if (show.results == TRUE) hits

    } else {

      message("Number of PDF files with matching content: 0")
      message("Total number of matches: 0")

    }

  } else {

    # Messages 2
    message(paste0("No PDF files found!"))

  }

}
