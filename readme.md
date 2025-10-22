# Acme Test server with auto challenge

This docker compose start pebble acme test server and challange server, and permit to get certificate with acme with dns challenge without dns infrastructure.

Prerequisite: 
- docker
- docker compose plugin v2

Images used:
- https://github.com/letsencrypt/pebble

  A miniature version of Boulder, Pebble is a small ACME test server not suited for use as a production CA.
- https://github.com/letsencrypt/challtestsrv

  Small TEST-ONLY server for mock DNS & responding to HTTP-01, DNS-01, and TLS-ALPN-01 ACME challenges.
- Dns-bridge : an httpreq lego dns provider
  
  A litle python wrapper ([httpreq](https://go-acme.github.io/lego/dns/httpreq/index.html)) to challtestsrv.
- https://github.com/go-acme/lego

  An acme golang client to test certificate generation with [httpreq](https://go-acme.github.io/lego/dns/httpreq/index.html) dns provider.

This is only for testing, do not use in production !

To start and test:
```sh
make
```

To clean all:
```sh
make clean-all
```

The pebble Acme server start on 0.0.0.0:14000
