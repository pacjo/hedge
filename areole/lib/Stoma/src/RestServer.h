#pragma once

#include <Arduino.h>
#include <functional>

#if defined(ESP8266)
    #include <ESP8266WebServer.h>
    typedef ESP8266WebServer WebServerType;
#else
    #include <WebServer.h>
    typedef WebServer WebServerType;
#endif

namespace Stoma {

class RestServer {
private:
    WebServerType server;
public:
    RestServer(int port = 80) : server(port) {}

    void init() {
        server.begin();
    }

    void tick() {
        server.handleClient();
    }

    void onGet(const String& path, std::function<String()> callback) {
        server.on(path, HTTP_GET, [this, callback]() {
            server.send(200, "application/json", callback());
        });
    }

    void onPost(const String& path, std::function<void()> callback) {
        server.on(path, HTTP_POST, [this, callback]() {
            callback();
            server.send(200, "application/json", "{\"status\":\"ok\"}");
        });
    }
};

}
