require("luarocks.loader")

describe("mobile_detect tests", function()
  local md

  setup(function()
    md = require("mobile_detect")
  end)

  before_each(function()
    http_headers = {}
  end)

  it("should return false for empty headers", function()
    assert.is_false(md.is_mobile(nil))
  end)

  it("should have a non-empty config dir", function()
    local config_dir = md._config_dir()
    assert.is.truthy(config_dir)
  end)

  it("should have a json configuration file", function()
    local f = io.open(md._config_dir() .. "/mobile_detect.json", "r")
    assert(f)
    if f ~= nil then io.close(f) end
  end)

  it("should return true for HTTP_WAP_CONNECTION", function()
    http_headers['HTTP_WAP_CONNECTION'] = ""
    assert(md.is_mobile(http_headers))
  end)

  it("should return true if accept wml", function()
    http_headers['HTTP_ACCEPT'] = "text/vnd.wap.wml"
    assert(md.is_mobile(http_headers))
  end)

  it("should return false if accept html", function()
    http_headers['HTTP_ACCEPT'] = "text/html"
    assert.is_false(md.is_mobile(http_headers))
  end)

  it("should return true for iPhone Safari", function()
    http_headers['HTTP_USER_AGENT'] = "Mozilla/5.0 (iPod; U; CPU iPhone OS 4_3_3 like Mac OS X; ja-jp) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5"
    assert(md.is_mobile(http_headers))
  end)

  it("should return true for Android user agents", function()
    http_headers['HTTP_USER_AGENT'] = "Mozilla/5.0 (Linux; U; Android 2.2; en-us; Nexus One Build/FRF91) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1"
    assert(md.is_mobile(http_headers))
    http_headers['HTTP_USER_AGENT'] = "Mozilla/5.0 (Linux; U; Android 2.1; en-us; Nexus One Build/ERD62) AppleWebKit/530.17 (KHTML, like Gecko) Version/4.0 Mobile Safari/530.17"
    assert(md.is_mobile(http_headers))
    http_headers['HTTP_USER_AGENT'] = "Mozilla/5.0 (Linux; U; Android 1.6; en-gb; Dell Streak Build/Donut AppleWebKit/528.5+ (KHTML, like Gecko) Version/3.1.2 Mobile Safari/ 525.20.1"
    assert(md.is_mobile(http_headers))
    http_headers['HTTP_USER_AGENT'] = "Mozilla/5.0 (Linux; U; Android 2.1-update1; de-de; HTC Desire 1.19.161.5 Build/ERE27) AppleWebKit/530.17 (KHTML, like Gecko) Version/4.0 Mobile Safari/530.17"
    assert(md.is_mobile(http_headers))
    http_headers['HTTP_USER_AGENT'] = "Mozilla/5.0 (Linux; U; Android 2.1-update1; en-us; ADR6300 Build/ERE27) AppleWebKit/530.17 (KHTML, like Gecko) Version/4.0 Mobile Safari/530.17"
    assert(md.is_mobile(http_headers))
    http_headers['HTTP_USER_AGENT'] = "Mozilla/5.0 (Linux; U; Android 1.6; en-us; WOWMobile myTouch 3G Build/unknown) AppleWebKit/528.5+ (KHTML, like Gecko) Version/3.1.2 Mobile Safari/525.20.1"
    assert(md.is_mobile(http_headers))
    http_headers['HTTP_USER_AGENT'] = "Mozilla/5.0 (Linux; U; Android 2.2; nl-nl; Desire_A8181 Build/FRF91) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1"
    assert(md.is_mobile(http_headers))
    http_headers['HTTP_USER_AGENT'] = "HTC_Dream Mozilla/5.0 (Linux; U; Android 1.5; en-ca; Build/CUPCAKE) AppleWebKit/528.5+ (KHTML, like Gecko) Version/3.1.2 Mobile Safari/525.20.1"
    assert(md.is_mobile(http_headers))
    http_headers['HTTP_USER_AGENT'] = "Mozilla/5.0 (Linux; U; Android 2.2; en-us; DROID2 GLOBAL Build/S273) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1"
    assert(md.is_mobile(http_headers))
    http_headers['HTTP_USER_AGENT'] = "Mozilla/5.0 (Linux; U; Android 3.0; en-us; Xoom Build/HRI39) AppleWebKit/534.13 (KHTML, like Gecko) Version/4.0 Safari/534.13"
    assert(md.is_mobile(http_headers))
    http_headers['HTTP_USER_AGENT'] = "Mozilla/5.0 (Linux; U; Android 2.2; en-us; Droid Build/FRG22D) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1"
    assert(md.is_mobile(http_headers))
    http_headers['HTTP_USER_AGENT'] = "Mozilla/5.0 (Linux; U; Android 2.1-update1; de-de; E10i Build/2.0.2.A.0.24) AppleWebKit/530.17 (KHTML, like Gecko) Version/4.0 Mobile Safari/530.17"
    assert(md.is_mobile(http_headers))
  end)

  it("should return false for desktop Chrome", function()
    http_headers['HTTP_USER_AGENT'] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1700.41 Safari/537.36"
    assert.is_false(md.is_mobile(http_headers))
  end)

  it("should return false for desktop Firefox", function()
    http_headers['HTTP_USER_AGENT'] = "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:25.0) Gecko/20100101 Firefox/25.0"
    assert.is_false(md.is_mobile(http_headers))
  end)
end)
