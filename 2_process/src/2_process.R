source("2_process/src/process_and_style.R")

p2_targets_list <- list(
  tar_target(
    p2_site_data_clean, 
    process_data(p1_site_data)
  ),
  tar_target(
    p2_site_data_annotated_csv,
    annotate_data(p2_site_data_clean, site_info = p1_site_info, out_filename = '2_process/out/site_data_annotated.csv'),
    format = "file"
  )
)