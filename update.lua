local git = require "git"

local user = "Chilllyy"
local repo = "ComputerCraftFarmers"
local branch = "main"

local version_file = fs.open("/os/ver", 'r')
local version = version_file.readAll()
version_file.close()

local url_template = "https://api.github.com/repos/" .. user .. "/" .. repo .. "/"

function check()
    local url = "https://raw.githubusercontent.con" .. user .. "/" .. repo .. "/" .. branch .. "/ver"
    local cloud = tonumber(git.getWebRaw(url))
    local current = tonumber(version)
    return cloud_version > local_version
end

function update()
    local url = url_template .. "contents?ref=" .. branch
    local folder = "/"
    git.clone(url, folder)
end

return {check = check, update = update}