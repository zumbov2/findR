[![Licence](https://img.shields.io/badge/licence-GPL--3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.en.html)
# findR
The `findR` functions `findRscript`, `findRmd`, and `findPDF` scan all directories and subdirectories of a given path for R scripts, R Markdown and PDF files with content that matches a specific pattern. The hits can be copied to a folder.

## Installation
```
install.packages("devtools")
devtools::install_github("zumbov2/findR")
```
## Example
Hmm, I've used the [circlize package](https://cran.r-project.org/web/packages/circlize/index.html) before, but I can't remember where or when! I apply `findRscript` to my R directory.

```
library(findR)
findRscript(pattern = "circlize", comments = F, folder = "myChordDiagrams")
```
After roughly 20 seconds:

![](https://github.com/zumbov2/findR/blob/master/img/report1.png)

The new folder looks like this:

![](https://github.com/zumbov2/findR/blob/master/img/folder.png)

## Some gimmickry
What `ggplot2` type am I? Let's find out with `findR`.

```
geom_types <- c("geom_bar", "geom_line", "geom_point", "geom_histogram")
hits <- vector(mode = "numeric", length = 4)

for (i in 1:length(geom_types)) {
  
  hits[i] <- nrow(findRscript(pattern = geom_types[i], comments = F, copy = F))
  
}
```

The tension is getting higher.

```
library(tidyverse)
ggstats <- data_frame(type = geom_types, freq = hits)

ggstats %>%
  mutate(type = factor(type, levels = type[order(freq, decreasing = T)])) %>%
  ggplot(aes(type, freq)) +
  geom_bar(stat = "identity") +
  theme_minimal() + 
  labs(x = "", y = "")
  
ggsave("type.png", dpi = 500)
```

Tadaaa...

![](https://github.com/zumbov2/findR/blob/master/img/type.png)
 
 Punkt. Aus. Ende.
