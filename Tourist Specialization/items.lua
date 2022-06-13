return {
PlaceObj('ModItemCode', {
	'FileName', "Code/Script.lua",
}),
PlaceObj('ModItemOptionChoice', {
	'name', "TouristIcons",
	'DisplayName', "Custom Icons",
	'Help', "Custom icons for colonists with <color 244 228 117>Tourist</color> trait",
	'DefaultValue', "On",
	'ChoiceList', {
		"On",
		"Off",
	},
}),
PlaceObj('ModItemOptionChoice', {
	'name', "TouristSpec",
	'DisplayName', "Specialization",
	'Help', "Specialization for colonists with <color 244 228 117>Tourist</color> trait",
	'DefaultValue', "Tourist",
	'ChoiceList', {
		"Off",
		"No Specialization",
		"Tourist",
	},
}),
}
