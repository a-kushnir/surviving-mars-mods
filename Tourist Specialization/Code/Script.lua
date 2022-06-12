
local base_MakeTourist = MakeTourist
function MakeTourist(applicant)
	applicant.traits[applicant.specialist] = nil
	applicant.specialist = "Tourist"
    base_MakeTourist(applicant)
end
