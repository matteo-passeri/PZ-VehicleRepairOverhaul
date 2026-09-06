---@diagnostic disable: undefined-field, param-type-mismatch
require "TimedActions/ISBaseTimedAction"

VRO_DoSalvageAction = ISBaseTimedAction:derive("VRO_DoSalvageAction")

function VRO_DoSalvageAction:isValid()
  return self.character and self.item and self.item:getContainer() == self.character:getInventory()
    and (not self.spec.torch or (self.torch and self.character:getPrimaryHandItem() == self.torch))
end

function VRO_DoSalvageAction:update()
  self.item:setJobDelta(self:getJobDelta())
  self.item:setJobType(getText(self.spec.name))
  if self.sound ~= 0 and not self.character:getEmitter():isPlaying(self.sound) then self.sound = self.character:playSound("BlowTorch") end
  self.character:setMetabolicTarget(Metabolics.HeavyWork)
end

function VRO_DoSalvageAction:start()
  if self.spec.torch then
    self:setActionAnim("BlowTorch")
    self:setOverrideHandModels(self.torch, nil)
    self.sound = self.character:playSound("BlowTorch")
  else
    self:setActionAnim("RipClothing")
  end
end

function VRO_DoSalvageAction:stop()
  if self.item then self.item:setJobDelta(0) end
  if self.sound ~= 0 then self.character:getEmitter():stopSound(self.sound) end
  ISBaseTimedAction.stop(self)
end

function VRO_DoSalvageAction:perform()
  if self.sound ~= 0 then self.character:getEmitter():stopSound(self.sound) end
  if self.item then self.item:setJobDelta(0) end
  sendClientCommand(self.character, "VRO_vehicle", "salvagePart", { itemId=self.item:getID(), salvageKey=self.spec.key })
  ISBaseTimedAction.perform(self)
end

function VRO_DoSalvageAction:new(character, item, torch, spec)
  local o = ISBaseTimedAction.new(self, character)
  o.character, o.item, o.torch, o.spec = character, item, torch, spec
  o.maxTime = character:isTimedActionInstant() and 1 or spec.time
  o.stopOnWalk, o.stopOnRun = true, true
  o.sound = 0
  return o
end
