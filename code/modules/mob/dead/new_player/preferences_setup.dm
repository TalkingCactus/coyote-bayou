
	//The mob should have a gender you want before running this proc. Will run fine without H
/datum/preferences/proc/random_character(gender_override)
	if(gender_override)
		gender = gender_override
	else
		gender = MALE
	underwear = "Boxers"
	undie_color = random_clothing_dye()
	undershirt = "Shirt - Short Sleeved"
	shirt_color = random_clothing_dye()
	socks = "Short"
	socks_color = random_clothing_dye()
	use_custom_skin_tone = FALSE
	skin_tone = pick("latino", "mediterranean")
	hair_style = pick("Trimmed", "Fade (Low)")
	facial_hair_style = pick("Beard (5 o\'Clock)", "Beard (3 o\'Clock)")
	hair_color = random_hair_shade()
	facial_hair_color = random_hair_shade()
	left_eye_color = random_dark_shade()
	right_eye_color = random_dark_shade()
	age = (rand(20, 25))

/// Like random character, except it's not random. Doesn't actually save or load any slots, just cleans the current one.
/datum/preferences/proc/wipe_character()
	undie_color = initial(undie_color)
	underwear = initial(underwear)

	shirt_color = initial(shirt_color)
	undershirt = initial(undershirt)

	socks_color = initial(socks_color)
	socks = initial(socks)

	backbag = initial(backbag)
	jumpsuit_style = initial(jumpsuit_style)

	hair_style = initial(hair_style)
	hair_color = initial(hair_color)
	facial_hair_style = initial(facial_hair_style)
	facial_hair_color = initial(facial_hair_color)

	skin_tone = initial(skin_tone)
	use_custom_skin_tone = initial(use_custom_skin_tone)

	left_eye_color = initial(left_eye_color)
	right_eye_color = initial(right_eye_color)
	eye_type = initial(eye_type)
	split_eye_colors = initial(split_eye_colors)

	tbs = initial(tbs)
	kisser = initial(kisser)
	pref_species = initial(pref_species)

	//Main character features list
	features = initial(features)

	custom_speech_verb = initial(custom_speech_verb)
	custom_tongue = initial(custom_tongue)
	modified_limbs = initial(modified_limbs)
	chosen_limb_id = initial(chosen_limb_id)

	security_records = initial(security_records)
	medical_records = initial(medical_records)

	creature_species = initial(creature_species)
	creature_name = initial(creature_name)
	creature_flavor_text = initial(creature_flavor_text)
	creature_ooc = initial(creature_ooc)
	creature_image = initial(creature_image)
	creature_profilepic = initial(creature_profilepic)
	creature_pfphost = initial(creature_pfphost)
	creature_body_size = initial(creature_body_size)
	creature_fuzzy = initial(creature_fuzzy)

	char_quirks = initial(char_quirks)
	all_quirks = initial(all_quirks)

	job_preferences = initial(job_preferences)
	joblessrole = initial(joblessrole)
	
	exp = initial(exp)
	chosen_gear = initial(chosen_gear)
	loadout_data = initial(loadout_data)

	special_s = initial(special_s)
	special_p = initial(special_p)
	special_e = initial(special_e)
	special_c = initial(special_c)
	special_i = initial(special_i)
	special_a = initial(special_a)
	special_l = initial(special_l)

	custom_pixel_x = initial(custom_pixel_x)
	custom_pixel_y = initial(custom_pixel_y)

	permanent_tattoos = initial(permanent_tattoos)
	matchmaking_prefs = initial(matchmaking_prefs)

	fuzzy = initial(fuzzy)

	waddle_amount = initial(waddle_amount)
	up_waddle_time = initial(up_waddle_time)
	side_waddle_time = initial(side_waddle_time)

/datum/preferences/proc/update_preview_icon(current_tab)
	var/equip_job = TRUE
	switch(current_tab)
		if(APPEARANCE_TAB)
			equip_job = FALSE
		if(ERP_TAB)
			equip_job = FALSE
	// Determine what job is marked as 'High' priority, and dress them up as such.
	var/datum/job/previewJob = get_highest_job()

	if(previewJob)
		// Silicons only need a very basic preview since there is no customization for them.
		if(istype(previewJob,/datum/job/ai))
			parent.show_character_previews(image('icons/mob/ai.dmi', icon_state = resolve_ai_icon(preferred_ai_core_display), dir = SOUTH))
			return
		if(istype(previewJob,/datum/job/cyborg))
			parent.show_character_previews(image('icons/mob/robots.dmi', icon_state = "robot", dir = SOUTH))
			return

	// Set up the dummy for its photoshoot
	var/mob/living/carbon/human/dummy/mannequin = SSdummy.get_a_dummy()
	// Apply the Dummy's preview background first so we properly layer everything else on top of it.
	mannequin.add_overlay(mutable_appearance('modular_citadel/icons/ui/backgrounds.dmi', bgstate, layer = SPACE_LAYER))
	copy_to(mannequin, initial_spawn = TRUE)

	if(current_tab == LOADOUT_TAB)
		//give it its loadout if not on the appearance tab
		SSjob.equip_loadout(parent.mob, mannequin, FALSE, bypass_prereqs = TRUE, can_drop = FALSE)
	else
		if(previewJob && equip_job)
			mannequin.job = previewJob.title
			previewJob.equip(mannequin, TRUE, preference_source = parent)

	mannequin.cut_overlays()
	mannequin.regenerate_icons()
	COMPILE_OVERLAYS(mannequin)

	parent.show_character_previews(new /mutable_appearance(mannequin))
	SSdummy.return_dummy(mannequin)

/datum/preferences/proc/get_highest_job()
	var/highest_pref = 0
	var/datum/job/highest_job
	for(var/job in job_preferences)
		if(job_preferences["[job]"] > highest_pref)
			highest_job = SSjob.GetJob(job)
			highest_pref = job_preferences["[job]"]
	return highest_job
