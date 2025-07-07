# Use NVIDIA's CUDA devel image (includes nvcc)
FROM nvidia/cuda:12.2.2-cudnn8-devel-ubuntu22.04

# Avoid interactive prompts during package install
ENV DEBIAN_FRONTEND=noninteractive

# Install system packages
RUN apt-get update && apt-get install -y \
    python3 python3-pip git curl gcc g++ \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN pip3 install --upgrade pip

# Install PyTorch for CUDA 12.2 (ARM64)
RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu122

# Install torch-geometric dependencies
RUN pip3 install \
    numpy \
    scipy \
    sympy \
    scikit-learn \
    networkx \
    requests \
    tqdm \
    --extra-index-url https://pytorch-geometric.com/whl/torch-2.2.0+cu122.html

# Copy your requirements and install
COPY requirements.txt .
RUN pip3 install -r requirements.txt

# Default command (optional)
CMD ["python3"]

