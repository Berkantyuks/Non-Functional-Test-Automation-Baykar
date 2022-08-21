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

# Run loadtest
results <- loadtest(url = "https://kariyer.baykartech.com",
                    method = "GET",
                    threads = 5,
                    loops = 30,
                    delay_per_request=100)

# Print Results
print(results)

pdf(file= "sample.pdf" )

# create a 2X2 grid
par( mfrow= c(2,2) )

# Plot Results
pet <- plot_elapsed_times(results)
peth <- plot_elapsed_times_histogram(results)
prt <- plot_requests_by_thread(results)
prs <- plot_requests_per_second(results)

grid_graphs <- ggarrange(pet, peth, prt, prs,
          labels = c("A", "B", "C", "D"),
          ncol = 2, nrow = 2)

dev.off()

# Generate HTML Report
loadtest_report(results,"C:\\Users\\byuks\\Documents\\GitHub\\Non-Functional-Test-Automation-Baykar\\LoadTestReport.html")