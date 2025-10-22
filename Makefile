all: setup test

datas/pebble-certs/acme/cert.pem: 
	./scripts/genpeblecert.sh
	docker compose down 
	docker compose up -d --build
	rm -rf datas/certificates/*
	sleep 3

setup: datas/pebble-certs/acme/cert.pem

start: 
	docker compose up -d 

restart: 
	docker compose restart

logs: 
	docker compose logs -f

down: 
	docker compose down

test: setup 
	./scripts/genlego.sh
	openssl x509 -in datas/certificates/certificates/test.example.com.crt -text -noout

clean-pebble: 
	rm -rf datas/pebble-certs/*
clean-lego: 
	rm -rf datas/certificates/*

clean-all: down clean-lego clean-pebble 
	rm -rf datas

