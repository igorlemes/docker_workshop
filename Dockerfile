# Base image
FROM alpine:3.14

# Install Conda
RUN apk add python3

# # Set the working directory
WORKDIR /app

# # Copy the Shiny app to the container
COPY main.py /app/main.py

# # Run the Shiny app
ENTRYPOINT ["python3", "/app/main.py"]