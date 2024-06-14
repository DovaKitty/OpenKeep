/datum/component/stat
	var
		name // name of the stat, such as ST, DX, IQ, etc.
		base_value = 10 // Unless specified otherwise, what the stat starts at.
		min_value = 0 // The lowest the stat can go.
		max_value = 20 // The highest the stat can go.

	New(new_name, new_base_value, new_min_value = 1, new_max_value = 100)
		// Call the parent class's New proc
		..()

		// Initialize the stat with the provided values
		name = new_name
		base_value = new_base_value
		min_value = new_min_value
		max_value = new_max_value

	proc/get_total()
		return base_value

	proc/set_base(value)
		base_value = clamp(value, min_value, max_value)

	proc/change_base(value)
		base_value = clamp(base_value + value, min_value, max_value)

/datum/component/skill
	var
		name // name of the skill, such as "Sword" or "Fishing".
		level = 0 // The level of the skill, make sure to use integers and not strings.
		max_level = 6 // The highest the skill can go. 0 is default, 6 is the highest level, and is considered "legendary". Technically you could try higher, but it is not supported.
		exp = 0 // The experience the skill has. This is used to determine when the skill levels up. exp required is based on difficulty.
		stat // The stat that the skill is based on. Before being actually used, the associate stat factors into SL (skill level) calculation.
		difficulty // The difficulty of the skill. Used to determine how much exp is required to level up. Use "Easy", "Average" and "Hard".

	New(new_name, new_stat, new_difficulty)
		// Call the parent class's New proc
		..()

		// Initialize the skill with the provided values
		name = new_name
		stat = new_stat
		difficulty = new_difficulty

/mob/living
	var
		PATRON = null
		// Stats. Try not to add any more!
		stat_ST = new /datum/component/stat("ST", 10, 1, 100) // Size and strength of body. Determines HP, damage and carry weight. Not generally capped, monsters can have very large ST scores.
		stat_DX = new /datum/component/stat("DX", 10, 1, 20) // Dexterity and agility. Determines speed, accuracy and many skills. Capped at 20. Generally stronger than ST and HT.
		stat_IQ = new /datum/component/stat("IQ", 10, 1, 20) // Intelligence and magical ability. Determines learning speed and many skills, along with magical power. Capped at 20.
		stat_HT = new /datum/component/stat("HT", 10, 1, 20) // Health and resilience. Determines speed, stamina, recovery and resistance to disease. Capped at 20.
		stat_WIL = new /datum/component/stat("WIL", 10, 1, 20) // Willpower and mental strength. Determines resistance to mental attacks and stress. Capped at 20.
		stat_PER = new /datum/component/stat("PER", 10, 1, 20) // Perception and senses. Determines awareness and vision. Capped at 20.
		stat_SPD = new /datum/component/stat("SPD", 0, -3, 3) // Speed and reflexes. Determines how fast you can move and react. Real stat is calculated elsewhere, this is a bonus ranging between -3 and 3. Rare to see this changed.
		stat_LUC = new /datum/component/stat("LUC", 0, -3, 3) // The favor of gods and fate itself. Hard to acquire, positive luck increases critical success range, while negative luck increases critical failure range. Ranges between -3 and 3.
		// Weapon skills
		skill_Knife = new /datum/component/skill("Knife", "stat_DX", "Easy")
		skill_Sword = new /datum/component/skill("Sword", "stat_DX", "Average")
		skill_Polearm = new /datum/component/skill("Polearm", "stat_DX", "Average")
		skill_Axe_Mace = new /datum/component/skill("Axe/Mace", "stat_DX", "Average")
		skill_Whip_Flail = new /datum/component/skill("Whip/Flail", "stat_DX", "Hard")
		skill_Bow = new /datum/component/skill("Bow", "stat_DX", "Average")
		skill_Crossbow = new /datum/component/skill("Crossbow", "stat_DX", "Easy")
		skill_Wrestling = new /datum/component/skill("Wrestling", "stat_DX", "Average")
		skill_Brawling = new /datum/component/skill("Brawling", "stat_DX", "Easy") // Unarmed combat, punching and kicking. Also for saps and blackjacks.
		skill_Shield = new /datum/component/skill("Shield", "stat_DX", "Easy")
		// Crafting skills
		skill_Weaponsmith = new /datum/component/skill("Weaponsmith", "stat_IQ", "Average")
		skill_Armorsmith = new /datum/component/skill("Armorsmith", "stat_IQ", "Average")
		skill_Blacksmith = new /datum/component/skill("Blacksmith", "stat_IQ", "Average")
		skill_Carpentry = new /datum/component/skill("Carpentry", "stat_IQ", "Easy")
		skill_Masonry = new /datum/component/skill("Masonry", "stat_IQ", "Easy")
		skill_Traps = new /datum/component/skill("Traps", "stat_IQ", "Average") // Making and disarming traps. Use PER for spotting traps.
		skill_Cooking = new /datum/component/skill("Cooking", "stat_IQ", "Average")
		skill_Pharmacy = new /datum/component/skill("Pharmacy", "stat_IQ", "Hard")
		skill_Alchemy = new /datum/component/skill("Alchemy", "stat_IQ", "Hard") // Making potions and poisons.
		skill_Engineering = new /datum/component/skill("Engineering", "stat_IQ", "Hard") // Making and repairing technology.
		skill_Leatherworking = new /datum/component/skill("Leatherworking", "stat_DX", "Easy") // Replacement for skincrafting, includes furs and hides.
		skill_Sewing = new /datum/component/skill("Sewing", "stat_DX", "Easy") // Making and repairing clothes, suturing wounds.
		// Labor skills
		skill_Farming = new /datum/component/skill("Farming", "stat_IQ", "Easy") // Could be called 'Gardening'.
		skill_Mining = new /datum/component/skill("Mining", "stat_IQ", "Average")
		skill_Animal_Handling = new /datum/component/skill("Animal Handling", "stat_IQ", "Average") // Including taming and training.
		skill_Fishing = new /datum/component/skill("Fishing", "stat_PER", "Easy")
		skill_Butchering = new /datum/component/skill("Butchering", "stat_DX", "Average") // Skinning and gutting animals.
		// Magic skills
		skill_Miracles = new /datum/component/skill("Miracles", "stat_IQ", "Hard") // Divine magic, healing and protection.
		skill_Arcane = new /datum/component/skill("Arcane", "stat_IQ", "Hard") // Arcane magic, elemental and force spells.
		// Misc skills
		skill_Climbing = new /datum/component/skill("Climbing", "stat_DX", "Average")
		skill_Swimming = new /datum/component/skill("Swimming", "stat_HT", "Easy")
		skill_Stealth = new /datum/component/skill("Stealth", "stat_DX", "Average")
		skill_Lockpicking = new /datum/component/skill("Lockpicking", "stat_IQ", "Average")
		skill_Pickpocket = new /datum/component/skill("Pickpocket", "stat_DX", "Hard")
		skill_Physician = new /datum/component/skill("Physician", "stat_IQ", "Hard") // Healing and surgery.
		skill_Riding = new /datum/component/skill("Riding", "stat_DX", "Average")
		skill_Reading = new /datum/component/skill("Reading", "stat_IQ", "Easy")

	proc/get_stat(stat_name) // Returns the total value of a stat, including the buffer.
		var/datum/component/stat/stat = stat_name
		if (stat)
			return stat.get_total()
		return 0

	proc/get_target_stat(stat_name, mob/living/carbon/target) // Returns the total value of a stat of a specified mob
		if (target)
			var/datum/component/stat/stat = stat_name
			if (stat && istype(stat, /datum/component/stat))
				return target.get_stat(stat)
			else
				return 0
		else
			return 0

	proc/set_stat_base(stat_name, value) // Sets the base value of a stat, ignoring the buffer. Useful for setting up mobs.
		var/datum/component/stat/stat = stat_name
		if (stat)
			stat.set_base(value)
		else
			return 0

	proc/change_stat(stat_name, value) // Changes the base value of a stat by a certain amount. Useful for permanent changes or buffs provided by classes.
		var/datum/component/stat/stat = stat_name
		if (stat)
			stat.change_base(value)
		else
			return 0

	proc/get_skill(skill_name) // Returns the total level of a skill.
		var/datum/component/skill/skill = skill_name
		if (skill)
			return skill.level
		return 0

	proc/get_target_skill(skill_name, mob/living/carbon/target) // Returns the total level of a skill of a specified mob
		if (target)
			var/datum/component/skill/skill = skill_name
			if (skill && istype(skill, /datum/component/skill))
				return target.get_skill(skill)
			else
				return 0
		else
			return 0

	proc/get_skill_exp(skill_name) // Returns the experience of a skill.
		var/datum/component/skill/skill = skill_name
		if (skill)
			return skill.exp
		return 0

	proc/get_skill_stat(skill_name) // Returns the stat associated with a skill.
		var/datum/component/skill/skill = skill_name
		if (skill)
			return skill.stat
		return 0

	proc/change_skill(skill_name, value) // Changes the level of a skill by a certain amount. Useful for permanent changes or buffs provided by classes.
		var/datum/component/skill/skill = skill_name
		if (skill)
			skill.level = clamp(skill.level + value, 0, skill.max_level)
		else
			return 0

	proc/add_skill_exp(skill_name, value = 1) // Adds experience to a skill. Useful for when a skill is used. Don't specify value unless you intend on adding a lot.
		var/datum/component/skill/skill = skill_name
		if (skill)
			skill.exp += value * get_stat(stat_IQ)
			var/multiplier
			switch(skill.difficulty)
				if ("Easy")
					multiplier = 1
				if ("Average")
					multiplier = 1.5
				if ("Hard")
					multiplier = 2
			var/exp_needed = 100 * multiplier * (2 ** skill.level)
			if (skill.exp >= exp_needed)
				skill.exp = 0
				change_skill(skill, 1)
		else
			return 0

	proc/roll_stats() //RNG stats have been removed...for now... use /set_stat_base if you want to change that.
		if (ishuman(src))
			var/mob/living/carbon/human/H = src
			if (H.dna.species)
				if (H.gender == FEMALE)
					for (var/name in H.dna.species.specstats_f)
						var/datum/component/stat/stat = name
						var/value = H.dna.species.specstats_f[name]
						change_stat(stat, value)
				else
					for (var/name in H.dna.species.specstats)
						var/datum/component/stat/stat = name
						var/value = H.dna.species.specstats[name]
						change_stat(stat, value)
			switch (H.age)
				if (AGE_YOUNG)
					change_stat(stat_ST, -1)
					change_stat(stat_DX, 1)
				if (AGE_MIDDLEAGED)
					change_stat(stat_ST, 1)
					change_stat(stat_HT, -1)
				if (AGE_OLD)
					change_stat(stat_ST, -1)
					change_stat(stat_HT, -2)
					change_stat(stat_IQ, 2)

	proc/success_roll(stat_or_skill, modifier = 0) // Standard roll for success or failure. Returns "Critical Success", "Success", "Failure", or "Critical Failure".
		var/dice_roll = roll("3d6") // 3-18
		var/positive_luck = 0 // Makes critical success more likely
		var/negative_luck = 0 // Makes critical failure more likely
		var/datum/component/stat/stat = stat_or_skill
		var/datum/component/skill/skill = stat_or_skill
		if (get_stat(stat_LUC) > 0)
			positive_luck = get_stat(stat_LUC)
		if (get_stat(stat_LUC) < 0)
			negative_luck = -get_stat(stat_LUC)
		if (stat && istype(stat, /datum/component/stat))
			var/effective_stat = get_stat(stat) - modifier
			if (effective_stat - dice_roll >= (10 - positive_luck)) // It is possible to not be able to succeed at all, even if you roll a 3 or 4, unlike GURPS. May need to be changed in the future to make 3 and 4 always crit.
				return "Critical Success"
			if (effective_stat >= dice_roll)
				return "Success"
			if (dice_roll - effective_stat >= (10 - negative_luck))
				return "Critical Failure"
			else
				return "Failure"
		if (skill && istype(skill, /datum/component/skill))
			var/effective_skill = get_skill(skill) - modifier + (get_stat(get_skill_stat(skill))-10)
			if (effective_skill - dice_roll >= (10 - positive_luck))
				return "Critical Success"
			if (effective_skill >= dice_roll)
				return "Success"
			if (dice_roll - effective_skill >= (10 - negative_luck))
				return "Critical Failure"
			else
				return "Failure"
		else
			return "Failure"

	proc/quick_contest(user, user_stat_or_skill, target, target_stat_or_skill) // Standard roll for contests. Returns "User" or "Target". No ties. Can be used to compare between stats and skills, for example Pickpocket vs PER.
		var/user_roll = roll("3d6") // 3-18
		var/target_roll = roll("3d6") // 3-18
		var/effective_user = 0
		var/effective_target = 0

		if (user_stat_or_skill != null)
			var/datum/component/stat/stat = user_stat_or_skill
			if (stat && istype(stat, /datum/component/stat))
				effective_user = get_stat(stat)
			else
				var/datum/component/skill/skill = user_stat_or_skill
				if (skill && istype(skill, /datum/component/skill))
					effective_user = get_skill(skill) + (get_stat(get_skill_stat(skill)) - 10)
				else
					return "Target"

		if (target_stat_or_skill != null)
			var/datum/component/stat/stat = target_stat_or_skill
			if (stat && istype(stat, /datum/component/stat))
				effective_target = get_target_stat(stat, target)
			else
				var/datum/component/skill/skill = target_stat_or_skill
				if (skill && istype(skill, /datum/component/skill))
					effective_target = get_target_skill(skill, target) + (get_target_stat(get_skill_stat(skill), target) - 10)
				else
					return "User"

		var/user_margin = effective_user - user_roll
		var/target_margin = effective_target - target_roll
		if (user_margin > target_margin)
			return "User"
		if (target_margin > user_margin)
			return "Target"
		return pick("User", "Target") // Upon a margin of success being equal, pick a winner at random.

/datum/species
	var/list/specstats = list("stat_ST" = 0, "stat_DX" = 0, "stat_HT" = 0, "stat_IQ" = 0, "stat_WIL" = 0, "stat_PER" = 0, "stat_SPD" = 0, "stat_LUC" = 0)
	var/list/specstats_f = list("stat_ST" = 0, "stat_DX" = 0, "stat_HT" = 0, "stat_IQ" = 0, "stat_WIL" = 0, "stat_PER" = 0, "stat_SPD" = 0, "stat_LUC" = 0)