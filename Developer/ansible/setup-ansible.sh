#!/bin/bash

# Function to setup the container
setup_container() {
    # Check if the container already exists
    if ! podman container exists ansible-practice; then
        # Run the container with Ansible and Git installed
        podman run -it -d --name ansible-practice ubuntu-ansible-user:22.04 bash
    else
        echo "Container already exists. Starting and attaching..."
    fi

    # Start the container if it's not already running
    podman start ansible-practice

    # Attach to the running container
    podman attach ansible-practice
}

# Function to reset the container
reset_container() {
    # Remove the container if it exists
    podman rm -f ansible-practice 2>/dev/null

    # Setup the container again
    setup_container
}

# Check the script argument
if [ "$1" == "reset" ]; then
    reset_container
else
    setup_container
fi
