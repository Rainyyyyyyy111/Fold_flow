# 使用 NVIDIA 官方提供的 PyTorch 基础镜像
FROM pytorch/pytorch:2.1.0-cuda11.8-cudnn8-runtime

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential git wget curl vim htop && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir --upgrade pip

# ==============================================================
# 第一部分：深度学习与流形核心依赖
# ==============================================================
RUN pip install --no-cache-dir \
    e3nn einops opt-einsum wandb pytorch-lightning torchmetrics \
    torchsde torchdiffeq geoopt~=0.4.0 jax jaxlib dm-tree \
    hydra-core==1.2.0 hydra-colorlog==1.2.0 hydra-optuna-sweeper==1.2.0 \
    hydra-submitit-launcher omegaconf deepspeed ninja h5py tensorboard

# 作者魔改版的 geomstats
RUN pip install --no-cache-dir git+https://github.com/joeybose/geomstats.git@master

# ==============================================================
# 第二部分：生信分析、基础计算与 OpenFold 魔鬼依赖大全
# ==============================================================
# 注意：OpenMM 及其旧版 simtk 接口是这里的难点
RUN pip install --no-cache-dir \
    numpy scipy pandas matplotlib scikit-learn seaborn>=0.12.2 \
    biopython fair-esm mdtraj pot scprep scanpy timm GPUtil \
    lmdb plotly pydantic ml-collections \
    absl-py git+https://github.com/NVIDIA/dllogger.git tmtools ipdb

# 为了支持 simtk.openmm 的导入（AlphaFold/OpenFold 的残留），安装官方 openmm
RUN conda install -y -c conda-forge openmm pdbfixer

WORKDIR /workspace