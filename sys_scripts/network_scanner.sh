#!/bin/bash

nmap -A -p- -T5 --min-rate 5000 192.168.1.0/24
