# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Set environment variables to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive
# Set your timezone here
ENV TZ=Europe/Zurich  

# Create a new user
RUN useradd -m -s /bin/bash mm

# Update the package list and install Git and Ansible as root
RUN apt-get update && \
    apt-get install -y git ansible && \
    rm -rf /var/lib/apt/lists/*  
# Clean up to reduce image size

# Switch to the new user
USER mm

# Set the working directory to the user's home directory
WORKDIR /home/mm
