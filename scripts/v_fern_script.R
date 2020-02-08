library(googledrive)
library(googlesheets4)
library(tidyverse)

drive_auth()
sheets_auth(token = drive_token())
ss <- sheets_get("13AL7iMovWwIoz2jxl-Yg4ezTu8rLyA01hOu7vnknEQ4")
income <- read_sheet(as_sheets_id(ss), sheet = 4)
expense <- read_sheet(as_sheets_id(ss), sheet = 5)
