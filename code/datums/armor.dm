#define ARMORID "armor-[tier]-[linemelee]-[linebullet]-[linelaser]-[melee]-[bullet]-[laser]-[energy]-[bomb]-[bio]-[rad]-[fire]-[acid]-[magic]-[wound]-[damage_threshold]"

GLOBAL_LIST_INIT(armor_tierline, list(25, 50, 75, 100, 125, 150, 200, 250, 300, 350, 400, 500, 600))

/proc/getArmor(tier = 0, linemelee = 0, linebullet = 0, linelaser = 0, melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0, fire = 0, acid = 0, magic = 0, wound = 0, damage_threshold = 0)
	. = locate(ARMORID)
	if (!.)
		. = new /datum/armor(tier, linemelee, linebullet, linelaser, melee, bullet, laser, energy, bomb, bio, rad, fire, acid, magic, wound, damage_threshold)

/datum/armor
	datum_flags = DF_USE_TAG
	var/tier  //1 to 11. Tier 1 - thin clothing, 2 - thick clothing , 3 - armored jackets, 4 - low quality/light armor, 5 - medium qual armor, 6 - medium high, 7 - high, 8 - exceptional/low qual PA, 9 - t45, 10 - t51, 11 - t60
	var/linemelee
	var/linebullet
	var/linelaser
	var/melee
	var/bullet
	var/laser
	var/energy
	var/bomb
	var/bio
	var/rad
	var/fire
	var/acid
	var/magic
	var/wound
	var/damage_threshold

/datum/armor/New(tier = 0, linemelee = 0, linebullet = 0, linelaser = 0, melee = 0, bullet = 0, laser = 0,  energy = 0, bomb = 0, bio = 0, rad = 0, fire = 0, acid = 0, magic = 0, wound = 0, damage_threshold = 0)

	if(tier) //ASSIGNS ARMOR VALUES BASED ON TIER, IT WILL USE ARMOR VALUES INSTEAD OF THE TIER FOR THAT VALUE IF THE ARMOR VALUE IS PRESENT
		linemelee = linemelee+GLOB.armor_tierline[tier] //If an armor has a tier value, having a linemelee value will add onto that tier value rather than replace it.
		linebullet = linebullet+GLOB.armor_tierline[tier]
		linelaser = linelaser+GLOB.armor_tierline[tier]
		wound = wound+(tier*5)

	src.linemelee = linemelee
	src.linebullet = linebullet
	src.linelaser = linelaser
	src.energy = energy
	src.bomb = clamp(bomb, 0, ARMOR_CAP_BOMB)
	src.bio = clamp(bio, 0, ARMOR_CAP_BIO)
	src.rad = clamp(rad, 0, ARMOR_CAP_RAD)
	src.fire = clamp(fire, 0, ARMOR_CAP_FIRE)
	src.acid = clamp(acid, 0, ARMOR_CAP_ACID)
	src.magic = clamp(magic, 0, ARMOR_CAP_MAGIC)
	src.wound = clamp(wound, 0, ARMOR_CAP_WOUND)
	src.damage_threshold = clamp(damage_threshold, 0, ARMOR_CAP_DT)
//DESERT ROSE 2 LINEARMOR EXPLAINED: Heavily influenced by this Skyrim mod https://www.nexusmods.com/skyrim/mods/15860 % damage reduction is exponential (E.G. 90 doubles the effective health increase of 80).
//Linearmor is linear (so 100 armor is twice 50). Linearmor will never equal 100 armor. If a mob were to have 100 health, each point of linearmor would be the equivalent to +1 effective health. For example, 100 linearmor = 200 effective health or 50% damage reduction.
	src.melee = round(100*linemelee/(abs(linemelee)+100), 0.5) || melee
	src.bullet = round(100*linebullet/(abs(linebullet)+100), 0.5) || bullet
	src.laser = round(100*linelaser/(abs(linelaser)+100), 0.5) || laser

	src.tier = 0
	tag = ARMORID

/datum/armor/proc/modifyRating(tier = 0, linemelee = 0, linebullet = 0, linelaser = 0, melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0, fire = 0, acid = 0, magic = 0, wound = 0, damage_threshold = 0)
	return getArmor(tier, src.linemelee+linemelee, src.linebullet+linebullet, src.linelaser+linelaser, src.melee+melee, src.bullet+bullet, src.laser+laser, src.energy+energy, src.bomb+bomb, src.bio+bio, src.rad+rad, src.fire+fire, src.acid+acid, src.magic+magic, src.wound+wound, src.damage_threshold+damage_threshold)

/datum/armor/proc/modifyAllRatings(modifier = 0)
	return getArmor(tier, linemelee+modifier, linebullet+modifier, linelaser+modifier, melee, bullet, laser, energy+modifier, bomb+modifier, bio+modifier, rad+modifier, fire+modifier, acid+modifier, magic+modifier, wound+modifier, damage_threshold+modifier)

/datum/armor/proc/setRating(tier, linemelee, linebullet, linelaser, melee, bullet, laser, energy, bomb, bio, rad, fire, acid, magic, wound)
	return getArmor((isnull(tier) ? src.tier : tier),\
					(isnull(linemelee) ? src.linemelee : linemelee),\
					(isnull(linebullet) ? src.linebullet : linebullet),\
					(isnull(linelaser) ? src.linelaser : linelaser),\
					(isnull(melee) ? src.melee : melee),\
					(isnull(bullet) ? src.bullet : bullet),\
					(isnull(laser) ? src.laser : laser),\
					(isnull(energy) ? src.energy : energy),\
					(isnull(bomb) ? src.bomb : bomb),\
					(isnull(bio) ? src.bio : bio),\
					(isnull(rad) ? src.rad : rad),\
					(isnull(fire) ? src.fire : fire),\
					(isnull(acid) ? src.acid : acid),\
					(isnull(magic) ? src.magic : magic),\
					(isnull(wound) ? src.wound : wound),\
					(isnull(damage_threshold) ? src.damage_threshold : damage_threshold))

/datum/armor/proc/getRating(rating)
	return vars[rating]

/datum/armor/proc/getList()
	return list("tier" = tier, "linemelee" = linemelee, "linebullet" = linebullet, "linelaser" = linelaser, "melee" = melee, "bullet" = bullet, "laser" = laser, "energy" = energy, "bomb" = bomb, "bio" = bio, "rad" = rad, "fire" = fire, "acid" = acid, "magic" = magic, "wound" = wound, "damage_threshold" = damage_threshold)

/datum/armor/proc/attachArmor(datum/armor/AA)
	return getArmor(tier, linemelee+AA.linemelee, linebullet+AA.linebullet, linelaser+AA.linelaser, melee+AA.melee, bullet+AA.bullet, laser+AA.laser, energy+AA.energy, bomb+AA.bomb, bio+AA.bio, rad+AA.rad, fire+AA.fire, acid+AA.acid, magic+AA.magic, wound+AA.wound, damage_threshold+AA.damage_threshold)

/datum/armor/proc/detachArmor(datum/armor/AA)
	return getArmor(tier, linemelee-AA.linemelee, linebullet-AA.linebullet, linelaser-AA.linelaser, melee+AA.melee, bullet+AA.bullet, laser+AA.laser, energy-AA.energy, bomb-AA.bomb, bio-AA.bio, rad-AA.rad, fire-AA.fire, acid-AA.acid, magic-AA.magic, wound-AA.wound, damage_threshold-AA.damage_threshold)

/datum/armor/vv_edit_var(var_name, var_value)
	if (var_name == NAMEOF(src, tag))
		return FALSE
	. = ..()
	tag = ARMORID // update tag in case armor values were edited

#undef ARMORID
