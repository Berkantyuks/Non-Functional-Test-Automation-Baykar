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
library(stringr)

source("custom_plots/load_test_plots.R")

test_url <- c("https://kariyer.baykartech.com")
test_url_formatted <- str_replace(test_url, "https://","")
test_mark <- readPNG("img/tcnf-test-logo.png")
current_date <- Sys.Date()
current_time <- Sys.time()

thr = 7
loops = 10

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
  pdf(file= paste("results\\",current_date,"test_result.pdf"), width = 11, height = 9)
  
  # create a 2X2 grid
  par( mfrow= c(2,2) )
  
  # Plot Results - don't touch here
  pet <- tc_plot_elapsed_times(results)
  peth <- tc_plot_elapsed_times_histogram(results)
  prt <- tc_plot_requests_by_thread(results)
  prs <- tc_plot_requests_per_second(results)
  
  ac <- annotation_custom(rasterGrob(test_mark, 
                                     x = 1, 
                                     y=0.89, 
                                     hjust = 1, 
                                     width= .12, 
                                     interpolate=TRUE))
  
  grid_graphs <- ggarrange(pet + ac,
                           peth + ac, 
                           prt + ac, 
                           prs + ac,
                           ncol = 2, nrow = 2)
  
  out <- annotate_figure(grid_graphs,
                  bottom = text_grob(paste("This file auto generated and executed by: Berkant Yüksektepe. Test Class Non-Functional Used in plots. This page involves only load and performance tests, \n for more information please visit project repo: https://github.com/Berkantyuks/Non-Functional-Test-Automation-Baykar\n"),
                                     color = "black",
                                     face = "italic", 
                                     size = 10),
                  left = paste(current_time),
                  right = paste(current_time),
                  top = text_grob(paste0("\n Automated NF Test Results for ",test_url_formatted," (THR: ",thr,", LPS: ",loops,")","\n"), color = "black", face = "bold", size = 14))
  print(out)
  dev.off()
}

CreatePDF.LoadTest(results)


# Generate HTML Report
loadtest_report(results,"C:\\Users\\byuks\\Documents\\GitHub\\Non-Functional-Test-Automation-Baykar\\LoadTestReport.html")