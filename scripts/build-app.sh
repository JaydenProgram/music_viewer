#!/bin/bash
set -euo pipefail

cd application

flutter clean

flutter pub get

flutterpi_tool build --arch=arm64 --release