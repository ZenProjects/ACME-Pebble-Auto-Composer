set -x 
DOMAIN_NAME="test.example.com"
LEGO_CONTAINER="lego"
EMAIL="test@example.com"
. $(dirname $0)/../configs/.env

docker exec -it ${LEGO_CONTAINER} /lego --server "${PEBBLE_FQDN}/dir" \
	  --email "${EMAIL}" \
          --domains "${DOMAIN_NAME}" \
          --accept-tos \
	  --eab \
	  --kid="${KID}" \
	  --hmac="${KID_HMAC}" \
	  --path /certificates \
	  --dns httpreq \
	  --dns.propagation-disable-ans \
	  run
