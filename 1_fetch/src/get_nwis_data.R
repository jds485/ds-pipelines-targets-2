
combine_nwis_data <- function(site_paths){
  
  data_out = data.frame()
  # loop through files to combine in R data.frame
  for (path in site_paths){
    # read the downloaded data and append it to the existing data.frame
    these_data <- read_csv(path, col_types = 'ccTdcc')
    data_out <- bind_rows(data_out, these_data)
  }
  return(data_out)
}

nwis_site_info <- function(fileout, site_data){
  site_no <- unique(site_data$site_no)
  site_info <- dataRetrieval::readNWISsite(site_no)
  write_csv(site_info, fileout)
  return(fileout)
}


download_nwis_site_data <- function(filepath, parameterCd = '00010', startDate="2014-05-01", endDate="2015-05-01"){
  
  # filepaths look something like directory/nwis_01432160_data.csv,
  # remove the directory with basename() and extract the 01432160 with the regular expression match
  site_num <- basename(filepath) %>% 
    stringr::str_extract(pattern = "(?:[0-9]+)")
  
  # readNWISdata is from the dataRetrieval package
  data_out <- readNWISdata(sites=site_num, service="iv", 
                           parameterCd = parameterCd, startDate = startDate, endDate = endDate)

  # -- simulating a failure-prone web-sevice here, do not edit --
  set.seed(Sys.time())
  if (sample(c(T,F,F,F), 1)){
    stop(site_num, ' has failed due to connection timeout. Try tar_make() again')
  }
  # -- end of do-not-edit block
  
  write_csv(data_out, file = filepath)
  return(filepath)
}

