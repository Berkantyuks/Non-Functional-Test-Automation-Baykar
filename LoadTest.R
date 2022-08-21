# Set Environment Variable
Sys.setenv("LOADTEST_JMETER_PATH"="C:\\apache-jmeter-5.2\\bin\\jmeter.bat")
# Install packages
install.packages("remotes")
install.packages("devtools")
install.packages("tidyr")
install.packages("rmarkdown")
remotes::install_github("tmobile/loadtest")

# Load loadtest library
library(loadtest)

# Run loadtest
results <- loadtest(url = "https://example.com", method = "GET", threads = 1, loops = 10)

# Print Results
print(results)

# Plot Results
plot_requests_per_second(results)

# Generate HTML Report
loadtest_report(results,"C:\\apache-jmeter-5.2\\bin\\LoadTestReport.html")