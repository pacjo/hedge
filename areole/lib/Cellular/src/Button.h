#pragma once

#include <Arduino.h>
#include <functional>
#include "Component.h"

namespace Cellular {

class Button : public Component {
private:
    uint8_t pin;
    std::function<void()> onPress;

    // state machine
    const unsigned long debounceDelay = 50;
    unsigned long lastDebounceTime = 0;
    bool lastReadState = HIGH;
    bool currentState = HIGH;

public:
    Button(uint8_t pin) : pin(pin), onPress(nullptr) {}

    void init() override {
        pinMode(pin, INPUT_PULLUP);     // TODO: don't hardcode - maybe we could do #define to get pin mode and active state
    }

    void onClick(std::function<void()> callback) {
        onPress = callback;
    }

    void tick() {
        bool reading = digitalRead(pin);

        // something changed - start debounce
        if (reading != lastReadState) {
            lastDebounceTime = millis();
            lastReadState = reading;
        }

        // debounce ok
        if ((millis() - lastDebounceTime) > debounceDelay) {
            // state actually changed - run callback
            if (reading != currentState) {
                currentState = reading;

                // TODO: determined active state or provide as parameter
                if (currentState == LOW && onPress) {
                    onPress();
                }
            }
        }
    }
};

}
