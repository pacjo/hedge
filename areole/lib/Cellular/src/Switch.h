#pragma once

#include <Arduino.h>
#include "Component.h"

namespace Cellular {

class Switch : public Component {
private:
    uint8_t pin;
    bool state;

public:
    Switch(uint8_t pin, bool initialState = false) :
        pin(pin), state(initialState) {}

    void init() override {
        pinMode(pin, OUTPUT);
        setState(state);
    }

    void turnOn() { setState(true); }
    void turnOff() { setState(false); }
    void toggle() { setState(!state); }
    bool isOn() const { return state; }

private:
    void setState(bool state) {
        digitalWrite(pin, state ? HIGH : LOW);
        this->state = state;
    }
};

}
