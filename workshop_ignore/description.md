Parallel Parity is a mod with the primary feature of making Pixel Scenes (structures like the Tree or Lava Lake) function properly in Parallel Worlds, along with some other PW-related tweaks!
The entire mod is fully configurable via the custom-made Mod Settings menu accessible via the Options screen

[h3] [u] Supported Languages [/u] [/h3]
[list]
 [*][b]Português Brasileiro[/b] (BR-PT) - Last Updated: [i] 13/1/26 [/i]
 [*][b]Deutsch[/b] (DE) - Last Updated: [i] 12/1/26 [/i]
[/list]

[hr][/hr]

[h2]List of features:[/h2]


Pixel Scenes work in Parallel Worlds (toggles for which ones)
[img]https://github.com/FatalUserK/parallel_parity[/img]

Control over specific pixel scene elements spawning in PWs (for balance reasons)


Parallel Portals, which let you toggle specific portals which keep you in the current Parallel World


Return Rifts, which give you the option to return back to the Parallel World that portal just snatched you away from!


Spatial Awareness Fix which teaches Nolla how to count past 3!


A fancy and fully configurable Mod Settings menu built from the ground up!


Mod Support which allows any mod to append any of the extendible features above.
This includes Mod Settings!


And some more nonsense I didn't mention here, as well as more nonsense to come, I'm not done yet!


All features are highly configurable via the Mod Settings menu and can be found fully detailed here: [url=noita.wiki.gg/wiki/Mod:Parallel_Parity] Parallel Parity Features [/url]

[hr][/hr]

[h1][u] Frequently Asked Questions [/u][/h1]
[i] Okay fine I haven't gotten a lot of questions yet, but these should be helpful nonetheless!! [/i]

[h3] Why do you recommend against some default settings? My brother in christ YOU MADE THE MOD [/h3]
I decided to configure the settings to have minimal gameplay impact for more "vanilla" purists, this is so its easier for people who don't know their way around modding to better experience the mod.
I would like to instead encourage you to decide what feels right- or if you don't want to, holding down the SHIFT button will turn the [Reset] button into a [Recommended] button!

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