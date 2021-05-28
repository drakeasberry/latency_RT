# 2019 button difference test
library(tidyverse)
library(plyr)

# Get a list of files
# get all csv files for 5 buttons on button box
arduino_file_paths = list.files(path='input/Button_Box_Latency', pattern = '*.csv', full.names = TRUE) # list all the files with path

# get all csv files for different controller types
controller_file_paths = list.files(path='input/Controllers_latency', pattern = '*.csv', full.names = TRUE) # list all the files with path

# Loop through files to read and add two columns of info from header information
loop_transform_files <-  function(list_of_files, outdir){

  # transforms data structure for use in analysis
  for(csv_file in list_of_files){
    print(csv_file)
    name <- basename(csv_file)
    print(name)
    # read in raw data file
    my_data <- read_delim(csv_file,";",skip = 6)
    
    my_data_info <- read_delim(csv_file,";", n_max = 2)
    
    my_data_complete <- my_data %>% 
      mutate(Device = as.character(my_data_info[1,2]),
             Button = as.character(my_data_info[2,2]))
    out_file <- paste0(outdir, name)
    print(out_file)
    write_csv(my_data_complete, out_file)
  }
}

# Create csv files in corrected format for Button differences in Button Box
loop_transform_files(arduino_file_paths, 'input/Button_Box_Latency/tmp/')
# Create csv files in corrected format for Button differences in different controllers
loop_transform_files(controller_file_paths, 'input/Controllers_latency/tmp/')

# get all csv files for 5 buttons on button box
arduino_file_paths = list.files(path='input/Button_Box_Latency/tmp', pattern = '*.csv', full.names = TRUE) # list all the files with path

# get all csv files for different controller types
controller_file_paths = list.files(path='input/Controllers_latency/tmp', pattern = '*.csv', full.names = TRUE) # list all the files with path

# Read in all individual files into a single dataframe
df_arduino <- ldply(arduino_file_paths, read_csv)
df_controller <- ldply(controller_file_paths, read_csv)

# Change hte buton numbers to the color of button on box
df_button_box <- df_arduino %>% 
  mutate(Button = ifelse(Button == '11', 'White', 
                         ifelse(Button == '2', 'Green', 
                                ifelse(Button == '3', 'Blue',
                                       ifelse(Button == '4', 'Yellow',
                                              ifelse(Button == '5', 'Red', Button))))))

df_controllers <- df_controller %>% 
  mutate(Button = ifelse(Button == '5', 'Red', 
                         ifelse(Button == '272', 'Left Mouse', 
                                ifelse(Button == '304', 'X',
                                       ifelse(Device == 'Logitech_Gamepad_F310' & Button == '305', 'Right Button',
                                              ifelse(Device == 'Empirisoft_Corporation_Analog_Scale_Device' & Button == '305', 'B', Button))))))

# Remove unneeded items from environment
rm(df_arduino, df_controller, arduino_file_paths, controller_file_paths)

# Check for differences between buttons
aov_button_box <- aov()