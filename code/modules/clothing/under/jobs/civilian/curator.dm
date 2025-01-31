/obj/item/clothing/under/rank/civilian/curator
	name = "sensible suit"
	desc = "It's very... sensible."
	icon_state = "red_suit"
	inhand_icon_state = "red_suit"
	can_adjust = FALSE

/obj/item/clothing/under/rank/civilian/curator/skirt
	name = "sensible suitskirt"
	icon_state = "red_suit_skirt"
	body_parts_covered = CHEST|GROIN|ARMS
	fitted = FEMALE_UNIFORM_TOP
	mutantrace_variation = STYLE_DIGITIGRADE|STYLE_NO_ANTHRO_ICON

/obj/item/clothing/under/rank/civilian/curator/treasure_hunter
	name = "treasure hunter uniform"
	desc = "A rugged uniform suitable for treasure hunting."
	icon_state = "curator"
	inhand_icon_state = "curator"

/obj/item/clothing/under/rank/civilian/curator/nasa
	name = "\improper NASA jumpsuit"
	desc = "It has a NASA logo on it and is made of space-proofed materials."
	icon_state = "black"
	inhand_icon_state = "bl_suit"
	w_class = WEIGHT_CLASS_BULKY
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.02
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST | GROIN | LEGS | ARMS //Needs gloves and shoes with cold protection to be fully protected.
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	resistance_flags = NONE
