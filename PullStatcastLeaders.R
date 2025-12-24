library(baseballr)
library(dplyr)
library(purrr)
dir.create("data", showWarnings = FALSE)
years<-2015:2025

ev_df<-map_dfr(years,\(y) {
  statcast_leaderboards(
    leaderboard="exit_velocity_barrels",year=y,player_type="batter",
    min_pa=100
  ) %>% mutate(year=y)
})
expected_df <- map_dfr(years, \(y) {
  statcast_leaderboards(
    leaderboard = "expected_statistics",
    year = y,
    player_type = "batter",
    min_pa = 100
  ) %>% mutate(year = y)
})

saveRDS(ev_df,  "data/ev_barrels_2015_2025.rds")
saveRDS(expected_df, "data/expected_stats_2015_2025.rds")
expected_df2 <- readRDS("data/expected_stats_2015_2025.rds")
class(expected_df2)