//-->laserv guns that have a dynamo to recharge
//<--

/obj/item/gun/energy/laser/cranklasergun
	name = "energy dynamo cranked weapon template"
	desc = "Should not exists. Bugreport."
	icon_state = "laser"
	item_state = "laser"
	cell_type = /obj/item/stock_parts/cell/ammo/mfc/cranklasergun
	ammo_type = list(/obj/item/ammo_casing/energy/cranklasergun)
	var/list/crank_overcharge_mult = list()  //depending on how many overcharge stages the gun has, leave blank if you want no overcharge
	var/list/crank_overcharge_fire_sounds = list()  //if your overcharged shots have different sounds put the actual paths here
	var/cranking_time = 0.2 SECONDS
	var/crank_stamina_cost = 5
	var/list/crank_sound = list(
		'sound/effects/dynamo_crank/dynamo_crank.mp3',
	)
	dead_cell = TRUE  //This variable also has to stay TRUE for all cranklaserguns or else you'll get extra shots in your gun upon spawn
	allow_ui_interact = FALSE  //this variable must stay false to all cranklaserguns or else the gun UI will pop up every time you crank
	custom_materials = list(/datum/material/iron=2000)
	ammo_x_offset = 1
	shaded_charge = 1
	can_remove = 0 //We can't remove the battery of a cranklasergun
	can_charge = 0 //And we surely can't put such weapon in recharger, it's faster to crank anyways
	weapon_class = WEAPON_CLASS_RIFLE
	weapon_weight = GUN_TWO_HAND_ONLY
	init_firemodes = list(
		/datum/firemode/semi_auto
	)
////////////////////////////////////////////////////////////////

//-->regular cranklaser cell
/obj/item/stock_parts/cell/ammo/mfc/cranklasergun  //basically a single shot charge
	name = "integrated single charge cell"
	desc = "An integrated single charge cell, typically used as fast discharge power bank for energy weapons."
	icon = 'icons/fallout/objects/powercells.dmi'
	icon_state = "mfc-full"
	maxcharge = 1


/obj/item/ammo_casing/energy/cranklasergun
	projectile_type = /obj/item/projectile/beam/laser/cranklasergun
	e_cost = 1
	select_name = "kill"


/obj/item/projectile/beam/laser/cranklasergun
	name = "laser"
	icon_state = "laser"
	pass_flags = PASSTABLE| PASSGLASS
	damage = 60
	light_range = 2
	damage_type = BURN
	hitsound = 'sound/weapons/sear.ogg'
	hitsound_wall = 'sound/weapons/effects/searwall.ogg'
	flag = "laser"
	eyeblur = 2
	impact_effect_type = /obj/effect/temp_visual/impact_effect/red_laser
	light_color = LIGHT_COLOR_RED
	ricochets_max = 50	//Honk!
	ricochet_chance = 0
	is_reflectable = TRUE
	wound_bonus = -30
	bare_wound_bonus = 40
	recoil = BULLET_RECOIL_LASER
////////////////////////////////////////////////////////////////

//-->Gun mechanics
//Crank to recharge
/obj/item/gun/energy/attack_self(mob/living/user)
	. = ..()
	crankgun(user)

/obj/item/gun/energy/proc/crankgun(mob/living/user)
	if(istype(src, /obj/item/gun/energy/laser/cranklasergun))  //does the gun belong to the cranklasergun type we seek?
		var/obj/item/gun/energy/laser/cranklasergun/firearm = src  //let's assign it a name then
		var/obj/item/stock_parts/cell/C = src.get_cell()

		var/playsound_volume = 50

		if((C.charge < C.maxcharge) && (!recharge_queued))
			recharge_queued = 1  //this variable makes it so we can't queue multiple recharges at once, only one at a time (variable gets reset in {/obj/item/gun/shoot_live_shot(mob/living/user)})
			playsound(user.loc, pick(firearm.crank_sound), playsound_volume, TRUE)
			if(do_after(user, firearm.cranking_time, target = src, allow_movement = TRUE))
				recharge_queued = 0
				user.apply_damage(firearm.crank_stamina_cost, STAMINA)  //have you ever ridden a bike with a dynamo?
				C.charge += 250
				update_icon()
				crankgun(user)

				//if it's the overcharged variant, then execute this too
				if(firearm.crank_overcharge_mult.len)
					if(!C.charge)
						firearm.damage_multiplier = firearm.crank_overcharge_mult[1]
					else if(C.charge <= firearm.crank_overcharge_mult.len)
						firearm.damage_multiplier = firearm.crank_overcharge_mult[C.charge]
					else
						firearm.damage_multiplier = firearm.crank_overcharge_mult[firearm.crank_overcharge_mult.len]

				if(firearm.crank_overcharge_fire_sounds.len)
					if(!C.charge)
						firearm.fire_sound = firearm.crank_overcharge_fire_sounds[1]
					else if(C.charge <= firearm.crank_overcharge_fire_sounds.len)
						firearm.fire_sound = firearm.crank_overcharge_fire_sounds[C.charge]
					else
						firearm.fire_sound = firearm.crank_overcharge_fire_sounds[firearm.crank_overcharge_fire_sounds.len]

			else
				recharge_queued = 0

//if I'm shooting, reset few variables in the way it makes sense
/obj/item/gun/shoot_live_shot(mob/living/user)
	. = ..()
	//we have to check if the gun is a cranklasergun type, otherwise ignore it
	if(istype(src, /obj/item/gun/energy/laser/cranklasergun))
		var/obj/item/gun/energy/laser/cranklasergun/firearm = src
		recharge_queued = 0

		if(firearm.crank_overcharge_mult.len)
			var/obj/item/stock_parts/cell/C = src.get_cell()
			C.charge = 0
//<--

////////////////////////////////////////////////////////////////
//Actual crankable guns start here

//-->Standard issue crankable laser gun template, this can't be overcharged and can shoot multiple times.
/obj/item/gun/energy/laser/cranklasergun/classic
	name = "My first crank template"
	desc = "googoo zaza"
	icon_state = "laer-e"
	item_state = "laer-e"
	cranking_time = 1.5 SECONDS
	crank_stamina_cost = 0 // put a number here if you want your cranking to tire people out
	cell_type = /obj/item/stock_parts/cell/ammo/mfc/cranklasergun/classic
	ammo_type = list(/obj/item/ammo_casing/energy/cranklasergun/classic)
	crank_sound = list(
		'sound/effects/dynamo_crank/dynamo_crank_mb1.ogg',
		'sound/effects/dynamo_crank/dynamo_crank_mb2.ogg',
		'sound/effects/dynamo_crank/dynamo_crank_mb3.ogg',
	)

/obj/item/stock_parts/cell/ammo/mfc/cranklasergun/classic  //basically a single shot charge
	maxcharge = 1000

/obj/item/ammo_casing/energy/cranklasergun/classic
	projectile_type = /obj/item/projectile/beam/laser/cranklasergun/classic
	fire_sound = 'sound/weapons/pulse2.ogg'

/obj/item/projectile/beam/laser/cranklasergun/classic
	damage = 25
////////////////////////////////////////////////////////////////

//-->Standard issue crankable laser gun that can be overcharged, this allows for a single shot only, but charging the gun makes the shot stronger
/obj/item/gun/energy/laser/cranklasergun/overcharge
	name = "Crankable laser musket template"
	desc = "you shouldn't see this, please report it!"
	icon_state = "laer-e"
	item_state = "laer-e"
	crank_overcharge_mult = list(1, 2, 3)
	crank_overcharge_fire_sounds = list(
		'sound/weapons/pulse3.ogg',
		'sound/weapons/pulse2.ogg',
		'sound/weapons/pulse.ogg',
	)
	cranking_time = 1.5 SECONDS
	crank_stamina_cost = 0  // put a number here if you want your cranking to tire people out
	damage_multiplier = 3
	cell_type = /obj/item/stock_parts/cell/ammo/mfc/cranklasergun/overcharge
	ammo_type = list(/obj/item/ammo_casing/energy/cranklasergun/overcharge)
	fire_sound = 'sound/weapons/pulse.ogg'
	crank_sound = list(
		'sound/effects/dynamo_crank/dynamo_crank.mp3',
	)

/obj/item/stock_parts/cell/ammo/mfc/cranklasergun/overcharge
	maxcharge = 750

/obj/item/ammo_casing/energy/cranklasergun/overcharge
	projectile_type = /obj/item/projectile/beam/laser/cranklasergun/overcharge
	fire_sound = 'sound/weapons/pulse.ogg'

/obj/item/projectile/beam/laser/cranklasergun/overcharge
	damage = 30
////////////////////////////////////////////////////////////////

//-->Revolver_man's laser musket
/obj/item/gun/energy/laser/cranklasergun/overcharge/revolver_man
	name = "Revolver Man's lazor"
	desc = "Revolver Man has fucking lasors now???!!!"
	icon_state = "laer-e"
	item_state = "laer-e"
	crank_overcharge_mult = list(1, 1.5, 2, 2.5, 3, 3.5)
	crank_overcharge_fire_sounds = list(
		'sound/weapons/pulse3.ogg',
		'sound/weapons/pulse2.ogg',
		'sound/weapons/pulse.ogg',
	)
	cranking_time = 0.8 SECONDS
	crank_stamina_cost = 0 // put a number here if you want your cranking to tire people out
	damage_multiplier = 3.5
	cell_type = /obj/item/stock_parts/cell/ammo/mfc/cranklasergun/overcharge/revolver_man
	ammo_type = list(/obj/item/ammo_casing/energy/cranklasergun/overcharge/revolver_man)
	fire_sound = 'sound/weapons/pulse.ogg'
	crank_sound = list(
		'sound/effects/dynamo_crank/dynamo_crank.mp3',
	)

/obj/item/stock_parts/cell/ammo/mfc/cranklasergun/overcharge/revolver_man
	maxcharge = 1500

/obj/item/ammo_casing/energy/cranklasergun/overcharge/revolver_man
	projectile_type = /obj/item/projectile/beam/laser/cranklasergun/overcharge/revolver_man
	fire_sound = 'sound/weapons/pulse.ogg'

/obj/item/projectile/beam/laser/cranklasergun/overcharge/revolver_man
	damage = 30

// Start of TG lasers
/obj/item/gun/energy/laser/cranklasergun/tg
	name = "improvised laser"
	desc = "Hanging out of a gutted weapon's frame are a series of wires and capacitors. This improvised carbine hums ominously as you examine it. It... Probably won't explode when you pull the trigger, at least?"
	icon = 'icons/fallout/objects/guns/energy.dmi'
	lefthand_file = 'icons/fallout/onmob/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/fallout/onmob/weapons/guns_righthand.dmi'
	icon_state = "scraplaser"
	item_state = "shotguncity"
	cell_type = /obj/item/stock_parts/cell/ammo/mfc/cranklasergun/tg
	ammo_type = list(/obj/item/ammo_casing/energy/cranklasergun/tg)
	ammo_x_offset = 1
	shaded_charge = 1
	can_charge = 1
	can_scope = TRUE
	trigger_guard = TRIGGER_GUARD_NORMAL
	max_upgrades = 6
	cranking_time = 1.2 SECONDS
	crank_stamina_cost = 10
	crank_sound = list(
		'sound/effects/dynamo_crank/dynamo_crank_mb1.ogg',
		'sound/effects/dynamo_crank/dynamo_crank_mb2.ogg',
		'sound/effects/dynamo_crank/dynamo_crank_mb3.ogg',
	)

	weapon_class = WEAPON_CLASS_NORMAL
	weapon_weight = GUN_ONE_HAND_AKIMBO
	init_recoil = LASER_HANDGUN_RECOIL(1, 1)
	init_firemodes = list(
		/datum/firemode/semi_auto,
		/datum/firemode/automatic/rpm100
	)

/obj/item/stock_parts/cell/ammo/mfc/cranklasergun/tg  //basically a single shot charge
	name = "integrated single charge cell"
	desc = "An integrated single charge cell, typically used as fast discharge power bank for energy weapons."
	icon = 'icons/fallout/objects/powercells.dmi'
	icon_state = "mfc-full"
	maxcharge = 5000


/obj/item/ammo_casing/energy/cranklasergun/tg
	projectile_type = /obj/item/projectile/beam/laser/cranklasergun/tg
	e_cost = 250
	select_name = "kill"


/obj/item/projectile/beam/laser/cranklasergun/tg
	name = "blaster bolt"
	icon_state = "laser"
	pass_flags = PASSTABLE| PASSGLASS
	damage = 30
	damage_list = list("25" = 25, "30" = 25, "35" = 25, "40" = 25)
	light_range = 2
	damage_type = BURN
	hitsound = 'sound/weapons/sear.ogg'
	hitsound_wall = 'sound/weapons/effects/searwall.ogg'
	flag = "laser"
	eyeblur = 2
	impact_effect_type = /obj/effect/temp_visual/impact_effect/red_laser
	light_color = LIGHT_COLOR_RED
	ricochets_max = 50	//Honk!
	ricochet_chance = 0
	is_reflectable = TRUE
	recoil = BULLET_RECOIL_HEAVY_LASER

// THE TG CARBINE

/obj/item/gun/energy/laser/cranklasergun/tg/carbine
	name = "laser carbine"
	desc = "A somewhat compact laser carbine that's capable of being put in larger holsters. Manufactured by Trident Gammaworks, this model of rifle was marketed before the collapse for hunting and sport shooting."
	icon_state = "lascarbine"
	cell_type = /obj/item/stock_parts/cell/ammo/mfc/cranklasergun/tg/carbine
	ammo_type = list(/obj/item/ammo_casing/energy/cranklasergun/tg)
	can_flashlight = 1
	flight_x_offset = 15
	flight_y_offset = 10
	crank_sound = list(
		'sound/effects/dynamo_crank/dynamo_crank.mp3',
	)
	cranking_time = 0.6 SECONDS
	crank_stamina_cost = 10
	init_recoil = LASER_CARBINE_RECOIL(1, 1)

/obj/item/stock_parts/cell/ammo/mfc/cranklasergun/tg/carbine
	name = "integrated single charge cell"
	desc = "An integrated single charge cell, typically used as fast discharge power bank for energy weapons."
	icon = 'icons/fallout/objects/powercells.dmi'
	icon_state = "mfc-full"
	maxcharge = 5000


/obj/item/ammo_casing/energy/cranklasergun/tg/carbine
	projectile_type = /obj/item/projectile/beam/laser/cranklasergun/tg
	e_cost = 200
	select_name = "kill"
// TG CARBINE END

// TG PISTOL
/obj/item/gun/energy/laser/cranklasergun/tg/pistol
	name = "miniture laser pistol"
	desc = "An ultracompact version of the Trident Gammaworks laser carbine, this gun is small enough to fit in a pocket or pouch. While it retains most of the carbine's power, its battery is less efficient due to the size."
	icon_state = "laspistol"
	item_state = "laser"
	w_class = WEIGHT_CLASS_SMALL
	damage_multiplier = GUN_LESS_DAMAGE_T1
	cranking_time = 0.2 SECONDS
	crank_sound = list(
		'sound/effects/dynamo_crank/dynamo_crank.mp3',
	)
	crank_stamina_cost = 2.5 // Requires more time, but less stamina
	cell_type = /obj/item/stock_parts/cell/ammo/mfc/cranklasergun/tg/pistol
	ammo_type = list(/obj/item/ammo_casing/energy/cranklasergun/tg/pistol)
	init_recoil = LASER_HANDGUN_RECOIL(1, 1)

/obj/item/stock_parts/cell/ammo/mfc/cranklasergun/tg/pistol //basically a single shot charge
	name = "integrated single charge cell"
	desc = "An integrated single charge cell, typically used as fast discharge power bank for energy weapons."
	icon = 'icons/fallout/objects/powercells.dmi'
	icon_state = "mfc-full"
	maxcharge = 5000


/obj/item/ammo_casing/energy/cranklasergun/tg/pistol
	projectile_type = /obj/item/projectile/beam/laser/cranklasergun/tg
	e_cost = 250
	select_name = "kill"
// TG PISTOL END

// TG RIFLE
/obj/item/gun/energy/laser/cranklasergun/tg/rifle
	name = "laser rifle"
	desc = "The Mark II laser rifle, produced by Trident Gammaworks, was the golden standard of energy weapons pre-collapse, but it rapidly lost popularity with the introduction of the Wattz 2000 and AER-9 rifles."
	icon_state = "lasrifle"
	weapon_weight = GUN_TWO_HAND_ONLY
	w_class = WEIGHT_CLASS_BULKY
	cell_type = /obj/item/stock_parts/cell/ammo/mfc/cranklasergun/tg/rifle
	ammo_type = list(/obj/item/ammo_casing/energy/cranklasergun/tg/rifle)
	cranking_time = 0.6 SECONDS
	crank_stamina_cost = 10
	can_flashlight = 1
	crank_sound = list(
		'sound/effects/dynamo_crank/dynamo_crank.mp3',
	)
	flight_x_offset = 20
	flight_y_offset = 10
	init_recoil = LASER_RIFLE_RECOIL(1, 1)
	init_firemodes = list(
		/datum/firemode/burst/two,
		/datum/firemode/semi_auto/fast,
		/datum/firemode/automatic/rpm75
	)

/obj/item/stock_parts/cell/ammo/mfc/cranklasergun/tg/rifle
	name = "integrated single charge cell"
	desc = "An integrated single charge cell, typically used as fast discharge power bank for energy weapons."
	icon = 'icons/fallout/objects/powercells.dmi'
	icon_state = "mfc-full"
	maxcharge = 5000

/obj/item/ammo_casing/energy/cranklasergun/tg/rifle
	projectile_type = /obj/item/projectile/beam/laser/cranklasergun/tg
	e_cost = 125
	select_name = "kill"
// TG RIFLE END

// TG HEAVY RIFLE
/obj/item/gun/energy/laser/cranklasergun/tg/rifle/heavy
	name = "heavy laser rifle"
	desc = "Originally designed as a man portable anti-tank weapon, nowadays this massive rifle is mostly used to fry Super Mutants and bandits in Power Armor."
	icon_state = "lascannon"
	weapon_weight = GUN_TWO_HAND_ONLY
	cell_type = /obj/item/stock_parts/cell/ammo/mfc/cranklasergun/tg/rifle/heavy
	ammo_type = list(/obj/item/ammo_casing/energy/cranklasergun/tg/rifle/heavy)
	cranking_time = 1.6 SECONDS
	crank_stamina_cost = 20
	crank_sound = list(
		'sound/weapons/laserPump.ogg',
	)
	init_recoil = LASER_RIFLE_RECOIL(2, 2)
	init_firemodes = list(
		/datum/firemode/semi_auto/slower,
		/datum/firemode/automatic/rpm40
	)

/obj/item/stock_parts/cell/ammo/mfc/cranklasergun/tg/rifle/heavy
	name = "integrated single charge cell"
	desc = "An integrated single charge cell, typically used as fast discharge power bank for energy weapons."
	icon = 'icons/fallout/objects/powercells.dmi'
	icon_state = "mfc-full"
	maxcharge = 5000

/obj/item/ammo_casing/energy/cranklasergun/tg/rifle/heavy
	projectile_type = /obj/item/projectile/beam/cranklasergun/tg/rifle/heavy
	e_cost = 208
	fire_sound = 'sound/weapons/pulse.ogg'
	select_name = "kill"

/obj/item/projectile/beam/cranklasergun/tg/rifle/heavy
	name = "intense blaster bolt"
	damage = 60
	damage_list = list("55" = 25, "60" = 25, "65" = 25, "70" = 25)
	wound_bonus = 40 // nasty, but it's still a laser.
	recoil = BULLET_RECOIL_PLASMA
// TG HEAVY RIFLE END

// TG SMG
/obj/item/gun/energy/laser/cranklasergun/tg/rifle/auto
	name = "tactical laser rifle"
	desc = "Despite the introduction of interchangeable power cells for energy weapons, the Mark IV autolaser remained in use with SWAT and National Guard units due its incredibly efficient laser projection system."
	icon_state = "taclaser"
	item_state = "p90"
	cell_type = /obj/item/stock_parts/cell/ammo/mfc/cranklasergun/tg/rifle/auto
	ammo_type = list(/obj/item/ammo_casing/energy/cranklasergun/tg/rifle/auto)
	cranking_time = 0.6 SECONDS
	crank_stamina_cost = 10
	crank_sound = list(
		'sound/weapons/laserPump.ogg',
	)
	init_recoil = AUTOCARBINE_RECOIL(1, 1)
	init_firemodes = list(
		/datum/firemode/automatic/rpm200,
		/datum/firemode/burst/three/fast,
		/datum/firemode/semi_auto/fast
	)

/obj/item/stock_parts/cell/ammo/mfc/cranklasergun/tg/rifle/auto
	name = "integrated single charge cell"
	desc = "An integrated single charge cell, typically used as fast discharge power bank for energy weapons."
	icon = 'icons/fallout/objects/powercells.dmi'
	icon_state = "mfc-full"
	maxcharge = 5000

/obj/item/ammo_casing/energy/cranklasergun/tg/rifle/auto
	projectile_type = /obj/item/projectile/beam/laser/cranklasergun/tg
	e_cost = 83
	select_name = "kill"
// TG PARTY CANNON

/obj/item/gun/energy/laser/cranklasergun/tg/particalcannon
	name = "particle cannon"
	desc = "The Trident Gammaworks 'Yamato' particle cannon was designed to be mounted on light armor for use against hard targets, ranging from vehicles to buildings. And some madman has disconnected this one and modified it to be portable. Without an engine to supply its immense power requirements, the capacitors can only handle five shots before needing to recharge -- but sometimes, that's all you need."
	icon_state = "lassniper"
	item_state = "esniper"
	weapon_weight = GUN_TWO_HAND_ONLY
	w_class = WEIGHT_CLASS_BULKY
	cranking_time = 1.2 SECONDS
	crank_stamina_cost = 20
	crank_sound = list(
		'sound/weapons/laserPumpEmpty.ogg',
	)
	cell_type = /obj/item/stock_parts/cell/ammo/mfc/cranklasergun/tg/particalcannon
	ammo_type = list(/obj/item/ammo_casing/energy/cranklasergun/tg/particalcannon)
	init_recoil = LASER_RIFLE_RECOIL(2, 3)
	init_firemodes = list(
		/datum/firemode/semi_auto/slower,
	)

/obj/item/stock_parts/cell/ammo/mfc/cranklasergun/tg/particalcannon
	name = "integrated single charge cell"
	desc = "An integrated single charge cell, typically used as fast discharge power bank for energy weapons."
	icon = 'icons/fallout/objects/powercells.dmi'
	icon_state = "mfc-full"
	maxcharge = 15625

/obj/item/ammo_casing/energy/cranklasergun/tg/particalcannon
	projectile_type = /obj/item/projectile/beam/cranklasergun/tg/particalcannon
	e_cost = 3125
	fire_sound = 'sound/weapons/lasercannonfire.ogg'
	select_name = "kill"

/obj/item/projectile/beam/cranklasergun/tg/particalcannon
	name = "hyper-velocity particle beam"
	icon_state = "emitter"
	damage = 100 // With no -HP traits, any light armor saves you and EVERYONE is armored; you get 5 shots and can't reload in the field
	damage_list = list("90" = 25, "100" = 25, "115" = 25, "130" = 24, "1000" = 1) //fuck you fuck you fuck you fuck you fuck you fuck you fuck you fuck you fuck you fuck you fuck you fuck you fuck you fuck you fuck you ~TK
	wound_bonus = 60 // nasty, but it's still a laser
	supereffective_damage = 100 // lowered from 150 because you can charge it now
	supereffective_faction = list("hostile", "ant", "supermutant", "deathclaw", "cazador", "raider", "china", "gecko", "wastebot", "yaoguai")
	hitscan = TRUE
	tracer_type = /obj/effect/projectile/tracer/xray
	muzzle_type = /obj/effect/projectile/muzzle/xray
	impact_type = /obj/effect/projectile/impact/xray

// TG Repeating Blaster
/obj/item/gun/energy/laser/cranklasergun/tg/spamlaser
	name = "repeating blaster"
	desc = "The odd design of the Trident Gammaworks M950 repeating blaster allows for an extremely high number of shots, but the weapon's power is rather low in turn. Before the end of the world, it was marketed as an anti-varmint weapon. Turns out, it's still largely used as one after the end."
	icon_state = "spamlaser"
	weapon_weight = GUN_TWO_HAND_ONLY
	w_class = WEIGHT_CLASS_BULKY
	cranking_time = 2 SECONDS // Basically costs nothing
	crank_stamina_cost = 10
	cell_type = /obj/item/stock_parts/cell/ammo/mfc/cranklasergun/tg/spamlaser
	ammo_type = list(/obj/item/ammo_casing/energy/cranklasergun/tg/spamlaser)
	init_recoil = AUTOCARBINE_RECOIL(1, 1)
	init_firemodes = list(
	/datum/firemode/automatic/rpm200,
	/datum/firemode/semi_auto,
	)

/obj/item/stock_parts/cell/ammo/mfc/cranklasergun/tg/spamlaser
	name = "integrated single charge cell"
	desc = "An integrated single charge cell, typically used as fast discharge power bank for energy weapons."
	icon = 'icons/fallout/objects/powercells.dmi'
	icon_state = "mfc-full"
	maxcharge = 5000

/obj/item/ammo_casing/energy/cranklasergun/tg/spamlaser
	projectile_type = /obj/item/projectile/beam/cranklasergun/tg/spamlaser
	e_cost = 40 //Gets 6 shots per charge
	fire_sound = 'sound/weapons/taser2.ogg'
	select_name = "kill"

/obj/item/projectile/beam/cranklasergun/tg/spamlaser //ultra weak but spammy, duh
	name = "blaster bolt"
	damage = 10
	damage_list = list("8" = 20, "10" = 60, "15" = 15, "30" = 5)
	recoil = BULLET_RECOIL_HEAVY_LASER

// TG Electro Autoblaster
/obj/item/gun/energy/laser/cranklasergun/tg/spamlaser/shock
	name = "shock autoblaster"
	desc = "The T30 Repeater was an experiment by Trident Gammaworks to exploit tesla technology. It saw limited commercial success even though the technology was deemed to have great potential."
	icon_state = "teslaser"
	weapon_weight = GUN_TWO_HAND_ONLY
	w_class = WEIGHT_CLASS_BULKY
	cranking_time = 2 SECONDS // Basically costs nothing
	crank_stamina_cost = 10
	crank_sound = list(
		'sound/weapons/laserPump.ogg',
	)
	cell_type = /obj/item/stock_parts/cell/ammo/mfc/cranklasergun/tg/spamlaser
	ammo_type = list(/obj/item/ammo_casing/energy/cranklasergun/tg/spamlaser/shocker)
	init_recoil = AUTOCARBINE_RECOIL(1.5, 1.2)
	init_firemodes = list(
	/datum/firemode/automatic/rpm150,
	/datum/firemode/semi_auto,
	)

/obj/item/ammo_casing/energy/cranklasergun/tg/spamlaser/shocker
	projectile_type = /obj/item/projectile/beam/cranklasergun/tg/spamlaser/shocker
	e_cost = 83
	fire_sound = 'sound/weapons/taser.ogg'
	select_name = "kill"

/obj/item/projectile/beam/cranklasergun/tg/spamlaser/shocker //stronger spammy zaps
	name = "electrobolt"
	damage = 20
	damage_list = list("14" = 10, "16" = 10, "20" = 75, "25" = 5)
	recoil = BULLET_RECOIL_HEAVY_LASER
	tracer_type = /obj/effect/projectile/tracer/pulse
	muzzle_type = /obj/effect/projectile/muzzle/pulse
	impact_type = /obj/effect/projectile/impact/pulse
	hitscan = TRUE
	hitscan_light_intensity = 4
	hitscan_light_range = 1
	hitscan_light_color_override = LIGHT_COLOR_BLUE
	muzzle_flash_intensity = 9
	muzzle_flash_range = 4
	muzzle_flash_color_override = LIGHT_COLOR_BLUE
	impact_light_intensity = 8
	impact_light_range = 3.75
	impact_light_color_override = LIGHT_COLOR_BLUE
