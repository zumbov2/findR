#' Find reminders on how to use a specific R function
#'
#' \code{reminder} scans all directories and subdirectories of a given path for files (.R, .Rmd, .txt) containing
#'     a specific R function and prints the corresponding code.
#'
#' @param func a function to search for.
#' @param path a character vector, path to be scanned. The default corresponds to the working directory, getwd().
#' @param before integer. The number of lines before the match to print.
#' @param after integer. The number of lines after the match to print.
#' @param rm.blank a logical value. If \code{TRUE}, all blank code lines are removed before printing.
#' @param stepwise a logical value. If \code{TRUE}, examples are shown one by one using prompt.
#' @examples
#'# Find reminder on how to use the function chordDiagram
#'reminder(func = "chordDiagram", path = system.file(package = "findR"), after = 7, stepwise = FALSE)
#' @export

reminder <- function(func = "library",
                     path = ".",
                     before = 0,
                     after = 0,
                     rm.blank = FALSE,
                     stepwise = TRUE) {

# Version with prompt
if (stepwise == TRUE) {

    # Get all R scripts in subdirectories
    fls <- list.files(path, pattern = "\\.r$|\\.rmd$|\\.txt$", full.names = T, recursive = T, ignore.case = T)

    if (length(fls) > 0) {

      # Counter
      n <- 0

      # Prompt input
      x <- ""

      # Scan R scripts for pattern
      for (i in 1:length(fls)) {

        # Control input (level 1)
        if (x == "n") break()
        if (x == "y") x <- ""

        # Exclude comments
        a <- readLines(fls[i], warn = F)
        b <- gsub(" ", "", a)
        b <- substr(b, 0, 1)
        a <- a[!b == "#"]

        # Remove blank code lines
        if (rm.blank == TRUE) {

          b <- gsub(" ", "", a)
          a <- a[!b == ""]

        }

        # Show examples file by file
        if (length(grep(paste0(func, "\\("), a)) > 0) {

          # Control input (level 2)
          if (x == "n") break()
          if (x == "y") x <- ""

          # Get matching lines
          line <- which(grepl(paste0(func, "\\("), a))

          # Update counter
          n <- n + length(line)

          # Show one example after the other
          for (j in 1:length(line)) {

            # Control prompt (level 3)
            if (x == "n") break()
            if (x == "y") x <- ""

            # Define code section
            start <- line[j] - before
            stop <- line[j] + after

            # Limitations
            if (start < 1) start <- 1
            if (stop > length(a)) stop <- length(a)

            # Print reminder
            c <- NULL

            for (k in start:stop) {

              c <- c(c, a[k])

            }

            cat(c, sep = "\n")

            # Prompt
            while (!x %in% c("y", "n")) x <- readline("Show next example? (y/n): ")

          }

        }

      }

      if (n == 0) message("No examples found!")

      } else {

      message("No files (.R, .Rmd, .txt) found!")

      }

    # Version wihout prompt
  } else {

  # Get all R scripts in subdirectories
  fls <- list.files(path, pattern = "\\.r$|\\.rmd$|\\.txt$", full.names = T, recursive = T, ignore.case = T)

  if (length(fls) > 0) {

    # Counter
    n <- 0

    # Scan R scripts for pattern
    for (i in 1:length(fls)) {

      # Exclude comments
      a <- readLines(fls[i], warn = F)
      b <- gsub(" ", "", a)
      b <- substr(b, 0, 1)
      a <- a[!b == "#"]

      # Remove blank code lines
      if (rm.blank == TRUE) {

        b <- gsub(" ", "", a)
        a <- a[!b == ""]

      }

      # Show examples file by file
      if (length(grep(paste0(func, "\\("), a)) > 0) {

        # Get matching lines
        line <- which(grepl(paste0(func, "\\("), a))

        # Update counter
        n <- n + length(line)

        # Show one example after the other
        for (j in 1:length(line)) {

          # Define code section
          start <- line[j] - before
          stop <- line[j] + after

          # Limitations
          if (start < 1) start <- 1
          if (stop > length(a)) stop <- length(a)

          # Print reminder
          c <- NULL

          for (k in start:stop) {

            c <- paste(c, a[k], sep = "\n")

          }

          cat(c, sep = "\n")

        }

      }

    }

    if (n == 0) message("No examples found!")

  } else {

    message("No files (.R, .Rmd, .txt) found!")

  }

}

}
