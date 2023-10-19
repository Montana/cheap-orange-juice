#!/bin/bash

# Function to scrape Amazon for orange juice prices
scrape_amazon() {
        local amazon_url="https://www.amazon.com/s?k=orange+juice"
        local price_pattern='data-asin="[^"]*" data-locale="[^"]*" data-price="([0-9]+\.[0-9]+)"'

        local page_content=$(curl -s "$amazon_url")
        local cheapest_price=999999

        while [[ $page_content =~ $price_pattern ]]; do
                local price="${BASH_REMATCH[1]}"
                if (($(bc <<<"$price < $cheapest_price"))); then
                        cheapest_price=$price
                fi
                page_content="${page_content#*"${BASH_REMATCH[0]}"}"
        done

        echo "Cheapest orange juice on Amazon: $cheapest_price"
}

# Function to scrape Whole Foods for orange juice prices
scrape_whole_foods() {
        local whole_foods_url="https://www.wholefoodsmarket.com/search?text=orange%20juice"
        local price_pattern='data-product-price="([0-9]+\.[0-9]+)"'

        local page_content=$(curl -s "$whole_foods_url")
        local cheapest_price=999999

        while [[ $page_content =~ $price_pattern ]]; do
                local price="${BASH_REMATCH[1]}"
                if (($(bc <<<"$price < $cheapest_price"))); then
                        cheapest_price=$price
                fi
                page_content="${page_content#*"${BASH_REMATCH[0]}"}"
        done

        echo "Cheapest orange juice at Whole Foods: $cheapest_price"
}

# Call the scraping functions for Amazon and Whole Foods
scrape_amazon
scrape_whole_foods
