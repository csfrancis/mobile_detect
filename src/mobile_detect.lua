local M = {}

local _config_dir = nil
local _detect = nil

local rex = require("rex_pcre")
local cjson = require("cjson")

local function get_config_dir()
  if _config_dir ~= nil then
    return _config_dir
  end

  local path = require("luarocks.path")
  local search = require("luarocks.search")
  local fetch = require("luarocks.fetch")
  local cfg = require("luarocks.cfg")

  local tree_map = {}
  local results = {}
  local query = search.make_query(M.module_name, nil)
  local trees = cfg.rocks_trees

  for _, tree in ipairs(trees) do
    local rocks_dir = path.rocks_dir(tree)
    tree_map[rocks_dir] = tree
    search.manifest_search(results, rocks_dir, query)
  end

  assert(results.mobile_detect)

  local version = nil
  for k, _ in pairs(results.mobile_detect) do version = k end

  local repo = tree_map[results.mobile_detect[version][1].repo]
  return path.conf_dir(M.module_name, version, repo)
end

local function _initialize()
  if _detect ~= nil then return end

  local json_file = get_config_dir()..package.config:sub(1,1).."mobile_detect.json"
  local f = assert(io.open(json_file, "r"))
  local t = f:read("*all")
  f:close()

  _detect = cjson.decode(t)
end

local function check_headers_for_match(http_headers)
  if http_headers == nil then return false end
  for k,v in pairs(_detect.headerMatch) do
    if http_headers[k] ~= nil then
      if v ~= cjson.null and v.matches ~= cjson.null then
        for _,match in ipairs(v.matches) do
          if rex.find(http_headers[k], match) ~= nil then return true end
        end
      else
        return true
      end
    end
  end
  return false
end

local function get_user_agent(http_headers)
  if http_headers == nil then return nil end
  for _,v in ipairs(_detect.uaHttpHeaders) do
    if http_headers[v] ~= nil then return http_headers[v] end
  end
  return nil
end

local function check_user_agent_for_match(user_agent, matches)
  for _,v in pairs(matches) do
    if rex.find(user_agent, v) ~= nil then return true end
  end
  return false
end

local function check_headers_for_user_agent_match(http_headers, matches)
  user_agent = get_user_agent(http_headers)
  if user_agent == nil then return false end
  return check_user_agent_for_match(user_agent, matches)
end

M.module_name = "mobile_detect"

function M.is_mobile(http_headers)
  if check_headers_for_match(http_headers) then return true end

  user_agent = get_user_agent(http_headers)
  if user_agent == nil then return false end
  return check_user_agent_for_match(user_agent, _detect.uaMatch.phones)
    or check_user_agent_for_match(user_agent, _detect.uaMatch.tablets)
    or check_user_agent_for_match(user_agent, _detect.uaMatch.browsers)
    or check_user_agent_for_match(user_agent, _detect.uaMatch.os)
end

function M.is_mobile_browser(http_headers)
  return check_headers_for_user_agent_match(http_headers, _detect.uaMatch.browsers)
end

function M.is_mobile_os(http_headers)
  return check_headers_for_user_agent_match(http_headers, _detect.uaMatch.os)
end

function M.is_phone(http_headers)
  return check_headers_for_user_agent_match(http_headers, _detect.uaMatch.phones)
end

function M.is_tablet(http_headers)
  return check_headers_for_user_agent_match(http_headers, _detect.uaMatch.tablets)
end

function M._config_dir()
  return get_config_dir()
end

_initialize()

return M
