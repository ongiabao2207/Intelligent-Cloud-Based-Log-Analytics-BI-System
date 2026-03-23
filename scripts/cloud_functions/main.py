import base64
import json
import logging
from google.cloud import language_v1
from google.cloud import bigquery

# Initialize clients outside the function for better performance
language_client = language_v1.LanguageServiceClient()
bq_client = bigquery.Client()

def process_logs(event, context):
    """
    Cloud Function triggered by Pub/Sub to process website logs.
    """
    try:
        # 1. Decode Pub/Sub Message
        if 'data' not in event:
            logging.error("No data found in Pub/Sub event.")
            return

        pubsub_message = base64.b64decode(event['data']).decode('utf-8')
        log_data = json.loads(pubsub_message)
        logging.info(f"Processing log for user: {log_data.get('user_id')}")

        # 2. AI Sentiment Analysis
        feedback_text = log_data.get('feedback')
        sentiment_score = None

        if feedback_text:
            document = language_v1.Document(
                content=feedback_text,
                type_=language_v1.Document.Type.PLAIN_TEXT
            )
            # Call Natural Language API
            sentiment = language_client.analyze_sentiment(request={'document': document}).document_sentiment
            sentiment_score = sentiment.score
            logging.info(f"Analyzed sentiment: {sentiment_score}")
        else:
            logging.info("No feedback provided. Skipping AI analysis.")

        # 3. Data Enrichment
        log_data['sentiment_score'] = sentiment_score

        # 4. BigQuery Ingestion
        dataset_id = "analytics_ds" 
        table_id = "website_logs"
        table_ref = bq_client.dataset(dataset_id).table(table_id)

        # Stream row into BigQuery
        errors = bq_client.insert_rows_json(table_ref, [log_data])

        if errors:
            logging.error(f"BigQuery insertion errors: {errors}")
        else:
            logging.info("Successfully ingested log into BigQuery.")

    except Exception as e:
        logging.error(f"Error processing pipeline: {str(e)}")