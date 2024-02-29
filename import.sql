COPY transactions(step, type, amount, nameOrig, oldbalanceOrg, newbalanceOrig, nameDest, oldbalanceDest, newbalanceDest, isFraud, isFlaggedFraud)
FROM '/home/2311-002-ka/Downloads/archive/Fraud.csv'
DELIMITER ','
CSV HEADER;