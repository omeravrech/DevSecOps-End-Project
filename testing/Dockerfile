FROM python:latest
WORKDIR /app
COPY requirements.txt .
RUN pip3 install -r requirements.txt
COPY main.py .
ENTRYPOINT ["pytest","main.py"]
