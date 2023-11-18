

///Places SOMETHING near one of the valid landmarks. SOMETHING can be whatever you want. It could even be a spawner that spawns more than one thing :o
/datum/round_event/random_drop
	startWhen = 10 //Give players a few minutes to prep. Maybe randomize this on New()
	announceWhen = 1 //Almost right away
	fakeable = FALSE //that wouldn't be very fun
	/// This is the SOMETHING that will be placed near the landmark
	var/spawntype
	/// This is how large of an explosion should appear before the drop is spawned.
	var/explosion_size
	/// Our SOMETHING can spawn up to this far away from our landmark.
	var/drop_precision = 3
	/// This drop will only happen at these landmark types.
	var/suitable_landmarks = list()
	/// If TRUE, only players with PDAs will receive these alerts
	var/require_pda_for_alerts = TRUE
	/// Message to send to every player who has a PDA
	var/alert_message
	/// Sound to play to every player who has a PDA
	var/alert_sound
