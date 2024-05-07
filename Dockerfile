FROM continuumio/miniconda3
WORKDIR /app
COPY . /app
RUN conda init bash \
&& . ~/.bashrc \
&& conda create -n tf tensorflow -y \
&& conda activate tf
RUN pip install tensorflow tensorflow_hub boto3
RUN python /app/sr.py
