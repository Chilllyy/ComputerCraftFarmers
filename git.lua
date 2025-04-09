function getWebTable(url)
    local response = http.get(url)
    local data = response.readAll()
    return textutils.unserializeJSON(data)
end

function getWebRaw(url)
    local response = http.get(url)
    return response.readAll()
end

function delete(path)
    if fs.exists(path) then
        fs.delete(path)
        return true
    else
        return false
    end
end

function clone(url, folder)
    fs.makeDir(folder)
    local data = getWebTable(url)
    for i,v in ipairs(data) do
        if v.type == "dir" then
            local new_url = v.url
            local new_dir = folder .. "/" .. v.name
            clone(new_url, new_dir)
        elseif v.type == "file" then
            local dl_url = v.download_url
            local raw = getWebRaw(dl_url)
            local file = folder .. "/" .. v.name
            local f = fs.open(file, "w")
            f.write(raw)
            f.close()
        end
    end
end

return {clone = clone, getWebTable = getWebTable, getWebRaw = getWebRaw}