##mobile_detect##

A simple little Lua library to perform mobile browser detection.

Detection rules were stolen from https://github.com/serbanghita/Mobile-Detect.

### Installation ###

```
luarocks install mobile_detect
```

### Dependencies ###

- Lua >= 5.1 | Luajit >= 2.0.0
- lua-cjson
- Lrexlib-PCRE

### Usage ###

All APIs take a table of HTTP headers as an input parameter.

```lua
md = require("mobile_detect")

http_headers = {}
http_headers['HTTP_USER_AGENT'] = "Mozilla/5.0 (iPod; U; CPU iPhone OS 4_3_3 like Mac OS X; ja-jp) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5"
assert(md.is_mobile(http_headers))
```

The following APIs are provided:
- `is_mobile`
- `is_mobile_browser`
- `is_mobile_os`
- `is_phone`
- `is_tablet`

### Development ###

Tests can be run using [busted](http://olivinelabs.com/busted):

```
sudo luarocks install busted
busted test/mobile_detect_test.lua
```