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

/obj/effect/proc_holder/spell/aoe_turf/silence_aura
	name = "Aura of Silence"
	desc = "Creates a field of magical silence around you, muting all within its radius."
	charge_max = 300
	clothes_req = TRUE
	antimagic_allowed = TRUE
	req_inhand = /obj/item/clothing/neck/roguetown/psycross/silver
	invocation_type = "none"
	range = 7
	cooldown_min = 5
	action_icon_state = "silence"
	var/silence_range = 7
	var/silence_duration = 100
	devotion_cost = 30
	associated_skill = /datum/skill/magic/holy
	sound = 'sound/magic/silence.ogg'

/obj/effect/proc_holder/spell/aoe_turf/silence_aura/cast(list/targets, mob/user = usr)
	. = ..()
	user.visible_message("<span class='warning'>[user] makes the sign of the Psycross with their hands, emanating a dreaded aura!</span>","<span class='warning'>I make the sign of the Psycross with my hands, letting the truth of silence spill from my soul.</span>")
	new /obj/effect/silence_field(get_turf(user), silence_range, silence_duration, list(user))

// The actual silence field effect
/obj/effect/silence_field
	anchored = TRUE
	name = "silence field"
	desc = "A field of magical silence."
	icon = 'icons/effects/160x160.dmi'
	icon_state = "silence"
	layer = FLY_LAYER
	pixel_x = -64
	pixel_y = -64
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/list/immune = list()
	var/turf/target
	var/freezerange = 2
	var/duration = 100
	var/datum/proximity_monitor/advanced/silence_field/silencefield
	alpha = 125

/obj/effect/silence_field/Initialize(mapload, radius, time, list/immune_atoms, start = TRUE)
	. = ..()
	if(!isnull(time))
		duration = time
	if(!isnull(radius))
		freezerange = radius
	for(var/A in immune_atoms)
		immune[A] = TRUE
	if(start)
		INVOKE_ASYNC(src, PROC_REF(start_silence))

/obj/effect/silence_field/Destroy()
	qdel(silencefield)
	playsound(src, 'sound/magic/silence_end.ogg', 50, TRUE)
	return ..()

/obj/effect/silence_field/proc/start_silence()
	target = get_turf(src)
	playsound(src, 'sound/magic/silence_start.ogg', 50, TRUE)
	silencefield = make_field(/datum/proximity_monitor/advanced/silence_field, list("current_range" = freezerange, "host" = src, "immune" = immune, "duration" = duration))
	QDEL_IN(src, duration)

// The proximity monitor that handles the actual silencing effect
/datum/proximity_monitor/advanced/silence_field
	name = "silence field"
	setup_field_turfs = TRUE
	field_shape = FIELD_SHAPE_RADIUS_SQUARE
	requires_processing = TRUE
	var/list/immune = list()
	var/list/silenced_things = list()
	var/list/silenced_mobs = list()
	var/duration = 100 // Default duration

/datum/proximity_monitor/advanced/silence_field/Destroy()
	unsilence_all()
	return ..()

/datum/proximity_monitor/advanced/silence_field/field_turf_crossed(atom/movable/AM)
	silence_atom(AM)

/datum/proximity_monitor/advanced/silence_field/proc/silence_atom(atom/movable/A)
	if(immune[A] || !istype(A))
		return FALSE
	if(isliving(A))
		silence_mob(A)
		into_the_negative_zone(A)
	return TRUE

/datum/proximity_monitor/advanced/silence_field/proc/unsilence_all()
	for(var/mob/living/M in silenced_mobs)
		unsilence_mob(M)
		escape_the_negative_zone(M)

/datum/proximity_monitor/advanced/silence_field/proc/silence_mob(mob/living/L)
	if(!(L in silenced_mobs))
		silenced_mobs += L
		L.set_silence(duration)
		L.set_deafened(duration)
		to_chat(L, "<span class='danger'>I can't move my mouth! Where are the colors!?</span>")

/datum/proximity_monitor/advanced/silence_field/proc/unsilence_mob(mob/living/L)
	silenced_mobs -= L
	L.set_silence(1)
	L.set_deafened(1)

/datum/proximity_monitor/advanced/silence_field/proc/into_the_negative_zone(atom/A)
	A.add_atom_colour(list(-1,0,0,0, 0,-1,0,0, 0,0,-1,0, 0,0,0,1, 1,1,1,0), TEMPORARY_COLOUR_PRIORITY)

/datum/proximity_monitor/advanced/silence_field/proc/escape_the_negative_zone(atom/A)
	A.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY)
