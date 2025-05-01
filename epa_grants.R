# Set working directory to the folder containing this script
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Load required packages
library(tidyverse)
library(readxl)
library(janitor)

# don't use scientific notation
options(scipen=999)

# load congressional district data
members <- read_excel("data/Member Data.xlsx", sheet = 1) %>%
  clean_names()

#############
# load data from USAspending search on programs defined in court document
target_programs <- read_csv("data/Assistance_PrimeAwardSummaries_2025-04-23_H21M56S45_1.csv")

# some processing
target_programs_live <- target_programs %>%
  clean_names() %>%
  filter(period_of_performance_current_end_date >= "2025-02-13") %>%
  mutate(award_amount = replace_na(total_obligated_amount,0),
         total_outlays = replace_na(total_outlayed_amount,0),
         not_disbursed = award_amount - total_outlays,
         st_dis_recip = gsub("-","", prime_award_summary_recipient_cd_original),
         st_dis_recip = gsub("98","00",st_dis_recip),
         st_dis_perf = gsub("-","", prime_award_summary_place_of_performance_cd_original),
         st_dis_perf = gsub("98","00",st_dis_perf))

write.csv(target_programs_live, "processed_data/target_programs_live.csv", na = "", row.names = FALSE)

# summary by congressional district of performance location
target_programs_live_district_perf <- target_programs_live %>%
  left_join(members, by = c("st_dis_perf" = "st_dis")) %>%
  group_by(st_dis_perf,first_name,last_name,party) %>%
  summarize(grants = n(),
            amount_awarded = sum(award_amount, na.rm = TRUE),
            total_outlays = sum(total_outlays, na.rm = TRUE),
            not_disbursed = sum(not_disbursed, na.rm = TRUE)) %>%
  ungroup() %>%
  arrange(-not_disbursed)

write.csv(target_programs_live_district_perf, "processed_data/target_programs_live_district_perf.csv", na = "", row.names = FALSE)

# summary by congressional district of grant recipient 
target_programs_live_district_recip <- target_programs_live %>%
  left_join(members, by = c("st_dis_recip" = "st_dis")) %>%
  group_by(st_dis_recip,first_name,last_name,party) %>%
  summarize(grants = n(),
            amount_awarded = sum(award_amount, na.rm = TRUE),
            total_outlays = sum(total_outlays, na.rm = TRUE),
            not_disbursed = sum(not_disbursed, na.rm = TRUE)) %>%
  ungroup() %>%
  arrange(-not_disbursed)

write.csv(target_programs_live_district_recip, "processed_data/target_programs_live_district_recip.csv", na = "", row.names = FALSE)

# summary by program
target_programs_live_program <-  target_programs_live %>%
  mutate(cfda = substr(cfda_numbers_and_titles,1,6)) %>%
  group_by(cfda) %>%
  summarize(grants = n(),
            amount_awarded = sum(award_amount, na.rm = TRUE),
            total_outlays = sum(total_outlays, na.rm = TRUE),
            not_disbursed = sum(not_disbursed, na.rm = TRUE)) %>%
  ungroup() %>%
  arrange(-not_disbursed)

write.csv(target_programs_live_program, "processed_data/target_programs_live_program.csv", na = "", row.names = FALSE)

# summary by state of primary location of performance
target_programs_live_state_perf <- target_programs_live %>%
  group_by(primary_place_of_performance_state_name) %>%
  summarize(grants = n(),
            amount_awarded = sum(award_amount, na.rm = TRUE),
            total_outlays = sum(total_outlays, na.rm = TRUE),
            not_disbursed = sum(not_disbursed, na.rm = TRUE)) %>%
  ungroup() %>%
  arrange(-not_disbursed)

write.csv(target_programs_live_state_perf, "processed_data/target_programs_live_state_perf.csv", na = "", row.names = FALSE)

# summary by party of congressional district of performance location
target_programs_live_party_perf <- target_programs_live %>%
  left_join(members, by = c("st_dis_perf" = "st_dis")) %>%
  group_by(party) %>%
  summarize(grants = n(),
            amount_awarded = sum(award_amount, na.rm = TRUE),
            total_outlays = sum(total_outlays, na.rm = TRUE),
            not_disbursed = sum(not_disbursed, na.rm = TRUE)) %>%
  ungroup() %>%
  arrange(-not_disbursed)

write.csv(target_programs_live_party_perf, "processed_data/target_programs_live_party_perf.csv", na = "", row.names = FALSE)

# summary by party of congressional district of recipient location
target_programs_live_party_recip <- target_programs_live %>%
  left_join(members, by = c("st_dis_recip" = "st_dis")) %>%
  group_by(party) %>%
  summarize(grants = n(),
            amount_awarded = sum(award_amount, na.rm = TRUE),
            total_outlays = sum(total_outlays, na.rm = TRUE),
            not_disbursed = sum(not_disbursed, na.rm = TRUE)) %>%
  ungroup() %>%
  arrange(-not_disbursed)

write.csv(target_programs_live_party_recip, "processed_data/target_programs_live_party_recip.csv", na = "", row.names = FALSE)

