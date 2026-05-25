#include <Arduino.h>
#include <Cellular.h>

// TODO: use xylem logger

Cellular::Switch mainsPower(14);
Cellular::Button frontButton(3);

void setup() {
    Serial.begin(9600);

    // logic
    frontButton.onClick([]() {
        mainsPower.toggle();
    });

    // component init
    mainsPower.init();
    frontButton.init();
}

void loop() {
    frontButton.tick();

    delay(10); // yield to background tasks
}
