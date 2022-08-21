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
library(png)

test_url <- c("https://kariyer.baykartech.com")
test_mark <- readPNG("img/tcnf-test-logo.png")
currentDate <- Sys.Date()

# Run loadtest
results <- loadtest(url = test_url,
                    method = "GET",
                    threads = 5,
                    loops = 30,
                    delay_per_request=100)

# Print Results
print(results)

CreatePDF.LoadTest <- function()
{
  pdf(file= paste("results\\",currentDate,"test_result.pdf"), width = 10, height = 8)
  
  # create a 2X2 grid
  par( mfrow= c(2,2) )
  
  # Plot Results
  pet <- plot_elapsed_times(results)
  peth <- plot_elapsed_times_histogram(results)
  prt <- plot_requests_by_thread(results)
  prs <- plot_requests_per_second(results)
  
  grid_graphs <- ggarrange(pet, peth, prt, prs,
                           ncol = 2, nrow = 2)
  
  annotate_figure(grid_graphs,
                  bottom = text_grob(paste(" Test Executed by: \n Berkant Yüksektepe \n"), color = "blue",
                                     hjust = 1, x = 1, face = "italic", size = 10),
                  left = paste(currentDate),
                  right = test_mark,
                  top = text_grob(paste("Load Test: ", test_url, "\n"), color = "black", face = "bold", size = 14))
  
  dev.off()
}

CreatePDF.LoadTest()


# Generate HTML Report
loadtest_report(results,"C:\\Users\\byuks\\Documents\\GitHub\\Non-Functional-Test-Automation-Baykar\\LoadTestReport.html")