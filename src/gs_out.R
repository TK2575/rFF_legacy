#' Export data to Google Sheets

library(googlesheets)

gs_connect <- function() {
  gs_ls()
  gs_title("2017 Fantasy Football Results")
}

gs_add_week <- function(week_num) {
  doc <- gs_connect()
  get_matches_data() %>% filter(Week == week_num) %>% gs_add_data(mode='Matches')
  get_roster_data() %>% filter(Week == week_num) %>% gs_add_data(mode='Roster')
  get_matches_data() %>% team_summary() %>% gs_full_table(mode='Team Scoring Summary')
  get_roster_data() %>% team_pos_summary() %>% gs_full_table(mode='Position Scoring Summary')
  get_roster_data() %>% player_summary() %>% gs_full_table(mode='Player Scoring Summary')
}

gs_add_all_data <- function() {
  gs_full_table(get_roster_data(), 'Roster')
  gs_full_table(get_matches_data(), 'Matches')
}

gs_full_table <- function(df, mode) {
  doc <- gs_connect()
  gs_ws_delete(doc, mode, verbose=F)
  doc <- gs_connect()
  gs_ws_new(doc, mode, input = df)
}

gs_add_data <- function(df, mode) {
  doc <- gs_connect()
  gs_add_row(doc, mode, input=df, verbose=F)
}

# TODO add dimensions to gs_ws_new calls to match the input dimensions