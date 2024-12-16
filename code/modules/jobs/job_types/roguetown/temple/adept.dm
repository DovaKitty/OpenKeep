/datum/job/roguetown/adept
	title = "Adept"
	flag = ADEPT
	department_flag = TEMPLE
	faction = "Station"
	total_positions = 2
	spawn_positions = 2

	allowed_races = list(
		"Humen",
		"Elf",
		"Half-Elf",
		"Dwarf",
		"Dark Elf",
		"Aasimar"
	)
	allowed_sexes = list(MALE, FEMALE)
	tutorial = "You were a convicted criminal, the lowest scum of Rockhill. Your master, the Inquisitor, saved you from the gallows and has given you true purpose in service to the Forgotten God. You will not let him down."

	outfit = /datum/outfit/job/roguetown/adept
	advclass_cat_rolls = list(CTAG_ADEPT = 20)
	display_order = JDO_ADEPT
	bypass_lastclass = TRUE
	min_pq = 0

/datum/outfit/job/roguetown/adept
	name = "Adept"
	jobtype = /datum/job/roguetown/adept

// Brutal Zealot, a class balanced to town guard, with 1 more strength but less intelligence and perception. Axe/Mace and shield focus.
/datum/advclass/adept/bzealot
	name = "Brutal Zealot"
	tutorial = "You are a former thug who has been given a chance to redeem yourself by the Inquisitor. You serve him and the Forgotten God with your physical strength and zeal."
	outfit = /datum/outfit/job/roguetown/adept/bzealot

	category_tags = list(CTAG_ADEPT)
	maximum_possible_slots = 2

/datum/outfit/job/roguetown/adept/bzealot/pre_equip(mob/living/carbon/human/H)
	..()
	H.set_patron(/datum/patron/forgotten)

	//Armor for class
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
	belt = /obj/item/storage/belt/rogue/leather
	cloak = /obj/item/clothing/cloak/tabard/adept
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/trou/leather
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	mask = /obj/item/clothing/mask/rogue/facemask
	wrists = /obj/item/clothing/neck/roguetown/psycross/silver
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	beltl = /obj/item/rogueweapon/mace/spiked
	backr = /obj/item/rogueweapon/shield/wood/adept
	gloves = /obj/item/clothing/gloves/roguetown/leather
	backpack_contents = list(/obj/item/keyring/shepherd = 1, /obj/item/rogueweapon/knife/dagger/silver = 1)

	//Stats for class
	H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/firearms, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
	H.change_stat("strength", 2)
	H.change_stat("intelligence", -2)
	H.change_stat("endurance", 1)
	H.change_stat("constitution", 1)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_KNOWBANDITS, TRAIT_GENERIC)

// Reformed Thief, a class balanced to rogue. Axe and crossbow focus.
/datum/advclass/adept/rthief
	name = "Reformed Thief"
	tutorial = "You are a former thief who has been given a chance to redeem yourself by the Inquisitor. You serve him and the Forgotten God with your stealth and cunning."
	outfit = /datum/outfit/job/roguetown/adept/rthief

	category_tags = list(CTAG_ADEPT)
	maximum_possible_slots = 2

/datum/outfit/job/roguetown/adept/rthief/pre_equip(mob/living/carbon/human/H)
	..()
	H.set_patron(/datum/patron/forgotten)
	//Armor for class
	armor = /obj/item/clothing/suit/roguetown/armor/leather/splint
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/clothing/neck/roguetown/gorget
	beltl = /obj/item/rogueweapon/mace/cudgel
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/trou/leather
	wrists = /obj/item/clothing/neck/roguetown/psycross/silver
	mask = /obj/item/clothing/mask/rogue/facemask
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	backl = /obj/item/quiver/bolts
	pants = /obj/item/clothing/under/roguetown/trou/leather
	cloak = /obj/item/clothing/cloak/raincloak/brown
	backpack_contents = list(/obj/item/lockpick = 1, /obj/item/keyring/shepherd = 1, /obj/item/rogueweapon/knife/dagger/silver = 1)

	//Stats for class
	H.mind.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/climbing, 5, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/sneaking, 4, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/stealing, 4, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/lockpicking, 4, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/firearms, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/craft/traps, 2, TRUE)
	H.change_stat("strength", -1)
	H.change_stat("perception", 2)
	H.change_stat("speed", 2)
	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_KNOWBANDITS, TRAIT_GENERIC)

/datum/advclass/adept/nun
	name = "Forgotten Sister"
	tutorial = "You are a former thug who has been given a chance to redeem yourself by the Inquisitor. You serve him and the Forgotten God with your physical strength and zeal."
	outfit = /datum/outfit/job/roguetown/adept/nun

	category_tags = list(CTAG_ADEPT)
	maximum_possible_slots = 2

/datum/outfit/job/roguetown/adept/nun/pre_equip(mob/living/carbon/human/H)
	..()
	H.set_patron(/datum/patron/forgotten)

	//Armor for class
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
	head = /obj/item/clothing/head/roguetown/helmet/battlenun
	neck = /obj/item/clothing/neck/roguetown/psycross/silver
	cloak = /obj/item/clothing/cloak/stabard/battlenun
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	backr = /obj/item/rogueweapon/mace/goden/steel

	backpack_contents = list(/obj/item/keyring/shepherd = 1, /obj/item/rogueweapon/knife/dagger/silver = 1)

	//Stats for class
	H.mind.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
	H.mind.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
	H.mind.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
	H.change_stat("strength", 1)
	H.change_stat("intelligence", 1)
	H.change_stat("constitution", 1)
	H.change_stat("endurance", 2)
	H.change_stat("speed", -1)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_KNOWBANDITS, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_MUTE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_ANTIMAGIC, TRAIT_GENERIC)
	H.virginity = TRUE

/datum/outfit/job/roguetown/adept/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		if(H.mind.has_antag_datum(/datum/antagonist))
			return
		var/datum/antagonist/new_antag = new /datum/antagonist/purishep()
		H.mind.add_antag_datum(new_antag)
		H.set_patron(/datum/patron/forgotten)
		H.verbs |= /mob/living/carbon/human/proc/torture_victim

/datum/job/roguetown/adept/after_spawn(mob/living/carbon/human/H, mob/M, latejoin = TRUE)
	..()
	if(H)
		H.advsetup = 1
		H.invisibility = INVISIBILITY_MAXIMUM
		H.become_blind("advsetup")
