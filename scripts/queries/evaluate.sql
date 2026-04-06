SELECT 'LogisticRegression' as model_name, * FROM ML.EVALUATE(MODEL `analytics_ds.logreg_purchase_prediction_model`)
UNION ALL
SELECT 'BoostedTree' as model_name, * FROM ML.EVALUATE(MODEL `analytics_ds.boostedtree_purchase_prediction_model`)
UNION ALL
SELECT 'DNN' as model_name, * FROM ML.EVALUATE(MODEL `analytics_ds.dnn_purchase_prediction_model`);