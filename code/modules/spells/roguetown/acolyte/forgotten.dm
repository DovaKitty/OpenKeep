/obj/effect/proc_holder/spell/invoked/gag
	name = "Gag"
	overlay_state = "gag"
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

/obj/effect/proc_holder/spell/invoked/aura_silence
	name = "Aura of Silence"
	overlay_state = "aura_silence"
	invocation_type = "none"
	sound = 'sound/magic/churn.ogg'
	active_sound = 'sound/magic/chimes.ogg'
	range = 7
	miracle = TRUE
	devotion_cost = 10

	var/devotion_drain_rate = 2
	var/devotion_cycle_time = 30
	var/last_cycle = 0
	var/list/greyscaled_atoms = list()

/obj/effect/proc_holder/spell/invoked/aura_silence/proc/on_activation(mob/living/user)
	user.visible_message("<span class='warning'>[user] makes the sign of the Psycross, a silent dread pulses from them!</span>",
						 "<span class='notice'>I make the sign of the Psycross, my inner peace is focused outwards!</span>")

	if(!cast_check(0, user))
		deactivate(user)
		return

	if(!consume_devotion_once(user))
		deactivate(user)
		return

	// Immediately apply silence and greyscale to everything in range
	apply_silence_and_greyscale(user)

/obj/effect/proc_holder/spell/invoked/aura_silence/proc/on_deactivation(mob/living/user)
	user.visible_message("<span class='notice'>[user] gathers the silence into themselves once more...</span>",
						 "<span class='notice'>I bind the silence to my soul once more....</span>")

	// Remove greyscale from everything we tinted
	for(var/atom/movable/A in greyscaled_atoms)
		from_greyscale(A)
	greyscaled_atoms.Cut()

/obj/effect/proc_holder/spell/invoked/aura_silence/proc/process()
	if(!active || !ranged_ability_user)
		return

	var/mob/living/carbon/human/caster = ranged_ability_user

	if(!caster)
		deactivate(null)
		return

	if(world.time >= last_cycle + devotion_cycle_time)
		last_cycle = world.time

		if(!drain_ongoing_devotion(caster))
			caster.visible_message("<span class='notice'>[caster] grows visibly weary as the silence recedes.</span>",
								   "<span class='danger'>I can’t sustain the silence any longer!</span>")
			deactivate(caster)
			return

		// Re-apply silence + greyscale to all in range
		apply_silence_and_greyscale(caster)

		// Remove greyscale from any who left the aura range
		remove_greyscale_if_out_of_range(caster)


/obj/effect/proc_holder/spell/invoked/aura_silence/proc/apply_silence_and_greyscale(mob/living/carbon/human/caster)
	// Silence all carbon/human mobs in range for 5 seconds
	for(var/mob/living/carbon/human/M in range(range, caster))
		if(M != caster)
			M.set_silence(5 SECONDS)

	// Greyscale all *atoms* in range
	for(var/atom/movable/A in range(range, caster))
		if(!(A in greyscaled_atoms))
			to_greyscale(A)
			greyscaled_atoms += A

/obj/effect/proc_holder/spell/invoked/aura_silence/proc/remove_greyscale_if_out_of_range(mob/living/carbon/human/caster)
	var/list/to_remove = list()
	for(var/atom/movable/A in greyscaled_atoms)
		if(get_dist(caster, A) > range)
			from_greyscale(A)
			to_remove += A

	for(var/atom/movable/A in to_remove)
		greyscaled_atoms.Remove(A)

/obj/effect/proc_holder/spell/invoked/aura_silence/proc/to_greyscale(atom/movable/A)
	A.add_atom_colour(list(
		0.3, 0.59, 0.11, 0, 0,
		0.3, 0.59, 0.11, 0, 0,
		0.3, 0.59, 0.11, 0, 0,
		0,   0,    0,    1, 0,
		0,   0,    0,    0, 1
	), 30)

/obj/effect/proc_holder/spell/invoked/aura_silence/proc/from_greyscale(atom/movable/A)
	A.remove_atom_colour(30)

/obj/effect/proc_holder/spell/invoked/aura_silence/proc/consume_devotion_once(mob/living/carbon/human/caster)
	var/datum/devotion/cleric_holder/D = caster?.cleric
	if(!D)
		return FALSE

	if(!D.check_devotion(devotion_cost))
		to_chat(caster, "<span class='warning'>I don't have enough devotion to invoke this silence aura!</span>")
		return FALSE

	D.consume_devotion(devotion_cost)
	return TRUE

/obj/effect/proc_holder/spell/invoked/aura_silence/proc/drain_ongoing_devotion(mob/living/carbon/human/caster)
	var/datum/devotion/cleric_holder/D = caster?.cleric
	if(!D)
		return FALSE

	if(!D.check_devotion(devotion_drain_rate))
		return FALSE

	D.consume_devotion(devotion_drain_rate)
	return TRUE
