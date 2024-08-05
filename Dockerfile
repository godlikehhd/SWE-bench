# 第一阶段：基础环境安装
FROM ubuntu:22.04 as builder

# 使用root用户安装必要的软件包
USER root

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    git \
    wget \
    bash \
    gcc \
    jq \
    libffi-dev \
    python3-pytest \
    libfreetype6-dev \
    libqhull-dev \
    pkg-config \
    texlive \
    cm-super \
    dvipng \
    python-tk \
    ffmpeg \
    imagemagick \
    fontconfig \
    ghostscript \
    inkscape \
    graphviz \
    optipng \
    fonts-comic-neue \
    python3-pikepdf \
    build-essential \
    libssl-dev

# 安装Miniconda
WORKDIR /root
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash ./Miniconda3-latest-Linux-x86_64.sh -b -p /root/miniconda3 && \
    rm Miniconda3-latest-Linux-x86_64.sh
ENV PATH="/root/miniconda3/bin:${PATH}"
RUN conda init

# 克隆SWE-bench仓库并创建环境
WORKDIR /opt
RUN git clone https://github.com/yuntongzhang/SWE-bench.git

WORKDIR SWE-bench
RUN conda env create -f environment.yml
RUN ln -sf /bin/bash /bin/sh

# 第二阶段：运行环境
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 复制第一阶段的构建结果
COPY --from=builder /root /root
COPY --from=builder /opt /opt

# 安装运行所需的软件包
RUN apt update && apt install -y \
    libffi-dev \
    python3-pytest \
    libfreetype6-dev \
    libqhull-dev \
    pkg-config \
    texlive \
    cm-super \
    dvipng \
    python-tk \
    ffmpeg \
    imagemagick \
    fontconfig \
    ghostscript \
    inkscape \
    graphviz \
    optipng \
    fonts-comic-neue \
    python3-pikepdf \
    build-essential \
    libssl-dev

# 确保用户权限
RUN useradd -m user
USER user
WORKDIR /home/user

ENTRYPOINT [ "/bin/bash" ]
