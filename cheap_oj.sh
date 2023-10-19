#!/bin/bash

url="https://www.amazon.com/s?k=orange+juice"

url_regex='href="([^"]+)"'
price_regex='data-price="([0-9]+\.[0-9]+)"'

min_price=9999
min_url=""

# Crawl pages 
while [[ $url ]]; do
  # Get page HTML
  html=$(curl -s "$url")

  # Extract product URLs 
  while [[ $html =~ $url_regex ]]; do
    product_url="${BASH_REMATCH[1]}"

    # Get product page HTML
    product_html=$(curl -s "$product_url")

    # Extract price
    if [[ $product_html =~ $price_regex ]]; then
      price="${BASH_REMATCH[1]}"

      # Check if new minimum
      if (( $(echo "$price < $min_price" | bc -l) )); then
        min_price=$price
        min_url=$product_url
      fi
    fi
  done

  # Get next page
  url=$(echo "$html" | grep -o 'url":"[^"]*page=[0-9]*' | head -n 1 | cut -d'"' -f4)
done

echo "Cheapest orange juice: $min_price"
echo "URL: $min_url"
