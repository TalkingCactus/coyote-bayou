/obj/item/wrench
	name = "wrench"
	desc = "A wrench with common uses. Can be found in your hand. This can repair dents in robots."
	icon = 'icons/obj/tools.dmi'
	icon_state = "wrench"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	flags_1 = CONDUCT_1
	slot_flags = INV_SLOTBIT_BELT
	force = 25
	force_unwielded = 25
	force_wielded = 30
	throwforce = 7
	var/praying = FALSE
	w_class = WEIGHT_CLASS_SMALL
	usesound = 'sound/items/ratchet.ogg'
	custom_materials = list(/datum/material/iron=500)
	reskinnable_component = /datum/component/reskinnable/wrench

	attack_verb = list("bashed", "battered", "bludgeoned", "whacked")
	tool_behaviour = TOOL_WRENCH
	toolspeed = 1
	armor = ARMOR_VALUE_GENERIC_ITEM

	wound_bonus = -10
	bare_wound_bonus = 5

/obj/item/wrench/attack(mob/living/M, mob/living/user)
	if(user.a_intent == INTENT_HARM)
		return ..()

	var/mob/living/carbon/human/target = M
	if(!target || !isrobotic(target))
		return FALSE

	if(praying)
		to_chat(user, span_notice("You are already using [src]."))
		return

	user.visible_message(span_info("[user] kneels[M == user ? null : " next to [M]"] and begins repairing their dents."), \
		span_info("You kneel[M == user ? null : " next to [M]"] and begins repairing any dents."))

	praying = TRUE
	if(!target || !isrobotic(target))
		praying = FALSE
		return FALSE
	if(do_after(user, 1 SECONDS, target = M)) 
		M.adjustBruteLoss(-5, include_roboparts = TRUE) //Wrench is for brute
		to_chat(M, span_notice("[user] finished repairing your dents!"))
		praying = FALSE
		playsound(get_turf(target), 'sound/items/trayhit2.ogg', 100, 1)
	else
		to_chat(user, span_notice("You were interrupted."))
		praying = FALSE

/obj/item/wrench/cyborg
	name = "automatic wrench"
	desc = "An advanced robotic wrench. Can be found in construction cyborgs."
	icon = 'icons/obj/items_cyborg.dmi'
	icon_state = "wrench_cyborg"
	toolspeed = 0.5

/obj/item/wrench/brass
	name = "brass wrench"
	desc = "A brass wrench. It's faintly warm to the touch."
	resistance_flags = FIRE_PROOF | ACID_PROOF
	icon_state = "wrench_clock"
	toolspeed = 0.5

/obj/item/wrench/bronze
	name = "bronze plated wrench"
	desc = "A bronze plated wrench."
	icon_state = "wrench_brass"
	toolspeed = 0.95

/obj/item/wrench/abductor
	name = "ultracite wrench"
	desc = "A polarized wrench. It causes anything placed between the jaws to turn."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "wrench"
	usesound = 'sound/effects/empulse.ogg'
	toolspeed = 0.1

/obj/item/wrench/power
	name = "hand drill"
	desc = "A simple powered hand drill. It's fitted with a bolt bit."
	icon_state = "drill_bolt"
	item_state = "drill"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	usesound = 'sound/items/drill_use.ogg'
	custom_materials = list(/datum/material/iron=150,/datum/material/silver=50,/datum/material/titanium=25)
	//done for balance reasons, making them high value for research, but harder to get
	force = 8 //might or might not be too high, subject to change
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 8
	attack_verb = list("drilled", "screwed", "jabbed")
	toolspeed = 0.25

/obj/item/wrench/power/attack_self(mob/user)
	playsound(get_turf(user),'sound/items/change_drill.ogg',50,1)
	var/obj/item/wirecutters/power/s_drill = new /obj/item/screwdriver/power(drop_location())
	to_chat(user, span_notice("You attach the screw driver bit to [src]."))
	qdel(src)
	user.put_in_active_hand(s_drill)

/obj/item/wrench/medical
	name = "medical wrench"
	desc = "A medical wrench with common(medical?) uses. Can be found in your hand."
	icon_state = "wrench_medical"
	force = 2 //MEDICAL
	throwforce = 4

	attack_verb = list("wrenched", "medicaled", "tapped", "jabbed", "whacked")

/obj/item/wrench/advanced
	name = "advanced wrench"
	desc = "A wrench that uses the same magnetic technology that abductor tools use, but slightly more ineffeciently."
	icon = 'icons/obj/advancedtools.dmi'
	icon_state = "wrench"
	usesound = 'sound/effects/empulse.ogg'
	toolspeed = 0.2
	reskinnable_component = null

//DR2 TOOLS

/obj/item/wrench/crude
	name = "crude wrench"
	desc = "A bent bar, finnicky to use and requires a lot of effort for consant adjustments, better than your bare hand though."
	icon_state = "crudewrench"
	item_state = "crudewrench"
	toolspeed = 6
	reskinnable_component = null

/obj/item/wrench/basic
	name = "basic wrench"
	desc = "A pipe with an old, wrench head on it."
	icon_state = "basicwrench"
	item_state = "basicwrench"
	toolspeed = 2
	reskinnable_component = null

/obj/item/wrench/hightech
	name = "advanced locking device"
	desc = "An advanced locking device that uses micro-mechanisms to grasp on and tighten objects with extreme torque accuracy and speed."
	icon_state = "advancedwrench"
	item_state = "advancedwrench"
	toolspeed = 0.1
	reskinnable_component = null
