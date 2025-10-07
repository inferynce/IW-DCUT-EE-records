#library(here)
#library(readr)

IWdata <- read_csv(here("Data", "zwr_combined_leaderboard.csv"),
                   col_types = cols(Time = col_character()))
