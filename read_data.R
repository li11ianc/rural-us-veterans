library(tidyverse)

# Read in cleaned data

# Table 1. Selected Characteristics of Veterans by State and Urban/Rural Residence
charac <- readxl::read_excel(path = "rural_veterans/data/rural_vets_clean.xlsx", 
                             sheet = "Table 1 Percent")
charac_error <- readxl::read_excel(path = "rural_veterans/data/rural_vets_clean.xlsx", 
                                   sheet = "Table 1 Margin of Error")


# Table 2. Poverty Statistics for Veterans, by State and Urban/Rural Residence
poverty <- readxl::read_excel(path = "rural_veterans/data/rural_vets_clean.xlsx", 
                              sheet = "Table 2 Percent")
poverty_error <- readxl::read_excel(path = "rural_veterans/data/rural_vets_clean.xlsx", 
                                    sheet = "Table 2 Margin of Error")


# Table 3. Employment Characteristics for Working-Age Veterans, by State and Urban/Rural Residence
employ <- readxl::read_excel(path = "rural_veterans/data/rural_vets_clean.xlsx", 
                             sheet = "Table 3 Percent")
employ_error <- readxl::read_excel(path = "rural_veterans/data/rural_vets_clean.xlsx", 
                                   sheet = "Table 3 Margin of Error")

# Clean and organize data

poverty <- poverty[1:155,] %>%
  janitor::clean_names() %>%
  rename(total_poverty_determined = total, rural_urban = tru)

employ <- employ[1:155,] %>%
  janitor::clean_names() %>%
  rename(total_working_age = total, rural_urban = tru)

charac <- charac[1:155,] %>%
  janitor::clean_names() %>%
  rename(rural_urban = tru, age_18_25 = x18_to_25_years, age_26_44 = x26_to_44_years, 
         age_45_54 = x45_to_54_years, age_55_64 = x55_to_64_years, age_65_74 = x65_to_74_years,
         age_75_plus = x75_years_and_older, gulf_war2 = gulf_war_september_2001_or_later_1,
         gulf_war1 = gulf_war_august_1990_to_august_2001, 
         va_disability = has_a_va_service_connected_disability_rating,
         no_va_disability = no_va_service_connected_disability_rating,
         county_less_than_half_rural = lives_in_county_that_is_less_than_50_percent_rural2,
         county_over_half_rural = lives_in_county_that_is_50_99_9_percent_rural,
         county_all_rural = lives_in_county_that_is_100_percent_rural) %>%
  mutate(
    county_over_half_rural = case_when(
      county_over_half_rural == "X" ~ as.numeric(NA),
      TRUE ~ as.numeric(county_over_half_rural)),
    county_over_half_rural = as.numeric(county_over_half_rural),
    county_all_rural = case_when(
      county_all_rural == "X" ~ as.numeric(NA),
      TRUE ~ as.numeric(county_all_rural)),
    county_all_rural = as.numeric(county_all_rural)
    )

total <- full_join(poverty, employ, by=c("state","rural_urban", "format"))

vets <- full_join(total, charac, by=c("state","rural_urban", "format"))

write_csv(vets, "rural_veterans/data/rural_vets_complete_clean.csv")

