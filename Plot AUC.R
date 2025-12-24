library(tidymodels)
library(dplyr)
library(ggplot2)
fit<-readRDS("data/model_fit.rds")
dat<-readRDS("data/model_table.rds")
test <- test %>%
  mutate(breakout = factor(breakout, levels = c(0, 1)))
pred <- predict(fit, test, type = "prob") %>%
  bind_cols(test %>% select(year, player_id, breakout, delta_woba))
roc_auc(pred, truth = breakout, .pred_1)
pred %>%
  mutate(decile = ntile(.pred_1, 10)) %>%
  group_by(decile) %>%
  summarize(
    avg_pred = mean(.pred_1, na.rm = TRUE),
    breakout_rate = mean(as.integer(breakout == "1"), na.rm = TRUE),
    n = n(),
    .groups = "drop"
  ) %>%
  ggplot(aes(avg_pred, breakout_rate)) +
  geom_point() +
  geom_smooth(method = "lm", se = TRUE) +
  labs(
    title = "Breakout Model Calibration (Deciles)",
    x = "Predicted Breakout Rate",
    y = "Actual Breakout Rate"
  ) +
  theme_minimal()
pred_2026 <- predict(
  fit,
  base %>% filter(year == 2025),
  type = "prob"
) %>%
  bind_cols(
    base %>%
      filter(year == 2025) %>%
      select(player_id, year, woba, est_woba)
  )
single_player <- base %>%
  filter(player_id == 701350, year == 2025)
nrow(single_player)
predict(fit, single_player, type = "prob")
pred_2026 %>%
  arrange(desc(.pred_1)) %>%
  slice(1:10)