
local ModPath = CurrentModPath
local Tourist = "Tourist"

-- Sets Tourist Specialization
local base_MakeTourist = MakeTourist
function MakeTourist(applicant)
	applicant.traits[applicant.specialist] = nil
	applicant.specialist = Tourist
    return base_MakeTourist(applicant)
end

-- Fixes Tourist Outside Visuals
function OnMsg.ColonistAddTrait(colonist, trait_id, init)
	if trait_id == Tourist then
		colonist:SetSpecialization(trait_id, init)
	end
end
OnMsg.ColonistAddTrait = ColonistAddTrait

-- Overrides Tourist Icons
local base_GetSpecializationIcons = Colonist.GetSpecializationIcons
function Colonist:GetSpecializationIcons()
	local traits = self.traits or {}
	if self.traits.Tourist and not traits.Child and not traits.Android then
		return ModPath..string.format("UI/Icons/Colonists/IP/IP_%s_%s.tga", Tourist, self.entity_gender),
		       ModPath..string.format("UI/Icons/Colonists/Pin/%s_%s.tga", Tourist, self.entity_gender)
	else
		return base_GetSpecializationIcons(self)
	end
end
