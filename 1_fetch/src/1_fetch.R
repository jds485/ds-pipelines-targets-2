source("1_fetch/src/get_nwis_data.R")

p1_targets_list <- list(
  tar_target(
    # create the file names that are needed for download_nwis_site_data
    p1_site_download_paths, 
    file.path("1_fetch/out", paste0('nwis_', site_nums, '_data.csv'))
  ),
  tar_target(
    p1_station1_csv,
    {
      dummy <- dummy_date
      download_nwis_site_data(filepath = p1_site_download_paths[1])
    },
    format = "file"
  ),
  tar_target(
    p1_station2_csv,
    {
      dummy <- dummy_date
      download_nwis_site_data(filepath = p1_site_download_paths[2])
    },
    format = "file"
  ),
  tar_target(
    p1_station3_csv,
    {
      dummy <- dummy_date
      download_nwis_site_data(filepath = p1_site_download_paths[3])
    },
    format = "file"
  ),
  tar_target(
    p1_station4_csv,
    {
      dummy <- dummy_date
      download_nwis_site_data(filepath = p1_site_download_paths[4])
    },
    format = "file"
  ),
  tar_target(
    p1_station5_csv,
    {
      dummy <- dummy_date
      download_nwis_site_data(filepath = p1_site_download_paths[5])
    },
    format = "file"
  ),
  tar_target(
    p1_site_data,
    combine_nwis_data(c(p1_station1_csv, p1_station2_csv, p1_station3_csv, p1_station4_csv, p1_station5_csv))
  ),
  tar_target(
    p1_site_info,
    nwis_site_info(p1_site_data)
  )
)