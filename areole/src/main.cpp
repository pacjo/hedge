#include <Arduino.h>
#include <Cellular.h>
#include <Stoma.h>

// TODO: use xylem logger

Stoma::WiFiManager wifiManager("phloem", "password");
Stoma::RestServer restServer(80);

Cellular::Switch mainsPower(14);
Cellular::Button frontButton(3);

void setup() {
    Serial.begin(9600);

    // logic
    frontButton.onClick([]() {
        mainsPower.toggle();
    });

    // cellular init
    mainsPower.init();
    frontButton.init();

    // stoma init
    wifiManager.init();
    restServer.init();

    // api setup
    restServer.onPost("/toggle", []() {
        mainsPower.toggle();
    });
    restServer.onGet("/status", []() -> String {
        return mainsPower.isOn() ? "on" : "off";
    });
}

void loop() {
    // cellular ticks
    frontButton.tick();

    // stoma ticks
    restServer.tick();

    delay(10); // yield to background tasks
}
