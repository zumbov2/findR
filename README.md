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

![](https://github.com/zumbov2/findR/blob/master/report1.png)

And the new folder looks like this:

![](https://github.com/zumbov2/findR/blob/master/folder.png)

The process took roughly 20 seconds.

## Gimmickry
