-- Dự đoán khả năng mua hàng cho dữ liệu hiện có
SELECT
  user_id,
  action,
  feedback,
  sentiment_score,
  response_time_ms,
  predicted_is_purchase,
  predicted_is_purchase_probs[OFFSET(0)].prob AS probability_of_purchase
FROM
  ML.PREDICT(MODEL `analytics_ds.boostedtree_purchase_prediction_model`, (
    SELECT * FROM `analytics_ds.website_logs` WHERE sentiment_score IS NOT NULL
  ));