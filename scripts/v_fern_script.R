library(googledrive)
library(googlesheets4)
library(tidyverse)
library(janitor)

drive_auth()
sheets_auth(token = drive_token())
ss <- sheets_get("13AL7iMovWwIoz2jxl-Yg4ezTu8rLyA01hOu7vnknEQ4") #spreadsheet
income <- read_sheet(as_sheets_id(ss), sheet = 3)
expense <- read_sheet(as_sheets_id(ss), sheet = 2)

income <- clean_names(income) #income
expense <- clean_names(expense) #expense

sales <- income %>%
  select(customer_name, product_sold, qty_how_many_sold, sale_price) %>%
  mutate(sale = sale_price * qty_how_many_sold) %>%
  group_by(product_sold) %>%
  summarise(sale = sum(sale)) %>%
  ungroup()
  
expenses <- expense %>%
  select(category, qty, price, any_shipping) %>%
  mutate(total_expense = (qty * price) + any_shipping) %>%
  group_by(category) %>%
  summarise(expense = sum(total_expense, na.rm = TRUE))
  