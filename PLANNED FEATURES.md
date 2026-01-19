These are just features that have crossed my mind which I would like to at least consider implementing later down the line.
These are just bonus features that I may or may not get around to, we'll see

- Vertical Parity
  - spawns pixel scenes and whatnot in sky/hell
  - should in theory be trivial?
  - ~~but its a whole new string of logic i need to cram into all 3 stages of pixel scene handling :(~~
    - scraper has been better modularised, the compiler is on the chopping block
  - parallel portals applies
  - option to display fake biome-entered names "(Above/Below) (East/West) (biome)"
    - ~~North/South? Up/Down? Sky/Hell? idk ill figure smth out~~ Above/Below
  - Make sure Spatial Awareness works here
    - Option to toggle whether position is displayed as Grid or Polar coordinates
- Option to make default handling for unknown pixel scenes to be true
  - add blacklist for mods, though reasonably this should be noted as a potentially buggy setting with other mods involved, so support is optional
- other shadow bosses??
  - maybe not
- add Eyes to hidden pixel scenes group
  - eyes are weird cuz they span from PW -1 to +1, need to insert custom conditions for manual pixel scenes (will likely not be unique to this one niche case)
  -  need to create logic for predictin eyes in lua
    - 