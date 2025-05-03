{ pkgs, ... }:
{

  # Place the script directly in the home directory
  home.file.".config/waybar/btc-price.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      # Fetch real-time BTC price from Binance API
      fetch_price() {
        price=$(curl -s "https://api.binance.com/api/v3/ticker/price?symbol=BTCUSDC" | jq -r '.price' | awk '{printf "%.0f", $1}')
        # Ensure output for Waybar, even on error
        if [ -z "$price" ]; then
          echo "Error"
        else
          echo "₿$price"
        fi
      }

      # Initial price fetch
      fetch_price
    '';
  };

  # Ensure dependencies are installed
  home.packages = with pkgs; [
    curl
    jq
    gawk
  ];
}
