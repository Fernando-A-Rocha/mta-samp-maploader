![Banner](https://i.imgur.com/bKuFhjf.png)

# About

**mta-samp-maploader** is a MTA resource that reads SA-MP map code in Pawn and loads the map objects and other elements in MTA.

MTA forum topic: *Coming Soon*

Contact (author): Nando#7736 **(Discord)**

## Your opinion matters

Click the button to check the project's feedback page:

[<img src="https://i.imgur.com/x19GaN1.png?1">](https://github.com/Fernando-A-Rocha/mta-samp-maploader/issues/1)

# Getting Started

## Prerequisites

- Required minimum MTA Server & Client version `1.5.9-9.21125.0`
- Get the installers from [nightly.mtasa.com](https://nightly.mtasa.com/)
- ![https://i.imgur.com/BmkUosO.png](https://i.imgur.com/BmkUosO.png)
- Client will auto-update upon joining the server
- *Find out what the build numbers mean here: [buildinfo.mtasa.com](https://buildinfo.mtasa.com/)*
- **If you don't have the right version these resources will not work correctly**

## Dependencies

This project uses 2 resources that `samp_maploader` requires.

- `newmodels` from [mta-add-models](https://github.com/Fernando-A-Rocha/mta-add-models) (v1.6.9)
- `sampobj_reloaded` from [mta-add-models](https://github.com/Fernando-A-Rocha/mta-add-models)
  - 👉 [Download](https://github.com/Fernando-A-Rocha/mta-add-models#includes) `models.zip` containing all dff/txd/col files required (SA-MP Objects)

It's important to start these 2 resources before starting `samp_maploader` in that order.

## Already using one of the dependencies?

If your server already has `newmodels` & `sampobj_reloaded` and you want to install `samp_maploader`, you don't need to re-download those 2 resources if you have the [correct versions](#dependencies). The following edits were made to them, that you can do yourself:

- Removed the test commands from `newmodels`
- Disabled debug messages in [newmodels/_config.lua](/newmodels/_config.lua)
- Removed all predefined mods in [newmodels/mod_list.lua](/newmodels/mod_list.lua), [newmodels/meta.xml](/newmodels/meta.xml) and 'models' folder (now deleted)
- Removed the test command from `sampobj_reloaded`

## Installing

- Get the latest release: [here](https://github.com/Fernando-A-Rocha/mta-samp-maploader/releases/latest)
- Download the source code Zip and extract it
- Place the 3 folders in your server's resources folder
- Execute command `start samp_maploader` in server console: it will start the dependencies before starting the main resource

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

5. Define **maps to load** in [samp_maploader/map_list.lua](samp_maploader/map_list.lua) inside `mapList`
    - Read the comments to understand how to define your map

6. Use `start samp_maploader` to initiate the resource

7. ‼️ **Important**: If you restart `newmodels`, you will also need to restart `sampobj_reloaded` and then you can restart `samp_maploader`.

# Important Info

- MTA currently limits the amount of objects you can stream within a small radius (memory issue). It's very noticeable when in SA-MP interiors with a lot of objects, e.g. test map #2
- Transparent materials currently don't work when applied with SetObjectMaterial **(todo)** [issue 2](https://github.com/Fernando-A-Rocha/mta-samp-maploader/issues/2)
- Material color currently has no effect when applied with SetObjectMaterial **(todo)** [issue 3](https://github.com/Fernando-A-Rocha/mta-samp-maploader/issues/3)
- setObjectMaterialText is currently not supported **(todo)** [issue 4](https://github.com/Fernando-A-Rocha/mta-samp-maploader/issues/4)

# Generating Collision Files

There's a tool to generate a `.col` file from a given `.dff` model. Check out the tutorial [here](TUTORIAL_COL.md).

# Final Note

Feel free to update this README.md if you wish to improve it.

Thank you for reading, have fun!
