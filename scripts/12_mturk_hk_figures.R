# Figures
# Set Working dir 

## Gaurav's path
setwd(basedir) 
setwd("partisan-gaps")  # folder

## Daniel's path
setwd(githubdir)
setwd("partisan-gaps")  # folder

# Load the packages
library("tidyverse")
library("texreg")
library("DeclareDesign")

## Sourcing the data cleaning file 
source("scripts/10_mturk_hk_kcgie.R")

## Analysis of multiple choice questions 
mturk_hk_closed_correct |> 
  dplyr::select(responses, congenial, democrat_leaners) |>
  mutate(democrat_leaners = ifelse(democrat_leaners == 1, "Democrat", "Republican"),
         responses = ifelse(responses == 1, "Correct", "Incorrect"),
         congenial = ifelse(congenial == 1, "Congenial", "Not Congenial")) |> 
  drop_na() |> 
  ggplot(aes(x = responses, fill = congenial)) + geom_bar()  +
  theme_bw() + 
  theme(legend.position = "bottom") + facet_grid(~democrat_leaners)

mturk_hk_closed_correct |> 
  dplyr::select(responses_noinflation, congenial, democrat_leaners) |>
  mutate(democrat_leaners = ifelse(democrat_leaners == 1, "Democrat", "Republican"),
         responses_noinflation = ifelse(responses_noinflation == 1, "Correct", "Incorrect"),
         congenial = ifelse(congenial == 1, "Congenial", "Not Congenial")) |> 
  drop_na() |> 
  ggplot(aes(x = responses_noinflation, fill = congenial)) + geom_bar()  +
  theme_bw() + 
  theme(legend.position = "bottom") + facet_grid(~democrat_leaners)



## Analysis of the scale questions
mturk_hk_scale |> 
  dplyr::select(scale_mc_c_10, democrat_leaners) |> 
  drop_na() |> 
  ggplot(aes(x = as.factor(scale_mc_c_10), fill = as.factor(democrat_leaners))) + geom_bar()  +
  theme_bw() + 
  theme(legend.position = "bottom")

mturk_hk_scale |> 
  dplyr::select(scale_mc_c_10, congenial) |> 
  drop_na() |> 
  ggplot(aes(x = as.factor(scale_mc_c_10), fill = as.factor(congenial))) + geom_bar()  +
  theme_bw() + 
  theme(legend.position = "bottom")

mturk_hk_scale |> 
  dplyr::select(scale_mc_c_7, democrat) |> 
  drop_na() |> 
  ggplot(aes(x = scale_mc_c_7, fill = as.factor(democrat))) + geom_bar()  +
  theme_bw() + 
  theme(legend.position = "bottom")
