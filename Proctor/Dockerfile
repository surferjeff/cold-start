FROM python:3.10-slim
WORKDIR /app
COPY agent.py proctor.py requirements.txt /app/
RUN pip install -r requirements.txt
EXPOSE 8080
CMD ["python", "agent.py"]