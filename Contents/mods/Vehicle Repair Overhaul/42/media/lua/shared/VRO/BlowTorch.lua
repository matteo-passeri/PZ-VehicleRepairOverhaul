---@diagnostic disable: undefined-field, param-type-mismatch
-- Build 42 stores BlowTorch fuel in InventoryItem.currentUses.  Do not use
-- getDrainableUsesInt as the primary source: Base.BlowTorch is no longer
-- necessarily a DrainableComboItem.
local BlowTorch = {}

local function wholeUses(value)
  value = tonumber(value)
  if not value then return nil end
  return math.max(0, math.floor(value))
end

function BlowTorch.isItem(item)
  if not item then return false end

  local fullType = item.getFullType and item:getFullType() or ""
  if fullType == "Base.BlowTorch" then return true end
  local itemType = item.getType and item:getType() or ""
  if itemType == "BlowTorch" then return true end

  -- Support compatible B42 items which carry the vanilla BlowTorch tag.
  if item.hasTag and ItemTag and ResourceLocation and (ResourceLocation.of or ResourceLocation.new) then
    local location = ResourceLocation.of and ResourceLocation.of("base:BlowTorch")
      or (ResourceLocation.new and ResourceLocation.new("base", "BlowTorch"))
    if location then
      local ok, tag = pcall(function() return ItemTag.get(location) end)
      if ok and tag then
        local matched, matches = pcall(function() return item:hasTag(tag) end)
        if matched and matches then return true end
      end
    end
  end
  return false
end

function BlowTorch.uses(item)
  if not BlowTorch.isItem(item) then return 0 end

  -- B42's canonical BlowTorch fuel counter.
  if item.getCurrentUses then
    local ok, value = pcall(function() return item:getCurrentUses() end)
    local uses = ok and wholeUses(value) or nil
    if uses ~= nil then return uses end
  end

  -- Compatibility fallback for older drainable/custom torches only.
  if item.getDrainableUsesInt then
    local ok, value = pcall(function() return item:getDrainableUsesInt() end)
    local uses = ok and wholeUses(value) or nil
    if uses ~= nil then return uses end
  end
  return 0
end

-- This runs only on the server.  Keep the torch when it reaches zero.
function BlowTorch.consume(item, requiredUses)
  local required = wholeUses(requiredUses) or 0
  if required <= 0 then return true end
  if not (BlowTorch.isItem(item) and item.Use and BlowTorch.uses(item) >= required) then return false end

  for _ = 1, required do
    local before = BlowTorch.uses(item)
    if before <= 0 then return false end
    -- This is the B42 vanilla welding-tool call form.  The final argument
    -- keeps the empty tool instance instead of consuming the item itself.
    local ok = pcall(function() item:Use(false, false, true) end)
    if not ok or BlowTorch.uses(item) ~= before - 1 then return false end
  end
  if item.syncItemFields then item:syncItemFields() end
  return true
end

return BlowTorch
