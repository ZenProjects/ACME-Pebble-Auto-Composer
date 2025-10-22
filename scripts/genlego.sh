set -x 
DOMAIN_NAME="test.example.com"
LEGO_CONTAINER="lego"
EMAIL="test@example.com"

docker exec -it ${LEGO_CONTAINER} /lego --server https://anakai.ch2o.info:14000/dir \
	  --email "${EMAIL}" \
          --domains "${DOMAIN_NAME}" \
          --accept-tos \
	  --path /certificates \
	  --dns httpreq \
	  --dns.propagation-disable-ans \
	  run
