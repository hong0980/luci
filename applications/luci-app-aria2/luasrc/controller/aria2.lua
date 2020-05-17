local n=require"nixio.fs"
local a=require"luci.sys"
local e=require"luci.http"
local i=require"luci.util"
local o=require"luci.model.uci".cursor()
module("luci.controller.aria2",package.seeall)
function index()
if not nixio.fs.access("/etc/config/aria2")then
return
end
entry({"admin","nas","aria2"},
firstchild(),_("Aria2")).dependent=false
entry({"admin","nas","aria2","config"},
cbi("aria2/config"),_("Configuration"),1)
entry({"admin","nas","aria2","file"},
form("aria2/files"),_("Files"),2)
entry({"admin","nas","aria2","log"},
firstchild(),_("Log"),3)
entry({"admin","nas","aria2","log","view"},
template("aria2/log_template"))
entry({"admin","nas","aria2","log","read"},
call("action_log_read"))
entry({"admin","nas","aria2","status"},
call("action_status"))
end
function action_status()
local t={
running=(a.call("pidof aria2c >/dev/null")==0)
}
e.prepare_content("application/json")
e.write_json(t)
end

function action_log_read()
local t={log="",syslog=""}
local o=o:get("aria2","main","log")or"/var/log/aria2.log"
if n.access(o)then
t.log=i.trim(a.exec("tail -n 50 %s | sed 'x;1!H;$!d;x'"%o))
end
t.syslog=i.trim(a.exec("logread | grep aria2 | tail -n 50 | cut -d' ' -f3- | sed 's/daemon.info /日志信息/g'"))
e.prepare_content("application/json")
e.write_json(t)
end
