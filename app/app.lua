-- app.lua
local http = require "lapis.nginx.http"

local lapis = require("lapis")
local http = require("lapis.nginx.http")
local config = require("lapis.config").get()

local util = require("lapis.util")
local console = require("lapis.console")
local json_params = require("lapis.application").json_params

local socketurl = require("socket.url")
local sqlite3 = require("lsqlite3")
local inspect = require('inspect')



sensors = {}



local data = {}

local app = lapis.Application()
app:enable("etlua")
app.layout = require "views._layout"


--app:get("/console", console.make())

--setCache("test","abc")


app:get("index", "/", function(self)
    self.title = "Dashboard"
    self.temp = 4.3
    self.test = data.test
    return {render = true}
end)


app:get('sensors','/sensors', function(self)
    self.title = "Sensors"
    --    self.temp = 4.3
    --    self.test = data.test
    self.sensors = getSensors()

    return {render = true}
--    return self.route_name
--    return self:url_for('index')
--    return inspect(self)

end)

app:get("/api/collectSensors", function(self)
  -- a simple GET request
  getSensorData(0)
  return "response: " .. body
end)

app:get("/api/getSensors", json_params(function(self)
    -- Set api layout
    app.layout = require "views._layout_api"

    local body = getSensors()

    return util.to_json(body)
end))


-----------------------------
-----------------------------

function getSensors()
    -- Getting a list of sensors that we have
    db = sqlite3.open(config.sqlitedb)

    for row in db:nrows('SELECT * FROM sensors') do
        sensors[row.id] = row
    end

    db:close()
    return sensors
end

function getSensorData (sensorID)
    print(sensors)

    if sensors[1].type == 0 then
        local body, status_code, headers = http.simple(sensors[sensorID].ip)
    end
end


function setCache(key, value)

    memc:set_timeout(1000) -- 1 sec

    local ok, err = memc:connect("192.168.174.135", "11211")
    if not ok then
        ngx.say("failed to connect: ", err)
        return
    end
    
    local ok, err = memc:set(key, value)
    if not ok then
        ngx.say("failed to set "..key..": ", err)
        return
    end

    return true
end

function getCache(key)
    memc:set_timeout(1000) -- 1 sec

    local ok, err = memc:connect("192.168.174.135", "11211")
    if not ok then
        ngx.say("failed to connect: ", err)
        return
    end
    
    local res, flags, err = memc:get(key)
    if err then
        ngx.say("failed to get "..key..": ", err)
        return
    end

    if not res then
        ngx.say( key.."not found")
        return
    end

    return res
end



function initDB ()
    -- If tables don't exist - create.
end


function table.val_to_str ( v )
    if "string" == type( v ) then
        v = string.gsub( v, "\n", "\\n" )
        if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
            return "'" .. v .. "'"
        end
        return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
    else
        return "table" == type( v ) and table.tostring( v ) or
                tostring( v )
    end
end

function table.key_to_str ( k )
    if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
        return k
    else
        return "[" .. table.val_to_str( k ) .. "]"
    end
end

function table.tostring( tbl )
    local result, done = {}, {}
    for k, v in ipairs( tbl ) do
        table.insert( result, table.val_to_str( v ) )
        done[ k ] = true
    end
    for k, v in pairs( tbl ) do
        if not done[ k ] then
            table.insert( result,
                table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
        end
    end
    return "{" .. table.concat( result, "," ) .. "}"
end


return app