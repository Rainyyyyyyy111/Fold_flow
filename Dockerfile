# 使用 NVIDIA 官方提供的 PyTorch 基础镜像
FROM pytorch/pytorch:2.1.0-cuda11.8-cudnn8-runtime

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential git wget curl vim htop && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir --upgrade pip

# 将所有排查到的依赖打包进去 (包括 ml-collections, deepspeed 等 OpenFold 常客)
RUN pip install --no-cache-dir \
    e3nn einops opt-einsum wandb pytorch-lightning torchmetrics \
    torchsde torchdiffeq geoopt~=0.4.0 numpy scipy pandas matplotlib \
    scikit-learn seaborn>=0.12.2 biopython fair-esm mdtraj pot \
    scprep scanpy timm GPUtil jax jaxlib dm-tree lmdb plotly \
    pydantic ml-collections deepspeed ninja h5py tensorboard

RUN pip install --no-cache-dir \
    hydra-core==1.2.0 hydra-colorlog==1.2.0 hydra-optuna-sweeper==1.2.0 \
    hydra-submitit-launcher omegaconf

RUN pip install --no-cache-dir git+https://github.com/joeybose/geomstats.git@master

WORKDIR /workspace