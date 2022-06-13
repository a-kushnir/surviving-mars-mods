
local base_MakeTourist = MakeTourist
function MakeTourist(applicant)
	applicant.traits[applicant.specialist] = nil
	applicant.specialist = "Tourist"
    return base_MakeTourist(applicant)
end

function OnMsg.ColonistAddTrait(colonist, trait_id, init)
	if trait_id == "Tourist" then
		colonist:SetSpecialization(trait_id, init)
	end
end
OnMsg.ColonistAddTrait = ColonistAddTrait
