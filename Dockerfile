FROM nvidia/cuda:12.2.2-cudnn8-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install Python + pip
RUN apt-get update && apt-get install -y \
    python3 python3-pip git && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN pip install --upgrade pip

# Install PyTorch 2.7.0 + CUDA 12.8 support (ARM64 wheels)
RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128

# Optional: Add your Python dependencies
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

# Default shell
CMD ["/bin/bash"]

