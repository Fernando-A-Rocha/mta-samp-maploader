![Banner](https://i.imgur.com/gEXuXuB.png)

# About


**mta-samp-maploader** is a MTA resource that reads SA-MP map code in Pawn and loads the map objects and other elements in MTA.

MTA forum topic: TBA

Contact (author): Nando#7736 **(Discord)**

## Your opinion matters!

Click the button to check the project's feedback page:

[<img src="https://i.imgur.com/x19GaN1.png?1">](https://github.com/Fernando-A-Rocha/mta-samp-maploader/issues/1)


## Other Projects

My MTA roleplay server: [San Andreas Roleplay (SA-RP)](https://forum.mtasa.com/topic/128625-rp-san-andreas-roleplay-english/) [![Discord](https://img.shields.io/discord/777891185359323146?label=discord&logo=discord)](https://sa-roleplay.net/discord)

Discord Webhooks in MTA: [mta-discord-webhooks](https://github.com/Fernando-A-Rocha/mta-discord-webhooks)

Add new peds/objects/vehicles in MTA: [mta-add-models](https://github.com/Fernando-A-Rocha/mta-add-models)


# Dependencies

This project uses resources from some of my other projects that `samp_maploader` requires.

- `newmodels` from [mta-add-models](https://github.com/Fernando-A-Rocha/mta-add-models) (v1.6.0 edited)
- `sampobj_reloaded` from [mta-add-models](https://github.com/Fernando-A-Rocha/mta-add-models) (edited)

It's important to start these 2 resources before starting `samp_maploader` in that order.

# Structure

`samp_maploader` files and folders:
- `maps`: SA-MP Pawn map files to load
- `models`: models used by maps to load
- `list.lua`: list of maps to load
- `client.lua`: map loading functions
- `server.lua`: map parsing & sending to client for loading
- `files`: shader stuff
- `matlist.lua` SA material names and other dff/txd info

# Tutorial

How to add your own SA-MP maps & load them: TODO