###########################################################################################################
# findR: Test Script 1
###########################################################################################################

# Load packages
library(tidyverse)

# Chord
chordDiagram(data,
             order = parties,
             grid.col = colors,
             col = col_mat,
             transparency = 0.2,
             link.rank = rank(data$total),
             annotationTrack = c("name","grid")
             )
