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
currentDate <- Sys.Date()

# Run loadtest
results <- loadtest(url = test_url,
                    method = "GET",
                    threads = 7,
                    loops = 10,
                    delay_per_request=100)

# Print Results
print(results)


## Create pdf file by test results
CreatePDF.LoadTest <- function(results)
{
  pdf(file= paste("results\\",currentDate,"test_result.pdf"), width = 10, height = 8)
  
  # create a 2X2 grid
  par( mfrow= c(2,2) )
  
  # Plot Results
  pet <- plot_elapsed_times(results)
  peth <- plot_elapsed_times_histogram(results)
  prt <- plot_requests_by_thread(results)
  prs <- plot_requests_per_second(results)
  
  ac <- annotation_custom(rasterGrob(test_mark, 
                                     x = 1, 
                                     y=0.85, 
                                     hjust = 1, 
                                     width= .12, 
                                     interpolate=TRUE))
  
  grid_graphs <- ggarrange(pet + ac,
                           peth + ac, 
                           prt + ac, 
                           prs + ac,
                           ncol = 2, nrow = 2)
  
  out <- annotate_figure(grid_graphs,
                  bottom = text_grob(paste(" Test Executed by: \n Berkant Yüksektepe \n"), color = "blue",
                                     hjust = 1, x = 1, face = "italic", size = 10),
                  left = paste(currentDate),
                  right = paste(currentDate),
                  top = text_grob(paste("Load Test: ", test_url, "\n"), color = "black", face = "bold", size = 14))
  print(out)
  dev.off()
}

CreatePDF.LoadTest(results)


# Generate HTML Report
loadtest_report(results,"C:\\Users\\byuks\\Documents\\GitHub\\Non-Functional-Test-Automation-Baykar\\LoadTestReport.html")