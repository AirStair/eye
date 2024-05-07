FROM continuumio/miniconda3
ARG AWS_BUCKET
ARG AWS_ENDPOINT
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ENV AWS_BUCKET=${AWS_BUCKET}
ENV AWS_ENDPOINT=${AWS_ENDPOINT}
ENV AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
ENV AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
COPY ./sr.py ./sr.py
COPY ./goofys ./goofys
RUN chmod a+x ./goofys
VOLUME ./s3
RUN ./goofys \
--endpoint=${AWS_ENDPOINT} \
${AWS_BUCKET} ./s3
RUN conda init bash \
&& . ~/.bashrc \
&& conda create -n tf tensorflow -y \
&& conda activate tf
RUN pip install \
tensorflow \
tensorflow_hub
RUN python /app/sr.py
