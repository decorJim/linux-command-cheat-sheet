#!/bin/bash

while true; do
    curl -i "https://c418team04prod-currencyapi.computerlab.online/exchange_rate?from_currency=USD&to_currency=CAD"; 
    sleep 1;
    curl -i "https://c418team04prod-currencyapi.computerlab.online/convert_amount?from_currency=USD&to_currency=CAD&amount=100";
    sleep 1;
    curl -i "https://c418team04prod-currencyapi.computerlab.online/check_password_strength?password=StrongPass1"
    sleep 1;
    curl -i "https://c418team04prod-currencyapi.computerlab.online/available_currencies?from_currency=USD";
    sleep 1;
    curl -i "https://c418team04prod-currencyapi.computerlab.online/available_crypto"
    sleep 1;
    curl -i "https://c418team04prod-currencyapi.computerlab.online/convert_crypto?from_crypto=BTC&to_currency=CAD"
    sleep 1;
    curl -i "https://c418team04prod-currencyapi.computerlab.online/update_orderbookdb_asset_price?symbol=BTC&new_price=92000.50"
    sleep 1;
    curl -i "https://c418team04prod-currencyapi.computerlab.online/add_crypto_to_orderbook?symbol=BTC"
    sleep 1;
done
