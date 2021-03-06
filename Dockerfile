FROM hiroara/myenv:latest

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh --progress=bar:force:noscroll && \
    bash /tmp/miniconda.sh -b -p $HOME/miniconda && \
    rm /tmp/miniconda.sh

ENV PATH $PATH:/root/miniconda/bin
ENV PYTHON_VERSION=3.7.9

RUN conda install python=${PYTHON_VERSION}

RUN conda install -c conda-forge -y jupyterlab && \
    conda clean --all

EXPOSE 8888

RUN conda install -y \
      matplotlib \
      numpy \
      pandas \
      scikit-learn \
      tqdm \
      && \
    conda install -c conda-forge -y --repodata-fn=repodata.json \
      nodejs \
      && \
    conda install -c conda-forge -y \
      ipywidgets \
      && \
    conda install -c anaconda -y \
      tensorflow-estimator=2.0.0 \
      tensorflow-probability=0.8.0 \
      tensorflow=2.0.0 \
      && \
    conda clean --all -y

# Tools
RUN apt-get update && \
    apt-get install -y \
      fonts-noto-cjk \
      && \
    rm -rf /var/lib/apt/lists/*

COPY ./conf/matplotlibrc /root/.config/matplotlib/matplotlibrc

RUN jupyter labextension install -y @jupyter-widgets/jupyterlab-manager

CMD ["jupyter", "lab", "--allow-root", "--no-browser", "--ip=0.0.0.0"]
