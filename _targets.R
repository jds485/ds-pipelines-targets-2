library(targets)
source("1_fetch/src/get_nwis_data.R")
source("2_process/src/process_and_style.R")
source("3_visualize/src/plot_timeseries.R")

options(tidyverse.quiet = TRUE)
tar_option_set(packages = c("tidyverse", "dataRetrieval")) # Loading tidyverse because we need dplyr, ggplot2, readr, stringr, and purrr

# Vector of stations for which to download data
site_nums <- c("01427207", "01432160", "01435000", "01436690", "01466500")

p1_targets_list <- list(
  tar_target(
    # create the file names that are needed for download_nwis_site_data
    site_download_paths, 
    file.path("1_fetch/out", paste0('nwis_', site_nums, '_data.csv'))
  ),
  tar_target(
    station1_csv,
    download_nwis_site_data(filepath = site_download_paths[1]),
    format = "file"
  ),
  tar_target(
    station2_csv,
    download_nwis_site_data(filepath = site_download_paths[2]),
    format = "file"
  ),
  tar_target(
    station3_csv,
    download_nwis_site_data(filepath = site_download_paths[3]),
    format = "file"
  ),
  tar_target(
    station4_csv,
    download_nwis_site_data(filepath = site_download_paths[4]),
    format = "file"
  ),
  tar_target(
    station5_csv,
    download_nwis_site_data(filepath = site_download_paths[5]),
    format = "file"
  ),
  tar_target(
    site_data,
    combine_nwis_data(c(station1_csv, station2_csv, station3_csv, station4_csv, station5_csv))
  ),
  tar_target(
    site_info_csv,
    nwis_site_info(fileout = "1_fetch/out/site_info.csv", site_data),
    format = "file"
  )
)

p2_targets_list <- list(
  tar_target(
    site_data_clean, 
    process_data(site_data)
  ),
  tar_target(
    site_data_annotated,
    annotate_data(site_data_clean, site_filename = site_info_csv)
  ),
  tar_target(
    site_data_styled,
    style_data(site_data_annotated)
  )
)

p3_targets_list <- list(
  tar_target(
    figure_1_png,
    plot_nwis_timeseries(fileout = "3_visualize/out/figure_1.png", site_data_styled),
    format = "file"
  )
)

# Return the complete list of targets
c(p1_targets_list, p2_targets_list, p3_targets_list)
