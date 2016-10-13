openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -days 36500 -nodes
cat key.pem cert.pem > certificate.pem
