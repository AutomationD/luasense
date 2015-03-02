# Luasense is a framework for your ESP8266 sensors
#### This is a work-in-progress code. Feel free to fork & PR
- [Luasense Head](https://github.com/kireevco/luasense) device - could be anything that can run nginx, Lua & [lapis](https://github.com/leafo/lapis) (For instance raspberry pi)
- [Luasense Sensor](https://github.com/kireevco/luasense-sensor) devices - ESP8266 nodes running [nodemcu](https://github.com/nodemcu/nodemcu-firmware) & sensor code


This repo contains code that runs on a head unit. You will need nginx with ngx_lua or openresty to run lapis.

## OpenResty for raspbian
There is a [repo](https://bintray.com/kireevco/deb/openresty/view) with openresty builds for arm. It should work on a raspberry pi.
In order to add it to your raspbian execute the following:
```bash
echo "deb http://dl.bintray.com/kireevco/deb /" | sudo tee -a /etc/apt/sources.list
echo "deb-src http://dl.bintray.com/kireevco/deb /" | sudo tee -a /etc/apt/sources.list
```