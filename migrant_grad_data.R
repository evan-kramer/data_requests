# Migrant Grad Data
# Evan Kramer
# 11/15/2017

library(tidyverse)
library(lubridate)
library(ggplot2)
library(haven)
library(readxl)
library(stringr)

setwd("K:/ORP_accountability/data/2017_graduation_rate")

migrant_grad = read_csv("student_level_20170830.csv") %>% 
    filter(migrant == "Y") %>% 
    left_join(read_csv("student_level_with_dropout_count_20171113.csv") %>% 
                  transmute(student_key, dropout_count = as.numeric(dropout_count)),
              by = c("student_key")) %>% 
    summarize_each(funs(sum(., na.rm = T)), starts_with("grad_c"), dropout_count) %>% 
    mutate(migrant = "Y", grad_rate = round(100 * grad_count / grad_cohort, 1), 
           dropout_rate = round(100 * dropout_count / grad_cohort, 1))

migrant_grad_suppressed = mutate_each(migrant_grad, funs(ifelse(. < 5, "*", as.character(.))), starts_with("dropout"))

write_csv(migrant_grad, "C:/Users/CA19130/Downloads/cpm_migrant_request.csv")
write_csv(migrant_grad_suppressed, "C:/Users/CA19130/Downloads/cpm_migrant_request_suppressed.csv")

rm(list = ls(pattern = "migrant_grad"))
   