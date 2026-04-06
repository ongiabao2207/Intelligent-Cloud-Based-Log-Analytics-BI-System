CREATE OR REPLACE MODEL `analytics_ds.logreg_purchase_prediction_model`
OPTIONS(
  model_type='logistic_reg', 
  input_label_cols=['is_purchase']
) AS
SELECT
  IF(action='purchase',1,0) AS is_purchase,
  sentiment_score,
  response_time_ms
FROM
  `analytics_ds.website_logs`
WHERE
  sentiment_score IS NOT NULL;