# Read in cleaned data

# Table 1. Selected Characteristics of Veterans by State and Urban/Rural Residence
charac <- readxl::read_excel(path = "rural_veterans/data/rural_vets.xlsx", sheet = "Table 1 Percent")
charac_error <- readxl::read_excel(path = "rural_veterans/data/rural_vets.xlsx", sheet = "Table 1 Margin of Error")


# Table 2. Poverty Statistics for Veterans, by State and Urban/Rural Residence
poverty <- readxl::read_excel(path = "rural_veterans/data/rural_vets.xlsx", sheet = "Table 2 Percent")
poverty_error <- readxl::read_excel(path = "rural_veterans/data/rural_vets.xlsx", sheet = "Table 2 Margin of Error")


#Table 3. Employment Characteristics for Working-Age1 Veterans, by State and Urban/Rural Residence
employ <- readxl::read_excel(path = "rural_veterans/data/rural_vets.xlsx", sheet = "Table 3 Percent")
employ_error <- readxl::read_excel(path = "rural_veterans/data/rural_vets.xlsx", sheet = "Table 3 Margin of Error")