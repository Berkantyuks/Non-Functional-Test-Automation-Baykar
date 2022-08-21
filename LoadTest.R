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

test_url <- c("https://kariyer.baykartech.com")
test_mark <- readPNG("img/tcnf-test-logo.png")
currentDate <- Sys.time()

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


## Create pdf file by test results
CreatePDF.LoadTest <- function(results)
{
  pdf(file= paste("results\\",currentDate,"test_result.pdf"), width = 11, height = 9)
  
  # create a 2X2 grid
  par( mfrow= c(2,2) )
  
  # Plot Results
  pet <- plot_elapsed_times(results)
  peth <- plot_elapsed_times_histogram(results)
  prt <- plot_requests_by_thread(results)
  prs <- plot_requests_per_second(results)
  
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
                  bottom = text_grob(paste("This file auto generated and executed by: Berkant Yüksektepe. Test Class Non-Functional Used in plots. This page involves only load and performance tests, \n for more information please visit project repo: https://github.com/Berkantyuks/Non-Functional-Test-Automation-Baykar\n"), color = "red",
                                    face = "italic", size = 10),
                  left = paste(currentDate),
                  right = paste(currentDate),
                  top = text_grob(paste("\n Load Test: ",test_url," (THR: ",thr," LPS: ",loops,")","\n"), color = "black", face = "bold", size = 14))
  print(out)
  dev.off()
}

CreatePDF.LoadTest(results)


# Generate HTML Report
loadtest_report(results,"C:\\Users\\byuks\\Documents\\GitHub\\Non-Functional-Test-Automation-Baykar\\LoadTestReport.html")