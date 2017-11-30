# Success Rates (3-12)
sr = read_csv("K:/ORP_accountability/projects/2017_school_accountability/school_summary_file.csv") %>%
    select(system:success_rate_2017_pctile) 
sr$len = str_length(sr$school)
sr$loc = NA
for(i in 1:nrow(sr)) {
    sr$loc[i] = str_locate(sr$school[i], "8")[1]
}
rm(i)
sr = filter(sr, len == 4 & loc == 1) %>% 
    select(-len, -loc, -designation_ineligible)

# K2 Assessment Data
k2 = read_dta("K:/ORP_accountability/projects/2017_grade_2_assessment/school_level_2017_JW_final_10242017.dta") %>% 
    mutate(subgroup = ifelse(subgroup == "English Language Learners with T1/T2",
                             "English Learners with T1/T2", subgroup)) %>% 
    filter(subgroup %in% c("All Students", "Black/Hispanic/Native American",
                           "Economically Disadvantaged", "English Learners with T1/T2",
                           "Students with Disabilities")) %>% 
    group_by(year, system, system_name, school, school_name, subgroup) %>% 
    summarize_at(vars(valid_tests, starts_with("n_")), funs(sum(., na.rm = T))) %>% 
    group_by(subgroup) %>% 
    mutate(pct_on_mastered_k2 = ifelse(valid_tests >= 30, round(100 * (n_ontrack_prof + n_mastered_adv) / valid_tests, 1), NA),
           pct_on_mastered_k2_pctile = round(percent_rank(pct_on_mastered_k2) * 100, 1))
k2$len = str_length(k2$school)
k2$loc = NA
for(i in 1:nrow(k2)) {
    k2$loc[i] = str_locate(k2$school[i], "8")[1]
}
rm(i)
k2 = filter(k2, len == 4 & loc == 1) %>% 
    select(-len, -loc, -starts_with("n_"), -year)

# Combine
ov = bind_rows(sr, k2) %>% 
    arrange(system, school, subgroup) %>% 
    mutate(pool = ifelse(is.na(pool), "K2", pool),
           system_name = str_replace(str_to_title(system_name), " Schools", ""))

write_excel_csv(ov, "C:/Users/CA19130/Downloads/charter_grant_achievement_data.csv", na = "")
