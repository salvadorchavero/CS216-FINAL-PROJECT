library(tidyverse)

files = c("analysis/data/PERM_Disclosure_Data_FY2018_EOY.csv",
          "analysis/data/PERM_Disclosure_Data_FY17.csv",
          "analysis/data/PERM_Disclosure_Data_FY16.csv",
          "analysis/data/PERM_Disclosure_Data_FY15.csv",
          "analysis/data/PERM_Disclosure_Data_FY14.csv",
          "analysis/data/PERM_Disclosure_Data_FY2013.csv",
          "analysis/data/PERM_Disclosure_Data_FY12.csv",
          "analysis/data/PERM_Disclosure_Data_FY11.csv",
          "analysis/data/PERM_Disclosure_Data_FY10.csv",
          "analysis/data/PERM_Disclosure_Data_FY09.csv",
          "analysis/data/PERM_Disclosure_Data_FY08.csv")

# Variables to include
selected_variables <- c("DECISION_DATE", "CASE_STATUS", "CASE_RECEIVED_DATE",
                        "REFILE", "EMPLOYER_NAME", "EMPLOYER_ADDRESS_1",
                        "EMPLOYER_CITY", "EMPLOYER_STATE", "EMPLOYER_COUNTRY",
                        "EMPLOYER_POSTAL_CODE", "EMPLOYER_NUM_EMPLOYEES",
                        "EMPLOYER_YR_ESTAB", "AGENT_FIRM_NAME", "AGENT_CITY",
                        "AGENT_STATE", "PW_JOB_TITLE_9089", "PW_LEVEL_9089",
                        "PW_AMOUNT_9089", "JOB_INFO_EDUCATION",
                        "JOB_INFO_MAJOR", "COUNTRY_OF_CITIZENSHIP",
                        "CLASS_OF_ADMISSION")
  

read_filter <- function(filename) {
  print(filename)
  df <- read_csv(filename)
  names(df) <- toupper(names(df))
  df <- df %>% select(one_of(selected_variables))
  
  return(df)
}

perm <- read_filter(files[1])

for (file in files[2:length(files)]) {
  # Read in next file as temporary DF
  tmp <- read_filter(file)
  
  perm <- bind_rows(perm, tmp)
}

# Remove values with important missing info
perm <- perm %>%
  filter(!is.na(DECISION_DATE), !is.na(CASE_STATUS))

# Remove temporary df
rm(tmp)

# Export as csv
write_csv(perm, "analysis/data/perm_clean.csv")
