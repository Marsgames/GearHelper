import requests
import time
import os
import difflib
import re
import pathlib

wowClassesUrl = "https://wowpedia.fandom.com/wiki/SpecializationID"
noxxic_base_url = "https://www.noxxic.com/wow/guide"
noxxic_stats_prefix = "/stat-priority/"

# Get actual path
path = pathlib.Path(__file__).parent.resolve()

linksDic = {}
response = None
f1_text = ""
f2_text = ""

class WoWClassSpec:
    def __init__(self, class_name: str, spec_name: str, spec_id: int):
        self.class_name = class_name
        self.spec_name = spec_name
        self.spec_id = spec_id

class GHTemplateHelper:
    def __init__(self, source: str, template_string: str):
        self.source = source
        self.template_string = template_string

def get_classes():
    """ Populate linksDic with WoWClassSpec objects for each class/spec """
    
    global linksDic
    
    # TODO: get classes from wowwiki to have it always up to date

    # Dictionary of (ClassName, SpecName) with SpecID as key
    linksDic = {
        250: WoWClassSpec("Death-Knight", "Blood", 250),
        251: WoWClassSpec("Death-Knight", "Frost", 251),
        252: WoWClassSpec("Death-Knight", "Unholy", 252),
        
        577: WoWClassSpec("Demon-Hunter", "Havoc", 577),
        581: WoWClassSpec("Demon-Hunter", "Vengeance", 581),
        
        102: WoWClassSpec("Druid", "Balance", 102),
        103: WoWClassSpec("Druid", "Feral", 103),
        104: WoWClassSpec("Druid", "Guardian", 104),
        105: WoWClassSpec("Druid", "Restoration", 105),

        1473: WoWClassSpec("Evoker", "Augmentation", 1473),
        1467: WoWClassSpec("Evoker", "Devastation", 1467),
        1468: WoWClassSpec("Evoker", "Preservation", 1468),
        
        253: WoWClassSpec("Hunter", "Beast Mastery", 253),
        254: WoWClassSpec("Hunter", "Marksmanship", 254),
        255: WoWClassSpec("Hunter", "Survival", 255),

        62: WoWClassSpec("Mage", "Arcane", 62),
        63: WoWClassSpec("Mage", "Fire", 63),
        64: WoWClassSpec("Mage", "Frost", 64),
        
        268: WoWClassSpec("Monk", "Brewmaster", 268),
        270: WoWClassSpec("Monk", "Mistweaver", 270),
        269: WoWClassSpec("Monk", "Windwalker", 269),

        65: WoWClassSpec("Paladin", "Holy", 65),
        66: WoWClassSpec("Paladin", "Protection", 66),
        70: WoWClassSpec("Paladin", "Retribution", 70),

        256: WoWClassSpec("Priest", "Discipline", 256),
        257: WoWClassSpec("Priest", "Holy", 257),
        258: WoWClassSpec("Priest", "Shadow", 258),

        259: WoWClassSpec("Rogue", "Assassination", 259),
        260: WoWClassSpec("Rogue", "Outlaw", 260),
        261: WoWClassSpec("Rogue", "Subtlety", 261),

        262: WoWClassSpec("Shaman", "Elemental", 262),
        263: WoWClassSpec("Shaman", "Enhancement", 263),
        264: WoWClassSpec("Shaman", "Restoration", 264),

        265: WoWClassSpec("Warlock", "Affliction", 265),
        266: WoWClassSpec("Warlock", "Demonology", 266),
        267: WoWClassSpec("Warlock", "Destruction", 267),

        71: WoWClassSpec("Warrior", "Arms", 71),
        72: WoWClassSpec("Warrior", "Fury", 72),
        73: WoWClassSpec("Warrior", "Protection", 73),
    }

class PawnTools:
    @staticmethod
    def clean_pawn_string(pawn_string) -> str:
        """ Clean pawn string to have consistent keys """
        
        pawn_string = pawn_string.replace("HasteRating", "Haste")
        pawn_string = pawn_string.replace("CritRating", "CriticalStrike")
        pawn_string = pawn_string.replace("MasteryRating", "Mastery")
        pawn_string = pawn_string.replace("DPS", "MainHandDps")
        pawn_string = pawn_string.replace("OffHandDPS", "OffHandDps")

        return pawn_string

    @staticmethod
    def pawn_dictionary_from_string(pawn_string) -> dict:
        """ Convert pawn string to dictionary """
        
        # '( Pawn: v1: "Blood Death Knight (Noxxic)": Class=Death Knight, Spec=Blood, Versatility=42.67, Mastery=42.08, CriticalStrike=38.40, Haste=30.69, Strength=29.61 )'
        pawn_string = PawnTools.clean_pawn_string(pawn_string)
        pawn_dict = {}
        for line in pawn_string.split(","):
            if "Class=" in line or "Spec=" in line:# or "Pawn:" in line or "v1:" in line:
                continue
            key, value = line.split("=")
            value = value.replace(' )\\"}', "")
            pawn_dict[key.strip()] = value.strip()

        return pawn_dict

    @staticmethod
    def pawn_stat_converter(pawn_dict) -> dict:
        """ Convert pawn dictionary keys to GearHelper keys """
        
        stat_conversion = {
            "intellect": "ITEM_MOD_INTELLECT_SHORT",
            "haste": "ITEM_MOD_HASTE_RATING_SHORT",
            "criticalstrike": "ITEM_MOD_CRIT_RATING_SHORT",
            "versatility": "ITEM_MOD_VERSATILITY",
            "mastery": "ITEM_MOD_MASTERY_RATING_SHORT",
            "agility": "ITEM_MOD_AGILITY_SHORT",
            "stamina": "ITEM_MOD_STAMINA_SHORT",
            "strength": "ITEM_MOD_STRENGTH_SHORT",
            "mainhanddps": "MainHandDps",
            "offhanddps": "OffHandDps",
        }
        converted_dict = {}
        for key, value in pawn_dict.items():
            if key.lower() in stat_conversion:
                converted_dict[stat_conversion[key.lower()]] = value
        return converted_dict

    @staticmethod
    def generate_gh_template_from_pawn_dictionary(pawn_dict) -> str:
        """ Generate GearHelper template string from pawn dictionary """
        
        gh_string = ""
        pawn_dict = PawnTools.pawn_stat_converter(pawn_dict)

        for key, value in pawn_dict.items():
            gh_string += f"           [{key}] = {value},\n"

        return gh_string

def generate_gh_template_for_class(class_spec: WoWClassSpec, templates: dict) -> str:
    """ Generate GearHelper template for a given class/spec from multiple sources """
    
    class_name = class_spec.class_name
    spec_name = class_spec.spec_name
    spec_id = class_spec.spec_id

    class_template = f"    -- {class_name.upper().replace('-', ' ')} {spec_name.upper().replace('-', ' ')} --\n"
    class_template += f"    [{str(spec_id)}] = {{\n"

    for source, template_string in templates.items():
        class_template += f"        [\"{source}\"] = {{\n"
        class_template += template_string
        class_template += "        },\n"
    
    class_template += "    },\n"
    return class_template

def get_noxxic_stats():
    """ Scrape noxxic stats and create part2.txt file """
    
    global wowClassesUrl
    global path
    global linksDic
    global response

    retry_list = []

    # Create a file named "part2" wich will contain noxxic stats
    with open(f"{str(path)}/part2.txt", "w") as file:
        # foreach element in linksDic
        for spec_id, wowClassSpec in linksDic.items():
            class_name = wowClassSpec.class_name
            spec_name = wowClassSpec.spec_name
            spec_name = spec_name.replace(" ", "-") # probably used when using wiki classes
            noxxic_class_url = f"{noxxic_base_url}/{spec_name}-{class_name}{noxxic_stats_prefix}".lower()

            print(f"Scraping {class_name} - {spec_name}: {noxxic_class_url}")

            # Try to connect to noxxic link previously created
            response = requests.get(noxxic_class_url)
            if not response.ok:
                retry_list.append(noxxic_class_url)
                print(f"Error while connecting to {noxxic_class_url}")
                continue

            # Regex to find pawn string in response.text
            regex = r'\\"\(\s*(Pawn: v1:[\s\S]*?)\s*\)\\"}'

            # Only keep regex matching parts of response.text
            match = re.search(regex, response.text)
            
            pawn_string = match.group(0)
            pawn_dict = PawnTools.pawn_dictionary_from_string(pawn_string)
            gh_template_string = PawnTools.generate_gh_template_from_pawn_dictionary(pawn_dict)
            
            final_class_template = generate_gh_template_for_class(wowClassSpec, {"NOX": gh_template_string})
            file.write(final_class_template)
            
        file.write("}\n")
        time.sleep(1)

def create_WeightValues_file():
    """ Create GH_Template.lua file by concatenating part1, part2 and part3 """
    
    global path
    global f1_text
    global f2_text

    # Concatenate files part1, part2 and part3
    filenames = [
        f"{str(path)}/part1.txt",
        f"{str(path)}/part2.txt",
        f"{str(path)}/part3.txt",
    ]
    with open(f"{str(path)}/GH_Template.lua", "w") as StatsActuelles:
        for parts in filenames:
            with open(parts) as infile:
                StatsActuelles.write(infile.read())

    # Remove file part2 (the one created with noxxic values)
    os.remove(f"{str(path)}/part2.txt")

def replace_file():
    """ Move GH_Template.lua to ../Gear/GH_Template.lua """
    
    global path

    source = f"{str(path)}/GH_Template.lua"
    destination = f"{str(path.parent)}/Gear/GH_Template.lua"
    
    os.replace(source, destination) 

if "__main__" == __name__:
    # pawn_string = '( Pawn: v1: "Blood Death Knight (Noxxic)": Class=Death Knight, Spec=Blood, Versatility=42.67, MasteryRating=42.08, CritRating=38.40, HasteRating=30.69, Strength=29.61 )'
    # pawn_dict = PawnTools.pawn_dictionary_from_string(pawn_string)
    # gh_string = PawnTools.generate_gh_template_from_pawn_dictionary(pawn_dict)
    # # print(gh_string)

    # print(generate_gh_template_for_class(WoWClassSpec("Death-Knight", "Blood", 250), {"NOX": gh_string, "Icy-Veins": gh_string}))

    get_classes()
    get_noxxic_stats()
    create_WeightValues_file()
    
    replace_file()
    print("ok")
