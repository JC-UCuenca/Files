#!/bin/bash

# Actualiza la lista de paquetes
sudo apt update

# Instala las bibliotecas requeridas
sudo apt install -y \
    libboost-all-dev \
    libboost1.83-dev \
    libglibmm-2.4-dev \
    libpulse-dev \
    libsndfile1-dev \
    libcurl4-gnutls-dev \
    libarchive-dev \
    liblo-dev \
    libtaglib-ocaml-dev \
    vamp-plugin-sdk \
    librubberband-dev \
    libusb-1.0-0-dev \
    libjack-dev \
    libudev-dev \
    libaubio-dev \
    libxinerama-dev \
    libcogl-pango-dev \
    libcairomm-1.0-dev \
    libpangomm-1.4-dev \
    lv2-dev \
    libcppunit-dev \
    libcwiid-dev \
    libwebsockets-dev \
    libsamplerate-ocaml-dev \
    liblrdf0-dev \
    libserd-dev \
    libsord-dev \
    libsratom-dev

echo "Instalación completada."
