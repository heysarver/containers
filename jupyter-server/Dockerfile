FROM quay.io/jupyter/pytorch-notebook:cuda12-python-3.11.8 as base

# Install git and build-essentials
USER root
RUN apt-get update && apt-get install -y git build-essential
