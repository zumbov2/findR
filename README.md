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





## Gimmickry
