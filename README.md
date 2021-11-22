![Banner](https://i.imgur.com/gEXuXuB.png)

# About

**mta-samp-maploader** is a MTA resource that reads SA-MP map code in Pawn and loads the map objects and other elements in MTA.

MTA forum topic: *Coming Soon*

Contact (author): Nando#7736 **(Discord)**

## Your opinion matters!

Click the button to check the project's feedback page:

[<img src="https://i.imgur.com/x19GaN1.png?1">](https://github.com/Fernando-A-Rocha/mta-samp-maploader/issues/1)


## Other Projects

My MTA roleplay server: [San Andreas Roleplay (SA-RP)](https://forum.mtasa.com/topic/128625-rp-san-andreas-roleplay-english/) [![Discord](https://img.shields.io/discord/777891185359323146?label=discord&logo=discord)](https://sa-roleplay.net/discord)

Discord Webhooks in MTA: [mta-discord-webhooks](https://github.com/Fernando-A-Rocha/mta-discord-webhooks)

Add new peds/objects/vehicles in MTA: [mta-add-models](https://github.com/Fernando-A-Rocha/mta-add-models)

# Getting Started

## Prerequisites

You'll need to update your MTA Client to a certain nightly (experimental) [version](https://buildinfo.mtasa.com/):
- Get the **Windows nightly installer** - *r21026* from [nightly.mtasa.com](https://nightly.mtasa.com/)
- Update your current MTA installation, type `ver` in F8 in-game to verifiy: `Multi Theft Auto v1.5.9-release-21026`

You'll also need to get a specific MTA Server nightly (experimental) [version](https://buildinfo.mtasa.com/):
- If updating a server, you need to install it on a separate folder, then move all your settings & resources to it
- Get the **Windows/Linux server** - *r21026* from [nightly.mtasa.com](https://nightly.mtasa.com/)
- To check the server's version type `ver` on the console: `MTA:SA Server v1.5.9-release-21026`

## Dependencies

This project uses resources from some of my other projects that `samp_maploader` requires.

- `newmodels` from [mta-add-models](https://github.com/Fernando-A-Rocha/mta-add-models) (v1.6.0 edited)
- `sampobj_reloaded` from [mta-add-models](https://github.com/Fernando-A-Rocha/mta-add-models) (edited)

It's important to start these 2 resources before starting `samp_maploader` in that order.

## Already using any of the dependencies?

If your server already has `newmodels` & `sampobj_reloaded` and want to have `samp_maploader`, you shouldn't need to re-download those 2 resources if you have the correct versions. I made the following edits to them:
- Removed the test commands from `newmodels`
- Disabled debug messages in [newmodels/_config.lua](/newmodels/_config.lua)
- Removed all predefined mods in [newmodels/mod_list.lua](/newmodels/mod_list.lua), [newmodels/meta.xml](/newmodels/meta.xml) and 'models' folder (now deleted)
- Removed the test command from `sampobj_reloaded`

## Installing

- Get the latest release: [here](https://github.com/Fernando-A-Rocha/mta-samp-maploader/releases/latest)
- Download the source code Zip and extract it
- Place the 3 folders in your server's resources folder
- Execute the following commands in server console (in order):
    - `start newmodels`
    - `start sampobj_reloaded`
    - `start samp_maploader`

## Structure

`samp_maploader` files and folders:
- `maps`: SA-MP Pawn map files to load
- `models`: models used by maps to load
- `list.lua`: list of maps to load
- `client.lua`: map loading functions
- `server.lua`: map parsing & sending to client for loading
- `files`: shader stuff
- `matlist.lua` SA material names and other dff/txd info

# Tutorial

With this `samp_maploader` resource you can load SA-MP maps in the Pawn format. To do this, follow these steps:

1. Place map files in [samp_maploader/maps](samp_maploader/maps)
    - Check the list of supported Pawn functions [here](#exported-functions)
    - Lines must be a series of function calls, see the existing example Pawn files

2. List map files (**name.pwn**) in [samp_maploader/meta.xml](samp_maploader/meta.xml) under `<!-- SA-MP Maps -->`
    - This allows the resource to send these files to the client when they join so the maps can be loaded

3. Place custom model files in [samp_maploader/models](samp_maploader/models)
    - This is required if your map has any `added objects` using `AddSimpleModel` 
    - Must have dot `dff, txd and col` files **for each new object**
    - If you don't have a collision file for your model check [this tutorial](TUTORIAL_COL.md)

4. List custom model files (**dff + txd + col**) in [samp_maploader/meta.xml](samp_maploader/meta.xml) under `<!-- SA-MP Map Models -->`
    - This is required if your map has any `added objects` using `AddSimpleModel` 
    - This allows the resource to send these files to the client when they join so the models can be loaded when requested in a map file

5. Define **maps to load** in [samp_maploader/list.lua](samp_maploader/list.lua) inside `mapList`
    - Read the comments to understand how to define your map

6. Use `start samp_maploader` to initiate the resource

7. ‼️ **Important**: If needed, after restarting `newmodels` you will need to restart `sampobj_reloaded` then `samp_maploader` after.

8. ‼️ **Important**: If you are in-game when restarting, you must **wait** a bit before restarting `samp_maploader` as it requires your client to have received the SA-MP objects mod list which happens a few seconds after `sampobj_reloaded` starts.

# Generating Collision Files

There's a tool to generate a `.col` file from a given `.dff` model. Check out the tutorial [here](TUTORIAL_COL.md).

# Final Note

Feel free to update this README.md if you wish to improve it.

Thank you for reading, have fun!