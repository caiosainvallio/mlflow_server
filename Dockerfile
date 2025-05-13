FROM python:3.9-slim 

WORKDIR /mlflow

COPY requirements.txt .

RUN pip install -r requirements.txt

RUN echo '#!/bin/bash \n\
python -c "import boto3; \
s3 = boto3.client(\"s3\", \
    endpoint_url=\"$MLFLOW_S3_ENDPOINT_URL\", \
    aws_access_key_id=\"$AWS_ACCESS_KEY_ID\", \
    aws_secret_access_key=\"$AWS_SECRET_ACCESS_KEY\"); \
try: \
    s3.create_bucket(Bucket=\"$BUCKET_NAME\"); \
    print(\"Bucket created successfully\"); \
except Exception as e: \
    if \"BucketAlreadyOwnedByYou\" in str(e): \
        print(\"Bucket already exists.\"); \
    else: \
        print(\"Error creating bucket: \", e); \
" \n\
\n\
mlflow server \
--backend-store-uri $MLFLOW_TRACKING_URI \
--default-artifact-root s3://$BUCKET_NAME/ \
--host 0.0.0.0 \
--port 3000 \
' > /mlflow/start.sh

RUN chmod +x /mlflow/start.sh

EXPOSE 3000

CMD ["/bin/bash", "/mlflow/start.sh"]