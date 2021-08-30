library(targets)
source("1_fetch/src/get_nwis_data.R")
source("2_process/src/process_and_style.R")
source("3_visualize/src/plot_timeseries.R")

options(tidyverse.quiet = TRUE)
tar_option_set(packages = c("tidyverse", "dataRetrieval")) # Loading tidyverse because we need dplyr, ggplot2, readr, stringr, and purrr

# Vector of stations for which to download data
site_nums <- c("01427207", "01432160", "01435000", "01436690", "01466500")
# Plot arguments
p_width = 12
p_height = 7
p_units = 'in'
# dummy variable to force re-downloading data from web
dummy_date = '2021-08-30'

p1_targets_list <- list(
  tar_target(
    # create the file names that are needed for download_nwis_site_data
    site_download_paths, 
    file.path("1_fetch/out", paste0('nwis_', site_nums, '_data.csv'))
  ),
  tar_target(
    station1_csv,
    {
      dummy <- dummy_date
      download_nwis_site_data(filepath = site_download_paths[1])
    },
    format = "file"
  ),
  tar_target(
    station2_csv,
    {
      dummy <- dummy_date
      download_nwis_site_data(filepath = site_download_paths[2])
    },
    format = "file"
  ),
  tar_target(
    station3_csv,
    {
      dummy <- dummy_date
      download_nwis_site_data(filepath = site_download_paths[3])
    },
    format = "file"
  ),
  tar_target(
    station4_csv,
    {
      dummy <- dummy_date
      download_nwis_site_data(filepath = site_download_paths[4])
    },
    format = "file"
  ),
  tar_target(
    station5_csv,
    {
      dummy <- dummy_date
      download_nwis_site_data(filepath = site_download_paths[5])
    },
    format = "file"
  ),
  tar_target(
    site_data,
    combine_nwis_data(c(station1_csv, station2_csv, station3_csv, station4_csv, station5_csv))
  ),
  tar_target(
    site_info,
    nwis_site_info(site_data)
  )
)

p2_targets_list <- list(
  tar_target(
    site_data_clean, 
    process_data(site_data)
  ),
  tar_target(
    site_data_annotated_csv,
    annotate_data(site_data_clean, site_info = site_info, out_filename = '2_process/out/site_data_annotated.csv'),
    format = "file"
  )
)

p3_targets_list <- list(
  tar_target(
    figure_1,
    plot_nwis_timeseries(site_data_annotated_csv = site_data_annotated_csv,
                         width = p_width, height = p_height, units = p_units)
  )
)

# Return the complete list of targets
c(p1_targets_list, p2_targets_list, p3_targets_list)
