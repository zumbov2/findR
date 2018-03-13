#' Find reminders on how to use a specific R function
#'
#' \code{reminder} scans all directories and subdirectories of a given path for files (.R, .Rmd, .txt) containing
#'     a specific R function and prints the corresponding lines of code.
#'
#' @param func a function to search for.
#' @param path a character vector, path to be scanned. The default corresponds to the working directory, getwd().
#' @param before integer. The number of lines to print before the function.
#' @param after integer. The number of lines to print after the function.
#' @param stepwise a logical value. If \code{TRUE}, examples are shown one by one using prompt.
#' @examples
#'# Find reminder on how to use the function chordDiagram
#'reminder(func = "chordDiagram", path = system.file(package = "findR"), stepwise = FALSE)
#' @export

reminder <- function(func = "library", path = ".", before = 0, after = 0, stepwise = TRUE) {

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

        # Load file
        a <- readLines(fls[i], warn = F)

        # Show examples file by file
        if (sum(stringr::str_count(a, paste0("(?<![A-z\\._0-9])", func, "\\("))) > 0) {

          # Control input (level 2)
          if (x == "n") break()
          if (x == "y") x <- ""

          # Detect lines with matches
          line <- stringr::str_which(a, paste0("(?<![A-z\\._0-9])", func, "\\("))

          # Update counter
          n <- n + length(line)

          # Show one example after the other
          for (j in 1:length(line)) {

            # Control prompt (level 3)
            if (x == "n") break()
            if (x == "y") x <- ""

            # Locate function in line
            loc <- stringr::str_locate_all(a[line[j]], paste0("(?<![A-z\\._0-9])", func, "\\("))

            # Detect exact position of func start and end
            for (k in 1:(length(unlist(loc))/2)) {

              # Control prompt (level 4)
              if (x == "n") break()
              if (x == "y") x <- ""

              # Trim file and replace all non-bracket patterns with 0
              b <- stringr::str_replace_all(a[line[j]:length(a)], "[^\\(\\)]", "0")

              # Trim first line
              b[1] <- stringr::str_sub(b[1], unlist(loc)[k], nchar(b[1]))

              # Replace brackets with +1 / -1
              b <- stringr::str_replace_all(b, "0", " 0")
              b <- stringr::str_replace_all(b, "\\(", " +1")
              b <- stringr::str_replace_all(b, "\\)", " -1")
              b <- stringr::str_trim(b, side = "left")
              b[b == ""] <- 0
              b <- stringr::str_split(b, " ")

              # Initialize line counter and bracket sum
              lc <- 0
              bs <- 0

              # Scan trough lines until funtion is closed
              while (lc < length(b)) {

                # Line counter
                lc <- lc + 1

                # Initialize position counter
                pc <- 0

                # Sum through line
                while (pc < length(b[[lc]])) {

                  pc <- pc + 1

                  bs_p <- bs
                  bs <- bs + as.numeric(unlist(stringr::str_split(b[[lc]], " ")))[pc]

                  if (bs_p == 1 & bs == 0) break()

                }

                if (bs_p == 1 & bs == 0) break()

              }

              # Line range of function
              start_line <- line[j]
              end_line <- line[j] + lc - 1

              # Exact position of function
              start_location <- unlist(loc)[k]
              end_location <- pc

              # Costumizable copy of a
              a2 <- a

              # Trim lines
              if (start_line == end_line) {

                a2[start_line] <- stringr::str_sub(a[start_line], start_location, start_location + end_location - 1)

              } else {

                a2[start_line] <- stringr::str_sub(a[start_line], start_location, nchar(a[start_line]))
                a2[end_line] <- stringr::str_sub(a[end_line], 1, end_location)

              }

              # Integration of before/after
              start_line <- start_line - before
              end_line <- end_line + after

              # Limitations
              if (start_line < 1) start_line <- 1
              if (end_line > length(a2)) end_line <- length(a2)

              # Print reminder
              c <- NULL

              for (l in start_line:end_line) {

              c <- c(c, a2[l])

              }

              cat(c, sep = "\n")

              # Prompt
              while (!x %in% c("y", "n")) x <- readline("Show next example? (y/n): ")
          }

        }

      }

      }

      if (n == 0) message("No examples found.")
      if (n > 0 & !x == "n") message("No additional examples found.")

      } else {

      message("No files (.R, .Rmd, .txt) found!")

      }

  } else {

    # Get all R scripts in subdirectories
    fls <- list.files(path, pattern = "\\.r$|\\.rmd$|\\.txt$", full.names = T, recursive = T, ignore.case = T)

    if (length(fls) > 0) {

      # Counter
      n <- 0

      # Scan R scripts for pattern
      for (i in 1:length(fls)) {

        # Load file
        a <- readLines(fls[i], warn = F)

        # Show examples file by file
        if (sum(stringr::str_count(a, paste0("(?<![A-z\\._0-9])", func, "\\("))) > 0) {

          # Detect lines with matches
          line <- stringr::str_which(a, paste0("(?<![A-z\\._0-9])", func, "\\("))

          # Update counter
          n <- n + length(line)

          # Show one example after the other
          for (j in 1:length(line)) {

            # Locate function in line
            loc <- stringr::str_locate_all(a[line[j]], paste0("(?<![A-z\\._0-9])", func, "\\("))

            # Detect exact position of func start and end
            for (k in 1:(length(unlist(loc))/2)) {

              # Trim file and replace all non-bracket patterns with 0
              b <- stringr::str_replace_all(a[line[j]:length(a)], "[^\\(\\)]", "0")

              # Trim first line
              b[1] <- stringr::str_sub(b[1], unlist(loc)[k], nchar(b[1]))

              # Replace brackets with +1 / -1
              b <- stringr::str_replace_all(b, "0", " 0")
              b <- stringr::str_replace_all(b, "\\(", " +1")
              b <- stringr::str_replace_all(b, "\\)", " -1")
              b <- stringr::str_trim(b, side = "left")
              b[b == ""] <- 0
              b <- stringr::str_split(b, " ")

              # Initialize line counter and bracket sum
              lc <- 0
              bs <- 0

              # Scan trough lines until funtion is closed
              while (lc < length(b)) {

                # Line counter
                lc <- lc + 1

                # Initialize position counter
                pc <- 0

                # Sum through line
                while (pc < length(b[[lc]])) {

                  pc <- pc + 1

                  bs_p <- bs
                  bs <- bs + as.numeric(unlist(stringr::str_split(b[[lc]], " ")))[pc]

                  if (bs_p == 1 & bs == 0) break()

                }

                if (bs_p == 1 & bs == 0) break()

              }

              # Line range of function
              start_line <- line[j]
              end_line <- line[j] + lc - 1

              # Exact position of function
              start_location <- unlist(loc)[k]
              end_location <- pc

              # Costumizable copy of a
              a2 <- a

              # Trim lines
              if (start_line == end_line) {

                a2[start_line] <- stringr::str_sub(a[start_line], start_location, start_location + end_location - 1)

              } else {

                a2[start_line] <- stringr::str_sub(a[start_line], start_location, nchar(a[start_line]))
                a2[end_line] <- stringr::str_sub(a[end_line], 1, end_location)

              }

              # Integration of before/after
              start_line <- start_line - before
              end_line <- end_line + after

              # Limitations
              if (start_line < 1) start_line <- 1
              if (end_line > length(a2)) end_line <- length(a2)

              # Print reminder
              c <- NULL

              for (l in start_line:end_line) {

                c <- c(c, a2[l])

              }

              cat(c, sep = "\n")

            }

          }

        }

      }

      if (n == 0) message("No examples found.")

    } else {

      message("No files (.R, .Rmd, .txt) found!")

    }
  }
}
