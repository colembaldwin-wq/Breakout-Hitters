library(tidymodels)
library(dplyr)
dat <- dat %>%
  group_by(year) %>%
  mutate(
    breakout = as.integer(
      delta_woba >= quantile(delta_woba, 0.80, na.rm = TRUE)
    )
  ) %>%
  ungroup()
dat <- dat %>%
  mutate(breakout = factor(breakout, levels = c(0, 1)))
train<-dat %>% filter(year<=2022)
test<-dat %>% filter(year>=2023)
rec<-recipe(breakout ~ pa,+woba+est_woba+avg_hit_speed+max_hit_speed+brl_percent+anglesweetspotpercent+ev95percent,
            data=train) %>%
  step_impute_median(all_numeric_predictors()) %>%
  step_normalize(all_numeric_predictors())
mod<-logistic_reg() %>% set_engine("glm")
wf <- workflow() %>%
  add_recipe(rec) %>%
  add_model(mod)
fit <- fit(wf, data = train)
saveRDS(fit, "data/model_fit.rds")