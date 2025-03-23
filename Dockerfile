# app/Dockerfile

FROM python:3.9-slim



WORKDIR /app



RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    software-properties-common \
    git \
    wget \
    vim \
    mc \
    screen \
    && rm -rf /var/lib/apt/lists/*


ARG TREX_VERSION="3.04"
ARG TREX_PATH="/opt/trex_client"
ENV TREX_VERSION=$TREX_VERSION
ENV TREX_PATH=$TREX_PATH
ENV TREX_EXT_LIBS="$TREX_PATH/external_libs"
ENV PYTHONPATH="$TREX_PATH/external_libs/scapy-2.4.3/"
ENV PYTHONPATH="$PYTHONPATH:$TREX_PATH/interactive"
ENV TREX=trex

RUN git clone https://github.com/streamlit/streamlit-example.git .
RUN mv streamlit_app.py app.py
RUN pip3 install -r requirements.txt



RUN  cd /opt; \
     wget --no-check-certificate https://trex-tgn.cisco.com/trex/release/v$TREX_VERSION.tar.gz; \
     tar --strip-components=1 -xOvzf v$TREX_VERSION.tar.gz v$TREX_VERSION/trex_client_v$TREX_VERSION.tar.gz | tar -xzv; \
     rm v$TREX_VERSION.tar.gz



EXPOSE 8501

HEALTHCHECK CMD curl --fail http://localhost:8501/_stcore/health

ENTRYPOINT ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"]
