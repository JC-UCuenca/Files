#!/bin/bash
awk '{nombres[$1]++} END {for( i in nombres) print i ":" nombres[i]}' nombres.txt
