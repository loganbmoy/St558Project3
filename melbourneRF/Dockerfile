# start from the rstudio/plumber image
FROM rstudio/plumber

# install the linux libraries needed for plumber
RUN apt-get update -qq && apt-get install -y  libssl-dev  libcurl4-gnutls-dev  libpng-dev pandoc 
    
    
# install plumber, GGally
RUN R -e "install.packages(c('tidymodels', 'bundle', 'plumber', 'lubridate'))"

# copy plumber.R from the current directory into the container
COPY melbourneRF/plumber.R app/plumber.R
# the data
COPY data /app/data

# open port to traffic
EXPOSE 8000

# when the container starts, start the plumber.R script
ENTRYPOINT ["R", "-e", \
    "pr <- plumber::plumb('app/plumber.R'); pr$run(host='0.0.0.0', port=8000)"]
