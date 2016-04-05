lateformeeting <- read.csv("inst/extdata/lateformeeting.csv")
save(lateformeeting, file = "data/lateformeeting.rda")

lfm_clean <- read.csv("inst/extdata/lfm_cleanup.csv")
save(lfm_clean, file = "data/lfm_clean.rda")
