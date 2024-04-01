
FROM python:3.9-slim

WORKDIR /home/generator

COPY generator .

RUN pip install -r requirements.txt

CMD ["python", "generate.py"]
