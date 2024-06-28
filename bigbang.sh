#!/bin/bash
PURPLE='\033[95m'
CYAN='\033[96m'
DARKCYAN='\033[36m'
BLUE='\033[94m'
GREEN='\033[92m'
YELLOW='\033[93m'
RED='\033[91m'
BOLD='\033[1m'
UNDERLINE='\033[4m'
END='\033[0m'

file_path="firebase.json"
mkdir -p "$(pwd)/cryptobot"

if [ -f "$file_path" ]; then
    (cd cryptobot && git clone https://github.com/EPS-2024-1-CryptoBot/crypto-frontend.git)
    (cd cryptobot && git clone https://github.com/EPS-2024-1-CryptoBot/crypto-backend.git)
    (cd cryptobot && git clone https://github.com/EPS-2024-1-CryptoBot/crypto-wallet.git)
    (cd cryptobot && git clone https://github.com/EPS-2024-1-CryptoBot/crypto-consultant.git)

    mkdir -p "$(pwd)/cryptobot/crypto-backend/env/dev"
    mkdir -p "$(pwd)/cryptobot/crypto-backend/env/prod"
    mkdir -p "$(pwd)/cryptobot/crypto-backend/env/test"
    cp firebase.json cryptobot/crypto-backend/env/dev/firebase.json | true
    cp firebase.json cryptobot/crypto-backend/env/prod/firebase.json | true
    cp firebase.json cryptobot/crypto-backend/env/test/firebase.json | true

    (cd cryptobot/crypto-frontend/frontend && make bigbang)
    (cd cryptobot/crypto-backend && npm i && make bigbang)
    (cd cryptobot/crypto-wallet && make bigbang)
    (cd cryptobot/crypto-consultant && make bigbang)

    printf "${CYAN}%-20s${END} %b \n" "FRONTEND URL" "http://localhost:5173"
    printf "${PURPLE}%-20s${END} %b \n" "PGADMIN URL" "http://localhost:5400"
    printf "${PURPLE}%-20s${END} %b \n" "BACKEND URL" "http://localhost:3000"
    printf "${YELLOW}%-20s${END} %b \n" "WALLET API URL" "http://localhost:8000"
    printf "${YELLOW}%-20s${END} %b \n" "RSA API URL" "http://localhost:9001"
    printf "${YELLOW}%-20s${END} %b \n" "MONGODB EXPRESS URL" "http://localhost:8081"
    printf "${RED}%-20s${END} %b \n" "CONSULTANT API URL" "http://localhost:8001"
else
    printf "${RED}%-20s${END} %b \n" "ERRO" "Crie um arquivo firebase.json VÁLIDO no root deste projeto"
    printf "${CYAN}%-20s${END} %b \n" "REF" "https://firebase.google.com/docs/hosting/full-config"
fi
