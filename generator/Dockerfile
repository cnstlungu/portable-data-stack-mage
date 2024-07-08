FROM python:3.9-slim

RUN apt-get update && apt-get install -y wget

ADD --chmod=755 https://astral.sh/uv/install.sh /install.sh
RUN /install.sh && rm /install.sh

WORKDIR /home/generator

COPY generator .

RUN /root/.cargo/bin/uv pip install --system -r requirements.txt

CMD ["python", "generate.py"]
