FROM python:3.11-slim

RUN apt update && \
    apt install -y curl && \
    apt clean

WORKDIR /app

ADD requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000

HEALTHCHECK --interval=5s --timeout=5s --retries=3 CMD curl -f http://localhost:5000/health || exit 1

CMD ["flask", "run", "--host=0.0.0.0", "--port=5000"]
