# Acme Test server with auto challenge

This docker compose start pebble acme test server and challange server, and permit to get certificate with acme with dns challenge without dns infrastructure.

Prerequisite: docker and docker compose plugin v2

Images used:
- https://github.com/letsencrypt/pebble
  A miniature version of Boulder, Pebble is a small ACME test server not suited for use as a production CA.
- https://github.com/letsencrypt/challtestsrv
  Small TEST-ONLY server for mock DNS & responding to HTTP-01, DNS-01, and TLS-ALPN-01 ACME challenges. 
- https://github.com/go-acme/lego
  acme golang client

Plus a python wrapper (httpreq) to challtestsrv.

To start and test:
```sh
make
```

To clean all:
```sh
make clean-all
```
