# Polybar WeatherBit module

## Setup

What you need:
* `jq`: for json manipulation (`apt install jq`)
* Weather Icons: to display fancy weather icons.
* WeatherBit API Key ([Learn more here](https://www.weatherbit.io/pricing))


## Configuration

On `config.json`, replace `key` by your WeatherBit API Key and your city ID inside `CITY_ID`:
```bash
{
  "API_KEY": "key",
  "CITY_ID": 1234567
}
```

Inside your Polybar configuration file:

```bash
[bar/your-bar]
modules = ... weatherbit ...

[module/weatherbit]
type = custom/script
exec = ~/path_to_the_folder/weather-bit/weatherbit.sh
interval = 600
# label-font = 3
```

## FAQ

### 1. How to can I get a WeatherBit API key

Go to the page https://www.weatherbit.io/pricing, select your plan (Free is fine), click on Sign Up and create your account. You'll see a page with your API key code (it may take some time to be active).

### 2. How to find my City ID:

You can checkout the WeatherBit API meta page (https://www.weatherbit.io/api/meta) and search inside the Cities CSV
