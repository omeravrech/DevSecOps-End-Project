# Public = Client - Frontend
# Server = Server - Backend
# tDB - Mongo DB
 
# Frontend:
Work with port 3000
Command - docker build -t frontend:v1 ./public

# Backend 
Work with port 5000
Command - docker build -t backend:v1 ./server

# DB - The database using mongodb
Work with port 27017
Command - docker pull mongo:latest
