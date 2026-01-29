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
	["Українська"] = "ukr",
	["Türkçe"] = "trtr",
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
	"ukr",
	"trtr",
}

local current_language = languages[GameTextGetTranslatedOrNot("$current_language")] or "unknown"
local cached_lang

--global table so mods can add their own settings or modify global magic numbers
ParallelParity_Settings = {
	custom_setting_types = {}, --custom settings handling, in case someone does something like that
	offset_amount = 15, --indentation caused by nested settings
	desc_line_gap = 12, --distance betwen the start of one line and the start of the next
	tooltip_buffer = 11, --buffer distance required between the end of a tooltip and the edge of the game screen used for linebreaks
	extra_line_sep = 2, --distance between normal descriptions and extra lines
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
		--en_desc = "Mostly cleans up visual pixel-scenes and backgrounds that are not meaningfully gameplay-altering\nThe criteria for this group is decided at my own discretion",
		ptbr = "Visuais",
		--ptbr_desc = "Dá uma limpeza em cenas de pixels visuais e backgrounds que não alteram significamente a jogabilidade\nOs critérios para este grupo são definidos a meu critério",
		de = "Visuell",
		--de_desc = "Verschönert hauptsächlich visuelle Pixelszenen und Hintergründe welche keinen Einfluss auf das Spielerlebnis haben. \nDie Kriterien für diese Gruppe sind von mir selbst entschieden",
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
	vertical = {
		en = "Vertical Parity",
		en_desc = "As above, so below.",
		ru_desc = "Как вверху, так и внизу.",
		ptbr_desc = "Assim na terra como no céu.",
		eses_desc = "Como es arriba, es abajo.",
		de_desc = "Wie oben, so unten.",
		frfr_desc = "Ce qui est en haut est comme ce qui est en bas.",
		it_desc = "Come in cielo, così in terra.",
		pl_desc = "Jako w niebie, tak i na ziemi.",
		zhcn_desc = "上下一致.",
		jp_desc = "上のように、下も.",
		ko_desc = "위에서, 그리고 아래에서.",
		pixel_scenes = {
			en = "Pixel Scenes",
			en_desc = "Should Pixel Scenes from the Pixel Scenes and Spliced Pixel Scenes categories spawn Above/Below\nSome things may not spawn in properly or be replaced due to lacking relevant Spawn Functions",
		},
		biome_scenes = {
			en = "Biome Scenes",
			en_desc = "Should Pixel Scenes that already spawn in Parallel Worlds spawn Above/Below (eg. Holy Mountains)",
		},
		biome_names = {
			en = "Above/Below biome names",
			en_desc = "Display a \"ENTERED ABOVE/BELOW (biome name)\" similar to Parallel World biome names",
		},
		spatial_awareness_coordinate_display = {
			en = "Spatial Awareness Coordinate Format",
			en_desc = "How should your current vertical and horizontal coordinates in Parallel Worlds be displayed",
			options = {
				none = {
					en = "None",
					en_desc = "Do not display vertical position",
				},
				grid = {
					en = "Cartesian",
					en_desc = "Display position as (x, y) coordinates on a grid",
				},
				polar = {
					en = "Polar",
					en_desc = "Display position as (r, θ)",
				},
			},
		},
	}, --[[I grabbed the translations from $log_collision_2, please correct if you feel any of this is inaccurate! -UserK]]
	worldgen_scope = {
		en = "Worldgen Changes Apply",
		en_desc = "When should settings related to World Generation be applied?\nIf on restart, already loaded chunks will be unaffected and will not generate new pixel scenes or remove old ones",
		options = {
			new_run = {
				en = "On New Run",
				en_desc = "Apply worldgen changes when you start a new run",
			},
			restart = {
				en = "On Restart",
				en_desc = "Apply worldgen changes when you restart your game or start a new run",
			},
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

	data = { --translations for non-settings
		extra_lines = {
			scope_new_run = {
				en = "Changes will apply on your next run",
			},
			scope_restart = {
				en = "Changes will apply when you next restart or on your next run",
			},
		}, --displayed as a tooltip when a user changes a setting that will not be applied under the current scope
	},
}

--TRANSLATOR NOTE! you dont have to worry about `translation_credit_data`, i can handle this myself
-- just please provide the colour value you would like your name to be as well as the translation for "[your translation] by [you]"
-- (if the structure "[text] [translator]" doesnt read well in your language, dw I'll handle it o/)
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
	},
}

--[[ translation line counter (just for when I'm curious how many lines of translateable text there is in this mod), not including `translation_credit_data`
local translatable = 0
local translations = 0
local function func(t)
	if t.en then translatable = translatable + 1 end
	if t.en_desc then translatable = translatable + 1 end
	for key, value in pairs(t) do
		local vtype = type(value)
		if vtype == "table" then
			func(value)
		elseif vtype == "string" then
			translations = translations + 1
		end
	end
end
func(ps.translation_strings)
print("translatable: " .. translatable)
print("translations: " .. translations)
print(("translated: %s%%"):format((translations/(translatable*3))*100))--]]

--[[ injector for ModSettingSet and ModSettingSetValue so i can read the values being changed more easily
local old_modsettingset = ModSettingSet
function ModSettingSet(id, value)
	local prev_value = ModSettingGet(id)
	local str = ("MOD SETTING SET: [%s], %s --> %s"):format(id, prev_value, value)
	if value ~= prev_value then str = str .. "                                 ------------------------------" end
	print(str)
	old_modsettingset(id, value)
end

local old_modsettingsetnextvalue = ModSettingSetNextValue
function ModSettingSetNextValue(id, value, is_default)
	local prev_value = ModSettingGetNextValue(id)
	local str = ("MOD SETTING SET NEXT VALUE: [%s], %s --> %s"):format(id, prev_value, value)
	if value ~= prev_value then str = str .. "                                 ------------------------------" end
	print(str)
	old_modsettingsetnextvalue(id, value, is_default)
end --]]



local font_dir
if ModDoesFileExist("mods/parallel_parity/fonts/regular.xml") then
	font_dir = "mods/parallel_parity/fonts/"
else
	font_dir = "../../workshop/content/881100/3635992834/fonts/workshop/"
end --if i cant locate the fonts under the local mods folder, the mod has to be running from the workshop directory

local regular_font = font_dir .. "regular.xml"


if mods_are_loaded and DebugGetIsDevBuild() then --custom fonts do not work in-game for noita_dev.exe: https://discord.com/channels/453998283174576133/632303734877192192/1465859077216145541
	regular_font = "data/fonts/font_pixel_noshadow.xml"
end

--ukrainian language that worked
--regular_font = "../../workshop/content/881100/2921365704/fonts/font_pixel_huge.xml"


local current_scope
local screen_w,screen_h
local description_start_pos
local keyboard_state = 0

local worldgen_scope = ModSettingGet("parallel_parity.worldgen_scope") == "on_restart" and 1 or 0
print("worldgen_scope: " .. worldgen_scope)

local orbs = 12
local original_orbs
local orb_offset = 0
local shadow_kolmi_desc_path
local shadow_kolmi_template_desc
local shadow_kolmi_desc

local logging = true
local function log(...)
	if logging then
		local str = ""
		for _, value in ipairs({...}) do
			str = str .. tostring(value)
		end
		print(str)
	end
end

local function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end


local function update_orb_count(amount)
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
	if orb_offset ~= 0 then orb_tl = orb_tl .. (" (%d%+d)"):format(original_orbs, orb_offset) end

	shadow_kolmi_desc = string.gsub(shadow_kolmi_template_desc.str, "SAMPO", orb_tl)
end


local function generate_tooltip_data(gui, text, offset_x, extra_lines)
	offset_x = offset_x or 0

	local data = {
		lines = {},
		w = 0,
		h = 0,
	}

	local line_length_max = screen_w - description_start_pos - ps.tooltip_buffer - offset_x
	local max_line_length = 0

	local function line_break(target_line)
		local split_lines = {}
		local current_line = ""
		for word in target_line:gmatch("%S+") do
			local test_line = (current_line == "") and word or current_line .. " " .. word
			local test_line_w = GuiGetTextDimensions(gui, test_line, 1, 2, regular_font)
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


		return split_lines
	end --i actually realised i didnt need to modularise this when i realised I could instead modularise split_lines, may recombine


	local function split_lines(str)
		local lines = {}
		for line in string.gmatch(str, '([^\n]+)') do
			local line_w = GuiGetTextDimensions(gui, str or "", 1, 2, regular_font)
			if line_w > line_length_max then
				local split_lines = line_break(line)

				local a = #lines
				for i, split_line in ipairs(split_lines) do
					lines[a+i] = split_line
				end
			else
				if line_w > max_line_length then max_line_length = line_w end
				lines[#lines+1] = line
			end
		end


		return lines
	end


	local x_pos = 0
	local y_pos = 0

	if text then
		for i, line in ipairs(split_lines(text)) do
			data.lines[#data.lines+1] = {
				text = line,
				x = x_pos,
				y = y_pos,
				c = {
					r = 1,
					g = 1,
					b = 1,
				},
			}

			y_pos = y_pos + ps.desc_line_gap
		end
	end


	if extra_lines then
		for key, value in pairs(extra_lines) do
			if #data.lines > 0 then
				y_pos = y_pos + ps.extra_line_sep
			end

			for i, line in ipairs(split_lines(value.text)) do
				data.lines[#data.lines+1] = {
					text = line,
					x = x_pos,
					y = y_pos,
					c = value.c or {
						r = 1,
						g = 1,
						b = 1,
					},
				}

				y_pos = y_pos + ps.desc_line_gap
			end
		end
	end

	if #data.lines == 0 then return end

	data.w = max_line_length - 1 --save afterwards in case it was entended by extra_lines
	data.h = (#data.lines * (ps.desc_line_gap + 1)) - 1

	return data
end

--MOD_SETTING_SCOPE_NEW_GAME
--MOD_SETTING_SCOPE_RUNTIME_RESTART
--MOD_SETTING_SCOPE_RUNTIME
local scopes = {
	"scope_new_run",
	"scope_restart",
	--"scope_runtime", --this should be unused
}

local function SettingUpdate(gui, setting, translation)
	if translation then
		setting.name = translation[current_language] or translation.en or setting.id
		if translation.en_desc and not translation[current_language] then --if there is english translation but no other translation
			setting.description = translation.en_desc .. string.format("\n(Missing %s translation)", GameTextGetTranslatedOrNot("$current_language"))
		else
			setting.description = translation[current_language .. "_desc"]
		end
	else
		setting.name = setting.name or setting.id
	end

	setting.extra_lines = {}

	if ModSettingGet(setting.path) ~= ModSettingGetNextValue(setting.path) then
		setting.extra_lines.scope_warning = ps.data.extra_lines[scopes[setting.scope+1]]
	end

	setting.w,setting.h = GuiGetTextDimensions(gui, setting.name or "", 1, 2, regular_font)
	if setting.icon then setting.icon_w,setting.icon_h = GuiGetImageDimensions(gui, setting.icon) end

	if setting.options then
		if translation then
			setting.option_names = {}
			setting.option_descriptions = {}
			setting.option_desc_data = {}

			if translation.options then
				for i, option in ipairs(setting.options) do
					local desc

					if translation.options[option] then
						setting.option_names[i] = translation.options[option][current_language] or translation.options[option].en or option

						if translation.options[option][current_language .. "_desc"] then
							desc = translation.options[option][current_language .. "_desc"]
						elseif translation.options[option].en_desc then
							desc = translation.options[option].en_desc .. string.format("\n(Missing %s translation)", GameTextGetTranslatedOrNot("$current_language"))
						end
					else
						setting.option_names[i] = option
					end

					if desc then
						setting.option_descriptions[i] = desc
						setting.option_desc_data[i] = generate_tooltip_data(gui, desc, (setting.recursion * ps.offset_amount) + setting.w, setting.extra_lines)
					end
				end
			else
				for i, option in ipairs(setting.options) do
					setting.option_names[i] = option
				end
			end
		else
			local descs = setting.option_descriptions or {}
			for i,_ in ipairs(setting.options) do
				setting.option_desc_data[i] = generate_tooltip_data(gui, descs[i], (setting.recursion * ps.offset_amount) + setting.w, setting.extra_lines)
			end
		end
		setting.current_option = ModSettingGetNextValue(setting.path) or setting.value_default
		setting.current_option_int = 1
		for index, value in ipairs(setting.options) do
			if value == setting.value_default then setting.value_default_int = index end
			if value == setting.value_recommended then setting.value_recommended_int = index end
			if value == setting.value_on then setting.value_on_int = index end
			if value == setting.value_off then setting.value_off_int = index end

			if value == setting.current_option then setting.current_option_int = index end
		end

		setting.value_default = setting.value_default or 1
		setting.value_recommended = setting.value_recommended or setting.value_default
		setting.value_on = setting.value_on or setting.value_default
		setting.value_off = setting.value_off or setting.value_default
	end

	setting.desc_data = generate_tooltip_data(gui, setting.description, setting.recursion * ps.offset_amount, setting.extra_lines)


	if setting.path == "parallel_parity.kolmi_arena.KOLMI" then
		for i, desc_line in ipairs(setting.desc_data.lines) do
			if string.find(desc_line.text, "SAMPO") then
				shadow_kolmi_desc_path = setting.desc_data.lines
				shadow_kolmi_template_desc = {
					str = setting.desc_data.lines[i].text,
					num = i
				}
				update_orb_count(0)
				break
			end
		end
	end
end

local function SettingSetValue(setting, value)
	if not current_scope then print("SCOPE IS UNDEFINED") return end

	if setting.scope >= current_scope or not mods_are_loaded then
		ModSettingSet(setting.path, value)
	end
	ModSettingSetNextValue(setting.path, value, false)

	SettingUpdate(GuiCreate(), setting)
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
		scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
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
		scope = worldgen_scope,
	},
	{
		id = "pw_counter",
		value_default = true,
		value_recommended = true,
		scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
	},
	{
		id = "ng_plus",
		value_default = true,
		value_recommended = true,
		scope = worldgen_scope,
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
				scope = worldgen_scope,
				dependents = {
					{
						id = "ORB",
						value_default = false,
						value_recommended = true,
						requires = { id = "parallel_parity.lava_lake", value = true },
						scope = worldgen_scope,
					},
				},
			},
			{
				id = "desert_skull",
				value_default = true,
				value_recommended = true,
				scope = worldgen_scope,
			},
			{
				id = "kolmi_arena",
				value_default = true,
				value_recommended = true,
				scope = worldgen_scope,
				dependents = {
					{
						id = "KOLMI",
						value_default = false,
						value_recommended = true,
						requires = { id = "parallel_parity.kolmi_arena", value = true },
						scope = worldgen_scope,
						hover_func = function()
							if shadow_kolmi_template_desc then
								shadow_kolmi_desc_path[shadow_kolmi_template_desc.num].text = shadow_kolmi_desc
							end
						end,
					},
				},
			},
			{
				id = "tree",
				value_default = true,
				value_recommended = true,
				scope = worldgen_scope,
				dependents = {
					{
						id = "GREED",
						value_default = false,
						value_recommended = true,
						requires = { id = "parallel_parity.tree", value = true },
						scope = worldgen_scope,
					},
				},
			},
			{
				id = "dark_cave",
				value_default = true,
				value_recommended = true,
				scope = worldgen_scope,
				dependents = {
					{
						id = "HP",
						value_default = true,
						value_recommended = true,
						requires = { id = "parallel_parity.dark_cave", value = true },
						scope = worldgen_scope,
					},
				},
			},
			{
				id = "mountain_lake",
				value_default = true,
				value_recommended = true,
				scope = worldgen_scope,
			},
			{
				id = "lake_island",
				value_default = true,
				value_recommended = true,
				scope = worldgen_scope,
				dependents = {
					{
						id = "FIRE_ESSENCE",
						value_default = false,
						value_recommended = true,
						requires = { id = "parallel_parity.lake_island", value = true },
						scope = worldgen_scope,
					},
					{
						id = "BOSS",
						value_default = false,
						value_recommended = false,
						requires = { id = "parallel_parity.lake_island", value = true },
						scope = worldgen_scope,
					},
				},
			},
			{
				id = "moons",
				value_default = false,
				value_recommended = true,
				scope = worldgen_scope,
			},
			{
				id = "gourd_room",
				value_default = true,
				value_recommended = true,
				scope = worldgen_scope,
				dependents = {
					{
						id = "GOURDS",
						value_default = false,
						value_recommended = true,
						requires = { id = "parallel_parity.gourd_room", value = true },
						scope = worldgen_scope,
					},
				},
			},
			{
				id = "meat_skull",
				value_default = true,
				value_recommended = true,
				scope = worldgen_scope,
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
				scope = worldgen_scope,
			},
			{
				id = "fungal_altars",
				value_default = true,
				value_recommended = true,
				scope = worldgen_scope,
			},
			{
				id = "fishing_hut",
				value_default = true,
				value_recommended = true,
				scope = worldgen_scope,
				dependents = {
					{
						id = "BUNKERS",
						value_default = true,
						value_recommended = true,
						requires = { id = "parallel_parity.fishing_hut", value = true },
						scope = worldgen_scope,
					},
				},
			},
			{
				id = "pyramid_boss",
				value_default = true,
				value_recommended = true,
				scope = worldgen_scope,
			},
			{
				id = "leviathan",
				value_default = false,
				value_recommended = false,
				scope = worldgen_scope,
			},
			{
				id = "avarice_diamond",
				value_default = false,
				value_recommended = true,
				scope = worldgen_scope,
			},
			{
				id = "essence_eaters",
				value_default = true,
				value_recommended = true,
				scope = worldgen_scope,
			},
			{
				id = "music_machines",
				value_default = true,
				value_recommended = true,
				scope = worldgen_scope,
			},
			{
				id = "evil_eye",
				value_default = false,
				value_recommended = true,
				scope = worldgen_scope,
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
				scope = worldgen_scope,
			},
			{
				id = "holy_mountain",
				value_default = true,
				value_recommended = false,
				scope = worldgen_scope,
			},
			{
				id = "fast_travel",
				value_default = true,
				value_recommended = true,
				scope = worldgen_scope,
			},
			{
				id = "tower_entrance",
				value_default = true,
				value_recommended = true,
				scope = worldgen_scope,
			},
			{
				id = "mountain",
				value_default = false,
				value_recommended = false,
				scope = worldgen_scope,
			},
			{
				id = "skull_island",
				value_default = true,
				value_recommended = true,
				scope = worldgen_scope,
			},
			{
				id = "summon",
				value_default = true,
				value_recommended = true,
				scope = worldgen_scope,
			},
		},
	}, --[[
	{
		id = "vertical", --tempted to name it "Vertical Insanity"
		type = "group",
		collapsed = true,
		items = {
			{
				id = "pixel_scenes",
				value_default = false,
				value_recommended = false,
			},
			{
				id = "biome_scenes",
				value_default = false,
				value_recommended = false,
			},
			{
				id = "biome_names",
				value_default = false,
				value_recommended = true,
			},
			{
				id = "spatial_awareness_coordinate_display",
				type = "options",
				options = {"none", "grid", "polar"},
				value_default = "none",
				value_recommended = "grid",
			},
		}
	},--]]
	{
		id = "worldgen_scope",
		type = "options",
		options = {"new_run", "restart"},
		value_default = "new_run",
		value_recommended = "new_run",
		scope = MOD_SETTING_SCOPE_RUNTIME
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
		reset_target = "value_on",
		reset_target_default = false,
		render_condition = function() return keyboard_state == 2 end,
		c = {
			r = 241/255,
			g = 55/255,
			b = 55/255,
		},
		click_func = function()
			update_orb_count(-1)
		end,
	},
	{
		id = "on",
		type = "reset_button",
		reset_target = "value_on",
		reset_target_default = true,
		render_condition = function() return keyboard_state == 3 end,
		c = {
			r = 122/255,
			g = 147/255,
			b = 225/255,
		},
		click_func = function()
			update_orb_count(1)
		end,
	},
	{
		id = "translation_credit",
		type = "tl_credit",
	},
}


ps.data = {
	extra_lines = {
		scope_new_run = {
			c = {
				r = 241/255,
				g = 241/255,
				b = 139/255,
			},
		},
		scope_restart = {
			c = {
				r = 241/255,
				g = 241/255,
				b = 139/255,
			},
		},
	},
}


-- some of this code is p nasty tbh, flee all ye of weak heart 'n' all, may rewrite this entirely in the future

function ModSettingsGuiCount()
	return 1
end

local tlcr_data_ordered = {}
function ModSettingsUpdate(init_scope, is_init)
	current_scope = init_scope

	current_language = languages[GameTextGetTranslatedOrNot("$current_language")] or "unknown"
	local cached = current_language == cached_lang
	cached_lang = current_language

	local dummy_gui = not is_init and GuiCreate()
	if dummy_gui then
		GuiStartFrame(dummy_gui)
		screen_w = GuiGetScreenDimensions(dummy_gui)

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
			if setting.data then
				for _, dependent in ipairs(setting.data) do
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
				tlcr_data_ordered[#tlcr_data_ordered].translator.offset = GuiGetTextDimensions(dummy_gui, tlcr_data_ordered[#tlcr_data_ordered].text, 1, 2, regular_font) + 4
				local curr_x = GuiGetTextDimensions(dummy_gui, tlcr_data_ordered[#tlcr_data_ordered].text .. tlcr_data_ordered[#tlcr_data_ordered].translator[1], 1, 2, regular_font) + 4
				if curr_x > max_len then max_len = curr_x end
			end
		end
		tlcr_data_ordered.size = {max_len, ps.desc_line_gap * #tlcr_data_ordered}
	end

	local function cache_settings(input_settings, input_translations, path, recursion)
		recursion = recursion or 0
		path = path or ""
		input_settings = input_settings or ps.settings
		input_translations = input_translations or ps.translation_strings
		for _, setting in pairs(input_settings) do
			if not setting.id then goto continue end
			setting.path = mod_id .. "." .. path .. setting.id
			setting.type = setting.type or type(setting.value_default)
			setting.text_offset_x = setting.text_offset_x or 0
			setting.recursion = recursion + 1

			local child_path = path .. (not setting.not_path and (setting.id .. ".") or "")
			for _, v in pairs(setting) do
				if type(v) == "table" then
					local is_table_of_tables = true
					for _, item in pairs(v) do
						if type(item) ~= "table" then is_table_of_tables = false end
					end

					if is_table_of_tables then
						cache_settings(v, input_translations[setting.id], child_path, recursion + 1)
					end
				end
			end

			if dummy_gui then
				SettingUpdate(dummy_gui, setting, input_translations[setting.id])
			end

			::continue::
		end
	end

	local function cache_settings_data(input_data, input_translations, recursion)
		recursion = (recursion or 0) + 1

		input_data.text = input_translations[current_language] or input_translations.en or nil

		for key, value in pairs(input_data) do
			if type(value) == "table" and input_translations[key] then
				cache_settings_data(value, input_translations[key], recursion + 1)
			end
		end
	end

	local function apply_settings(setting)
		if setting.path then
			local current_value = ModSettingGet(setting.path)
			local next_value = ModSettingGetNextValue(setting.path)

			if current_value == nil and setting.value_default ~= nil then
				current_value = setting.value_default
			end
			if next_value == nil and current_value ~= nil then
				next_value = current_value
				ModSettingSetNextValue(setting.path, next_value, false)
			end

			if current_value ~= next_value and setting.scope >= init_scope then
				current_value = next_value
			end

			if current_value ~= nil then ModSettingSet(setting.path, current_value) end

			--if setting.value_default ~= nil then
			--	log(setting.path)
			--	log(ModSettingGet(setting.path))
			--	log(ModSettingGetNextValue(setting.path))
			--end
		end

		for _, value in pairs(setting) do
			if type(value) == "table" then
				apply_settings(value)
			end
		end

	end



	if not cached then
		cache_settings()
		cache_settings_data(ps.data, ps.translation_strings.data)
	end

	for i, setting in ipairs(ps.settings) do
		apply_settings(setting)
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
			SettingSetValue(setting, target_value) --else print(setting.path .. " DOES NOT HAVE A DEFAULT FOR " .. target)
		end

		if type(setting.options) == "table" then
			setting.current_option_int = setting[target .. "_int"]
			setting.current_option = setting.options[setting.current_option_int]
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
---@param data table pass table of desc data to allow prebaking values
---@param x number
---@param y number
---@param sprite string? custom 9piece sprite
local function DrawTooltip(gui, data, x, y, sprite)
	local text_size = {data.w, data.h}
	sprite = sprite or "data/ui_gfx/decorations/9piece0_gray.png"
	GuiLayoutBeginLayer(gui)
	GuiZSetForNextWidget(gui, -200)
	GuiImageNinePiece(gui, create_id(), x, y, text_size[1]+10, text_size[2]+2, 1, sprite)
	y = y + 1
	for i,line in ipairs(data.lines) do
		GuiZSetForNextWidget(gui, -210)
		GuiColorSetForNextWidget(gui, line.c.r, line.c.g, line.c.b, 1)
		GuiText(gui, x + 5 + line.x, y + line.y, line.text, 1, regular_font)
		--GuiText(gui, x + 5, y + (i-1)*13, line)
	end --GuiText doesnt work by itself ig, newlines put next on the same line for some reason? idk.

	if data.extra_lines or false then
		local extra_y = y
		if data.lines then extra_y = extra_y + ps.extra_line_sep + (#data.lines)*ps.desc_line_gap end
		for i,line in ipairs(data.extra_lines.lines) do
			GuiZSetForNextWidget(gui, -210)
			GuiColorSetForNextWidget(gui, line.c.r, line.c.g, line.c.b, 1)
			GuiText(gui, x + 5, extra_y + (i-1)*ps.desc_line_gap, line, 1, regular_font)
		end
	end
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
	if setting.requires and not ModSettingGetNextValue(setting.requires.id) == setting.requires.value then
		is_disabled = true
	end

	local value = ModSettingGetNextValue(setting.path) and true

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
	GuiText(gui, x_offset + 19, 0, setting.name, 1, regular_font)


	if highlighted and setting.desc_data then DrawTooltip(gui, setting.desc_data, x, y+12) end
	GuiColorSetForNextWidget(gui, c.r, c.g, c.b, 1)

	local toggle_icon = ""
	if is_disabled then toggle_icon = "(X)"
	else toggle_icon = value == true and "(*)" or "(  )" end
	GuiText(gui, x_offset, 0, toggle_icon, 1, regular_font)

	if clicked then
		GamePlaySound("ui", "ui/button_click", 0, 0)
		SettingSetValue(setting, not value)
	end
	if rclicked then
		GamePlaySound("ui", "ui/button_click", 0, 0)
		if keyboard_state == 1 then
			SettingSetValue(setting, setting.value_recommended)
		elseif keyboard_state == 2 then
			SettingSetValue(setting, false)
		elseif keyboard_state == 3 then
			SettingSetValue(setting, true)
		else --if 0
			SettingSetValue(setting, setting.value_default)
		end
	end
end

local function draw_translation_credits(gui, x, y)
	GuiLayoutBeginLayer(gui)
	GuiZSetForNextWidget(gui, -200)
	GuiImageNinePiece(gui, create_id(), x, y, tlcr_data_ordered.size[1]+10, tlcr_data_ordered.size[2]+2, 1, "data/ui_gfx/decorations/9piece0_gray.png")
	for i,tl in ipairs(tlcr_data_ordered) do
		if tl.highlighted then
			GuiColorSetForNextWidget(gui, 236/255, 236/255, 67/255, 1)
		end

		local pos_x,pos_y = x + 5, y + 2 + (i-1)*ps.desc_line_gap
		GuiOptionsAddForNextWidget(gui, GUI_OPTION.Layout_NextSameLine)
		GuiZSetForNextWidget(gui, -210)
		GuiText(gui, pos_x, pos_y , tl.text, 1, regular_font)
		local c = tl.translator
		GuiColorSetForNextWidget(gui, c.r, c.g, c.b, 1)
		GuiZSetForNextWidget(gui, -210)
		GuiText(gui, pos_x + tl.translator.offset, pos_y, tl.translator[1], 1, regular_font)
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
				render_setting = setting.render_condition() --stupid fuckin bullshit, needing me to use functions, lua should just update conditions in real-time :(  (probably shouldnt)
			else
				render_setting = setting.render_condition ~= false
			end
			if render_setting then
				local setting_is_disabled = parent_is_disabled or (setting.requires and not ModSettingGetNextValue(setting.requires.id) == setting.requires.value)
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
					GuiText(gui, offset+10, 0, setting.name, 1, regular_font)
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

					if guiPrev[3] and mouse_is_valid and setting.desc_data then
						c.r = math.min((c.r * 1.2)+.05, 1)
						c.g = math.min((c.g * 1.2)+.05, 1)
						c.b = math.min((c.b * 1.2)+.05, 1)
						DrawTooltip(gui, setting.desc_data, x, y+12)
					end

					if setting.icon then
						GuiOptionsAddForNextWidget(gui, GUI_OPTION.Layout_NextSameLine)
						GuiImage(gui, create_id(), (setting.icon_offset_x or 0) + offset, setting.icon_offset_y or 0, setting.icon, 1, 1, 1)
					end
					GuiColorSetForNextWidget(gui, c.r, c.g, c.b, 1)
					GuiText(gui, (setting.icon_w or 0) + setting.text_offset_x + offset, 0, setting.name, 1, regular_font)
				elseif setting.type == "options" then
					GuiText(gui, offset, 0, "")
					local _,_,_,x, y = GuiGetPreviousWidgetInfo(gui)
					local text = setting.name .. ": "

					local w,h = GuiGetTextDimensions(gui, text, 1, 2, regular_font)
					GuiImageNinePiece(gui, create_id(), x, y, w, h, 0, "")
					local guiPrev = {GuiGetPreviousWidgetInfo(gui)}

					local c = setting.c or {
						r = .8,
						g = .8,
						b = .8,
					}

					local setting_hovered
					local clicked
					local rclicked
					if guiPrev[3] and mouse_is_valid then
						setting_hovered = true
						c.r = math.min((c.r * 1.2)+.05, 1)
						c.g = math.min((c.g * 1.2)+.05, 1)
						c.b = math.min((c.b * 1.2)+.05, 1)

						if setting.desc_data then DrawTooltip(gui, setting.desc_data, x, y+12) end
					end

					GuiColorSetForNextWidget(gui, c.r, c.g, c.b, 1)
					GuiOptionsAddForNextWidget(gui, GUI_OPTION.Layout_NextSameLine)
					GuiText(gui, offset, 0, text, 1, regular_font)

					local option_w,option_h = GuiGetTextDimensions(gui, ("[%s]"):format(setting.option_names[setting.current_option_int]), 1, 2, regular_font)
					GuiImageNinePiece(gui, create_id(), x + w, y, option_w, option_h, 0, "")
					local guiPrev = {GuiGetPreviousWidgetInfo(gui)}

					if mouse_is_valid and (setting_hovered or guiPrev[3]) then
						if setting.option_desc_data[setting.current_option_int] and not setting_hovered then
							DrawTooltip(gui, setting.option_desc_data[setting.current_option_int], x + w, y+12)
						end

						clicked = InputIsMouseButtonJustDown(1)
						rclicked = InputIsMouseButtonJustDown(2)


						if clicked then
							local option_offset = 1
							if keyboard_state == 1 then option_offset = -1 end

							setting.current_option_int = ((setting.current_option_int + option_offset - 1) % #setting.options) + 1 --add post-modulation to avoid 0-indexing
							setting.current_option = setting.options[setting.current_option_int] --add one cuz lua is 1-indexed
							SettingSetValue(setting, setting.current_option)
							GamePlaySound("ui", "ui/button_click", 0, 0)
						end

						if rclicked then
							if keyboard_state == 1 then
								setting.current_option_int = setting.value_recommended_int
							elseif keyboard_state == 2 then
								setting.current_option_int = setting.value_off_int
							elseif keyboard_state == 3 then
								setting.current_option_int = setting.value_on_int
							else
								setting.current_option_int = setting.value_default_int
							end

							setting.current_option = setting.options[setting.current_option_int]
							SettingSetValue(setting, setting.current_option)
							GamePlaySound("ui", "ui/button_click", 0, 0)
						end
					end

					GuiColorSetForNextWidget(gui, c.r, c.g, c.b, 1)
					GuiText(gui, offset + w, 0, ("[%s]"):format(setting.option_names[setting.current_option_int]), 1, regular_font)


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
						if setting.desc_data then DrawTooltip(gui, setting.desc_data, x, y+12) end
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
					GuiText(gui, (setting.icon_w or 0) + setting.text_offset_x, 0, setting.name, 1, regular_font)

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
					GuiText(gui, (setting.icon_w or 0) + setting.text_offset_x, 0, setting.name, 1, regular_font)

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