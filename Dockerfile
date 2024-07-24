# Base image
FROM rocker/shiny

# # Set the working directory
WORKDIR /app

# # Copy the Shiny app to the container
COPY app.R /app/app.R

# Porta
EXPOSE 4242

# # Run the Shiny app
ENTRYPOINT ["Rscript", "/app/app.R"]