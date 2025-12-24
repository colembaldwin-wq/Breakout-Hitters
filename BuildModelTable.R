library(dplyr)
ev_df<-readRDS("data/ev_barrels_2015_2025.rds")
expected_df<-readRDS("data/expected_stats_2015_2025.rds")
features<-ev_df %>%
  transmute(year, player_id,avg_hit_speed, max_hit_speed, brl_percent, anglesweetspotpercent, ev95percent)
outcomes<-expected_df %>%
  transmute(year, player_id, pa, woba, est_woba)
base<-outcomes %>%
  inner_join(features, by = c("year", "player_id")) %>%
  arrange(player_id, year)

dat<-base %>%
  group_by(player_id) %>%
  mutate(woba_next=lead(woba),
    year_next=lead(year),
    delta_woba = woba_next - woba
  ) %>%
  ungroup() %>%
  filter(year_next == year + 1) %>%
  filter(!is.na(delta_woba))
