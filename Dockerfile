FROM continuumio/miniconda3
WORKDIR /app
COPY ./sr.py /app/sr.py
COPY --chmod=777 ./goofys /app/goofys
RUN conda init bash \
&& . ~/.bashrc \
&& conda create -n tf tensorflow -y \
&& conda activate tf
RUN /app/goofys --endpoint=${AWS_ENDPOINT} ${AWS_BUCKET} /app/data
RUN pip install \
tensorflow \
tensorflow_hub
RUN python /app/sr.py
