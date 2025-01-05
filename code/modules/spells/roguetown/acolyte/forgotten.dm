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

/obj/effect/proc_holder/spell/invoked/aura_silence/proc/on_activation(mob/living/user)
	user.visible_message("<span class='warning'>[user] makes the sign of the Psycross, a silent dread pulses from them!</span>",
							"<span class='notice'>I make the sign of the Psycross, my inner peace is focused outwards!</span>")
	if(!cast_check(0, user))
		// If they have no devotion left or are blocked
		deactivate(user)
		return

	// If they pass the normal cast check, we do an initial devotion consume:
	if(!consume_devotion_once(user))
		deactivate(user)
		return

/obj/effect/proc_holder/spell/invoked/aura_silence/proc/on_deactivation(mob/living/user)
	user.visible_message("<span class='notice'>[user] gathers the silence into themselves once more...</span>",
							"<span class='notice'>I bind the silence to my soul once more....</span>")

/obj/effect/proc_holder/spell/invoked/aura_silence/proc/process()
	// If we’re not active or have no caster, do nothing.
	if(!active || !ranged_ability_user)
		return

	var/mob/living/carbon/human/caster = ranged_ability_user
	// Safety check: if the caster is gone or not a human, end.
	if(!caster)
		deactivate(null)
		return

	// If enough ticks have passed for our next cycle, do the devotion drain & AoE silence
	if(world.time >= last_cycle + devotion_cycle_time)
		last_cycle = world.time

		// Attempt to drain devotion
		if(!drain_ongoing_devotion(caster))
			// Not enough devotion. End the spell
			caster.visible_message("<span class='notice'>[caster] grows visibly weary as the silence reccedes.</span>",
									"<span class='danger'>I can’t sustain the silence any longer!</span>")
			deactivate(caster)
			return

		// Silence everything in range again
		for(var/mob/living/carbon/human/M in range(range, caster))
			if(M != caster)
				// Re-apply silence for N seconds so it’s effectively continuous
				M.set_silence(5 SECONDS)

/obj/effect/proc_holder/spell/invoked/aura_silence/proc/consume_devotion_once(mob/living/carbon/human/caster)
	var/datum/devotion/cleric_holder/D = caster?.cleric
	if(!D)
		return FALSE
	// Check if the caster has enough devotion
	if(!D.check_devotion(devotion_cost))
		to_chat(caster, "<span class='warning'>I don't have enough devotion to invoke this silence aura!</span>")
		return FALSE
	// If they do, consume it
	D.consume_devotion(devotion_cost)
	return TRUE

/obj/effect/proc_holder/spell/invoked/aura_silence/proc/drain_ongoing_devotion(mob/living/carbon/human/caster)
	var/datum/devotion/cleric_holder/D = caster?.cleric
	if(!D)
		return FALSE
	if(!D.check_devotion(devotion_drain_rate))
		// Not enough devotion left to keep going
		return FALSE
	D.consume_devotion(devotion_drain_rate)
	return TRUE
