FROM continuumio/miniconda3
WORKDIR /app
COPY ./sr.py /app/sr.py
COPY ./goofys /app/goofys
RUN chmod a+x /app/goofys
RUN /app/goofys --endpoint=${AWS_ENDPOINT} ${AWS_BUCKET} /app/data
RUN conda init bash \
&& . ~/.bashrc \
&& conda create -n tf tensorflow -y \
&& conda activate tf
RUN pip install \
tensorflow \
tensorflow_hub
RUN python /app/sr.py
