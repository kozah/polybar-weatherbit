#!/bin/sh

API="http://api.weatherbit.io/v2.0"
KEY=""

CITY_ID=""
UNITS="M"
SYMBOL="º"
FORECAST_DAYS="3"

get_icon() {
    case $1 in
        # # Icons for weather-icons
        # t---=thunderstorm d---=drizzle r---=rain s---=snow f---=freezing
        # a---=another c---=clear/cloud u---=unknown precipitation
        # ---d=day ---n=night

        # Thunderstorm with light rain
        t01d) icon="";;
        t01n) icon="";;
        # Thunderstorm with rain
        t02d) icon="";;
        t02n) icon="";;
        #Thunderstorm with heavy rain
        t03d) icon="";;
        t03n) icon="";;
        #Thunderstorm with light drizzle / Thunderstorm with drizzle / Thunderstorm with heavy drizzle
        t04*) icon="";;
        #Thunderstorm with Hail
        t05*) icon="";;
        #Light Drizzle
        d01*) icon="";;
        #Drizzle
        d02*) icon="";;
        #Heavy Drizzle
        d03*) icon="";;
        #Light Rain
        r01d) icon="";;
        r01n) icon="";;
        #Moderate Rain
        r02d) icon="";;
        r02n) icon="";;
        #Heavy Rain
        r03d) icon="";;
        r03n) icon="";;
        #Light shower rain
        r04d) icon="";;
        r04n) icon="";;
        #Shower rain
        r05d) icon="";;
        r05n) icon="";;
        #Heavy shower rain
        r06d) icon="";;
        r06n) icon="";;
        #Freezing rain
        f01*) icon="";;
        #Snow
        s0*d) icon="";;
        s0*n) icon="";;
        #Fog/Haze
        a0*d) icon="";;
        a0*n) icon="";;
        #Clear sky
        c01d) icon="";;
        c01n) icon="";;
        #Few clouds/Scattered clouds
        c02d) icon="";;
        c02n) icon="";;
        #Broken clouds
        c03d) icon="";;
        c03n) icon="";;
        #Overcast clouds
        c04*) icon="";;
        u***) icon="";;
        *) icon="";;
    esac

    echo $icon
}

current=$(curl -sf "$API/current?city_id=$CITY_ID&units=$UNITS&key=$KEY")
forecast=$(curl -sf "$API/forecast/daily?city_id=$CITY_ID&days=$((FORECAST_DAYS+1))&units=$UNITS&key=$KEY")

if [ -n "$current" ] && [ -n "$forecast" ]; then

    c_wind_speed=$(echo "$current" | jq -r ".data[].wind_spd" | cut -d "." -f 1)
    c_temp=$(echo "$current" | jq -r ".data[].temp" | cut -d "." -f 1)
    c_weather_icon=$(echo "$current" | jq -r ".data[].weather.icon")
    c_avg_humidity=$(echo "$current" | jq -r ".data[].rh" | cut -d "." -f 1)
    # if you want day-time high temp (7AM to 7PM), use .data[0].high_temp
    c_max_temp=$(echo "$forecast" | jq -r ".data[0].max_temp" | cut -d "." -f 1)
    # if you want night-time low temp (7PM to 7AM) use .data[0].low_temp
    c_min_temp=$(echo "$forecast" | jq -r ".data[0].min_temp" | cut -d "." -f 1)
    c_prob_precip=$(echo "$forecast" | jq -r ".data[0].pop")
    c_precip=$(echo "$forecast" | jq -r ".data[0].precip")

    if [ "$c_prob_precip" -gt "0" ]; then
        rain=$(echo "[ ${c_precip}mm]")
    else
        rain=""
    fi

    min_max=$(echo "[ $c_min_temp$SYMBOL  $c_max_temp$SYMBOL]")
    humidity=$(echo " ${c_avg_humidity}%")
    wind=$(echo " ${c_wind_speed}m/s")

    line="$(get_icon $c_weather_icon) $c_temp$SYMBOL $min_max $rain $humidity $wind      "

    for i in $(seq $FORECAST_DAYS)
    do
        # if you want day-time high temp (7AM to 7PM), use .data[$i].high_temp
        f_max_temp=$(echo "$forecast" | jq -r ".data[$i].max_temp" | cut -d "." -f 1)
        # if you want night-time low temp (7PM to 7AM) use .data[$i].low_temp
        f_min_temp=$(echo "$forecast" | jq -r ".data[$i].min_temp" | cut -d "." -f 1)
        f_weather_icon=$(echo "$forecast" | jq -r ".data[$i].weather.icon")
        line="$line $(get_icon $f_weather_icon) $f_min_temp$SYMBOL/$f_max_temp$SYMBOL"
    done

    echo "$line"
else
    echo "An error occured"
fi
