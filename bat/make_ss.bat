
REM makes a self signed certificate

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout %1.pem -out %1.pem -passin pass:"%2"

openssl pkcs12 -export -out %1.pfx -in %1.pem -name "%1" -passin pass:"%2" -passout pass:"%2"

openssl pkcs12 -in %1.pfx -out %1.pem -passin pass:"%2" -passout pass:"%2"

openssl pkcs12 -export -in %1.pem -out %1.ks -name "%1" -passin pass:"%2" -passout pass:"%2"

openssl rsa -in %1.pem -out %1.pub -pubout -passin pass:"%2"
