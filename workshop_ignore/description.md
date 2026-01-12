Parallel Parity is a mod with the primary feature of making Pixel Scenes (structures like the Tree or Lava Lake) function properly in Parallel Worlds, along with some other PW-related tweaks!

[h3] [u] Supported Languages [/u] [/h3]
[list]
 [*][b]Português Brasileiro[/b] (BR-PT) - Last Updated: [i] 12/1/26 [/i]
 [*][b]Deutsch[/b] (DE) - Last Updated: [i] 12/1/26 [/i]
[/list]

[hr][/hr]

[h1][u] FEATURES [/u][/h1]
All features are highly configurable via the Mod Settings menu! (I'm quite proud of the mod settings menu and I hope you have an easy time interacting with it)

[h2][u] Parallel Pixel Scenes [/u][/h2]
Pixel Scenes (such as the Hiisi Anvil or Music Machines) and Spliced Pixel Scenes (larger pixel scenes such as Lava Lake or the Final Boss Arena) now properly spawn in ALL Parallel Worlds!
By default, the settings are configured to have minimal gameplay or balance-related influences on the game

[h3] Main World Localisation [/h3]
To avoid messing with vanilla balance too much, I implemented special localisation options
Basically you can control certain specific things within pixel scenes to not appear in Parallel Worlds, such as the Lava Lake's Orb, the Lake Island's Fire Essence and "Tapion vasalli", and the HP Pickups from the Dark Cave
By default, Orb from Lava Lake, Curse of Greed from Tree, Fire Essence and Tapion vasalli from Lake Island, and Gourds from Gourd Room do not spawn in Parallel Worlds

[h3] Kolmisilmä Varjo [/h3]
If Kolmisilmä Arena is enabled, you can enabled the spawning of Kolmisilmä Varjo who will appear in the arena in Kolmisilmä's place in Parallel Worlds. The Sampo will also be replaced with a shadowy reflection similar to Kolmisilmä Varjo, and you won't be able to obtain it- though interacting with it will start the fight.
This is just a fun optional way you can choose to fight a clone of Kolmisilmä if you so choose, if the setting is disabled then nothing will spawn in the arena- Kolmisilmä isn't made for Parallel Worlds
By default, disabled

[h3] New Game+ [/h3]
Realistically this feature just works and there doesn't need to be a toggle for it, but you can toggle whether this mod applies to NG+! Reason for this toggle is this feature is somewhat untested and not final- the final version will require annoying stuff like predicting the future NG+ world seeds and from there all of the NG+ biome map permutations and whatnot all calculated when you start the run.
If I do fully implement the feature as I've described above, it will be an ordeal, so don't expect it anytime soon- if at all
By default, enabled

[h2][u] Parallel Portals [/u][/h2]
Parallel Portals allows certain portals to teleport you to their target destination within the same PW, no more will you be zipped back to the Main World by a Holy Mountain portal when farming for perks!
By default, the settings are configured so that only portals that send you back to the Main World are the Musical Curiosity and Tower Portal which both send you to the Mountain Top (I would only apply this to the Musical Curiosity, but they both use the same entity file- so what can you do ¯\_(ツ)_/¯ )

[h3] Summon Portal [/h3]
Summon Portal has some additional code which allows the statues and portal spot to spawn properly in Parallel Worlds, this was a pain but should work just fine
By default, enabled

[h2][u] Return Rifts [/u][/h2]
[i] Yes I do like my alliteration, how could you tell :) [/i]
Return Rifts are a sort of optional alternative to Parallel Portals, but can be enabled at the same time
If a portal teleports you from a Parallel World to the Main World, the game will spawn a temporary Rift at the destination which you can interact with to warp back to the right of the portal that you went through in the PW you just left
The rift will disappear after 30 or if you leave the slowly-shrinking radius which will reach the rift in the same amount of time- or it will disappear if you go through the rift, obviously.
By default, this setting is disabled- but I would personally highly recommend it, its quite convenient and I am personally happy with how the visuals turned out

[h2][u] Spatial Awareness Fix [/u][/h2]
A tweak that fixes the Spatial Awareness perk to not cap out at counting <-3 and >3 Parallel Worlds out
(Saw someone else upload a mod that does this around the same time Parallel Parity release- oops! This feature was planned a while ago, sorry o/ )

[h2][u] Mod Settings [/u][/h2]
Highly configurable mod settings! You can control most aspects of the mod from here, and it even supports settings for other mods (requires you to enter a game for it to work, API limitations sorgy)
The GUI is mostly coded from the ground up, so it has fancy things like Collapsible Folders and right clicking a setting will set it to it's default value 
Don't wanna have to manually right click every setting? There's a [Reset] button
[b]Secret hint![/b]: if you hold SHIFT in the mod settings menu, the [i] [Reset] [/i] button changes to a [i] [Recommended] [/i] button and will instead change all settings to my personal blend of configurations. Shift right click can also do the same to individual settings


[hr][/hr]

[h1][u] Frequently Asked Questions [/u][/h1]
[i] Okay fine I haven't gotten a lot of questions yet, but these should be helpful nonetheless!! [/i]

[h3] Why do you recommend against some default settings? My brother in christ YOU MADE THE MOD [/h3]
I decided to configure the settings to have minimal gameplay impact for more "vanilla" purists, this is so its easier for people who don't know their way around modding to better experience the mod.

[h3] Does this work with [X] mod? [/h3]
The way I have coded the core functions of this mod means it should be fairly robust, though please DO inform me if you run into issues and I will try to make a list of known issues that I cannot fix.
Beyond that, yes! This mod *will* work with other mods, [i]however[/i], mod owners will need to add compatibility themselves if they wish to add their own Pixel Scenes, Portals or whatever to this mod
more specific info can be found here: [url=github.com/FatalUserK/parallel_parity/blob/main/-COMPATIBILITY%20GUIDE.md] COMPATIBILITY GUIDE.md [/url]

[h3] Can I translate your mod into [X] language? [/h3]
Yes, absolutely yes, very much greatly appreciated, yes.
I am a stupid English wretch who would love it if more people could experience and play the stuff I make, if you would like to do translations for the mod then please do get in contact with me and I will do whatever I can to assist

[hr][/hr]

Brazilian Portuguese translations by [b]Absent Friend[/b]
German translations by [b]Xplosy[/b]
Return Rift shape/texture and end shader grabbed from [b]Evaisa[/b]'s Fairmod rifts

GitHub: https://github.com/FatalUserK/parallel_parity


fun little trivia since you made it this far, the Desert Skull is in my opinion the dumbest spliced pixel scene.
The point of spliced pixel scenes is to make it so that pixel scenes larger than a chunk do not land on chunk borders (can be problematic), so to fix this you create a "spliced" pixel scene file which is basically a collection of 512x512 (size of a chunk) sized snippets and spawn them at their designated positions.
The Skull is a single snippet, there is no point to it being a spliced pixel scene as it is only made of one part, which makes sense because its smaller than a single chunk
Despite this, [b]Nolla still managed to place it crossing 4 chunk borders[/b]. It is smaller than a chunk, made of one component, and STILL crosses 4 chunk borders despite being a Spliced Pixel Scene
Good job guys o7