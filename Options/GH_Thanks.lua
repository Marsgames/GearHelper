local thanksTable = {
    name = GearHelper.locals["thanksPanel"],
    type = "group",
    args = {
        name1 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 Nirek |r - Bug report + bug fix",
            type = "description"
        },
        name2 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 titaniumcoder |r - Bug report + bug fix",
            type = "description"
        },
        name3 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 deathcore01 |r - Bug report + DE translation",
            type = "description"
        },
        name4 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 Ricosoft |r - DE translation",
            type = "description"
        },
        name5 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 gOOvER |r - DE translation",
            type = "description"
        },
        name6 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 yasen |r - ZH translation",
            type = "description"
        },
        name7 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 ArnosEmpero |r - Bug report",
            type = "description"
        },
        name8 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 Schwoops |r - Bug report",
            type = "description"
        },
        name9 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 666cursed666 |r - Bug report",
            type = "description"
        },
        name10 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 xevilgrin |r - Bug report",
            type = "description"
        },
        name11 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 Comicus |r - Bug report",
            type = "description"
        },
        name12 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 Merxion |r - Bug report",
            type = "description"
        },
        name13 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 treyer75 |r - Bug report",
            type = "description"
        },
        name14 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 canlo21 |r - Bug report",
            type = "description"
        },
        name15 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 Veritias |r - Bug report",
            type = "description"
        },
        name16 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 aresyyywang |r - Bug report",
            type = "description"
        },
        name17 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 Seanross19 |r - Bug report",
            type = "description"
        },
        name18 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 jmac420 |r - Bug report",
            type = "description"
        },
        name19 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 cptcl |r - Bug report",
            type = "description"
        },
        name20 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 NaomiErin |r - Bug report",
            type = "description"
        },
        name21 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 CeloSG |r - Bug report + DE translation",
            type = "description"
        },
        name22 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 MaYcKe25 |r - BR translation",
            type = "description"
        },
        name23 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 john_yasen |r - CN translation",
            type = "description"
        },
        name24 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 Imna1975 |r - Bug report",
            type = "description"
        },
        name25 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 the777ahmad |r - Bug report",
            type = "description"
        },
        name26 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 Newill-Kristin |r - Bug report",
            type = "description"
        },
        name27 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 zloy-online |r - Bug report",
            type = "description"
        },
        name28 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 vaendryl |r - Bug report",
            type = "description"
        },
        name29 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 TheRedBull |r - Bug report",
            type = "description"
        },
        name30 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 MarshallBuhl |r - Bug report",
            type = "description"
        },
        name31 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 Zallanon |r - Bug report",
            type = "description"
        },
        name32 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 cz016m |r - Bug report",
            type = "description"
        },
        name33 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 tomas352000 |r - Bug report",
            type = "description"
        },
        name34 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 keithgeeker |r - Bug report + improvement",
            type = "description"
        },
        name35 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 knightfire120 |r - Bug report",
            type = "description"
        },
        name36 = {
            fontSize = "medium",
            name = "        |cFFFFFF00 netaras |r - KR translation",
            type = "description"
        }
    }
}

LibStub("AceConfig-3.0"):RegisterOptionsTable(GearHelper.locals["thanksPanel"], thanksTable)
LibStub("LibAboutPanel").new("GearHelper", "GearHelper")
LibStub("AceConfigDialog-3.0"):AddToBlizOptions(GearHelper.locals["thanksPanel"], GearHelper.locals["thanksPanel"], "GearHelper")
