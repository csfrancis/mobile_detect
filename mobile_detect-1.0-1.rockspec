package = "mobile_detect"
version = "1.0-1"
source = {
  url = "https://github.com/csfrancis/mobile_detect/archive/1.0.tar.gz"
}
description = {
  summary = "Mobile HTTP browser detection library",
  homepage = "https://github.com/csfrancis/mobile_detect",
  license = "MIT/X11",
  maintainer = "Scott Francis <scott.francis@shopify.com>"
}
dependencies = {
  "lua >= 5.1",
  "lua-cjson",
  "lrexlib-pcre"
}
build = {
  type = "builtin",
  install = {
    conf = {
      ["mobile_detect.json"] = "src/mobile_detect.json"
    }
  },
  modules = {
    mobile_detect = "src/mobile_detect.lua"
  }
}
