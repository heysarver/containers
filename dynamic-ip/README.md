# Dynamic IP Updater

This project contains a Dockerized application that checks the public IP address of your machine and updates a DNS record on DigitalOcean if the IP address has changed.

## Usage

1. Copy `.env.example` to `.env` and fill in your actual values:

    ```sh
    cp .env.example .env
    ```

2. Build and run the Docker container:

    ```sh
    docker-compose up --build -d
    ```

## Note

The `script.sh` is scheduled to run every hour. You can modify this by updating the `crontab` file.
