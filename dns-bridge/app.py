#!/usr/bin/env python3
import logging
import hashlib
import base64
from flask import Flask, request, jsonify
import requests

app = Flask(__name__)
app.logger.setLevel(logging.DEBUG)

CHALLTESTSRV = 'http://challenge-server:8055'

def compute_txt_value(key_auth):
    """Calcule la valeur TXT DNS pour le challenge DNS-01"""
    digest = hashlib.sha256(key_auth.encode()).digest()
    return base64.urlsafe_b64encode(digest).decode().rstrip('=')

@app.route('/present', methods=['POST'])
def present():
    data = request.json
    # Lego envoie 'domain', pas 'fqdn'
    domain = data.get('domain', '')
    key_auth = data.get('keyAuth', '')
    
    app.logger.info("=== PRESENT REQUEST: START ===")
    app.logger.debug(f"Received data: {data}")
    
    # Construire le FQDN complet pour le challenge DNS-01
    fqdn = f'_acme-challenge.{domain}'
    # Calculer la valeur TXT à partir du keyAuth
    txt_value = compute_txt_value(key_auth)
    
    app.logger.info(f"Domain: {domain}")
    app.logger.info(f"FQDN: {fqdn}")
    app.logger.info(f"TXT Value: {txt_value}")
    
    try:
        resp = requests.post(f'{CHALLTESTSRV}/set-txt', json={
            'host': fqdn,
            'value': txt_value
        }, timeout=5)
        
        app.logger.info(f"Challenge server response status: {resp.status_code}")
        app.logger.debug(f"Response body: {resp.text}")
        
        if resp.status_code == 200:
            app.logger.info("PRESENT SUCCESS: TXT record set successfully.")
            return '', 200
            
        app.logger.warning(f"PRESENT FAILURE: Challenge server returned non-200 status {resp.status_code}. Body: {resp.text}")
        return jsonify({'error': f'Failed to set TXT record: {resp.text}'}), 500
        
    except Exception as e:
        app.logger.error(f"PRESENT EXCEPTION: {str(e)}", exc_info=True)
        return jsonify({'error': str(e)}), 500

@app.route('/cleanup', methods=['POST'])
def cleanup():
    data = request.json
    domain = data.get('domain', '')
    
    app.logger.info("=== CLEANUP REQUEST: START ===")
    app.logger.debug(f"Received data: {data}")
    
    fqdn = f'_acme-challenge.{domain}'
    app.logger.info(f"Domain: {domain}")
    app.logger.info(f"FQDN: {fqdn}")
    
    try:
        resp = requests.post(f'{CHALLTESTSRV}/clear-txt', json={
            'host': fqdn
        }, timeout=5)
        
        app.logger.info(f"Challenge server response status: {resp.status_code}")
        app.logger.debug(f"Response body: {resp.text}")
        
        if resp.status_code == 200:
            app.logger.info("CLEANUP SUCCESS: TXT record cleared successfully.")
            return '', 200
            
        app.logger.warning(f"CLEANUP FAILURE: Challenge server returned non-200 status {resp.status_code}. Body: {resp.text}")
        return jsonify({'error': f'Failed to clear TXT record: {resp.text}'}), 500
        
    except Exception as e:
        app.logger.error(f"CLEANUP EXCEPTION: {str(e)}", exc_info=True)
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8056, debug=True)
