# Use NVIDIA PyTorch container for ARM64 with CUDA (supports Grace Hopper)
FROM nvcr.io/nvidia/pytorch:24.03-py3

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install extra system packages if needed
RUN apt-get update && apt-get install -y \
    git curl gcc g++ \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Upgrade pip (optional)
RUN pip install --upgrade pip

# Install additional dependencies for torch-geometric
RUN pip install \
    numpy \
    scipy \
    sympy \
    scikit-learn \
    networkx \
    requests \
    tqdm

# Copy and install your requirements
COPY requirements.txt .
RUN pip install -r requirements.txt

# Optional entrypoint
CMD ["python3"]

