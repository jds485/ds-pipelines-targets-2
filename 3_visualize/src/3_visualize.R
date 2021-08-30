source("3_visualize/src/plot_timeseries.R")

p3_targets_list <- list(
  tar_target(
    p3_figure_1,
    plot_nwis_timeseries(site_data_annotated_csv = p2_site_data_annotated_csv,
                         width = p_width, height = p_height, units = p_units)
  )
)