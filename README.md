# SkadarlijaScramble

A game where you run around Skadarlija serving coffee, food, and playing music!

## Raspberry Pi 4

Since this game uses Godot 4, which does not yet have solid unofficial builds for Raspberry Pi,
I am shipping an HTML version of the game with a small Python server to play this on Raspberry Pi.

The Python server is simply:

```
#!/usr/bin/env python3
from http import server # Python 3

class MyHTTPRequestHandler(server.SimpleHTTPRequestHandler):
        def end_headers(self):
                self.send_my_headers()
                server.SimpleHTTPRequestHandler.end_headers(self)

        def send_my_headers(self):
                self.send_header("Access-Control-Allow-Origin", "*")
                self.send_header("Cross-Origin-Embedder-Policy", "require-corp")
                self.send_header("Cross-Origin-Opener-Policy", "same-origin")

if __name__ == '__main__':
        server.test(HandlerClass=MyHTTPRequestHandler)
```

(I do not include this script in this repo, maybe I should?)

I also want to play this with a CRT and an 8BitDo gamepad. To do all of these weird things,
I needed to change the following:
* adjust UI margins since there are issues with the latest Raspberry Pi OS and overscan features
* change some UI graphics to reference the A/B buttons of 8BitDo gamepads
* add inputs for gamepads
* I found gamepads don't work out of the box with Raspberry Pi OS (bookworm) so I had to add keyboard inputs for the 8BitDo Micro's keyboard mode
* add a tiny bit of code to allow the browser to fullscreen the game after the first input is detected

I'll maintain these changes on a branch until I figure out a more elegant way to deal with these things!
