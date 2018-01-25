# findR
Find R Scripts, R Markdown and PDF files by content with pattern matching.

## Installation
```
install.packages("devtools")
devtools::install_github("zumbov2/findR")
```
## Example
Hmm, I've used the [circlize package](https://cran.r-project.org/web/packages/circlize/index.html) before, but I can't remember where or when!

```
findR::findRscript(pattern = "circlize", comments = F, folder = "myChordDiagrams")
```
After roughly 20 seconds:

![](https://github.com/zumbov2/findR/blob/master/report1.png)

And the new folder looks like this:

![](https://github.com/zumbov2/findR/blob/master/folder.png)

## Gimmickry
What `ggplot2` type am I? Let's find out with `findR`.

```
bar <- findR::findRscript(pattern = "geom_bar", comments = F, copy = F)
line <- findR::findRscript(pattern = "geom_line", comments = F, copy = F)
point <- findR::findRscript(pattern = "geom_point", comments = F, copy = F)
histogram <- findR::findRscript(pattern = "geom_histogram", comments = F, copy = F)
```

The tension is getting higher.

```
library(tidyverse)

ggstats <- data_frame(type = c("bar", "line", "point", "histogram"),
                      freq = c(nrow(bar), nrow(line), nrow(point), nrow(histogram)))

ggstats %>%
  mutate(type = factor(type, levels = type[order(freq, decreasing = T)])) %>%
  ggplot(aes(type, freq)) +
  geom_bar(stat = "identity") +
  theme_minimal() + 
  labs(x = "", y = "")
  
ggsave("type.png", dpi = 500)
```

Tadaaa...

![](https://github.com/zumbov2/findR/blob/master/type.png)
 
 Punkt. Aus. Ende.
