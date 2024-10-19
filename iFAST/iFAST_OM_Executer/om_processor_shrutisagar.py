#!/usr/bin/python3

from connect_dbr import DatabricksConnector

d_dtm = '2024-08-12 16:00:00+00:00'
#NE_ID="eNB_131307"
conn = DatabricksConnector(server_hostname="dbc-d2b3035b-54c3.cloud.databricks.com",http_path="/sql/1.0/warehouses/4db10f38cf9cef7a",access_token="dapieb049d1404e46225b9445d713fcaae5a")
try:
    conn.connect()
    print("Connection to Databricks successful!")
    #query = "SELECT * FROM hive_metastore.default.megatable_4g_site_gold_tmp2 WHERE D_DTM='{}' AND NE_ID='{}'".format(d_dtm, NE_ID)
    #query = f"SELECT * FROM hive_metastore.default.megatable_4g_site_gold_tmp2 LIMIT 2"
    query = "SHOW TABLES IN hive_metastore.default LIKE '%4g%'"
    result = conn.execute_query(query)
except Exception as e:
    print(f"Failed to connect to Databricks: {e}")
finally:
    conn.close()

