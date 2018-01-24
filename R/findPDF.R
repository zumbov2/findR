#' Find PDF files by content with pattern matching
#'
#' \code{findPDF} scans all directories and subdirectories of a given path for PDF files with content
#' that matches a specific pattern and copies the hits to a folder.
#'
#' @param path a character vector, path to be scanned. The default corresponds to the working directory, getwd().
#' @param pattern a pattern (regular expression) to search for.
#' @param lowercase a logical value. If \code{TRUE}, all PDF file content is converted to lower case.
#' @param copy a logical value. If \code{TRUE}, all matching PDF files are copied to \code{folder}.
#' @param folder a character vector, path or name of new folder to copy matching R scripts to.
#' @param overwrite a logical value. If \code{TRUE}, existing destination files are overwritten.
#' @examples
#' \dontrun{
#'
#' # Find all PDF files that contain the name hanna:
#' findPDF(pattern = "hanna")
#'
#' }
#' @export

findPDF <- function(path = ".", pattern = "hello world", lowercase = TRUE, copy = TRUE, folder = "findPDF", overwrite = TRUE) {

  # Get all subdirectories
  drs <- list.dirs(path = path)

  # Get all R-Scripts in subdirectories
  fls <- list.files(drs, pattern = "\\.pdf|\\.PDF", full.names = T)

  # Scan R scripts for pattern
  hits <- NULL

  for (i in 1:length(fls)) {

    if (lowercase == TRUE) {

      a <- try(suppressMessages(tolower(pdftools::pdf_text(fls[i]))), silent = TRUE)

    } else {

      a <- try(suppressMessages(pdftools::pdf_text(fls[i])), silent = TRUE)

    }

    if (length(grep(pattern, a)) > 0) {

      path_to_file <- fls[i]
      page <- which(grepl(pattern, a))
      hit <- cbind.data.frame(path_to_file, page)
      hits <- rbind.data.frame(hits, hit)

      rm(hit)

    }

  }

  # Copy scripts to new folder
  if (copy == TRUE) {

    dir.create(folder)

    if (!is.null(hits)) {

      for (i in 1:nrow(hits)) {

        file.copy(hits$path_to_file[i], folder, overwrite = overwrite)

      }

    }
  }

  # Print information
  message(paste0("Number of directories scanned: ", length(drs)))
  message(paste0("Number of PDF files scanned: ", length(fls)))
  message(paste0("Number of PDF files with matches: ", length(unique(hits$path_to_file))))
  message(paste0("Total number of matches: ", nrow(hits)))
  hits

}
