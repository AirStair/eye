FROM continuumio/miniconda3
WORKDIR /app
ADD --chmod 777 https://github.com/kahing/goofys/releases/latest/download/goofys
COPY . /app
RUN conda init bash \
&& . ~/.bashrc \
&& conda create -n tf tensorflow -y \
&& conda activate tf
RUN apt install goofys
RUN /app/goofys --endpoint=${AWS_ENDPOINT} ${AWS_BUCKET} /app/data
RUN pip install \
tensorflow \
tensorflow_hub
RUN python /app/sr.py
