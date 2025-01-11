#!/usr/bin/env sh

sudo mkdir -p ./data
sudo chown -R 1001:1001 ./data
sudo chmod -R a+rwx ./data

sudo docker compose down &&
  sudo docker compose pull &&
  sudo docker compose build --pull &&
  sudo docker compose up -d &&
  sudo docker compose logs -f