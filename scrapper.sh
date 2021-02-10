#!/usr/bin/env bash

#Install html2text
#sudo apt install html2text -y

PAGE="https://www.jobserve.com/gb/en/Job-Search/"

CURRENT_DAY=$(date "+%A")
CURRENT_DATE=$(date "+%_d.%B.%Y")
CURRENT_TIME=$(date "+%H.%M.%S")

# Get the webpage data  <https://data36.com/web-scraping-tutorial-episode-1-scraping-a-webpage-with-bash/>
JOBS=$(curl $PAGE | html2text | sed -n '/Job_Basket/,$p' | sed -n '/Keywords/q;p' | head -n-1 | tail -n+2 | tr -d '******')

STRING=$(echo $JOBS | awk '{ print substr( $0, 8 ) }')

SUM=$(echo $STRING | tr ',' '.' | awk '{ print substr( $0, 1, length($0)-20 ) }')

touch data.csv

HEAD=$(awk 'NR==1{print $1}' data.csv)

if [ "$HEAD" != "UK-JOBS," ]; then
    sed -i '1i UK-JOBS, DAY, DATE, TIME' data.csv
fi

echo "$SUM" , "$CURRENT_DAY" , "$CURRENT_DATE" , "$CURRENT_TIME" >>data.csv
