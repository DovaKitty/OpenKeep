/obj/effect/proc_holder/spell/invoked/gag
	name = "Gag"
	overlay_state = "love"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 7
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/churn.ogg'
	invocation_type = "none" //can be none, whisper, emote and shout
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	charge_max = 15 SECONDS
	devotion_cost = 30

/obj/effect/proc_holder/spell/invoked/gag/cast(list/targets, mob/user = usr)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		target.visible_message("<span class='warning'>[user] raises a finger to their lips while looking at [target]!</span>","<span class='warning'>My mouth is not opening!</span>")
		target.set_silence(15 SECONDS)
	return TRUE
/*
/obj/effect/proc_holder/spell/self/aura_silence
	name = "Aura of Silence"
	overlay_state = "bestialsense"
	charge_max = 12 MINUTES
	req_items = list(/obj/item/clothing/neck/roguetown/psycross/silver)
	invocation_type = "none"
	cooldown_min = 1 MINUTES
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	releasedrain = 15

/obj/effect/proc_holder/spell/self/aura_silence/cast(list/targets,mob/living/user = usr)

	user.visible_message(
	"<span class='warning'>[user] makes the sign of the Psycross, a silent dread pulses from them!</span>",
	"<span class='notice'>I make the sign of the Psycross, my inner peace is focused outwards!</span>"
	)
*/

/***************************************************************
 * Rewritten Aura of Silence -- Self Spell with 10-tick Checks
 ***************************************************************/

/obj/effect/proc_holder/spell/self/aura_silence
	name = "Aura of Silence"
	overlay_state = "bestialsense"
	charge_max = 12 MINUTES
	req_items = list(/obj/item/clothing/neck/roguetown/psycross/silver)
	invocation_type = "none"
	cooldown_min = 5
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	releasedrain = 15
	var/devotion_drain_rate = 2
	var/devotion_cycle_time = 30
	var/last_cycle = 0
	var/list/greyscaled_atoms = list()
	var/aura_range = 7

/obj/effect/proc_holder/spell/self/aura_silence/Initialize()
	. = ..()
	// Removed automatic processing start here for efficiency
	update_icon()

/obj/effect/proc_holder/spell/self/aura_silence/cast(list/targets, mob/living/user = usr)
	testing("Aura of Silence cast initiated.")
	. = ..()

	if(!active) {
		testing("Aura not active, activating now.")
		user.visible_message(
			"<span class='warning'>[user] makes the sign of the Psycross, a silent dread pulses from them!</span>",
			"<span class='notice'>I make the sign of the Psycross, my inner peace is focused outwards!</span>"
		)
		active = TRUE
		START_PROCESSING(SSfastprocess, src)  // Start processing loop on activation
		handle_silence_aura(user)
	} else {
		testing("Aura is active, deactivating now.")
		handle_aura_off(user)
	}
	return

\obj/effect/proc_holder/spell/self/aura_silence/proc/handle_aura_off(mob/living/user)
	testing("handle_aura_off called.")
	if(!active) {
		testing("Aura already inactive, returning.")
		return
	}

	user?.visible_message(
		"<span class='notice'>[user] gathers the silence into themselves once more...</span>",
		"<span class='notice'>I bind the silence to my soul once more....</span>"
	)

	for(var/atom/movable/A in greyscaled_atoms)
		from_greyscale(A)
	greyscaled_atoms.Cut()

	active = FALSE
	remove_ranged_ability()

	STOP_PROCESSING(SSfastprocess, src)  // Stop the processing loop when deactivating
	testing("Processing stopped and aura deactivated.")

\obj/effect/proc_holder/spell/self/aura_silence/process()
	testing("Process tick.")
	// Check if we should skip this tick (only proceed every 10 ticks)
	if(world.time % 10 != 0) {
		testing("Skipping this tick.")
		return
	}
	// If the aura isn’t on, or we have no user, do nothing
	if(!active || !ranged_ability_user) {
		testing("Process exiting: inactive or no user.")
		return
	}

	var/mob/living/carbon/human/caster = ranged_ability_user
	if(!caster) {
		testing("Caster not found, turning off aura.")
		handle_aura_off(null)
		return
	}

	// Check for devotion drain cycle
	if(world.time >= last_cycle + devotion_cycle_time) {
		testing("Time threshold reached, draining devotion.")
		last_cycle = world.time

		if(!drain_ongoing_devotion(caster)) {
			testing("Devotion insufficient, deactivating aura.")
			caster.visible_message(
				"<span class='notice'>[caster] grows visibly weary as the silence recedes.</span>",
				"<span class='danger'>I can’t sustain the silence any longer!</span>"
			)
			handle_aura_off(caster)
			return
		}
	}

	testing("Reapplying aura effects.")
	handle_silence_aura(caster)

\obj/effect/proc_holder/spell/self/aura_silence/proc/handle_silence_aura(mob/living/carbon/human/caster)
	testing("handle_silence_aura started.")
	// 1) Re-silence humans in range
	for(var/mob/living/carbon/human/M in range(aura_range, caster)) {
		if(M != caster) {
			testing("Silencing mob [M].")
			M.set_silence(5 SECONDS)
		}
	}

	// 2) Tint everything in range greyscale, if not already tinted
	for(var/atom/movable/A in range(aura_range, caster)) {
		if(!(A in greyscaled_atoms)) {
			testing("Applying greyscale to atom [A].")
			to_greyscale(A)
			greyscaled_atoms += A
		}
	}

	// 3) If anything is out of range, remove greyscale
	var/list/to_remove = list()
	for(var/atom/movable/OUT in greyscaled_atoms) {
		if(get_dist(caster, OUT) > aura_range) {
			testing("Removing greyscale from out-of-range atom [OUT].")
			from_greyscale(OUT)
			to_remove += OUT
		}
	}

	for(var/atom/movable/M in to_remove) {
		testing("Removing atom [M] from greyscaled_atoms list.")
		greyscaled_atoms -= M
	}

\obj/effect/proc_holder/spell/self/aura_silence/proc/to_greyscale(atom/movable/A)
	testing("to_greyscale called for [A].")
	A.add_atom_colour(
		list(
			0.3, 0.59, 0.11, 0, 0,
			0.3, 0.59, 0.11, 0, 0,
			0.3, 0.59, 0.11, 0, 0,
			0,   0,    0,    1, 0,
			0,   0,    0,    0, 1
		),
		30
	)

\obj/effect/proc_holder/spell/self/aura_silence/proc/from_greyscale(atom/movable/A)
	testing("from_greyscale called for [A].")
	A.remove_atom_colour(30)

\obj/effect/proc_holder/spell/self/aura_silence/proc/drain_ongoing_devotion(mob/living/carbon/human/caster)
	testing("Attempting to drain ongoing devotion.")
	var/datum/devotion/cleric_holder/D = caster?.cleric
	if(!D) {
		testing("No cleric datum found in drain_ongoing_devotion.")
		return FALSE
	}
	if(!D.check_devotion(devotion_drain_rate)) {
		testing("Not enough devotion for ongoing drain.")
		return FALSE
	}
	D.consume_devotion(devotion_drain_rate)
	testing("Devotion drained successfully.")
	return TRUE



/*
/obj/effect/proc_holder/spell/targeted/aura_silence
	name = "Aura of Silence"
	overlay_state = "love"
	invocation_type = "none"
	sound = 'sound/magic/churn.ogg'
	range = 7
	miracle = TRUE
	cast_without_targets = TRUE
	associated_skill = /datum/skill/magic/holy
	devotion_cost = -5
	charge_max = 300
	releasedrain = 30
	max_targets = 0

	// Additional variables for the aura
	var/devotion_drain_rate = 2
	var/devotion_cycle_time = 30
	var/last_cycle = 0
	var/list/greyscaled_atoms = list()

/obj/effect/proc_holder/spell/targeted/aura_silence/cast(list/targets, mob/living/user = usr)
	. = ..()
	user.visible_message(
		"<span class='warning'>[user] makes the sign of the Psycross, a silent dread pulses from them!</span>",
		"<span class='notice'>I make the sign of the Psycross, my inner peace is focused outwards!</span>"
	)

	apply_silence_and_greyscale(user)

	active = TRUE

/obj/effect/proc_holder/spell/targeted/aura_silence/deactivate(mob/living/user)
	if(active)
		// Show a message
		user?.visible_message(
			"<span class='notice'>[user] gathers the silence into themselves once more...</span>",
			"<span class='notice'>I bind the silence to my soul once more....</span>"
		)

		// Remove greyscale from everything we tinted
		for(var/atom/movable/A in greyscaled_atoms)
			from_greyscale(A)
		greyscaled_atoms.Cut()

	// Turn off the aura
	active = FALSE

	// Also remove the ability from the caster’s ranged_ability slot if necessary
	remove_ranged_ability()

/obj/effect/proc_holder/spell/targeted/aura_silence/process()
	// Only do something if it's active and there's a valid user
	if(!active || !ranged_ability_user)
		return

	var/mob/living/carbon/human/caster = ranged_ability_user
	if(!caster)
		deactivate(null)
		return

	// Check if it's time to drain devotion again
	if(world.time >= last_cycle + devotion_cycle_time)
		last_cycle = world.time

		// Attempt draining devotion from the caster each cycle
		if(!drain_ongoing_devotion(caster))
			caster.visible_message(
				"<span class='notice'>[caster] grows visibly weary as the silence recedes.</span>",
				"<span class='danger'>I can’t sustain the silence any longer!</span>"
			)
			deactivate(caster)
			return

		// Re-apply silence + greyscale to all in range
		apply_silence_and_greyscale(caster)

		// Remove greyscale from any who left the aura range
		remove_greyscale_if_out_of_range(caster)

	// the logic to greyscale local atoms, etc.
/obj/effect/proc_holder/spell/targeted/aura_silence/proc/apply_silence_and_greyscale(mob/living/carbon/human/caster)
	for(var/mob/living/carbon/human/M in range(range, caster))
		if(M != caster)
			M.set_silence(5 SECONDS)

	for(var/atom/movable/A in range(range, caster))
		if(!(A in greyscaled_atoms))
			to_greyscale(A)
			greyscaled_atoms += A

/obj/effect/proc_holder/spell/targeted/aura_silence/proc/remove_greyscale_if_out_of_range(mob/living/carbon/human/caster)
	var/list/to_remove = list()
	for(var/atom/movable/A in greyscaled_atoms)
		if(get_dist(caster, A) > range)
			from_greyscale(A)
			to_remove += A

	for(var/atom/movable/A in to_remove)
		greyscaled_atoms.Remove(A)

/obj/effect/proc_holder/spell/targeted/aura_silence/proc/to_greyscale(atom/movable/A)
	A.add_atom_colour(list(
		0.3, 0.59, 0.11, 0, 0,
		0.3, 0.59, 0.11, 0, 0,
		0.3, 0.59, 0.11, 0, 0,
		0,   0,    0,    1, 0,
		0,   0,    0,    0, 1
	), 30)

/obj/effect/proc_holder/spell/targeted/aura_silence/proc/from_greyscale(atom/movable/A)
	A.remove_atom_colour(30)

/obj/effect/proc_holder/spell/targeted/aura_silence/proc/drain_ongoing_devotion(mob/living/carbon/human/caster)
	var/datum/devotion/cleric_holder/D = caster?.cleric
	if(!D)
		return FALSE

	if(!D.check_devotion(devotion_drain_rate))
		return FALSE

	D.consume_devotion(devotion_drain_rate)
	return TRUE
*/
