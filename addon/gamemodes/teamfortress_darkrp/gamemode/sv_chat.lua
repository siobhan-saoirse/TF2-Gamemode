local medieval = {}
local convar = CreateConVar("tf_medieval_autorp", "0", {FCVAR_NOTIFY}, "")

hook.Add("PlayerSay", "TF2_Medieval", function(ply, msg, team)
    if !convar:GetBool() or string.StartWith(msg, "/") or string.StartWith(msg, "!") then return end

    if math.random(2) == 1 then
        msg = table.Random(medieval.prepended_words) .. msg
        msg = string.Replace(msg, "&god", "Odin")
        msg = string.Replace(msg, "&godadj", "Almighty")
    end

    if math.random(2) == 1 then
        msg = msg .. " " .. table.Random(medieval.appended_words)
    end

    return msg
end)

medieval.prepended_words = {
		"Forsooth, ",
		"I say, ",
		"I sayeth, ",
		"Forsooth, I say, ",
		"Forsooth, say I, ",
		"Forsooth, sayeth I, ",
		"Hark! ",
		"Harketh! ",
		"By &god, ",
		"By the Will of &godadj &god, ",
		"By the &bodyadj &bodypart of the &godadj &god, ",
		"By &godadj &god's &bodyadj &bodypart, ",
		"Avast, ",
		"Zounds, ",
		"Perchance, ",
		"Pray tell, ",
		"Prithee, ",
		"What hey, ",
		"What ho, ",
		"Pray, ",
		"Surely ",
		"Pray pardon, ",
		"Alas, ",
		"In short, ",
		"My Lord, ",
		"My Lady, ",
		"By my faith, ",
		"If it pleases you, ",
		"I pray you, ",
		"In truth, ",
		"By my trowth, ",
		"In sooth, ",
		"By my word, ",
		"S'wounds, ",
		"Z'wounds, ",
		"&god's wounds, ",
		"&god's &bodypart, ",
		"Heigh-ho, ",
		"Ah, ",
		"Quoth I, ",
		"Listen, ",
		"Listen thee, ",
		"Hear me, ",
		"Now hear me, ",
		"I warrant ",
		"Come, ",
		"Kind sire, ",
		"Sire, ",
		"There is much in what you say, and yet, "
}

medieval.appended_words = {
		"Anon!",
		"Hum.",
		"Good sir!",
		"Good sire!",
		"Milady!",
		"My Liege!",
		"Guvnor!",
}

--[[

 local word_replacements =
	{
		{
			prev = "it",
			word = "is",
			replacement = "'tis"
		},
		
		
		{
			prev = "it",
			word = "was",
			replacement = "'twas"
		},

		
		{
			prev = "it",
			word = "would",
			replacement = "'twould"
		},

		
		{
			prev = "it",
			word = "will",
			replacement = "'twill"
		},

		
		{
			prev = "it",
			word = "were",
			replacement = "'twere"
		},

		
		{
			prev = "shall",
			word = "not",
			replacement = "shan't"
		},

		
		{
			prev = "will",
			word = "not",
			replacement = "shan't"
		},
		
		
		{
			prev = "over",
			word =  "there",
			replacement =  "yonder"
		},
		
		
		{
			prev = "in",
			word = "the",
			chance = 2,
			replacement = "i' the"
		},
		
		
		{
			prev = "thank",
			word = "you",
			replacement = "many good thanks to you",
			replacement = "thankee",
			replacement = "kindly thanks to you",
			replacement = "grammercy to you"
		},

		
		{
			word = "you",
			word = "u",
			replacement =  "thou",
			replacement =  "thee",
			replacement =  "ye"

		},

		
		{
			word = "are",
			replacement =  "art"

		},

		
		{
			word = "god",
			replacement =  "Odin",
			replacement =  "Bob",
			replacement =  "Zeus",
			replacement =  "Hera",
			replacement =  "Thor",
			replacement =  "Crom",
			replacement =  "Mad-poet Navarth",
			replacement =  "Cugel",
			replacement =  "Wotsit",
			replacement =  "Baron Boddisey",
			replacement =  "Poseidon",
			replacement = "Saint Mary",
			replacement = "Pallus Athena",
			replacement = "Loki",
			replacement = "Erlik",
			replacement = "Shoggoth",
			replacement = "Omm",
			replacement = "Vishnu",
			replacement = "Azazoth",
			replacement = "Father Odin",
			replacement = "Allfather Odin",
			replacement = "Cthulhu",
			replacement = "Buddha",
			replacement = "Aphrodite",
			replacement = "Isis",
			replacement = "Kali",
			replacement = "Dionysus",
			replacement = "Zarathustra",
			replacement = "Croesus",
			replacement = "Hermes",
			replacement = "Venus",
			replacement = "Montezuma",
			replacement = "Popacatapetl",
			replacement = "Hephaestus",
			replacement = "Bubastes",
			replacement = "Bacchus",
			replacement = "Nebuchadnezzar" ,
			replacement = "Assurbanipal" ,
			replacement = "Sargon" ,
			replacement = "Xerxes",
			replacement = "Mulwatallish" ,
			replacement = "Labarna",
			replacement = "Hammurabi",
			replacement = "Rameses",
			replacement = "Minos",
			replacement = "Tilgath-Pileser",
			replacement = "Vercingetorix",
			replacement = "Mithradites",
			replacement = "Pericles",
			replacement = "Belasarius",
			replacement = "Archaemides",
			replacement = "Heraclius",
			replacement = "Imhotep",
			replacement = "Artemis",
			replacement = "Orthia",
			replacement = "Phoebe",
			replacement = "Hestia",
			replacement = "Eros",
			replacement = "Persephone",
			replacement = "Minerva",
			replacement = "Mercury",
			replacement = "Aesculapius",
			replacement = "Discordia",
			replacement = "Hecate",
			replacement = "Hespera"
		},

		
		{
			word = "godadj",
			replacement =  "Almighty",
			replacement =  "Unthinkable",
			replacement =  "Unknowable",
			replacement =  "All-knowing",
			replacement =  "All-seeing",
			replacement =  "Lecherous",
			replacement =  "Scandalous",
			replacement =  "Merciful",
			replacement =  "Ravaging",
			replacement =  "Thunderous",
			replacement = "Wrathful",
			replacement = "Distant",
			replacement = "Vengeful",
			replacement = "Supreme",
			replacement = "Wise",
			replacement = "Warlike",
			replacement = "Jealous",
			replacement = "Vindictive",
			replacement = "Powerful",
			replacement = "Adulterous",
			replacement = "Licentious",
			replacement = "Crafty",
			replacement = "Benefical",
			replacement = "Virtuous",
			replacement = "Protective",
			replacement = "Prophetic",
			replacement = "Bloodthirsty",
			replacement = "Murderous",
			replacement = "Ruinous",
			replacement = "Militant",
			replacement = "Invisible",
			replacement = "Omnipotent",
			replacement = "Forgotten",
			replacement = "Enlightened",
			replacement = "Tempestuous",
			replacement = "Destructive",
			replacement = "Grim"
		},

		
		{
			word = "bodypart",
			replacement =  "Beard",
			replacement =  "Third Leg",
			replacement =  "Scalp",
			replacement =  "Eye",
			replacement =  "Thigh",
			replacement =  "Arm",
			replacement =  "Sword",
			replacement =  "Heel",
			replacement =  "Gaze",
			replacement =  "Tongue",
			replacement =  "Hammer",
			replacement =  "Toenail",
			replacement =  "usermessageher Regions",
			replacement =  "Liver",
			replacement =  "Lights",
			replacement =  "Spleen",
			replacement =  "Gall",
			replacement =  "Liver and Lights"
		},

		
		{
			word = "bodyadj",
			replacement =  "Unknowable",
			replacement =  "Unescapable",
			replacement =  "Unfathomable",
			replacement =  "Unthinkable",
			replacement =  "Righteous",
			replacement =  "Hairy",
			replacement =  "Hairless",
			replacement =  "Wandering",
			replacement =  "Blistered",
			replacement =  "Awe-inspiring",
			replacement =  "Toothy",
			replacement =  "Ravaged",
			replacement =  "Aged",
			replacement =  "Endless",
			replacement =  "Wondrous",
			replacement = "Unavoidable",
			replacement = "Pestilent",
			replacement = "Forgotten",
			replacement = "Beautiful",
			replacement = "Fertile",
			replacement = "Prophetic",
			replacement = "Musical",
			replacement = "Helpful",
			replacement = "Virginal",
			replacement = "Curative",
			replacement = "Bleak",
			replacement = "Incessant",
			replacement = "Sagely",
			replacement = "Unfashionable",
			replacement = "Unfaltering",
			replacement = "Unfamiliar",
			replacement = "Abysmal",
			replacement = "Boundless",
			replacement = "Eternal",
			replacement = "Immeasurable",
			replacement = "Infinite",
			replacement = "Unending",
			replacement = "Soundless",
			replacement = "Incomprehensible",
			replacement = "Inexplicable",
			replacement = "Profound",
			replacement = "unintelligible",
			replacement = "Unbelievable",
			replacement = "Impeusermessagerable",
			replacement = "Indecipherable",
			replacement = "Esoteric",
			replacement = "Enigmatic",
			replacement = "Ancient",
			replacement = "Venerable",
			replacement = "Baneful",
			replacement = "Contagious",
			replacement = "Corrupting",
			replacement = "Deadly",
			replacement = "Deleterious",
			replacement = "Evil",
			replacement = "Noxious",
			replacement = "Diseased",
			replacement = "Pernicious",
			replacement = "Pestiferous",
			replacement = "Pestilential",
			replacement = "Tainted",
			replacement = "Contaminated",
			replacement = "Pulchritudinous",
			replacement = "Odoriferous",
			replacement = "Misbegotten",
			replacement = "Sacriligious"
		},


		
		{
			word = "lol",
			replacement =  "lolleth",
			replacement =  "lollery"

		},

		
		{
			word = "killed",
			word = "beaten",
			replacement =  "slain",
			replacement =  "vanquished",
			replacement =  "brung low",
			replacement =  "conquered",
			replacement =  "fleeced",
			replacement =  "humbled",
			replacement =  "subjugated",
			replacement =  "bested",
			replacement =  "foiled"

		},

		
		{
			word = "goodbye",
			word = "bye",
			word = "seeya",
			word = "goodnight",
			replacement =  "farewell",
			replacement =  "fare thee well",
			replacement =  "good morrow",
			replacement =  "by your leave",
			replacement =  "godspeed",
			replacement =  "begone",
			replacement =  "good day",
			replacement =  "good day, sirrah",
			replacement =  "good day, sire",
			replacement =  "good day, master",
			replacement =  "adieu",
			replacement =  "cheerio",
			replacement =  "pleasant journey",
			replacement =  "I bid thee good day",
			replacement =  "I bid thee farewell"

		},

		
		{
			word = "idiot",
			word = "fool",
			word = "bastard",
			word_plural = "idiots",
			word_plural = "fools",
			word_plural = "bastards",
			prepend_count = "2",
			replacement_prepend ="artless",
			replacement_prepend ="droning",
			replacement_prepend ="fawning",
			replacement_prepend ="warped",
			replacement_prepend ="paunchy",
			replacement_prepend ="puny",
			replacement_prepend ="spongy",
			replacement_prepend ="ruttish",
			replacement_prepend ="vain",
			replacement_prepend ="lumpish",
			replacement_prepend ="craven",
			replacement_prepend ="witless",
			replacement_prepend ="pustulent",
			replacement_prepend ="infested",
			replacement_prepend ="ill-bred",
			replacement_prepend ="blind",
			replacement_prepend ="scurvy",
			replacement_prepend ="puny",
			replacement_prepend ="fetid",
			replacement_prepend ="vile",
			replacement_prepend ="gibbering",
			replacement_prepend ="mewling",
			replacement_prepend ="rank",
			replacement_prepend ="fawning",
			replacement_prepend ="moonish",
			replacement_prepend ="brutish",
			replacement_prepend ="malapert",
			replacement_prepend ="curst",
			replacement_prepend ="lack-linen",
			replacement_prepend ="bottle-ailed",
			replacement_prepend ="lyingest",
			replacement_prepend ="embossed",
			replacement_prepend ="cheating",
			replacement_prepend ="crook-pated",
			replacement_prepend ="base-court",
			replacement_prepend ="hasty-witted",
			replacement_prepend ="two-faced",
			replacement_prepend ="pox-marked",
			replacement_prepend ="toad-brained",
			replacement_prepend ="errant",
			replacement_prepend ="idle-headed",
			replacement_prepend ="quailing",
			replacement_prepend ="flap-mouthed",
			replacement_prepend ="puking",
			replacement_prepend ="fly-bitten",
			replacement_prepend ="surly",
			replacement_prepend ="tottering",
			replacement_prepend ="villainous",
			replacement_prepend ="rump-fed",
			replacement_prepend ="bootless",
			replacement_prepend ="churlish",
			replacement_prepend ="tickle-brained",
			replacement_prepend ="froward",
			replacement =  "mongrel",
			replacement =  "codpiece",
			replacement =  "jackanape",
			replacement =  "ape",
			replacement =  "coxcomb",
			replacement =  "harlot",
			replacement =  "hussy",
			replacement =  "strumpet",
			replacement =  "cur",
			replacement =  "clot",
			replacement =  "fool",
			replacement =  "barnacle",
			replacement =  "harpy",
			replacement =  "wench",
			replacement =  "churl",
			replacement =  "pleb",
			replacement =  "taffer",
			replacement =  "scoundrel",
			replacement =  "scalliwag",
			replacement =  "mooncalf",
			replacement =  "rapscallion",
			replacement =  "doxy",
			replacement =  "bawd",
			replacement =  "tosspot",
			replacement =  "cupshot",
			replacement =  "recreant",
			replacement =  "fustalarion",
			replacement =  "scullion",
			replacement =  "rampallion",
			replacement =  "knave",
			replacement =  "barbermonger",
			replacement =  "boil",
			replacement =  "plague-sore",
			replacement =  "carbuncle",
			replacement =  "whoreson",
			replacement =  "clotpole",
			replacement =  "lout",
			replacement =  "gudgeon",
			replacement =  "puttock",
			replacement =  "skainsmate",
			replacement =  "varlet",
			replacement =  "bladder",
			replacement_plural ="mongrels",
			replacement_plural ="codpieces",
			replacement_plural ="jackanapes",
			replacement_plural ="apes",
			replacement_plural ="coxcombes",
			replacement_plural ="harlots",
			replacement_plural ="hussies",
			replacement_plural ="strumpets",
			replacement_plural ="clots",
			replacement_plural ="fools",
			replacement_plural ="barnacles",
			replacement_plural ="harpies",
			replacement_plural ="wenches",
			replacement_plural ="churls",
			replacement_plural ="plebians",
			replacement_plural ="taffers",
			replacement_plural ="scoundrels",
			replacement_plural ="scalliwags",
			replacement_plural ="mooncalves",
			replacement_plural ="rapscallions",
			replacement_plural ="doxies",
			replacement_plural ="bawds",
			replacement_plural ="tosspots",
			replacement_plural ="cupshots",
			replacement_plural ="recreants",
			replacement_plural ="fustalarions",
			replacement_plural ="scullions",
			replacement_plural ="rampallions",
			replacement_plural ="knaves",
			replacement_plural ="barbermongerers",
			replacement_plural ="boils",
			replacement_plural ="plague-sores",
			replacement_plural ="carbuncles",
			replacement_plural ="whoresons",
			replacement_plural ="louts"
		},

		
		{
			word = "yes",
			replacement =  "aye",
			replacement =  "yea",
			replacement =  "yea verily"

		},

		
		{
			word = "no",
			replacement =  "nay",
			replacement =  "nayeth"

		},

		
		{
			word = "hello",
			word = "hi",
			replacement =  "good day",
			replacement =  "well met",
			replacement =  "well meteth",
			replacement =  "tally ho",
			replacement =  "ave"
		
		},

		
		{
			word = "does",
			replacement =  "doeseth",
			replacement =  "dost",
			replacement =  "doth"
		
		},

		
		{
			word = "kill",
			word = "gank",
			replacement =  "slay",
			replacement =  "vanquish",
			replacement =  "bring low",
			replacement =  "conquer",
			replacement =  "fleece",
			replacement =  "humble",
			replacement =  "subjugate",
			replacement =  "best",
			replacement =  "foil"
		
		},

		
		{
			word = "your",
			replacement =  "thy",
			replacement =  "thine",
			replacement =  "thyne"
		
		},

		
		{
			word = "my",
			chance = 2,
			replacement =  "mine"
		
		},

		
		{
			word = "in",
			chance = 2,
			replacement =  "within"
		
		},

		
		{
			word = "it's",
			chance = 2,
			replacement =  "'tis"
		
		},

		
		{
			word = "the",
			chance = 2,
			replacement =  "ye"
		
		},

		
		{
			word = "joke",
			replacement =  "jest",
			replacement =  "jape"
		
		},

		
		{
			word = "go",
			chance = 2,
			replacement =  "",
			replacement =  "be off"
		
		},

		
		{
			word = "will",
			chance = 2,
			replacement =  "wilt",
			replacement =  "wouldst"
		
		},

		
		{
			word = "gold",
			word = "money",
			replacement =  "bullion",
			replacement =  "florins",
			replacement =  "pounds",
			replacement =  "ducats",
			replacement =  "pieces o'silver",
			replacement =  "groats",
			replacement =  "crowns",
			replacement =  "ingots"
		
		},

		
		{
			word = "balls",
			word = "groin",
			replacement = "leathers",
			replacement = "beans",
			replacement = "poundables",
			replacement = "usermessagehers",
			replacement = "nadchakles",
			replacement = "buis",
			replacement = "fellahs",
			replacement = "coin purse"

		},


		
		{
			word = "water",
			replacement =  "ale",
			replacement =  "mead",
			replacement =  "flagon of ale",
			replacement =  "flagon of mead"
		
		},

		
		{
			word = "food",
			replacement =  "vittles",
			replacement =  "rations",
			replacement =  "sustenance",
			replacement =  "viands",
			replacement =  "nutriments"
		
		},

		
		{
			word = "afk",
			replacement =  "away, fighting kobolds",
			replacement =  "away, fruity knights",
			replacement =  "aft, frisking knickers",
			replacement =  "abaft, flailing knouts"

		
		},

		
		{
			word = "aggro",
			replacement =  "wrath"
		
		},

		
		{
			word = "town",
			word = "village",
			word = "home",
			replacement =  "borough",
			replacement =  "burgage",
			replacement =  "burgh",
			replacement =  "keep",
			replacement =  "castle",
			replacement =  "hamlet",
			replacement =  "redoubt"

		
		},

		
		{
			word = "sell",
			replacement =  "hawk",
			replacement =  "pawn",
			replacement =  "tender",
			replacement =  "purvey"
		
		},

		
		{
			word = "buy",
			replacement =  "purchase",
			replacement =  "obtain"

		
		},

		
		{
			word = "debuff",
			replacement =  "ailment",
			replacement =  "sickness",
			replacement =  "pox"
		
		},

		
		{
			word = "map",
			replacement =  "chart"
		
		},

		
		{
			word = "between",
			replacement =  "betwixt"
		
		},

		
		{
			word = "thank",
			word = "thx",
			word_plural = "thanks",
			replacement =  "many good thank",
			replacement =  "thankee",
			replacement =  "kindly thank",
			replacement_plural ="many thanks",
			replacement_plural ="much thankage",
			replacement_plural ="thankee muchly"
		
		},

		
		{
			word = "please",
			replacement =  "I pray you",
			replacement =  "prithee",
			replacement =  "pray"
		
		},

		
		{
			word = "ok",
			replacement =  "as you will",
			replacement =  "agreed",
			replacement =  "well said",
			replacement =  "just so"
		
		},

		
		{
			word = "spy",
			word_plural = "spies",
			word_plural = "spys",
			replacement =  "cutpurse",
			replacement =  "pickpocket",
			replacement =  "vagabond",
			replacement =  "blackguard",
			replacement =  "hooligan",
			replacement =  "pilferer",
			replacement =  "backstabber",
			replacement =  "thief",
			replacement =  "haunt",
			replacement =  "rogue",
			replacement =  "rouge", // for the authentic RP experience
			replacement_plural = "cutpurses",
			replacement_plural = "pickpockets",
			replacement_plural = "vagabonds",
			replacement_plural = "blackguards",
			replacement_plural = "pilferers",
			replacement_plural = "backstabbers",
			replacement_plural = "thieves",
			replacement_plural = "haunts",
			replacement_plural = "rogues"
		},

		
		{
			word = "soldier",
			word = "solly",
			word_plural = "soldiers",
			replacement =  "mercenary",
			replacement =  "warrior",
			replacement =  "shovelman",
			replacement =  "champion",
			replacement_plural ="mercenaries",
			replacement_plural ="warriors",
			replacement_plural = "shovelmen",
			replacement_plural ="champions"
		},
		
		
		{
			word = "demoman",
			word_plural = "demomen",
			word_plural = "demomens",
			word_plural = "demomans",
			replacement =  "swordsman",
			replacement =  "scotsman",
			replacement =  "drunkard",
			replacement =  "swordmaster",
			replacement =  "blademaster",
			replacement =  "knight",
			replacement =  "paladin",
			replacement_plural ="swordsmen",
			replacement_plural ="scotsmen",
			replacement_plural ="drunkards",
			replacement_plural ="swordmasters",
			replacement_plural ="blades for hire",
			replacement_plural ="blademasters",
			replacement_plural = "knights",
			replacement_plural = "paladins"
		},

		
		{
			word = "medic",
			word_plural = "medics",
			replacement =  "priest",
			replacement =  "cleric",
			replacement =  "healer",
			replacement =  "nursemaid",
			replacement =  "bonesetter",
			replacement =  "butcher",
			replacement =  "medicine man",
			replacement =  "witchdoctor",
			replacement =  "leech",
			replacement =  "apothecary",
			replacement =  "wizard",
			replacement_plural = "priests",
			replacement_plural = "clerics",
			replacement_plural = "healers",
			replacement_plural = "nursemaids",
			replacement_plural = "bonesetters",
			replacement_plural = "butchers",
			replacement_plural ="medicine men",
			replacement_plural ="witchdoctors",
			replacement_plural = "leeches",
			replacement_plural = "apothecaries",
			replacement_plural = "wizards"
		},
		
		
		{
			word = "pyro",
			word_plural = "pyros",
			replacement =  "pyromaniac",
			replacement =  "maniac",
			replacement =  "flamewielder",
			replacement =  "firebrand",
			replacement =  "fire mage",
			replacement =  "fire magus",
			replacement =  "Masked Salamander",
			replacement_plural = "priests",
			replacement_plural = "pyromaniac",
			replacement_plural = "maniac",
			replacement_plural = "flamewielder",
			replacement_plural = "firebrand",
			replacement_plural = "fire mages",
			replacement_plural = "fire magii",
			replacement_plural = "Masked Salamanders"
		},

		
		{
			word = "sniper",
			word_plural = "snipers",
			replacement =  "hunter",
			replacement =  "ranger",
			replacement =  "woodsman",
			replacement =  "beastmaster",
			replacement =  "australian",
			replacement =  "archer",
			replacement =  "bowman",
			replacement =  "arrowman",
			replacement =  "fletcher",
			replacement_plural ="hunters",
			replacement_plural ="rangers",
			replacement_plural ="woodsmen",
			replacement_plural ="beastmasters",
			replacement_plural ="australians",
			replacement_plural = "archers",
			replacement_plural = "bowmen",
			replacement_plural = "arrowmen",
			replacement_plural = "fletchers"
		},

		
		{
			word = "scout",
			word_plural = "scouts",
			chance = 2,
			replacement =  "lookout",
			replacement =  "outrider",
			replacement =  "spotter",
			replacement =  "explorer",
			replacement =  "patroller",
			replacement =  "runner",
			replacement =  "advance guard",
			replacement_plural = "lookouts",
			replacement_plural = "outriders",
			replacement_plural = "spotters",
			replacement_plural = "explorers",
			replacement_plural = "patrollers",
			replacement_plural = "runners",
			replacement_plural = "advance guards"
		},
		
		
		{
			word = "heavy",
			word_plural = "heavies",
			replacement =  "brawler",
			replacement =  "bouncer",
			replacement =  "boxer",
			replacement =  "bruiser",
			replacement_plural = "brawlers",
			replacement_plural = "bouncers",
			replacement_plural = "boxers",
			replacement_plural = "bruisers"
		},
		
		
		{
			word = "engineer",
			word = "engy",
			word_plural = "engineers",
			word_plural = "engys",
			word_plural = "engies",
			replacement =  "craftsman",
			replacement =  "smith",
			replacement =  "smithy",
			replacement =  "blacksmith",
			replacement =  "artisan",
			replacement =  "machinist",
			replacement =  "ironsmith",
			replacement =  "metalworker",
			replacement =  "golem-maker",
			replacement =  "golemist",
			replacement_plural = "craftsmen",
			replacement_plural = "smiths",
			replacement_plural = "smithies",
			replacement_plural = "blacksmiths",
			replacement_plural = "artisans",
			replacement_plural = "machinists",
			replacement_plural = "ironsmiths",
			replacement_plural = "metalworkers",
			replacement_plural = "golem-maker",
			replacement_plural = "golemists"
		},
		
		
		{
			word = "is",
			chance = 2,
			replacement =  "be"
		
		},

		
		{
			word = "party",
			word = "group",
			word_plural = "parties",
			word_plural = "groups",
			replacement =  "band",
			replacement =  "fellowship",
			replacement =  "assembly",
			replacement =  "troop",
			replacement_plural ="bands",
			replacement_plural ="fellowships",
			replacement_plural ="assemblies",
			replacement_plural ="troops"
		
		},

		
		{
			word = "lfg",
			replacement_prepend ="I am seeking",
			replacement_prepend ="I be looking for",
			replacement_prepend ="I am desiring",
			replacement_prepend ="I be searching for",
			replacement_prepend ="I'm in search of",
			replacement =  "a fellowship",
			replacement =  "a band of trusty fellows",
			replacement =  "a trustworthy group",
			replacement =  "fine adventurers",
			replacement =  "a worthy band"
		
		},

		
		{
			word = "newbie",
			word = "newb",
			word = "noob",
			word = "nub",
			word = "lowbie",
			word = "beginner",
			word_plural = "newbies",
			word_plural = "newbs",
			word_plural = "noobs",
			word_plural = "nubs",
			word_plural = "lowbies",
			word_plural = "beginners",
			replacement =  "neophyte",
			replacement =  "youngster",
			replacement =  "serf",
			replacement =  "dabbler",
			replacement =  "pleb",
			replacement =  "apprentice",
			replacement =  "journeyman",
			replacement =  "pupil",
			replacement =  "tenderfoot",
			replacement =  "initiate",
			replacement =  "fledgling",
			replacement =  "greenhorn",
			replacement =  "acolyte",
			replacement_plural ="neophytes",
			replacement_plural ="youngsters",
			replacement_plural ="serfs",
			replacement_plural ="dabblers",
			replacement_plural ="plebians",
			replacement_plural ="apprentices",
			replacement_plural ="journeymen",
			replacement_plural ="pupils",
			replacement_plural ="tenderfeet",
			replacement_plural ="initiates",
			replacement_plural ="fledglings",
			replacement_plural ="greenhorns",
			replacement_plural = "acolytes"
		
		},

		
		{
			word = "level",
			word_plural = "levels",
			chance = 2,
			replacement =  "rank",
			replacement =  "station"
		
		},

		
		{
			word = "rofl",
			word = "roflmao",
			word = "roflol",
			replacement =  "rofleth",
			replacement =  "guffaw",
			
		
		},

		
		{
			word = "wait",
			word_plural = "waits",
			chance = 2,
			replacement =  "hold",
			replacement =  "hold hard",
			replacement =  "mark time",
			replacement =  "tarry",
			replacement_plural ="holds",
			replacement_plural ="holds hard",
			replacement_plural ="marks time",
			replacement_plural ="tarries"
		
		},

		
		{
			word = "need",
			word_plural = "needs",
			chance = 2,
			replacement =  "covet",
			replacement =  "wish",
			replacement =  "desire",
			replacement =  "request",
			replacement_plural ="covets",
			replacement_plural ="wishes",
			replacement_plural ="desires",
			replacement_plural ="requests"

		},

		
		{
			word = "even",
			chance = 2,
			replacement =  "e'en"

		},

		
		{
			word = "never",
			chance = 2,
			replacement =  "ne'er"

		},

		
		{
			word = "over",
			chance = 2,
			replacement =  "o'er"

		},

		
		{
			word = "before",
			chance = 2,
			replacement =  "'ere"

		},

		
		{
			word = "unless",
			chance = 2,
			replacement =  "lest"

		},

		
		{
			word = "haha",
			word = "hehe",
			word = "heh",
			word = "hah",
			replacement =  "guffaw!",
			replacement =  "cackle!",
			replacement =  "oh, 'tis to laugh!",
			replacement =  "zounds!",
			replacement =  "chuckle!",
			replacement =  "snigger!",
			replacement =  "snort!",
			replacement =  "snicker!",
			replacement =  "cachinnate!",
			replacement =  "titter!",
			replacement =  "and there was much tittering!",
			replacement =  "and there was much guffawing!",
			replacement =  "and there was much chuckling!",
			replacement =  "and there was much snorting!",
			replacement =  "and there was much snickering!",
			replacement =  "and there was much mirth!"

		},

		
		{
			word = "shop",
			word = "store",
			word_plural = "shops",
			word_plural = "stores",
			replacement =  "shoppe",
			replacement =  "shopcart",
			replacement =  "olde shoppe",
			replacement =  "market",
			replacement =  "marketplace",
			replacement =  "ye olde thrifte shoppe"


		},

		
		{
			word = "vendor",
			word = "seller",
			word_plural = "vendors",
			word_plural = "salesmen",
			replacement =  "shopkeep",
			replacement =  "monger",
			replacement =  "merchant",
			replacement =  "purveyor",
			replacement_plural ="shopkeepers",
			replacement_plural ="mongerers",
			replacement_plural ="merchants",
			replacement_plural ="purveyors"

		},

		
		{
			word = "friend",
			word = "buddy",
			word = "pal",
			word = "mate",
			word_plural = "friends",
			word_plural = "buddies",
			word_plural = "pals",
			word_plural = "mates",
			replacement =  "companion",
			replacement =  "boon companion",
			replacement =  "chum",
			replacement =  "lad",
			replacement =  "cohort",
			replacement =  "confidant",
			replacement =  "right-hand man",
			replacement =  "mate",
			replacement =  "compadre",
			replacement =  "fellow",
			replacement_plural ="companions",
			replacement_plural ="boon companions",
			replacement_plural ="chums",
			replacement_plural ="lads",
			replacement_plural ="cohorts",
			replacement_plural ="confidants",
			replacement_plural ="right-hand men",
			replacement_plural ="mates",
			replacement_plural ="compadres",
			replacement_plural ="fellows"

		},

		
		{
			word = "teh",
			replacement =  "the"

		},

		
		{
			word = "assist",
			replacement =  "aid",
			replacement =  "aideth",
			replacement =  "saveth",
			replacement =  "assistance",
			replacement =  "succor"

		},

		
		{
			word = "could",
			chance = 2,
			replacement =  "couldst"

		},

		
		{
			word = "would",
			chance = 2,
			replacement =  "wouldst"

		},

		
		{
			word = "sure",
			chance = 3,
			replacement =  "shore"

		},

		
		{
			word = "maybe",
			chance = 3,
			replacement =  "mayhaps",
			replacement =  "perchance"

		},

		
		{
			word = "girl",
			word = "woman",
			word_plural = "girls",
			word_plural = "women",
			replacement =  "madame",
			replacement =  "waif",
			replacement =  "mistress",
			replacement =  "lass",
			replacement =  "lady",
			replacement =  "goodwife",
			replacement =  "maid",
			replacement =  "maiden",
			replacement_plural ="madames",
			replacement_plural ="waifs",
			replacement_plural ="mistresses",
			replacement_plural ="lasses",
			replacement_plural ="ladies",
			replacement_plural ="goodwives",
			replacement_plural ="maids",
			replacement_plural ="maidens"

		},

		
		{
			word = "later",
			chance = 2,
			replacement =  "anon"

		},

		
		{
			word = "often",
			chance = 2,
			replacement =  "oft"

		},

		
		{
			word = "really",
			chance = 2,
			replacement =  "indeed",
			replacement =  "in truth"
		},
		
		
		{
			"word" "those",
			"chance"  2,
			"replacement" "yon"
		},
	
		
		{
			"word"  "here",
			"chance"  4,
			"replacement"  "hither"
		},
	
		
		{
			"word"  "enough",
			"chance"  2,
			"replacement"  "enow"
		},
	
		
		{
			"word"  "wow",
			"chance"  2,
			replacement = "Marry",
			replacement =   "Faith",
			replacement =   "S'wounds",
			replacement =   "God's wounds",
			replacement =   "Zounds"
		},
	
		
		{
			"word"  "child",
			"chance"  2,
			replacement =   "poppet"
		},
	
		
		{
			"word"  "why",
			"chance"  2,
			replacement =   "wherefore"
		},
	
		
		{
			"word"  "away",
			"chance"  2,
			replacement =   "aroint"
		},
	
		
		{
			"word"  "being",
			"chance"  3,
			replacement =   "bein'"
		},
	
		
		{
			"word"  "of",
			"chance"  3,
			replacement =   "o'"
		},
	
		
		{
			"word"  "fucker",
			replacement =   "swiver"
		},
	
		
		{
			"word"  "shit",
			replacement =   "nightsoil"
		},
	
		
		{
			"word"  "making",
			"chance"  2,
			replacement =   "a-makin'"
		},
	
		
		{
			"word"  "though",
			"chance"  2,
			replacement =   "tho'"
		},
	
		
		{
			"word"  "until",
			"chance"  2,
			replacement =   "'till"
		},
	
		
		{
			word =   "underneath",
			word =   "beneath",
			"chance"  2,
			replacement =   "'neath"
		},
	
		
		{
			"word"  "coming",
			"chance"  2,
			replacement =   "a-comin'"
		},
	
		
		{
			"word"  "walking",
			"chance"  2,
			replacement =   "a-walkin'"
		},
	
		
		{
			"word"  "hunting",
			"chance"  2,
			replacement =   "a-huntin'"
		},
	
		
		{
			"word"  "bet",
			"chance"  2,
			replacement =   "warrant"
		},

		
		{
			word = "!",
			chance = 4,
			replacement =  ", verily!",
			replacement =  ", verily I say!",
			replacement =  ", verily I sayeth!",
			replacement =  ", I say!",
			replacement =  ", I sayeth!",
			replacement =  "! Huzzah!",
			replacement =  "! Hear Hear!",
			replacement =  "! What-ho!",
			replacement =  "! Ho!",
			replacement =  "! Fie!",
			replacement =  ", indeed!"
		},

		
		{
			word = "?",
			chance = 4,
			replacement =  ", I say?",
			replacement =  ", I wonder?",
			replacement =  ", wonder I?",
			replacement =  ", what say thee?",
			replacement =  ", what sayeth thee?",
			replacement =  ", what say thou?",
			replacement =  ", what sayeth thou?",
			replacement =  ", I ponder?",
			replacement =  ", I pondereth?",
			replacement =  ", pray tell?",
			replacement =  ", ho?",
			replacement =  ", do tell?"
		},

		
		{
			word = "flag",
			replacement =  "pennant",
			replacement =  "banner",
			replacement =  "colors",
			replacement =  "heraldry"

		},



	}
}]]