# DevOps/SRE Troubleshooting Toolkit

A Docker container with essential tools for cloud, Kubernetes, and database troubleshooting.

## Contents

This container includes:
- Cloud CLI tools (AWS, Azure, GCP)
- Kubernetes tools (kubectl, helm, k9s, etc.)
- Network troubleshooting tools
- Database clients and troubleshooting scripts
- Message queue tools
- Cache tools

## Usage

Build the container:
```
docker build -t devops-toolkit .
```

Run the container:
```
docker run -it devops-toolkit
```

## Scripts

The container includes several troubleshooting scripts organized by type:

### Database Scripts (`/opt/tools/db-scripts/`)
- `mysql-troubleshoot.sh` - MySQL troubleshooting tools  
- `mssql-troubleshoot.sh` - Microsoft SQL Server troubleshooting tools
- `postgres-troubleshoot.sh` - PostgreSQL troubleshooting tools
- `mongodb-troubleshoot.sh` - MongoDB troubleshooting tools

### Cache Scripts (`/opt/tools/cache-scripts/`)
- `redis-troubleshoot.sh` - Redis troubleshooting tools

### Message Queue Scripts (`/opt/tools/message-queue-scripts/`)
- `rabbitmq-troubleshoot.sh` - RabbitMQ troubleshooting tools
- `sidekiq-troubleshoot.sh` - Sidekiq monitoring and troubleshooting
