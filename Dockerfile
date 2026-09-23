FROM python:3.13-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt && pip uninstall -y pip
COPY app.py .
RUN useradd --create-home appuser
USER appuser
CMD ["python", "app.py"]
