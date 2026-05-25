#pragma once

#include <Arduino.h>

#if defined(ESP8266)
    #include <ESP8266WiFi.h>
#else
    #include <WiFi.h>
#endif

namespace Stoma {

class WiFiManager {
private:
    const char* ssid;
    const char* password;

public:
    WiFiManager(const char* ssid, const char* password)
        : ssid(ssid), password(password) {}

    // TODO: use Xylem logger
    void init() {
        Serial.print("Connecting to: ");
        Serial.println(ssid);
        WiFi.mode(WIFI_STA);
        WiFi.begin(ssid, password);

        while (WiFi.status() != WL_CONNECTED) {
            delay(100);
            Serial.print(".");
        }
    }
};

}
