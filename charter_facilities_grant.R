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
    select(-len, -loc)

# K2 Assessment Data
k2 = 
# Combine



#write_excel_csv(a, "C:/Users/CA19130/Downloads/")
