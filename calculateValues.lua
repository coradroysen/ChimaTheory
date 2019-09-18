-- calculates the dmg and/or heal value of a spell
-- expects spellID
-- returns valueHeal, valueDmg
function CalculateDmgHealValue(spellID)
  if _G["spellData" .. playerClass][spellID] ~= nil then
    local name, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(id)
    local valueHeal = 0
    local valueHot = 0
    local valueDmg = 0
    local valueDot = 0

    -- heal (instant)
    if _G["spellData" .. playerClass][spellID].isHeal then
      local bonusHeal = GetSpellBonusHealing() * _G["spellData" .. playerClass][spellID].instantCoeff
      local baseHeal = (_G["spellData" .. playerClass][spellID].minHealV + _G["spellData" .. playerClass][spellID].maxHealV) / 2
      valueHeal = baseHeal + bonusHeal
    end

    -- heal (overTime or channeled)
    if _G["spellData" .. playerClass][spellID].isHot or _G["spellData" .. playerClass][spellID].isChanHeal then
      local bonusHeal = GetSpellBonusHealing() * _G["spellData" .. playerClass][spellID].overTimeCoeff
      local baseHeal = _G["spellData" .. playerClass][spellID].fullHealV
      valueHot = baseHeal + bonusHeal
    end

    -- dmg (instant)
    if _G["spellData" .. playerClass][spellID].isDmg then
      local bonusDmg = GetSpellBonusDamage(_G["spellData" .. playerClass][spellID].dmgType) * _G["spellData" .. playerClass][spellID].instantCoeff
      local baseDmg = (_G["spellData" .. playerClass][spellID].minDmgV + _G["spellData" .. playerClass][spellID].maxDmgV) / 2
      valueDmg = baseDmg + bonusDmg
    end

    -- dmg (overTime or channeled)
    if _G["spellData" .. playerClass][spellID].isDot or _G["spellData" .. playerClass][spellID].isChanDmg then
      local bonusDmg = GetSpellBonusDamage(_G["spellData" .. playerClass][spellID].dmgType) * _G["spellData" .. playerClass][spellID].overTimeCoeff
      local baseDmg = _G["spellData" .. playerClass][spellID].fullDmgV
      valueDot = baseDmg + bonusDmg
    end

    return math.floor(valueHeal + valueHot), math.floor(valueDmg + valueDot)
  end
end


function CalculateHealPerMana(spellID)
  local hpm = 0
  local valueHeal, valueDmg = CalculateDmgHealValue(spellID)
  local costs = GetSpellPowerCost(spellID)[1] and GetSpellPowerCost(spellID)[1].cost or 0
  if costs ~= 0 then hpm = math.floor(valueHeal / costs * 100) / 100 else hpm = "n/a" end

  return hpm
end

function CalculateDmgPerMana(spellID)
  local dpm = 0
  local valueHeal, valueDmg = CalculateDmgHealValue(spellID)
  local costs = GetSpellPowerCost(spellID)[1] and GetSpellPowerCost(spellID)[1].cost or 0
  if costs ~= 0 then dpm = math.floor(valueDmg / costs * 100) / 100 else dpm = "n/a" end

  return dpm
end