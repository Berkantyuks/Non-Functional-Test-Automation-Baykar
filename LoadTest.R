# Set Environment Variable
Sys.setenv("LOADTEST_JMETER_PATH"="C:\\apache-jmeter-5.5\\bin\\jmeter.bat")

# You Need Install All These packages for Execute Load Tests
#install.packages("remotes")
#install.packages("devtools")
#install.packages("tidyr")
#install.packages("rmarkdown")
#install.packages("ggpubr")
#remotes::install_github("tmobile/loadtest")

# Load loadtest library
library(loadtest)
library(ggpubr)
library(ggplot2)
library(grid)
library(gridExtra)
library(png)
library(jpeg)
library(stringr)

source("custom_plots/load_test_plots.R")

test_url <- c("https://kariyer.baykartech.com")
test_url_formatted <- str_replace(test_url, "https://","")

logo <- readPNG("img/BaykarLogo.png")
test_mark <- readPNG("img/stau-logo-fix.png")

cover <- readJPEG("img/cover.jpeg")

current_date <- Sys.Date()
current_time <- Sys.time()

thr = 8
loops = 40

automation_tag <- paste0(test_url_formatted," (THR: ",thr,", LPS: ",loops,")")

# Run loadtest
results <- loadtest(url = test_url,
                    method = "GET",
                    threads = thr,
                    loops = loops,
                    delay_per_request=100)

# Print Results
print(results)

head(results)


## Create pdf file by test results
CreatePDF.LoadTest <- function(results)
{
  automation_tag_formatted <- str_remove_all(automation_tag, "[^A-Za-z0-9]+")
  pdf(file= paste0("results\\",current_date,"test_result_",automation_tag_formatted,".pdf"), width = 11, height = 9.5)
  
  # create a 2X2 grid
  par( mfrow= c(2,2) )
  
  # Plot Results - don't touch here
  pet <- tc_plot_elapsed_times(results)
  peth <- tc_plot_elapsed_times_histogram(results)
  prt <- tc_plot_requests_by_thread(results)
  prs <- tc_plot_requests_per_second(results)
  
  ac <- annotation_custom(rasterGrob(logo, 
                                     x = 0.98, 
                                     y=0.955, 
                                     hjust = 1, 
                                     width= 0.04, 
                                     interpolate=TRUE))
  
  ar <- annotation_custom(rasterGrob(test_mark, 
                                     x = 0.98, 
                                     y=.05, 
                                     hjust = 1, 
                                     width= 0.05, 
                                     interpolate=TRUE))
  
  grid_graphs <- ggarrange(pet,
                           peth, 
                           prt, 
                           prs,
                           ncol = 2, nrow = 2)
  
  grid.raster(cover, vjust = 0.04, width=.99)
  
  grid.raster(test_mark, x=.105, y=.13, width=.29)
  
  grid.text("Software Testing and Automation Unit", y=.26, gp = gpar(fontface = "bold", fontsize = 18))
  grid.text("Load Test Report by Berkant", y=.22, gp = gpar(fontface = "bold", fontsize = 15))
  grid.text(paste0(automation_tag), y=.16, gp = gpar(fontface = "bold", fontsize = 15))
  
  grid.text(paste0(current_time), y=.08, gp = gpar(fontsize = 18))
  
  out <- annotate_figure(grid_graphs,
                  bottom = text_grob(paste("\n \n This file auto generated and executed by: Berkant Yüksektepe. Test Classes used. This page involves only load and performance tests, \n for more information please visit project repo: https://github.com/Berkantyuks/Non-Functional-Test-Automation-Baykar\n"),
                                     color = "black",
                                     face = "italic", 
                                     size = 10),
                  left = paste(current_time, "BAYKAR"),
                  right = paste(current_time, "BAYKAR"),
                  top = text_grob(paste0("\n Automated NF Test Results for ",automation_tag,"\n"), color = "black", face = "bold", size = 14)) + ac + ar
  
  print(out)
  dev.off()
}

CreatePDF.LoadTest(results)


# Generate HTML Report
loadtest_report(results,"C:\\Users\\byuks\\Documents\\GitHub\\Non-Functional-Test-Automation-Baykar\\LoadTestReport.html")