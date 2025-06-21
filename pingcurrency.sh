#!/bin/bash

while true; do
    curl -i "https://c418team04prod-currencyapi.computerlab.online/exchange_rate?from_currency=USD&to_currency=CAD"; 
    sleep 1;
    curl -i "https://c418team04prod-currencyapi.computerlab.online/convert_amount?from_currency=USD&to_currency=CAD&amount=100";
    sleep 1;
done
