---@diagnostic disable: undefined-field, param-type-mismatch
require "ISUI/ISInventoryPaneContextMenu"
require "TimedActions/VRO_DoSalvageAction"
local VRO = require "VRO/Core"
require "VRO/SalvageCatalog"
local BlowTorch = require "VRO/BlowTorch"
local NearbyInventory = require "VRO_NearbyInventory"

local function unwrap(items)
  if not items then return nil end
  local first = items[1]
  return first and (first.items and first.items[1] or first) or nil
end

local function findItem(inv, predicate)
  if not (inv and inv.getItems) then return nil end
  local items = inv:getItems()
  for i = 0, items:size() - 1 do
    local item = items:get(i)
    if predicate(item) then return item end
  end
  return nil
end

local function findTorch(inv, needed)
  return findItem(inv, function(item)
    return BlowTorch.isItem(item) and BlowTorch.uses(item) >= needed
  end)
end

local function perk(player, name)
  local p = Perks[name] or (Perks.FromString and Perks.FromString(name))
  return p and player:getPerkLevel(p) or 0
end

local function equipTorch(player, torch)
  if player:getPrimaryHandItem() ~= torch then
    ISTimedActionQueue.add(ISEquipWeaponAction:new(player, torch, 50, true, false))
  end
end

local function startSalvage(player, item, spec, torch, mask)
  local bundles = { { { item=item, takeUses=1 } } }
  if torch then bundles[#bundles + 1] = { { item=torch, takeUses=0 } } end
  if mask then bundles[#bundles + 1] = { { item=mask, takeUses=0 } } end
  NearbyInventory.stageBundlesThen(player, bundles, function()
    if torch then equipTorch(player, torch) end
    ISTimedActionQueue.add(VRO_DoSalvageAction:new(player, item, torch, spec))
  end)
end

local function addSalvageOption(player, context, item, spec)
  local inv = NearbyInventory.getEffectiveInventory(player)
  local levelOK = perk(player, spec.skill) >= spec.level
  local torch = spec.torch and findTorch(inv, spec.torch) or nil
  local mask = spec.torch and findItem(inv, function(candidate)
    return candidate and candidate.getFullType and candidate:getFullType() == "Base.WeldingMask"
  end) or nil
  local maskOK = not spec.torch or mask ~= nil
  local available = levelOK and (not spec.torch or (torch and maskOK))
  local option = context:addOption(getText(spec.name), player, startSalvage, item, spec, torch, mask)
  option.notAvailable = not available
  local tip = ISToolTip:new(); tip:initialise(); tip:setVisible(false); option.toolTip = tip
  tip:setName(getText(spec.name))
  tip.description = string.format("<RGB:%s>%s %d/%d <LINE>", levelOK and "1,1,1" or "1,0,0", getText("IGUI_perks_" .. spec.skill), perk(player, spec.skill), spec.level)
  if spec.torch then
    tip.description = tip.description .. string.format("<RGB:%s>%s %d/%d <LINE>", torch and "1,1,1" or "1,0,0", getItemNameFromFullType("Base.BlowTorch"), torch and BlowTorch.uses(torch) or 0, spec.torch)
    tip.description = tip.description .. string.format("<RGB:%s>%s %d/1", maskOK and "1,1,1" or "1,0,0", getItemNameFromFullType("Base.WeldingMask"), maskOK and 1 or 0)
  end
end

local function onFillInventoryObjectContextMenu(playerNum, context, items)
  if not VRO.IsVehicleSalvageEnabled() then return end
  local player, item = getSpecificPlayer(playerNum), unwrap(items)
  local fullType = item and item.getFullType and item:getFullType()
  local spec = fullType and VRO.GetSalvageSpec(fullType)
  if player and spec then addSalvageOption(player, context, item, spec) end
end

VRO.handlers = VRO.handlers or {}
if VRO.handlers.salvageMenu and Events.OnFillInventoryObjectContextMenu.Remove then Events.OnFillInventoryObjectContextMenu.Remove(VRO.handlers.salvageMenu) end
VRO.handlers.salvageMenu = onFillInventoryObjectContextMenu
Events.OnFillInventoryObjectContextMenu.Add(onFillInventoryObjectContextMenu)
