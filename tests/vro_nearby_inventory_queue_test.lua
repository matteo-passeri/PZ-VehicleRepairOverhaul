-- Run with: lua tests/vro_nearby_inventory_queue_test.lua
-- Focused regression coverage for nearby-item queue ownership and cleanup.
local tickHandlers = {}

Events = {
    OnTick = {
        Add = function(callback) tickHandlers[#tickHandlers + 1] = callback end,
        Remove = function() end,
    },
}

package.preload["TimedActions/ISBaseTimedAction"] = function()
    ISBaseTimedAction = {
        derive = function() return {} end,
        new = function() return {} end,
        perform = function() end,
    }
    return ISBaseTimedAction
end

local transferCalls = 0
ISInventoryTransferAction = {
    new = function(_, playerObj, item, source, destination)
        return { player = playerObj, item = item, source = source, destination = destination }
    end,
}
package.preload["TimedActions/ISInventoryTransferAction"] = function()
    return ISInventoryTransferAction
end

local addedActions = {}
ISTimedActionQueue = {
    add = function(action)
        transferCalls = transferCalls + 1
        if action.failAdd then error("queue failure") end
        addedActions[#addedActions + 1] = action
    end,
}

ISInventoryPaneContextMenu = { transferIfNeeded = function() end }
package.preload["VRO/Core"] = function()
    return { NearbyInventory = nil }
end

local path = "Vehicle Repair Overhaul/42/media/lua/client/VRO_NearbyInventory.lua"
local NearbyInventory = assert(loadfile(path))()

local inventory = {}
local player = { getInventory = function() return inventory end }
local source = {}
local item = { getContainer = function(self) return self.container end, container = source }

assert(NearbyInventory.queueItemToPlayer(player, item))
assert(NearbyInventory._queued[item] == player, "queue entry must own the player")
assert(transferCalls == 1)
assert(NearbyInventory.queueItemToPlayer(player, item))
assert(transferCalls == 1, "pending item must not queue a duplicate transfer")

assert(pcall(tickHandlers[1]), "OnTick must accept an in-flight queue entry")
assert(NearbyInventory._queued[item] == player)
item.container = inventory
assert(pcall(tickHandlers[1]))
assert(NearbyInventory._queued[item] == nil, "arrival must clear queue entry")

local legacyItem = { getContainer = function(self) return self.container end, container = source }
NearbyInventory._queued[legacyItem] = true
assert(pcall(tickHandlers[1]), "OnTick must discard a legacy boolean entry")
assert(NearbyInventory._queued[legacyItem] == nil)

local failedItem = { getContainer = function(self) return self.container end, container = source }
ISInventoryTransferAction.new = function(_, playerObj, queuedItem, queuedSource, destination)
    return { player = playerObj, item = queuedItem, source = queuedSource, destination = destination, failAdd = true }
end
assert(not NearbyInventory.queueItemToPlayer(player, failedItem))
assert(NearbyInventory._queued[failedItem] == nil, "failed queue insertion must clear entry")

ISInventoryTransferAction.new = function(_, playerObj, queuedItem, queuedSource, destination)
    return { player = playerObj, item = queuedItem, source = queuedSource, destination = destination }
end
assert(NearbyInventory.queueItemToPlayer(player, failedItem), "a failed item must be retryable")
assert(NearbyInventory._queued[failedItem] == player)

print("vro_nearby_inventory_queue_test: ok")
