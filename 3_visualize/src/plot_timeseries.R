plot_nwis_timeseries <- function(site_data_annotated_csv, width = 12, height = 7, units = 'in'){
  site_data_styled = read_csv(site_data_annotated_csv)
  gg_obj = ggplot(data = site_data_styled, aes(x = dateTime, y = water_temperature, color = station_name)) +
    geom_line() + theme_bw()
  
  return(gg_obj)
}