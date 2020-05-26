-- Copyright 2017-2019 Xingwang Liao <kuoruan@gmail.com>
-- Licensed to the public under the MIT License.

local m, s, o

local fs   = require "nixio.fs"
local util = require "luci.util"
local uci  = require "luci.model.uci".cursor()

if uci:get("aria2", "main", "Aria2_Pro") then
 config_dir=uci:get("aria2", "main", "Aria2_Pro")or""
else
 config_dir=uci:get("aria2", "main", "config_dir")or""
end
local config_file = "%s/aria2.conf.main" % config_dir
local session_file = "%s/aria2.session" % config_dir
local a = "/etc/config/aria2" % config_dir

m = SimpleForm("aria2", "%s - %s" % { translate("Aria2"), translate("Files") },
	translate("Here shows the files used by aria2."))
m.reset = false
m.submit = false

s = m:section(SimpleSection, nil, translatef("config文件的内容: <code>%s</code>", a))

o = s:option(TextValue, "_session")
o.rows = 20
o.readonly = true
o.cfgvalue = function()
	local v = fs.readfile(a) or translate("File does not exist.")
	return util.trim(v) ~= "" and v or translate("Empty file.")
end

s = m:section(SimpleSection, nil, translatef("Content of config file: <code>%s</code>", config_file))

o = s:option(TextValue, "_config")
o.rows = 20
o.readonly = true
o.cfgvalue = function()
	local v = fs.readfile(config_file) or translate("File does not exist.")
	return util.trim(v) ~= "" and v or translate("Empty file.")
end

s = m:section(SimpleSection, nil, translatef("Content of session file: <code>%s</code>", session_file))

o = s:option(TextValue, "_session")
o.rows = 20
o.readonly = true
o.cfgvalue = function()
	local v = fs.readfile(session_file) or translate("File does not exist.")
	return util.trim(v) ~= "" and v or translate("Empty file.")
end

return m
