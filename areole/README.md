# Areole

IoT/Smart Home firmware for embedded devices.


## Docs

- [Troubleshooting](docs/troubleshooting.md)


## TODO:

- [ ] maybe add something do `StatelessComponent`/`StatefulComponent` in `Cellular` which e.g. would declare private freertos `task()` in stateful
- [ ] add label to Cellular::Component, use that for tasks
- [ ] optimize stack size for freertos tasks
- [ ] maybe rename `Cellular::Switch`, since we can have input switch (toggle) and output switch (relay)
- [ ] check https://github.com/alexCajas/esp8266RTOSArduCore
- [ ] nothing is forcing wifimanager and restserver to have init() declared - maybe enforce it?
- [ ] Pollen service discovery/OTA
