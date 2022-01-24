FROM huggingface/transformers-pytorch-cpu:latest

COPY ./ /app
WORKDIR /app

# install requirements
RUN pip install "dvc[gdrive]"
RUN pip install -r requirements.txt

# initialise dvc
#RUN dvc init --no-scm
# configuring remote server in dvc
RUN dvc remote add -d storage gdrive://1j35lssqTMcvP-hcpjzXiZJDDvthL2yY2
RUN dvc remote modify storage gdrive_use_service_account true
RUN dvc remote modify storage gdrive_service_account_json_file_path creds.json

# pulling the trained model
RUN dvc pull dvcfiles/trained_model.dvc

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

EXPOSE 8000

CMD ["uvicorn", "app:app", "--port", "8000"]