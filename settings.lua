dofile_once("data/scripts/lib/mod_settings.lua")

--- note for anyone viewing this file:
---mod assets are not loaded on the main menu, which means we can't split our work into more than one file or use custom libs or sprites
---just wanted to justify why this file is (as of last updating this comment) 1453 lines

local mod_id = "parallel_parity"
mod_settings_version = 1

local function get_setting_id(name)
	return mod_id .. "." .. name
end

local mods_are_loaded = #ModGetActiveModIDs() > 0

local languages = { --translation keys
	["English"] = "en",
	["русский"] = "ru",
	["Português (Brasil)"] = "ptbr",
	["Español"] = "eses",
	["Deutsch"] = "de",
	["Français"] = "frfr",
	["Italiano"] = "it",
	["Polska"] = "pl",
	["简体中文"] = "zhcn",
	["日本語"] = "jp",
	["한국어"] = "ko",
}
local langs_in_order = { --do this cuz key-indexed tables wont keep this order
	"en",
	"ru",
	"ptbr",
	"eses",
	"de",
	"frfr",
	"it",
	"pl",
	"zhcn",
	"jp",
	"ko",
}

local current_language = languages[GameTextGetTranslatedOrNot("$current_language")]

--global table so mods can add their own settings or modify global magic numbers
ParallelParity_Settings = {
	custom_setting_types = {},
	offset_amount = 15,
	max_orbs = 36, -- for mods *cough* Apotheosis *cough cough* which increase the normal amount of orbs in the world
}
local ps = ParallelParity_Settings



--To add translations, add them below the same way English (en) languages have been added.
--Translation Keys can be seen in the `languages` table above
ps.translation_strings = {
	mod_ingame_warning = {
		en = "Warning! Options for other mods will not show up here!",
		en_desc = "Due to fundamental limitations with the Modding API, mods cannot interact with one another until the game begins.\nPlease enter a run if you wish to see settings related to other mods\nNOTE:\nTHIS MOD IS VERY NEW AND THUS DOES NOT CURRENTLY HAVE MANY MOD COMPATIBILITY OPTIONS",
		ptbr = "Aviso! Opções para outros mods não iram aparecer aqui!",
		ptbr_desc = "Por conta de limitações com a Modding API, mods não poderam interagir um com o outro até que o jogo inicie.\nPor favor, entre em uma run se deseja ver opções relacionadas a outros mods\nNOTA:\nESSE MOD É MUITO NOVO E, PORTANTO, NÃO POSSUI MUITAS CONFIGURAÇÕES DE COMPATIBILIDADE COM OUTROS MODS ATUALMENTE",
		de = "Warnung! Einstellungen für andere Mods werden hier nicht angezeigt!",
		de_desc = "Aufgrund grundlegender Limitationen mit der Modding API können Mods erst bei Spielbeginn miteinander interagieren. \nStarte ein Spiel, um Einstellungen bezüglich anderer Mods zu sehen. \nNOTIZ: \nDIESE MOD IST SEHR NEU UND HAT DAHER ZURZEIT KEINE KOMPATIBILITÄTSEINSTELLUNGEN",
	},
	general = {
		en = "General",
		en_desc = "Miscellaneous grouping of pixel scenes that don't fit any other category or earn their own",
		ptbr = "Geral",
		ptbr_desc = "Grupo diverso de \"cenas de pixels\" que não se encaixam em qualquer outra categoria ou que não possuem categoria própria.",
		de = "Allgemein",
		de_desc = "Verschiedene Gruppen von \"Pixelszenen\" welche in keine andere Kategorie fallen",
	},
	visuals = {
		en = "Visuals",
		en_desc = "Mostly cleans up visual pixel-scenes and backgrounds that are not meaningfully gameplay-altering\nThe criteria for this group is decided at my own discretion",
		ptbr = "Visuais",
		ptbr_desc = "Dá uma limpeza em cenas de pixels visuais e backgrounds que não alteram significamente a jogabilidade\nOs critérios para este grupo são definidos a meu critério",
		de = "Visuell",
		de_desc = "Verschönert hauptsächlich visuelle Pixelszenen und Hintergründe welche keinen Einfluss auf das Spielerlebnis haben. \nDie Kriterien für diese Gruppe sind von mir selbst entschieden",
	},
	return_rifts = {
		en = "Return Rifts",
		en_desc = "When a Portal teleports Minä back to the main world, spawns a rift that allows them to return",
		ptbr = "Riftes do Retorno",
		ptbr_desc = "Quando um Portal teleportar Minä de volta para o Mundo Principal, gera um rifte que torna possível retornar ao Mundo Paralelo",
		de = "Rückkehrportal",
		de_desc = "Wenn Minä durch ein Portal in die Hauptwelt gebracht wird, erscheint ein Rückkehrportal, welches die Rückkehr in die Parallelwelt erlaubt",
	},
	pw_counter = {
		en = "Spatial Awareness Fix",
		en_desc = "Improves the Parallel World indicator for Spatial Awareness to display values outside the usual limited range",
		ptbr = "Percepção Espacial (Correção)",
		ptbr_desc = "Aprimora o indicador do Mundo Paralelo da Percepção Espacial, exibindo valores fora do limite normal",
		de = "Räumliches Bewusstsein-Fix",
		de_desc = "Verbessert den Parallelwelt-Indikator für Räumliches Bewusstsein um Werte außerhalb des üblichen Umfangs anzuzeigen",
	},
	ng_plus = {
		en = "New Game+",
		en_desc = "Should changes also apply to New Game+ iterations\nWarning! This feature is incomplete and is thus somewhat experimental, but should be functional!",
		ptbr = "New Game+",
		ptbr_desc = "As mudanças também devem ser aplicadas às iterações do New Game+?\nAviso! Essa funcionalidade está imcompleta e, portanto, é um pouco experimental, mas deve ser funcional!",
		de = "New Game+",
		de_desc = "Sollen Änderungen auch zuünftige New Game+ betreffen? \nWarnung! Diese Finktionaltät ist nicht nicht fertiggestellt und ist etwas experimentell, sollte aber grundlegend funktionieren!",
	},
	mods = {
		en = "Mods",
		en_desc = "Content added by various mods",
		ptbr = "Mods",
		ptbr_desc = "Conteúdo adicionado por vários mods",
		de = "Mods",
		de_desc = "Inhalte hinzugefügt von verschiedenen Mods",
		mod_compat_restart = {
			en = "Restart to apply settings!",
			en_desc = "It is highly recommended you restart your game to apply compatibility settings changes!\nSorry about the inconvenience, mod settings are inherently limited and things like this are necessary for this to work :(",
			ptbr = "Reinicie para aplicar as configurações!",
			ptbr_desc = "É altamente recomendado reiniciar o jogo para aplicar as mudanças das configurações de compatibilidade!\nPeço desculpas pelo inconveniente, configurações de mods são por natureza limitadas e coisas desse tipo são necessárias para fazer isso tudo funcionar :(",
			de = "Starte das Spiel neu um Änderungen anzuwenden!",
			de_desc = "Es ist stark empfohlen, das Spiel neuzustarten um Kompatibilitätseinstellungsänderungen anzuwenden!\n'Tschuldigung, geht leider nicht anders, da Mod-Einstellungen nunmal stark limitiert sind :(",
		},
		no_mods_detected = {
			en = "No mod settings found!",
			en_desc = "Sorgy, nothing here",
			ptbr = "Nenhuma configuração de mod encontrada!",
			ptbr_desc = "Descurpa, nada aqui",
			de = "Keine Modeinstellungen verfügbar!",
			de_desc = "Sowwy, nix hier :(",
		},
	},
	spliced_pixel_scenes = {
		en = "Spliced Pixel Scenes",
		en_desc = "Pixel Scenes that are larger than a single chunk (512x512 area)\nExcept when they're not. Blame Nolla.",
		ptbr = "Cenas de Pixels Emendadas",
		ptbr_desc = "Cenas de Pixels que são maiores que um único chunk (área de 512x512)\nExceto quando não são. Culpa da Nolla.",
		de = "Aufgeteilte Pixelszenen",
		de_desc = "Pixelszenen, welche größer als ein einzelner Chunk (512x512 Pixel) sind\nAußer wenn sie das manchmal nicht sind. Beschwer dich bei Nolla.",
		lava_lake = {
			en = "Lava Lake",
			en_desc = "The large Lava Lake to the right of Mines. This includes the bottom of the pit underneath",
			ptbr = "Lago de Lava",
			ptbr_desc = "O grande Lago de Lava à direita das Minas. Isso inclui o buraco embaixo dele",
			de = "Lavasee",
			de_desc = "Der große Lavasee rechts neben den Minen, inklusive dem Loch darunter.",
			ORB = {
				en = "Spawn Orb",
				en_desc = "Should the Lava Lake Orb spawn in Parallel Worlds",
				ptbr = "Gerar Orbe",
				ptbr_desc = "O Orbe do Lago de Lava deve aparecer em Mundos Paralelos?",
				de = "Generiere Orb",
				de_desc = "Soll der Lavaseeorb in parallelen Welten erscheinen?",
			},
		},
		desert_skull = {
			en = "Desert Skull",
			en_desc = "The giant deer skull located in the Desert",
			ptbr = "Crânio do Deserto",
			ptbr_desc = "O gigante crânio de veado localizado no Deserto",
			de = "Wüstenschädel",
			de_desc = "Der riesige Hirschschädel in der Wüste",
		},
		kolmi_arena = {
			en = "Kolmisilmä Arena",
			en_desc = "The final boss arena after the Temple of the Art including the Holy Mountain just before it",
			ptbr = "Arena de Kolmisilmä",
			ptbr_desc = "A arena do chefão final após o Templo da Arte, incluindo a Montanha Sagrada antes dela",
			de = "Kolmisilmä Arena",
			de_desc = "Die finale Bossarena nach Tempel der Kunst inklusive des letzten Heiligen Berges",
			KOLMI = {
				en = "Spawn Kolmisilmä Varjo",
				en_desc = "Spawns a reflection of Kolmisilmä in Parallel Worlds which you can optionally fight\nSAMPO not included",
				ptbr = "Gerar Kolmisilmä Varjo",
				ptbr_desc = "Gera um reflexo de Kolmisilmä em Mundos Paralelos, o qual você pode opcionalmente enfrentar\nSAMPO não incluído",
				de = "Beschwöre Kolmisilmä Varjo",
				de_desc = "Beschwört eine reflektion von Kolmisilmä in parallelen Welten, welche optional bekämpft werden kann\nSAMPO nicht inklusive",
			}, --if in-game, "SAMPO" is replaced with current sampo name based on orb count, else it is replaced with "Sampo"
		},
		tree = {
			en = "Tree",
			en_desc = "The large tree to the left of the player spawn",
			ptbr = "Árvore",
			ptbr_desc = "A grande árvore à esquerda da área inicial",
			de = "Baum",
			de_desc = "Der große Baum links neben dem Anfangsgebiet",
			GREED = {
				en = "Curse of Greed",
				en_desc = "Should Curse of Greed spawn in Parallel Worlds",
				ptbr = "Maldição da Ganância",
				ptbr_desc = "A Maldição da Ganância deve aparecer em Mundos Parelelos?",
				de = "Fluch der Gier",
				de_desc = "Soll der Fluch der Gier in parallelen Welten erscheinen?",
			},
		},
		dark_cave = {
			en = "Dark Cave",
			en_desc = "The flooded cavern to the left of Mines",
			ptbr = "Caverna Escura",
			ptbr_desc = "A caverna inundada à esquerda das Minas",
			de = "Dunkle Höhle",
			de_desc = "Die geflutete Höhle links neben den Minen",
			HP = {
				en = "HP Pickups",
				en_desc = "Should the HP pickups spawn in Parallel Worlds",
				ptbr = "PV Máximo Extras",
				ptbr_desc = "Os PV Máximo Extras devem aparecer em Mundos Paralelos?",
				de = "HP Herzen",
				de_desc = "Sollen die HP Herzen in parallelen Welten erscheinen?",
			},
		},
		mountain_lake = {
			en = "Mountain Lake",
			en_desc = "The lake between the mountain and the desert, on the surface above the Lava Lake",
			ptbr = "Lago da Montanha",
			ptbr_desc = "O lago entre a montanha e o deserto, na superfície, acima do Lago de Lava",
			de = "Bergsee",
			de_desc = "Der See zwischen dem Berg und der Wüste, auf der Oberfläche über dem Lavasee",
		},
		lake_island = {
			en = "Lake Island",
			en_desc = "The island that spawns on top of the lake",
			ptbr = "Ilha do Lago",
			ptbr_desc = "A ilha que aparece acima do Lago",
			de = "Seeinsel",
			de_desc = "Die Insel, welche auf dem See erscheint",
			FIRE_ESSENCE = {
				en = "Fire Essence",
				en_desc = "Should the Fire Essence under the statue spawn in Parallel Worlds",
				ptbr = "Essência do Fogo",
				ptbr_desc = "A Essência do Fogo deve aparecer embaixo da estátua em Mundos Parelelos?",
				de = "Feueressenz",
				de_desc = "Soll die Feueressenz unter der Statue in parallelen Welten erscheinen?",
			},
			BOSS = {
				en = "Tapion vasalli",
				en_desc = "Should the Lake Island Boss spawn in Parallel Worlds",
				ptbr = "Tapion vasalli",
				ptbr_desc = "O chefão da Ilha do Lago deve aparecer em Mundos Paralelos?",
				de = "Tapion vasalli",
				de_desc = "Soll der Seeinsel-Boss in parallelen Welten erscheinen?",
			},
		},
		moons = {
			en = "Moons",
			en_desc = "The moons located in The Work (Sky) and The Work (Hell)",
			ptbr = "Luas",
			ptbr_desc = "As luas localizadas em Obra (Céu) e Obra (Inferno)",
			de = "Monde",
			de_desc = "Die Monde in Das Große Werk (Himmel) und Das Große Werk (Hölle) ((dort, wo UserK hingehört))",
		},
		gourd_room = {
			en = "Gourd Room",
			en_desc = "The Gourd Room in the left Extremely Dense Rock wall in Cloudscape",
			ptbr = "Sala das Cabaças",
			ptbr_desc = "A Sala das Cabaças na parede de rocha extremamente densa à esquerda da Núbigena",
			de = "Flaschenkürbisraum",
			de_desc = "Der FLASCHENKÜRBISRAUM in der linken Extrem Dichten Steinwand in der Wolkenlandschaft",
			GOURDS = {
				en = "Spawn Gourds",
				en_desc = "Should Gourds from The Gourd Room(tm) spawn in Parallel Worlds",
				ptbr = "Gerar Cabaças",
				ptbr_desc = "As Cabaças da Sala das Cabaças(tm) devem aparecer em Mundos Paralelos?",
				de = "Erschaffe Flaschenkürbisse",
				de_desc = "Sollen FLASCHENKÜRBISSE aus dem FLASCHENKÜRBISRAUM(tm) in parallelen Welten erscheinen?",
			}
		},
		meat_skull = {
			en = "Limatoukka Skull",
			en_desc = "The giant skull that spawns Tiny at the bottom of the desert cavern under Powerplant/Meat Lair",
			ptbr = "Crânio de Limatoukka",
			ptbr_desc = "O crânio gigante que faz Limatoukka aparecer no fundo da caverna do deserto, embaixo da Usina/Reino da Carne",
			de = "Limatoukka-Schädel",
			de_desc = "Der große Schädel, der Tiny beschwört und sich am unteren Ende der Wüstenhöhle unter dem Kraftwerk/dem Fleischreich befindet",
		},
	},
	other_pixel_scenes = {
		en = "Other Pixel Scenes",
		en_desc = "Regular Pixel Scene stuff",
		ptbr = "Outras Cenas de Pixels",
		ptbr_desc = "Coisas comuns de Cenas de Pixels",
		de = "Andere Pixelszenen",
		de_desc = "Reguläres Pixelszenenzeugs",
		hidden = {
			en = "Hidden",
			en_desc = "The background messages hidden throughout the world",
			ptbr = "Escondidas",
			ptbr_desc = "As mensagens escondidas por todo o mundo",
			de = "Versteckt",
			de_desc = "Die in der Welt verstecken Hintergrundnachrichten",
		},
		fungal_altars = {
			en = "Fungal Altars",
			en_desc = "The Fungal Altars and related objects",
			ptbr = "Altares Fúngicos",
			ptbr_desc = "Os Altares Fúngicos e objetos relacionados a eles",
			de = "Pilzaltare",
			de_desc = "Die Pilzaltare und verwandte Objekte",
		},
		fishing_hut = {
			en = "Fishing Hut",
			en_desc = "The Fishing Hut on the right of the Lake",
			ptbr = "Cabana de Pesca",
			ptbr_desc = "A Cabana de Pesca à direita do Lago",
			de = "Fischerhütte",
			de_desc = "Die Fischerhütte am rechten Ufer des Sees",
			BUNKERS = {
				en = "Bunkers",
				en_desc = "The Underwater Bunkers located under the Fishing Hut",
				ptbr = "Bunkers",
				ptbr_desc = "Os Bunkers Subaquáticos localizados embaixo da Cabana de Pesca",
				de = "Bunker",
				de_desc = "Die Unterwasserbunker unter der Fischerhütte",
			}
		},
		pyramid_boss = {
			en = "Kolmisilmän koipi",
			en_desc = "The Boss located in the Pyramid",
			ptbr = "Kolmisilmän koipi",
			ptbr_desc = "O chefão localizado na Pirâmide",
			de = "Kolmisilmän koipi",
			de_desc = "Der Pyramidenboss",
		},
		leviathan = {
			en = "Syväolento",
			en_desc = "The Leviathan of the Lake",
			ptbr = "Syväolento",
			ptbr_desc = "O Leviatã do Lago",
			de = "Syväolento",
			de_desc = "Der Leviathan des Sees",
		},
		avarice_diamond = {
			en = "Avarice Diamond",
			en_desc = "The diamond structure at the top of the Tower on the left",
			ptbr = "Diamante da Avareza",
			ptbr_desc = "A estrutura em formato de diamante no topo da Torre, à esquerda",
			de = "Diamant der Gier",
			de_desc = "Die Diamantstruktur an der Spitze der linken Turms",
		},
		essence_eaters = {
			en = "Essence Eaters",
			en_desc = "The Essence Eaters found in the Snowy Wastes and Desert",
			ptbr = "Papa-essências",
			ptbr_desc = "Os Papa-essências encontrados no Ermo Nevado e no Deserto",
			de = "Essenzfresser",
			de_desc = "Die Essenzfresser im Schneegebiet und der Wüste",
		},
		music_machines = {
			en = "Music Machines",
			en_desc = "The Music Machines\n\nWarning! Spawn positions will be relative to Main World regardless if other pixel scenes are also looped.\nMountain Lake machine will spawn in the ground, Tree machine will spawn very high up, etc.",
			ptbr = "Máquinas de Música",
			ptbr_desc = "As Máquinas de Música\n\nAviso! As posições de spawn serão relativas ao Mundo Principal independetemente de outras cenas de pixels serem repetidas.\nA máquina do Lago da Montanha irá aparecer dentro do chão, a máquina da Árvore irá aparecer bem no alto, etc.",
			de = "Musikmaschinen",
			de_desc = "Die Musikmaschinen\n\nWarnung! Spawnpositionen sind unabhängig davon, ob andere Pixelszenen in parallelen Welten generieren.\nDie Bergseemusikmaschine (tolles Wort!) würde im Boden generieren, die Baummusikmaschine hoch in der Luft, etc.",
		},
		evil_eye = {
			en = "Paha Silmä",
			en_desc = "The Evil Eye located to the left of the Tree",
			ptbr = "Paha Silmä",
			ptbr_desc = "O Olho do Mau localizado à esquerda da Árvore",
			de = "Paha Silmä",
			de_desc = "Das Böse Auge links neben dem Baum",
		},
	},
	portals = {
		en = "Parallel Portals",
		en_desc = "Controls whether portals keep you in your current world or send you back to the Main World",
		ptbr = "Portais Paralelos",
		ptbr_desc = "Controla se os portais mantêm você no mundo atual ou o enviam de volta ao Mundo Principal",
		de = "Parallelportale",
		de_desc = "Kontrolliert, ob Portale dich in der aktuellen Welt behalten oder zurück zur Hauptwelt schicken",
		general = {
			en = "General",
			en_desc = "General portals that don't fall under the other categories",
			ptbr = "Geral",
			ptbr_desc = "Portais que não se enquadram nas outras categorias",
			de = "Generell",
			de_desc = "Generelle Portale, welche in keine andere Kategorie fallen",
		},
		holy_mountain = {
			en = "Holy Mountain",
			en_desc = "The \"Portal Deeper\" that leads into Holy Mountain\nFinal Portal will likely dump you into lava if Kolmisilmä Arena is disabled",
			ptbr = "Montanha Sagrada",
			ptbr_desc = "O \"Portal para as profundezas\" que leva à Montanha Sagrada\nO Portal Final provavelmente jogará você na lava se a Arena de Kolmisilmä estiver desativada",
			de = "Heiliger Berg",
			de_desc = "Das \"Tieferführende Portal\" das in die Heiligen Berge führt\nDas finale Portal wird dich wahrscheinlich in unangenehm heiße Lava stecken, sollte die Kolmisilmä-Arena deaktiviert sein",
		},
		fast_travel = {
			en = "To Portal Room",
			en_desc = "The portal leading to the fast travel room created by Syväolento (Leviathan)\n(Fast Travel portals are already Parallel-World Local)",
			ptbr = "Para a Sala dos Portais",
			ptbr_desc = "O portal criado por Syväolento (Leviatã) que leva à sala de viagem rápida\n(Os portais de viagem rápida já são programados para funcionar em Mundos Paralelos)",
			de = "Zum Portalraum",
			de_desc = "Das Portal, welches zum Schnellreiseraum (Noch ein tolles Wort!) führt, welcher von Syväolento (Leviathan) erschaffen wird\n(Schnellreiseportale funktionieren bereits in parallelen Welten)",
		},
		tower_entrance = {
			en = "Tower Entrance",
			en_desc = "Does not include Tower Exit, which is part of Return Portal",
			ptbr = "Entrada da Torre",
			ptbr_desc = "Não inclui Saída da Torre, que faz parte do Portal de Retorno",
			de = "Turmeingang",
			de_desc = "Beinhaltet nicht den Turmausgang, welcher zu den Rückkehrportalen gehört",
		},
		mountain = {
			en = "Return Portal",
			en_desc = "Portal leading to the mountain\nThis includes the one summoned by the Musical Curiosity and the Tower Exit",
			ptbr = "Portal de Retorno",
			ptbr_desc = "O portal que leva à Montanha\nIsso inclui os que são invocados pela Curiosidade Musical e a Saída da Torre",
			de = "Rückkehrportal",
			de_desc = "Portal, welches zum Berg führt\nBeinhaltet das von der Musikalischen Kuriosität erschaffene Portal sowie den Turmausgang",
		},
		skull_island = {
			en = "Desert-Lake Portals",
			en_desc = "The Desert Skull and Island Statue portals",
			ptbr = "Portais Deserto-Lago",
			ptbr_desc = "Os portais do Crânio do Deserto e da Estátua da Ilha",
			de = "Wüstenseeportale",
			de_desc = "Die Wüstenschädel- und Inselstatuenportale",
		},
		summon = {
			en = "Egg of Technology",
			en_desc = "The portals for the Egg of Technology where the End of Everything spell can be found\nThis also does additional modifications to the jungle biome to make the statues and portal spot work\nin Parallel Worlds",
			ptbr = "Ovo da Tecnologia",
			ptbr_desc = "Os portais para o Ovo da Tecnologia onde o feitiço \"O fim de tudo\" pode ser encontrado\nIsso também faz modificações adicionais ao bioma \"Selva Subterrânea\" para fazer\nas estátuas e o portal funcionarem em Mundos Paralelos",
			de = "Ei der Technologie",
			de_desc = "Die Portale des Eis der Technologie, wo der Das Ende von allem-Zauber gefunden werden kann\nBeinhaltet zusätzliche Änderungen am Jungelbiom damit die Statuen und den Portalort\nin parallelen Welten funktionieren",
		},
	},
	reset = {
		en = "[Reset]",
		en_desc = "Resets all settings to default values",
		ptbr = "[Resetar]",
		ptbr_desc = "Redefine todas as configurações para os valores padrão",
		de = "[Zurücksetzen]",
		de_desc = "Setzt alle Einstellungen auf ihre Standartwerte zurück",
	},
	recommended = {
		en = "[Recommended]",
		en_desc = "Resets all settings to recommended values\nThese are just what I personally would recommend, feel free to play how you want o/ -UserK",
		ptbr = "[Recomendado]",
		ptbr_desc = "Redefine todas as configurações para os valores recomendados\nEssas são as que eu pessoalmente recomendo, sinta-se livre para jogar como quiser o/ -UserK",
		de = "[Empfohlen]",
		de_desc = "Setzt alle Einstellungen auf die empfohlenen Werte\nDiese Werte sind, was ich persönlich empfehlen würde, spiele aber wie Du möchtest! o/ -UserK",
	},
	off = {
		en = "[Off]",
		en_desc = "Turns off all settings!\nLiterally why wouldn't you just turn off the mod?!?",
		ptbr = "[Desl.]",
		ptbr_desc = "Desativa todas as configurações!\nPor que não simplesmente desativar o mod inteiro, né?!?",
	},
	on = {
		en = "[On]",
		en_desc = "Turns on all settings!\nThis is surely how the mod was meant to be played.",
		ptbr = "[Lig.]",
		ptbr_desc = "Ativa todas as configurações!\nIsso é certamente como o mod foi planejado pra ser jogado.",
	},
	translation_credit = {
		en = "Translation Credits",
		ptbr = "Créditos de Tradução",
		de = "Übersetzungsdanksagung",
	},
}

--TRANSLATOR NOTE! you dont have to worry about `translation_credit_data`, i can handle this myself
-- just please provide the colour value you would like your name to be as well as the translation for "[your translation] by [you]"
local translation_credit_data = {
	ptbr = {
		text = "Tradução para português brasileiro por",
		translator = { --note to self, account for multiple translators at some point if that ends up happening
			"Absent Friend",
			r = 190/255,
			g = 146/255,
			b = 190/255,
		}
	},
	de = {
		text = "Deutsche Übersetzung von",
		translator = {
			"Xplosy",
			r = 255/255,
			g = 16/255,
			b = 240/255,
		}
	}
}



local keyboard_state = 0
local orbs = 0
local original_orbs
local orb_offset = 0
local shadow_kolmi_desc_path
local shadow_kolmi_template_desc
local shadow_kolmi_desc = ""

local function change_orb_count(amount)
	orbs = (orbs + amount) % (ps.max_orbs + 1)
	orb_offset = orbs - original_orbs

	local orbs = orbs --do this to modify the value without affecting the global
	if orbs > 13 then
		orbs = 33
		if orbs == original_orbs == 14 then
			orbs = 14 --if the true orb count is 14, then allow the secret 14 orb sampo name to display
		end
	end

	local orb_tl = GameTextGetTranslatedOrNot("$item_mcguffin_" .. orbs)
	if orb_offset ~= 0 then orb_tl = orb_tl .. ("(%d%+d)"):format(original_orbs, orb_offset) end

	shadow_kolmi_desc = string.gsub(shadow_kolmi_template_desc.str, "SAMPO", orb_tl)
end

ps.mod_compat_settings = {
	{
		id = "mod_compat_restart",
		type = "note",
	},
}

--translations are separated for translators' convenience
ps.settings = {
	{
		id = "mod_ingame_warning",
		type = "note",
		render_condition = not mods_are_loaded,
		c = {
			r = .9,
			g = .65,
			b = .65,
		},
		icon = "data/ui_gfx/inventory/icon_warning.png",
		icon_offset_x = -3,
		icon_offset_y = -3,
		text_offset_x = -3,
	},
	{
		id = "general",
		value_default = true,
		value_recommended = true,
		scope = MOD_SETTING_SCOPE_NEW_GAME,
	},
	{
		id = "visuals",
		value_default = true,
		value_recommended = true,
		scope = MOD_SETTING_SCOPE_NEW_GAME,
	},
	{
		id = "return_rifts",
		value_default = false,
		value_recommended = true,
		scope = MOD_SETTING_SCOPE_NEW_GAME,
	},
	{
		id = "pw_counter",
		value_default = true,
		value_recommended = true,
		scope = MOD_SETTING_SCOPE_NEW_GAME,
	},
	{
		id = "ng_plus",
		value_default = true,
		value_recommended = true,
		scope = MOD_SETTING_SCOPE_NEW_GAME,
	},
	{
		id = "mods",
		type = "group",
		items = ps.mod_compat_settings,
		render_condition = mods_are_loaded,
		collapsed = false,
	},
	{
		id = "spliced_pixel_scenes",
		not_path = true,
		type = "group",
		collapsed = mods_are_loaded,
		items = {
			{
				id = "lava_lake",
				value_default = true,
				value_recommended = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
				dependents = {
					{
						id = "ORB",
						value_default = false,
						value_recommended = true,
						requires = { id = "parallel_parity.lava_lake", value = true },
						scope = MOD_SETTING_SCOPE_NEW_GAME,
					},
				},
			},
			{
				id = "desert_skull",
				value_default = true,
				value_recommended = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "kolmi_arena",
				value_default = true,
				value_recommended = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
				dependents = {
					{
						id = "KOLMI",
						value_default = false,
						value_recommended = true,
						requires = { id = "parallel_parity.kolmi_arena", value = true },
						scope = MOD_SETTING_SCOPE_NEW_GAME,
						hover_func = function()
							if shadow_kolmi_template_desc then
								shadow_kolmi_desc_path[shadow_kolmi_template_desc.num] = shadow_kolmi_desc
							end
						end,
					},
				},
			},
			{
				id = "tree",
				value_default = true,
				value_recommended = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
				dependents = {
					{
						id = "GREED",
						value_default = false,
						value_recommended = true,
						requires = { id = "parallel_parity.tree", value = true },
						scope = MOD_SETTING_SCOPE_NEW_GAME,
					},
				},
			},
			{
				id = "dark_cave",
				value_default = true,
				value_recommended = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
				dependents = {
					{
						id = "HP",
						value_default = true,
						value_recommended = true,
						requires = { id = "parallel_parity.dark_cave", value = true },
						scope = MOD_SETTING_SCOPE_NEW_GAME,
					},
				},
			},
			{
				id = "mountain_lake",
				value_default = true,
				value_recommended = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "lake_island",
				value_default = true,
				value_recommended = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
				dependents = {
					{
						id = "FIRE_ESSENCE",
						value_default = false,
						value_recommended = true,
						requires = { id = "parallel_parity.lake_island", value = true },
						scope = MOD_SETTING_SCOPE_NEW_GAME,
					},
					{
						id = "BOSS",
						value_default = false,
						value_recommended = false,
						requires = { id = "parallel_parity.lake_island", value = true },
						scope = MOD_SETTING_SCOPE_NEW_GAME,
					},
				},
			},
			{
				id = "moons",
				value_default = false,
				value_recommended = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "gourd_room",
				value_default = true,
				value_recommended = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
				dependents = {
					{
						id = "GOURDS",
						value_default = false,
						value_recommended = true,
						requires = { id = "parallel_parity.gourd_room", value = true },
						scope = MOD_SETTING_SCOPE_NEW_GAME,
					},
				},
			},
			{
				id = "meat_skull",
				value_default = true,
				value_recommended = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
		},
	},
	{
		id = "other_pixel_scenes",
		not_path = true,
		type = "group",
		collapsed = mods_are_loaded,
		items = {
			{
				id = "hidden",
				value_default = true,
				value_recommended = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "fungal_altars",
				value_default = true,
				value_recommended = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "fishing_hut",
				value_default = true,
				value_recommended = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
				dependents = {
					{
						id = "BUNKERS",
						value_default = true,
						value_recommended = true,
						requires = { id = "parallel_parity.fishing_hut", value = true },
						scope = MOD_SETTING_SCOPE_NEW_GAME,
					},
				},
			},
			{
				id = "pyramid_boss",
				value_default = true,
				value_recommended = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "leviathan",
				value_default = false,
				value_recommended = false,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "avarice_diamond",
				value_default = false,
				value_recommended = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "essence_eaters",
				value_default = true,
				value_recommended = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "music_machines",
				value_default = true,
				value_recommended = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "evil_eye",
				value_default = false,
				value_recommended = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
		},
	},
	{
		id = "portals",
		type = "group",
		collapsed = mods_are_loaded,
		items = {
			{
				id = "general",
				value_default = true,
				value_recommended = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "holy_mountain",
				value_default = true,
				value_recommended = false,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "fast_travel",
				value_default = true,
				value_recommended = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "tower_entrance",
				value_default = true,
				value_recommended = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "mountain",
				value_default = false,
				value_recommended = false,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "skull_island",
				value_default = true,
				value_recommended = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "summon",
				value_default = true,
				value_recommended = true,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
		},
	},
	{
		id = "reset",
		type = "reset_button",
		highlight_c = {
			r = 1,
			g = .7,
			b = .7,
		},
		render_condition = function() return keyboard_state == 0 end,
	},
	{
		id = "recommended",
		type = "reset_button",
		reset_target = "value_recommended",
		render_condition = function() return keyboard_state == 1 end,
		c = {
			r = 85/255,
			g = 23/255,
			b = 187/255,
		},
	},
	{
		id = "off",
		type = "reset_button",
		reset_target = "value_false",
		reset_target_default = false,
		render_condition = function() return keyboard_state == 2 end,
		c = {
			r = 241/255,
			g = 55/255,
			b = 55/255,
		},
		click_func = function()
			change_orb_count(-1)
		end,
	},
	{
		id = "on",
		type = "reset_button",
		reset_target = "value_true",
		reset_target_default = true,
		render_condition = function() return keyboard_state == 3 end,
		c = {
			r = 122/255,
			g = 147/255,
			b = 225/255,
		},
		click_func = function()
			change_orb_count(1)
		end,
	},
	{
		id = "translation_credit",
		type = "tl_credit",
	},
}



-- some of this code is p nasty tbh, flee all ye of weak heart 'n' all, may rewrite this entirely in the future

function ModSettingsGuiCount()
	return 1
end

local screen_w,screen_h
local tlcr_data_ordered = {}
function ModSettingsUpdate(init_scope, is_init)
	current_language = languages[GameTextGetTranslatedOrNot("$current_language")]
	orbs = 12

	local dummy_gui = not is_init and GuiCreate()
	local description_start_pos
	local arbitrary_description_buffer = 11
	if dummy_gui then
		GuiStartFrame(dummy_gui)
		screen_w,screen_h = GuiGetScreenDimensions(dummy_gui)

		--[[ source for magic number -160 below
		local inner_gui_width = 342
		local category_offset = 3
		local mod_setting_offset = 3
		local mod_setting_desc_offset = 5
		local start_pos_offset = (inner_gui_width * -.5) + category_offset + mod_setting_offset + mod_setting_desc_offset
		--]]

		description_start_pos = (screen_w * .5) - 160
	end


	if mods_are_loaded then
		if #ps.mod_compat_settings == 1 then
			table.insert(ps.mod_compat_settings, {
				id = "no_mods_detected",
				type = "note",
				c = {
					r = .5,
					g = .65,
					b = .9,
				}
			})
		end

		local function add_modded_translation(setting, translation_path)
			if setting.translations then
				translation_path[setting.id] = setting.translations
			else
				translation_path[setting.id] = translation_path[setting.id] or {}
			end

			if setting.items then
				for _, item in ipairs(setting.items) do
					add_modded_translation(item, translation_path[setting.id])
				end
			end
			if setting.dependents then
				for _, dependent in ipairs(setting.dependents) do
					add_modded_translation(dependent, translation_path[setting.id])
				end
			end
		end

		for _, mod_group in ipairs(ps.mod_compat_settings) do
			if mod_group.type == "group" and not mod_group.c then
				mod_group.c = {
					r = .2,
					g = .6,
					b = .2,
				}
			end
			add_modded_translation(mod_group, ps.translation_strings.mods)
		end
		if init_scope > 1 then
			orbs = math.min(GameGetOrbCountThisRun(), 15)
			if orbs == 15 then orbs = 33 end
		end
	end
	original_orbs = orbs

	if dummy_gui then
		tlcr_data_ordered = {}
		local max_len = 0
		for _, lang in ipairs(langs_in_order) do
			if translation_credit_data[lang] then
				tlcr_data_ordered[#tlcr_data_ordered+1] = translation_credit_data[lang]
				tlcr_data_ordered[#tlcr_data_ordered].highlighted = lang == current_language
				tlcr_data_ordered[#tlcr_data_ordered].translator.offset = GuiGetTextDimensions(dummy_gui, tlcr_data_ordered[#tlcr_data_ordered].text) + 4
				local curr_x = GuiGetTextDimensions(dummy_gui, tlcr_data_ordered[#tlcr_data_ordered].text .. tlcr_data_ordered[#tlcr_data_ordered].translator[1]) + 4
				if curr_x > max_len then max_len = curr_x end
			end
		end
		tlcr_data_ordered.size = {max_len, 13 * #tlcr_data_ordered}
	end



	local function update_translations_and_path(input_settings, input_translations, path, recursion)
		recursion = recursion or 0
		path = path or ""
		input_settings = input_settings or ps.settings
		input_translations = input_translations or ps.translation_strings
		for key, setting in pairs(input_settings) do
			setting.path = mod_id .. "." .. path .. setting.id
			setting.type = setting.type or type(setting.value_default)
			setting.text_offset_x = setting.text_offset_x or 0

			if setting.items then
				update_translations_and_path(setting.items, input_translations[setting.id], path .. (not setting.not_path and (setting.id .. ".") or ""), recursion + 1)
			elseif setting.dependents then
				update_translations_and_path(setting.dependents, input_translations[setting.id], path .. (not setting.not_path and (setting.id .. ".") or ""), recursion + 1)
			end


			if not dummy_gui then goto continue end

			if input_translations[setting.id] then
				setting.name = input_translations[setting.id][current_language] or input_translations[setting.id].en or setting.id
				if input_translations[setting.id].en_desc and not input_translations[setting.id][current_language] then --if there is english translation but no other translation
					setting.description = input_translations[setting.id].en_desc .. string.format("\n(Missing %s translation)", GameTextGetTranslatedOrNot("$current_language"))
				else
					setting.description = input_translations[setting.id][current_language .. "_desc"]
				end
			else
				setting.name = setting.id
			end

			if setting.description then
				setting._description_lines = {}
				local line_length_max = screen_w - description_start_pos - arbitrary_description_buffer - (recursion * ps.offset_amount)
				local max_line_length = 0
				for line in string.gmatch(setting.description, '([^\n]+)') do
					local line_w = GuiGetTextDimensions(dummy_gui, setting.description or "")
					if line_w > line_length_max then
    					local split_lines = {}
    					local current_line = ""
    					for word in line:gmatch("%S+") do
    					    local test_line = (current_line == "") and word or current_line .. " " .. word
    					    local test_line_w = GuiGetTextDimensions(dummy_gui, test_line)
    					    if test_line_w > line_length_max then
    					        split_lines[#split_lines + 1] = current_line
    					        current_line = word
    					    else
								if test_line_w > max_line_length then max_line_length = test_line_w end
    					        current_line = test_line
    					    end
    					end
    					-- Add the last line if it's not empty
    					if current_line ~= "" then split_lines[#split_lines + 1] = current_line end

						local a = #setting._description_lines
						for i, split_line in ipairs(split_lines) do
							setting._description_lines[a+i] = split_line
						end
					else
						if line_w > max_line_length then max_line_length = line_w end
						setting._description_lines[#setting._description_lines+1] = line
					end

					setting.desc_w = max_line_length
					setting.desc_h = (#setting._description_lines * 13) - 1
				end
			end

			if setting.path == "parallel_parity.kolmi_arena.KOLMI" then
				for i, desc_line in ipairs(setting._description_lines) do
					if string.find(desc_line, "SAMPO") then
						shadow_kolmi_desc_path = setting._description_lines
						shadow_kolmi_template_desc = {
							str = setting._description_lines[i],
							num = i
						}
						shadow_kolmi_desc = string.gsub(desc_line, "SAMPO", GameTextGetTranslatedOrNot("$item_mcguffin_" .. orbs))
						break
					end
				end
			end

			setting.w,setting.h = GuiGetTextDimensions(dummy_gui, setting.name or "")
			if setting.icon then setting.icon_w,setting.icon_h = GuiGetImageDimensions(dummy_gui, setting.icon) end

			::continue::
		end
	end
	update_translations_and_path()

	local function set_defaults(setting)
		if setting.type == "group" then
			for i, item in ipairs(setting.items) do
				set_defaults(item)
			end
		else
			if setting.value_default ~= nil and ModSettingGet(setting.path) == nil then
				ModSettingSet(setting.path, setting.value_default)
			end
			if setting.dependents then
				set_defaults(setting.dependents)
				for i, item in ipairs(setting.dependents) do
					set_defaults(item)
				end
			end
		end
	end
	local function save_setting(setting)
		if setting.items == "group" then
			for i, item in ipairs(setting.items) do
				save_setting(item)
			end
		elseif setting.id ~= nil and setting.scope ~= nil and setting.scope >= init_scope then
			local next_value = ModSettingGetNextValue(setting.path)
			if next_value ~= nil then
				ModSettingSet(setting.path, next_value)
			end
			if setting.dependents then
				for i, item in ipairs(setting.dependents) do
					save_setting(item)
				end
			end
		end
	end
	for i, setting in ipairs(ps.settings) do
		set_defaults(setting)
		save_setting(setting)
	end

	ModSettingSet(get_setting_id("_version"), mod_settings_version)
	if dummy_gui then GuiDestroy(dummy_gui) end
end


--RENDERING
local mouse_is_valid

local function reset_settings_to_default(group, target, default_value)
	target = target or "value_default"
	for _, setting in ipairs(group) do
		local target_value = setting[target]
		if target_value == nil and type(default_value) == type(setting.value_default) then
			target_value = default_value
		end
		if target_value ~= nil then
			ModSettingSet(setting.path, target_value) else --print(setting.path .. " DOES NOT HAVE A DEFAULT FOR " .. target)
		end

		if setting.items then
			reset_settings_to_default(setting.items, target, default_value)
		end
		if setting.dependents then
			reset_settings_to_default(setting.dependents, target, default_value)
		end
	end
end

----Rendering:
local max_id = 0
local function create_id()
	max_id = max_id + 1
	return max_id
end

---Draws a tooltip at desired position
---@param gui gui
---@param setting table pass entire setting rather than raw text to take advantage of prebaked description string size
---@param x number
---@param y number
---@param sprite string? custom 9piece sprite
local function DrawTooltip(gui, setting, x, y, sprite)
	local text_size = {setting.desc_w, setting.desc_h}
	sprite = sprite or "data/ui_gfx/decorations/9piece0_gray.png"
	GuiLayoutBeginLayer(gui)
	GuiZSetForNextWidget(gui, -200)
	GuiImageNinePiece(gui, create_id(), x, y, text_size[1]+10, text_size[2]+2, 1, sprite)
	for i,line in ipairs(setting._description_lines) do
		GuiZSetForNextWidget(gui, -210)
		GuiText(gui, x + 5, y + 1 + (i-1)*13, line)
	end --GuiText doesnt work by itself ig, newlines put next on the same line for some reason? idk.
	GuiLayoutEndLayer(gui)
end

---Create boolean setting
---@param gui gui
---@param x_offset number indentation as a result of child settings
---@param setting table setting data
---@param c number[] colour data
local function BoolSetting(gui, x_offset, setting, c)
	c = c or {
		r = 1,
		g = 1,
		b = 1,
	}
	local is_disabled
	if setting.requires and not ModSettingGet(setting.requires.id) == setting.requires.value then
		is_disabled = true
	end

	local value = ModSettingGet(setting.path)

	GuiText(gui, x_offset, 0, "")
	local _, _, _, x, y = GuiGetPreviousWidgetInfo(gui)
	GuiImageNinePiece(gui, create_id(), x, y, 19+setting.w, setting.h, 0)
	local guiPrev = {GuiGetPreviousWidgetInfo(gui)}

	local clicked, rclicked, highlighted
	if guiPrev[3] and mouse_is_valid then
		highlighted = true
		if setting.hover_func then setting.hover_func() end
		if InputIsMouseButtonJustDown(1) then clicked = true end
		if InputIsMouseButtonJustDown(2) then rclicked = true end
		if (clicked or rclicked) and is_disabled then
			GamePlaySound("ui", "ui/button_denied", 0, 0)
			clicked = false
			rclicked = false
		end
		c = {
			r = 1,
			g = 1,
			b = .7,
		}
	end

	if is_disabled then --dim if disabled
		c = {
			r = c.r * .5,
			g = c.g * .5,
			b = c.b * .5,
		}
	end


	GuiOptionsAddForNextWidget(gui, GUI_OPTION.Layout_NextSameLine)
	GuiColorSetForNextWidget(gui, c.r, c.g, c.b, 1)
	GuiText(gui, x_offset + 19, 0, setting.name)

	if highlighted and setting.description then DrawTooltip(gui, setting, x, y+12) end
	GuiColorSetForNextWidget(gui, c.r, c.g, c.b, 1)

	local toggle_icon = ""
	if is_disabled then toggle_icon = "(X)"
	else toggle_icon = value == true and "(*)" or "(  )" end
	GuiText(gui, x_offset, 0, toggle_icon)

	if clicked then
		GamePlaySound("ui", "ui/button_click", 0, 0)
		ModSettingSet(setting.path, not value)
	end
	if rclicked then
		GamePlaySound("ui", "ui/button_click", 0, 0)
		if keyboard_state == 1 then
			ModSettingSet(setting.path, setting.value_recommended)
		elseif keyboard_state == 2 then
			ModSettingSet(setting.path, false)
		elseif keyboard_state == 3 then
			ModSettingSet(setting.path, true)
		else --if 0
			ModSettingSet(setting.path, setting.value_default)
		end
	end
end

local function draw_translation_credits(gui, x, y)
	GuiLayoutBeginLayer(gui)
	GuiZSetForNextWidget(gui, -200)
	GuiImageNinePiece(gui, create_id(), x, y, tlcr_data_ordered.size[1]+10, tlcr_data_ordered.size[2]+2, 1, "data/ui_gfx/decorations/9piece0_gray.png")
	for i,tl in ipairs(tlcr_data_ordered) do
		if tl.highlighted then
			GuiColorSetForNextWidget(gui, 0.921875, 0.921875, 0.26171875, 1)
		end

		local pos_x,pos_y = x + 5, y + 2 + (i-1)*13
		GuiOptionsAddForNextWidget(gui, GUI_OPTION.Layout_NextSameLine)
		GuiZSetForNextWidget(gui, -210)
		GuiText(gui, pos_x, pos_y , tl.text)
		local c = tl.translator
		GuiColorSetForNextWidget(gui, c.r, c.g, c.b, 1)
		GuiZSetForNextWidget(gui, -210)
		GuiText(gui, pos_x + tl.translator.offset, pos_y, tl.translator[1])
	end --GuiText doesnt work by itself ig, newlines put next on the same line for some reason? idk.
	GuiLayoutEndLayer(gui)
end

function ModSettingsGui(gui, in_main_menu)
	keyboard_state = 0
	if InputIsKeyDown(225) or InputIsKeyDown(229) then
		keyboard_state = 1
	end
	if InputIsKeyDown(224) or InputIsKeyDown(228) then
		keyboard_state = keyboard_state + 2
	end

	GuiLayoutBeginLayer(gui)
	local x_orig,y_orig = (screen_w*.5) - 171.5, 49+.5
	GuiZSetForNextWidget(gui, 1000)
	GuiImageNinePiece(gui, create_id(), x_orig, y_orig, 340-1, 251-1, 0, "") --"data/temp/edge_c2_0.png", for debugging
	mouse_is_valid = ({GuiGetPreviousWidgetInfo(gui)})[3]
	--GuiZSetForNextWidget(gui, 1000)
	--GuiImageNinePiece(gui, create_id(), x_orig, y_orig, 1, 1, 1, "data/temp/edge_c2_1.png") --"data/temp/edge_c2_0.png", for debugging
	GuiLayoutEndLayer(gui)


	local function RenderModSettingsGui(gui, in_main_menu, _settings, offset, parent_is_disabled, recursion)
		recursion = recursion or 0
		offset = offset or 0
		_settings = _settings or ps.settings

		for _, setting in ipairs(_settings) do

			local render_setting
			if type(setting.render_condition) == "function" then
				render_setting = setting.render_condition() --stupid fuckin bullshit, needing me to use functions, lua should just update conditions in real-time :(
			else
				render_setting = setting.render_condition ~= false
			end
			if render_setting then
				local setting_is_disabled = parent_is_disabled or (setting.requires and not ModSettingGet(setting.requires.id) == setting.requires.value)
				if setting.type == "group" then
					local c = setting.c and {
						r = setting.c.r,
						g = setting.c.g,
						b = setting.c.b,
					} or {
						r = .4,
						g = .4,
						b = .75,
					}

					local collapse_icon
					if setting.collapsed then
						collapse_icon = "data/ui_gfx/button_fold_open.png"
					else
						collapse_icon = "data/ui_gfx/button_fold_close.png"
					end
					if setting_is_disabled then
						c.r = c.r * .5
						c.g = c.g * .5
						c.b = c.b * .5
					end

					GuiText(gui, offset, 0, "")
					local _, _, _, x, y = GuiGetPreviousWidgetInfo(gui)

					--GuiOptionsAddForNextWidget(gui, GUI_OPTION.ForceFocusable)
					GuiImageNinePiece(gui, create_id(), x, y, setting.w, setting.h, 0)
					if ({GuiGetPreviousWidgetInfo(gui)})[3] and mouse_is_valid then --check if element was clicked
						c.r = math.min((c.r * 1.2)+.05, 1)
						c.g = math.min((c.g * 1.2)+.05, 1)
						c.b = math.min((c.b * 1.2)+.05, 1)
						if InputIsMouseButtonJustDown(1) then
							GamePlaySound("ui", "ui/button_click", 0, 0)
							setting.collapsed = not setting.collapsed
						end
					end

					GuiOptionsAddForNextWidget(gui, GUI_OPTION.Layout_NextSameLine)
					GuiColorSetForNextWidget(gui, c.r, c.g, c.b, 1)
					GuiImage(gui, create_id(), offset, 0, collapse_icon, 1, 1, 1)


					GuiColorSetForNextWidget(gui, c.r, c.g, c.b, 1)
					GuiText(gui, offset+10, 0, setting.name)
					if setting.description then
						GuiTooltip(gui, setting.description, "")
					end

					--i think recursion just works here
					if setting.collapsed ~= true then RenderModSettingsGui(gui, in_main_menu, setting.items, offset + ps.offset_amount, setting_is_disabled, recursion) end
				elseif setting.type == "boolean" then
					BoolSetting(gui, offset, setting, {
						r = .7^recursion,
						g = .7^recursion,
						b = .7^recursion,
					})

				elseif setting.type == "note" then
					local c = setting.c and {
						r = setting.c.r,
						g = setting.c.g,
						b = setting.c.b,
					} or {
						r = .7,
						g = .7,
						b = .7,
					}

					GuiText(gui, offset, 0, "")
					local _, _, _, x, y = GuiGetPreviousWidgetInfo(gui)

					--GuiOptionsAddForNextWidget(gui, GUI_OPTION.ForceFocusable)
					GuiImageNinePiece(gui, create_id(), x, y, setting.w+(setting.icon_w or 0)+(setting.text_offset_x or 0), setting.h, 0)
					local guiPrev = {GuiGetPreviousWidgetInfo(gui)}

					if guiPrev[3] and mouse_is_valid and setting.description then
						c.r = math.min((c.r * 1.2)+.05, 1)
						c.g = math.min((c.g * 1.2)+.05, 1)
						c.b = math.min((c.b * 1.2)+.05, 1)
						DrawTooltip(gui, setting, x, y+12)
					end

					if setting.icon then
						GuiOptionsAddForNextWidget(gui, GUI_OPTION.Layout_NextSameLine)
						GuiImage(gui, create_id(), (setting.icon_offset_x or 0) + offset, setting.icon_offset_y or 0, setting.icon, 1, 1, 1)
					end
					GuiColorSetForNextWidget(gui, c.r, c.g, c.b, 1)
					GuiText(gui, (setting.icon_w or 0) + setting.text_offset_x + offset, 0, setting.name)
				elseif setting.type == "reset_button" then
					GuiText(gui, 0, 0, "")
					local _, _, _, x, y = GuiGetPreviousWidgetInfo(gui)
					GuiImageNinePiece(gui, create_id(), x, y, setting.w, setting.h, 0)
					local guiPrev = {GuiGetPreviousWidgetInfo(gui)}


					local c = setting.c or {
						r = 1,
						g = 1,
						b = 1,
					}
					if guiPrev[3] and mouse_is_valid then
						c = setting.highlight_c or {
							r = math.min((c.r * 1.2)+.05, 1),
							g = math.min((c.g * 1.2)+.05, 1),
							b = math.min((c.b * 1.2)+.05, 1),
						}
						DrawTooltip(gui, setting, x, y+12)
						if InputIsMouseButtonJustUp(1) then
							if setting.click_func then
								setting.click_func()
							end
							GamePlaySound("ui", "ui/button_click", 0, 0)
							reset_settings_to_default(ps.settings, setting.reset_target, setting.reset_target_default)
						end
					end

					--GuiOptionsAddForNextWidget(gui, GUI_OPTION.Layout_NextSameLine)
					GuiColorSetForNextWidget(gui, c.r, c.g, c.b, 1)
					GuiText(gui, (setting.icon_w or 0) + setting.text_offset_x, 0, setting.name)

				elseif setting.type == "tl_credit" then
					GuiText(gui, 0, 0, "")
					local _, _, _, x, y = GuiGetPreviousWidgetInfo(gui)
					GuiImageNinePiece(gui, create_id(), x, y, setting.w, setting.h, 0)
					local guiPrev = {GuiGetPreviousWidgetInfo(gui)}

					local c = {
						r = 0.21,
						g = 0.5,
						b = 0.21,
					}
					if guiPrev[3] and mouse_is_valid then
						c.r = math.min((c.r * 1.2)+.05, 1)
						c.g = math.min((c.g * 1.2)+.05, 1)
						c.b = math.min((c.b * 1.2)+.05, 1)
						draw_translation_credits(gui, x, y+12)
					end

					--GuiOptionsAddForNextWidget(gui, GUI_OPTION.Layout_NextSameLine)
					GuiColorSetForNextWidget(gui, c.r, c.g, c.b, 1)
					GuiText(gui, (setting.icon_w or 0) + setting.text_offset_x, 0, setting.name)

				elseif ps.custom_setting_types[setting.type] then
					ps.custom_setting_types[setting.type](gui, offset, setting)
				end

				if setting.dependents then
					RenderModSettingsGui(gui, in_main_menu, setting.dependents, offset + ps.offset_amount, setting_is_disabled, recursion + 1)
				end
			end
		end
	end

	RenderModSettingsGui(gui, in_main_menu)
end


--this is just here to stop vsc from pestering me about undefined globals

MOD_SETTING_SCOPE_NEW_GAME = MOD_SETTING_SCOPE_NEW_GAME --`0` - setting change (that is the value that's visible when calling ModSettingGet()) is applied after a new run is started
MOD_SETTING_SCOPE_RUNTIME_RESTART = MOD_SETTING_SCOPE_RUNTIME_RESTART --`1` - setting change is applied on next game exe restart
MOD_SETTING_SCOPE_RUNTIME = MOD_SETTING_SCOPE_RUNTIME --`2` - setting change is applied immediately
MOD_SETTING_SCOPE_ONLY_SET_DEFAULT = MOD_SETTING_SCOPE_ONLY_SET_DEFAULT --`3` - this tells us that no changes should be applied. shouldn't be used in mod setting definition.
GUI_OPTION = GUI_OPTION