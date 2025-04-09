local update = require "update"

function moveForward(...) return turtle.forward(...) end
function moveBackward(...) return turtle.back(...) end
function moveUp(...) return turtle.up(...) end
function moveDown(...) return turtle.down(...) end
function turnLeft(...) return turtle.turnLeft(...) end
function turnRight(...) return turtle.turnRight(...) end

function interactDown(...) return turtle.attackDown(...) end
function interact(...) return turtle.attack(...) end

function select(...) return turtle.select(...) end

--Variables

local modem = peripheral.find("modem")

local length = 0

local fuels = {}

local crops = {}

local age = {}


modem.open(400)


function start()
    if update.check() then
        print("Installing Update, please wait...")
        update.update()
    end
    if (turtle.getFuelLevel() <= 100) then
        refuel() 
    end
    while true do
        local event, side, channel, reply, data, distance = os.pullEvent("modem_message")

        if channel == 400 then
            fuels = data.fuels
            crops = data.crops
            age = data.age
            moveToEnd()
        end
    end 
end

function moveToEnd()
    local end_reached = false
    repeat
        local block_name = checkFront()
        if block_name == false then --no block there, move forward
            checkDown()
            moveForward()
            length = length + 1
        elseif block_name == "minecraft:oak_fence" then --oak fence there, reached end
            turnLeft()
            turnLeft()
            return_home()
            end_reached = true
        else
            print("Unknown block infront: " .. block_name)
            end_reached = true
        end
    until end_reached
end

function checkFront()
    local present, block_data = turtle.inspect()
    if present then
        return block_data.name
    else
        return false
    end
end

function checkDown()
    local present, block_data = turtle.inspectDown()
    if present then
        local name = block_data.name
        local fully_grown = block_data.state.age == age[block_data.name]
        if fully_grown then --is this fully grown?
            if crops[name] then --Is this one of the supported crops?
                turtle.digDown()
                local seed_name = crops[name]
                local seed_index = findItem(seed_name)
                if seed_index > 0 then --find seeds in inventory
                    turtle.select(seed_index)
                    turtle.placeDown()
                end
            end
        end
    else
        return false
    end
end

function findItem(item_name)
    local index = 1
    repeat
        local item = turtle.getItemDetail(index)
        if item then
            local name = item.name
            if name == item_name then
                return index
            end
        end
        index = index + 1
    until index >= 15

    return -1
end

function empty_inventory()
    local index = 1
    repeat
        turtle.select(index)
        turtle.drop()
        index = index + 1
    until index > 16

    turtle.select(1)
end

function return_home()
    repeat
        checkDown()
        moveForward()
        length = length - 1
    until length == 0

    print("Reached End")

    empty_inventory()

    turtle.turnLeft()
    turtle.turnLeft()
    sleep(3)
    start()
end

function refuel()
    turtle.select(16)
    if turtle.getItemCount(16) < 5 then
        turtle.turnLeft()
        turtle.turnLeft()
        turtle.suck(5)
        turtle.turnLeft()
        turtle.turnLeft()
    end
    local item_name = turtle.getItemDetail(16).name

    if fuels[item_name] then
        
    else
        print("Item not in fuels list: " .. item_name)
    end
    turtle.refuel(5)
end

start()