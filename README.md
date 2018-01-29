[![Licence](https://img.shields.io/badge/licence-GPL--3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.en.html)
# findR
The `findR` functions `findRscript`, `findRmd`, `findPDF`, and `findtxt` scan all directories and subdirectories of a given path for R scripts, R Markdown, PDF and text files with content that matches a specific pattern. The hits can be copied to a folder.

## Installation
```
install.packages("devtools")
devtools::install_github("zumbov2/findR")
```
## Example `findRscript`
Hmm, I've used the [circlize package](https://cran.r-project.org/web/packages/circlize/index.html) before, but I can't remember where or when! I apply `findRscript` to the main directory of my R projects.

```
library(findR)
findRscript(path = "C:/Users/David Zumbach/Desktop/R", 
            pattern = "circlize", 
            show.results = F,
            copy = T,
            folder = "myChordScripts")
```
[12 seconds later](https://www.youtube.com/watch?v=oeUcLaD9pR4):

```
Number of R scripts scanned: 1155
Number of R scripts with matching content: 20
Total number of matches: 40
```
![](https://github.com/zumbov2/findR/blob/master/img/folder.png)

## Example `findPDF`
Too many papers to read?

![](https://github.com/zumbov2/findR/blob/master/img/f2.png)

`findPDF` helps you focus!

```
findPDF(path = "2017/machine_learning", pattern = "tensorflow",
        lowercase = T, copy = T, folder = "2017/tensorflow")
```
15 seconds later and you've got your new reading list:

![](https://github.com/zumbov2/findR/blob/master/img/f3.png)

## Some gimmickry
What `ggplot2` type am I? Let's find out with `findR`.

```
geom_types <- c("geom_bar", "geom_line", "geom_point", "geom_histogram")
hits <- vector(mode = "numeric", length = 4)

for (i in 1:length(geom_types)) {
  
  hits[i] <- nrow(findRscript(pattern = geom_types[i], comments = F))
  
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
