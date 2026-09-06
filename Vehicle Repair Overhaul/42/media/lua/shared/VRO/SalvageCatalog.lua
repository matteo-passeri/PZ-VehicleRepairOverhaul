-- B42 salvage definitions.  The item lists are deliberately explicit: they are
-- the maintained VRO compatibility lists, not name-based vehicle heuristics.
local VRO = require "VRO/Core"
require "VRO/PartLists"

VRO.SalvageCatalog = {
  { key="doors", name="IGUI_VRO_SalvageDoors", lists={"Door_All"}, returns="large", skill="MetalWelding", level=3, torch=4, time=1000, xp=20 },
  { key="doors_large", name="IGUI_VRO_SalvageDoorsLarge", lists={"DoorMilitary_All"}, returns="armour", skill="MetalWelding", level=5, torch=5, time=1200, xp=20 },
  { key="trunk_doors", name="IGUI_VRO_SalvageTrunkDoors", lists={"TrunkDoor_All"}, returns="large", skill="MetalWelding", level=4, torch=4, time=1000, xp=20 },
  { key="trunk_doors_large", name="IGUI_VRO_SalvageTrunkDoorsLarge", lists={"TrunkDoorMilitary_All"}, returns="armour", skill="MetalWelding", level=4, torch=5, time=1200, xp=20 },
  { key="hoods", name="IGUI_VRO_SalvageHoods", lists={"Hood_All"}, returns="large", skill="MetalWelding", level=3, torch=4, time=1000, xp=20 },
  { key="hoods_large", name="IGUI_VRO_SalvageHoodsLarge", lists={"MilitaryHood_All"}, returns="armour", skill="MetalWelding", level=4, torch=5, time=1200, xp=25 },
  { key="gas_tanks", name="IGUI_VRO_SalvageGasTanks", lists={"GasTank_All"}, returns="large", skill="MetalWelding", level=3, torch=5, time=1000, xp=20 },
  { key="gas_tanks_small", name="IGUI_VRO_SalvageGasTanksSmall", lists={"GasTankSmall_All"}, returns="small", skill="MetalWelding", level=2, torch=3, time=700, xp=20 },
  { key="trunks", name="IGUI_VRO_SalvageTrunks", lists={"Trunk_All", "Trailer_All"}, returns="large", skill="MetalWelding", level=3, torch=4, time=800, xp=20 },
  { key="trunks_large", name="IGUI_VRO_SalvageTrunksLarge", lists={"TrunkMilitary_All"}, returns="armour", skill="MetalWelding", level=4, torch=5, time=1000, xp=20 },
  { key="trunks_small", name="IGUI_VRO_SalvageTrunksSmall", lists={"SmallTrunk_All"}, returns="small", skill="MetalWelding", level=2, torch=3, time=700, xp=20 },
  { key="mufflers", name="IGUI_VRO_SalvageMufflers", lists={"SmallMuffler_All", "Muffler_All"}, returns="muffler", skill="MetalWelding", level=4, torch=5, time=1000, xp=20 },
  { key="suspension", name="IGUI_VRO_SalvageSuspension", lists={"SmallSuspension_All", "Suspension_All", "MilitarySuspension_All"}, returns="suspension", skill="MetalWelding", level=4, torch=4, time=1000, xp=20 },
  { key="brakes", name="IGUI_VRO_SalvageBrakes", lists={"SmallBrake_All", "Brake_All", "MilitaryBrake_All"}, returns="small", skill="MetalWelding", level=3, torch=3, time=600, xp=20 },
  { key="seats", name="IGUI_VRO_SalvageSeats", lists={"CarSeat_All"}, returns="fabrics", skill="Tailoring", level=2, torch=3, time=600, xp=5 },
  { key="glove_boxes", name="IGUI_VRO_SalvageGloveBoxes", lists={"GloveBox_All"}, returns="electronics", skill="MetalWelding", level=2, torch=2, time=500, xp=10 },
  { key="tires", name="IGUI_VRO_SalvageTires", lists={"Tire_All", "MilitaryTire_All"}, returns="tires", skill="MetalWelding", level=2, torch=2, time=700, xp=10 },
  { key="bars", name="IGUI_VRO_SalvageBars", lists={"RoofRack_All", "Bullbar_All"}, returns="suspension", skill="MetalWelding", level=3, torch=3, time=700, xp=10 },
  { key="saddlebags", name="IGUI_VRO_SalvageSaddlebags", items={"Base.ATAMotoBagBMW1", "Base.ATAMotoBagBMW2", "Base.ATAMotoHarleyBag", "Base.ATAMotoHarleyHolster", "Base.SS100topbag3", "Base.90pierceArrowHoses"}, returns="leathers", skill="Tailoring", level=2, time=600, xp=5 },
  { key="saddlebags_hard", name="IGUI_VRO_SalvageSaddlebagsHard", lists={"SaddlebagsHard_All"}, returns="small", skill="MetalWelding", level=2, torch=2, time=600, xp=20 },
  { key="armour", name="IGUI_VRO_SalvageArmour", lists={"MilitaryWindow_All", "VehicleShovel_All"}, returns="armour", skill="MetalWelding", level=4, torch=5, time=1200, xp=20 },
  { key="lids", name="IGUI_VRO_SalvageLids", lists={"TrailerLids_All"}, returns="large", skill="MetalWelding", level=3, torch=3, time=800, xp=20 },
  { key="soft_tops", name="IGUI_VRO_SalvageSoftTops", lists={"SoftTops_All"}, returns="softtops", skill="MetalWelding", level=2, torch=3, time=800, xp=20 },
  { key="panels", name="IGUI_VRO_SalvagePanels", lists={"Panels_All"}, returns="small", skill="MetalWelding", level=3, torch=3, time=800, xp=20 },
  { key="tanks", name="IGUI_VRO_SalvageTankContainers", lists={"TankContainers_All"}, returns="large", skill="MetalWelding", level=4, torch=5, time=1000, xp=20 },
  { key="electronics", name="IGUI_VRO_SalvageElectronics", lists={"Battery_All", "LargeBattery_All", "Radio_All", "Light_All", "MiscElectronics_All"}, returns="electronics", skill="MetalWelding", level=2, torch=2, time=500, xp=10 },
}

local byKey, byItem = {}, {}
for _, spec in ipairs(VRO.SalvageCatalog) do
  byKey[spec.key] = spec
  local function add(fullType) if fullType and not byItem[fullType] then byItem[fullType] = spec end end
  for _, fullType in ipairs(spec.items or {}) do add(fullType) end
  for _, listName in ipairs(spec.lists or {}) do
    for _, fullType in ipairs(VRO.PartLists[listName] or {}) do add(fullType) end
  end
end

function VRO.GetSalvageSpec(fullType) return byItem[fullType] end
function VRO.GetSalvageSpecByKey(key) return byKey[key] end
function VRO.IsVehicleSalvageEnabled()
  if not SandboxVars then return true end
  local value = SandboxVars.VRO_DisableVehicleSalvage
  if value == nil and SandboxVars.VRO then value = SandboxVars.VRO.DisableVehicleSalvage end
  return value ~= true
end

return VRO.SalvageCatalog
