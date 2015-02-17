-- app.lua
local http = require "lapis.nginx.http"

local lapis = require("lapis")
local http = require("lapis.nginx.http")
local config = require("lapis.config").get()
local console = require("lapis.console")

local util = require("lapis.util")
local console = require("lapis.console")
local json_params = require("lapis.application").json_params

local sqlite3 = require("lsqlite3")

sensors = {}



local data = {}

local app = lapis.Application()
app:enable("etlua")
app.layout = require "views._layout"


app:get("/console", console.make())


app:get("/", function(self)
  self.temp = 4.3
  self.test = data.test
  return {render = 'index'}
end)

app:get("/collectSensors", function(self)
  -- a simple GET request
  getSensorData(0)
  return "response: " .. body
end)

app:get("/getSensors", json_params(function(self)
    -- Set api layout
    app.layout = require "views._layout_api"
    
    local body = getSensors()
    
    return util.to_json(body)
end))

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


function initDB ()
    -- If tables don't exist - create.
end



return app