
local Tourist = "Tourist"
local None = "none"

local ModPath = CurrentModPath
local Options_TouristIcons
local Options_TouristIcons_On = "On"
local Options_TouristSpec
local Options_TouristSpec_Tourist = "Tourist"
local Options_TouristSpec_None = "No Specialization"

-- Returns Configured Tourist Specialization or nil
local function TouristSpecialization()
	return (Options_TouristSpec == Options_TouristSpec_Tourist) and Tourist or
		   (Options_TouristSpec == Options_TouristSpec_None) and None or nil
end

-- Generates a Random Specialization
local function RandomSpec()
	return GenerateColonistData(city, nil, nil, {no_specialization = IsGameRuleActive("Amateurs") or nil}).specialist
end

-- Updates Applicats when Mod Options are updated
local function UpdateApplicants(randomSpec)
	local forcedSpec = TouristSpecialization()
	if randomSpec or forcedSpec then
		for _, applicant in ipairs(g_ApplicantPool) do
			applicant = applicant[1]
			if applicant.traits.Tourist then
				applicant.traits[applicant.specialist or None] = nil
				applicant.specialist = randomSpec and RandomSpec() or forcedSpec
				applicant.traits[applicant.specialist] = true
				applicant.traits[Tourist] = true
			end
		end
	end
end

-- Updates Colonists when Mod Options are updated
local function UpdateColonists(randomSpec)
	local forcedSpec = TouristSpecialization()
	local tourists = GetCityResourceOverview(UICity):GetAllTourists()
	for _, tourist in ipairs(tourists) do
		local specialist = randomSpec and RandomSpec() or forcedSpec
		if specialist and tourist.specialist ~= specialist then
			tourist:SetSpecialization(specialist)
			tourist.traits[Tourist] = true
		end
		tourist:ChooseEntity()
	end
end

-- Applies Mod Options
local function ModOptions()
	local randomSpec = TouristSpecialization()
	Options_TouristIcons = CurrentModOptions:GetProperty("TouristIcons")
	Options_TouristSpec = CurrentModOptions:GetProperty("TouristSpec")
	randomSpec = randomSpec and not TouristSpecialization()
	
	UpdateApplicants(randomSpec)
	UpdateColonists(randomSpec)
end

OnMsg.ModsReloaded = ModOptions
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then ModOptions() end
end

-- Sets Tourist Specialization
local base_MakeTourist = MakeTourist
function MakeTourist(applicant)
	local specialist = TouristSpecialization()
	if specialist then
		applicant.traits[applicant.specialist] = nil
		applicant.specialist = specialist
	end
    return base_MakeTourist(applicant)
end

-- Fixes Tourist Outside Visuals
function OnMsg.ColonistAddTrait(colonist, trait_id, init)
	if Options_TouristSpec == Options_TouristSpec_Tourist and trait_id == Tourist then
		colonist:SetSpecialization(trait_id, init)
	end
end

-- Overrides Tourist Icons
local base_GetSpecializationIcons = Colonist.GetSpecializationIcons
function Colonist:GetSpecializationIcons()
	local traits = self.traits or {}
	local result = base_GetSpecializationIcons(self)
	
	if not result or result == "" then
	    return result
	
	-- Set icons to Tourist
	elseif Options_TouristIcons == Options_TouristIcons_On and traits.Tourist then
		return ModPath..string.format("UI/Icons/Colonists/IP/IP_%s_%s.tga", Tourist, self.entity_gender),
		       ModPath..string.format("UI/Icons/Colonists/Pin/%s_%s.tga", Tourist, self.entity_gender)
	
	-- Restore icons to Colonist
	elseif Options_TouristIcons ~= Options_TouristIcons_On and self.specialist == Tourist then
		return string.format("UI/Icons/Colonists/IP/IP_%s_%s.tga", "Colonist", self.entity_gender),
		       string.format("UI/Icons/Colonists/Pin/%s_%s.tga", "Colonist", self.entity_gender)

	else
		return result
	end
end
