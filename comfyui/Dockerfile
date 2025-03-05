FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Europe/Paris

RUN apt-get update && apt-get install -y \
    git \
    make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev git git-lfs  \
    ffmpeg libsm6 libxext6 cmake libgl1-mesa-glx \
    && rm -rf /var/lib/apt/lists/* \
    && git lfs install

WORKDIR /code

RUN chown 1000:1000 -R /code

# User
RUN useradd -m --groups users,sudo  -u 1000 user
USER user
ENV HOME=/home/user \
    PATH=/home/user/.local/bin:$PATH

# Pyenv
RUN curl https://pyenv.run | bash
ENV PATH=$HOME/.pyenv/shims:$HOME/.pyenv/bin:$PATH

ARG PYTHON_VERSION=3.10.12
# Python
RUN pyenv install $PYTHON_VERSION && \
    pyenv global $PYTHON_VERSION && \
    pyenv rehash && \
    pip install --no-cache-dir --upgrade pip setuptools wheel && \
    pip install --no-cache-dir \
    datasets \
    huggingface-hub "protobuf<4" "click<8.1"

# Set the working directory to /data if USE_PERSISTENT_DATA is set, otherwise set to $HOME/app
WORKDIR $HOME/app

# Copy the current directory contents into the container at $HOME/app setting the owner to the user

RUN git clone https://github.com/comfyanonymous/ComfyUI . && \
    pip install xformers!=0.0.18 --no-cache-dir -r requirements.txt --extra-index-url https://download.pytorch.org/whl/cu121

# instal custom nodes
RUN echo "Installing custom nodes..."
# Controlnet Preprocessor nodes by Fannovel16
# RUN cd custom_nodes && git clone https://github.com/Fannovel16/comfy_controlnet_preprocessors && cd comfy_controlnet_preprocessors && python install.py --no_download_ckpts

RUN cd custom_nodes && git clone https://github.com/ltdrdata/ComfyUI-Manager && cd ComfyUI-Manager && pip install --no-cache-dir -r requirements.txt
RUN cd custom_nodes && git clone https://github.com/sipherxyz/comfyui-art-venture && cd comfyui-art-venture && pip install --no-cache-dir -r requirements.txt
RUN cd custom_nodes && git clone https://github.com/chflame163/ComfyUI_LayerStyle && cd ComfyUI_LayerStyle && pip install --no-cache-dir -r requirements.txt
RUN cd custom_nodes && git clone https://github.com/Fannovel16/comfyui_controlnet_aux && cd comfyui_controlnet_aux && pip install --no-cache-dir -r requirements.txt
RUN cd custom_nodes && git clone https://github.com/rgthree/rgthree-comfy && cd rgthree-comfy && pip install --no-cache-dir -r requirements.txt
RUN cd custom_nodes && git clone https://github.com/pythongosssss/ComfyUI-Custom-Scripts
RUN cd custom_nodes && git clone https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes
RUN cd custom_nodes && git clone https://github.com/cubiq/ComfyUI_IPAdapter_plus
RUN cd custom_nodes && git clone https://github.com/Derfuu/Derfuu_ComfyUI_ModdedNodes
RUN cd custom_nodes && git clone https://github.com/Acly/comfyui-inpaint-nodes
RUN cd custom_nodes && git clone https://github.com/ssitu/ComfyUI_UltimateSDUpscale --recursive
RUN cd custom_nodes && git clone https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet
RUN cd custom_nodes && git clone https://github.com/unanan/ComfyUI-clip-interrogator

RUN echo "Done"

CMD python main.py --listen 0.0.0.0 --port 7860 ${CLI_ARGS}
