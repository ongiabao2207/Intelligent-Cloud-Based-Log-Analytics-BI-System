CREATE OR REPLACE MODEL `analytics_ds.boostedtree_purchase_prediction_model`
OPTIONS(
  model_type='boosted_tree_classifier',
  input_label_cols=['is_purchase'],
  max_iterations=50
) AS
SELECT
  IF(action='purchase',1,0) AS is_purchase,
  sentiment_score,
  response_time_ms
FROM `analytics_ds.website_logs`
WHERE sentiment_score IS NOT NULL;