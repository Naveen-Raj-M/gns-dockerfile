# ------------------------------------------------------------------------------
# Dockerfile for ARM64  |  CUDA 12.2  |  PyTorch 2.7 (+CU128)  |  PyG compiled
# ------------------------------------------------------------------------------

FROM nvidia/cuda:12.2.2-cudnn8-devel-ubuntu22.04   #  devel = has nvcc & compilers

ENV DEBIAN_FRONTEND=noninteractive

# ------------------------------------------------------------------
# 1. System packages ‑‑ compiler tool‑chain + Python basics
# ------------------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
        python3 python3-pip python3-dev git build-essential \
        ninja-build cmake pkg-config wget curl ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# ------------------------------------------------------------------
# 2. Upgrade pip
# ------------------------------------------------------------------
RUN pip install --upgrade pip wheel setuptools

# ------------------------------------------------------------------
# 3. Install CUDA‑enabled PyTorch 2.7.0 (arm64 wheels exist on cu128)
# ------------------------------------------------------------------
RUN pip install torch==2.7.0 torchvision==0.18.0 torchaudio==2.7.0 \
        --index-url https://download.pytorch.org/whl/cu128

# ------------------------------------------------------------------
# 4. Build & install PyTorch‑Geometric + required C++/CUDA ops
#    ‑ The pip installer will detect nvcc and compile for arm64/SM90.
# ------------------------------------------------------------------
ENV TORCH_CUDA_ARCH_LIST="8.0 8.6 9.0 9.0+PTX"
RUN pip install \
        torch-scatter \
        torch-sparse \
        torch-cluster \
        torch-spline-conv \
        -f https://data.pyg.org/whl/torch-2.7.0+cu128.html  && \
    pip install torch-geometric

# ------------------------------------------------------------------
# 5. Your project‑specific Python requirements
# ------------------------------------------------------------------
COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt && rm /tmp/requirements.txt

# ------------------------------------------------------------------
# 6. Default entrypoint
# ------------------------------------------------------------------
CMD ["/bin/bash"]

