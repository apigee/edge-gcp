mkdir -p /opt/apigee/customer
mkdir -p /opt/apigee/customer/application
echo "conf_load_balancing_load.balancing.driver.nginx.limit_conn=25000" >> /opt/apigee/customer/application/router.properties
echo "conf_http_HTTPTransport.max.client.count=20000" >> /opt/apigee/customer/application/message-processor.properties
echo "conf_threadpool_maximum.pool.size=150" >> /opt/apigee/customer/application/message-processor.properties

echo "bin_setenv_min_mem=1024m" >> /opt/apigee/customer/application/message-processor.properties
echo "bin_setenv_max_mem=3072m" >> /opt/apigee/customer/application/message-processor.properties
echo "bin_setenv_max_permsize=256m" >> /opt/apigee/customer/application/message-processor.properties
echo "conf_system_jsse.enableSNIExtension=true" >> /opt/apigee/customer/application/message-processor.properties

echo "bin_setenv_min_mem=1024m" >> /opt/apigee/customer/application/router.properties
echo "bin_setenv_max_mem=3072m" >> /opt/apigee/customer/application/router.properties
echo "bin_setenv_max_permsize=256m" >> /opt/apigee/customer/application/router.properties

chown apigee:apigee /opt/apigee/customer/application/message-processor.properties
chown apigee:apigee /opt/apigee/customer/application/router.properties