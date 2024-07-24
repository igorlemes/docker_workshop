

# Base image
FROM rocker/shiny:latest

# Install Conda
RUN apt-get update && \
    apt-get install -y wget && \
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda && \
    rm Miniconda3-latest-Linux-x86_64.sh

# Set Conda environment variables
ENV PATH="/opt/conda/bin:${PATH}"
ENV CONDA_AUTO_UPDATE_CONDA=false

# Install required packages using Conda
COPY config.yml /tmp/environment.yml
RUN conda env create -f /tmp/environment.yml
RUN conda install -n env -c conda-forge -c bioconda -c R r-leaflet.extras
RUN conda clean -afy

# Install additional packages using Conda
RUN /bin/bash -c "source activate $(head -1 /tmp/environment.yml | cut -d' ' -f2)"

# Set the working directory
WORKDIR /app

# Copy the Shiny app to the container
COPY app.R /app/app.R

# Expose the Shiny app port
EXPOSE 80

# Run the Shiny app
CMD ["/bin/bash", "-c", "source activate $(head -1 /tmp/environment.yml | cut -d' ' -f2) && Rscript /app/app.R"]