![Banner](https://i.imgur.com/zynzF9k.png)

**mta-samp-maploader** is a MTA resource that reads SA-MP map code in Pawn and loads the map objects and other elements in MTA.

MTA forum topic: *Coming Soon*

Contact (author): Nando#7736 **(Discord)**

## Your opinion matters

Click the button to check the project's feedback page:

[<img src="https://i.imgur.com/x19GaN1.png?1">](https://github.com/Fernando-A-Rocha/mta-samp-maploader/issues/1)

# Getting Started

## Dependencies

This project uses 2 resources that `samp_maploader` requires.

- `newmodels` from [mta-add-models](https://github.com/Fernando-A-Rocha/mta-add-models)
- `sampobj_reloaded` from [mta-add-models](https://github.com/Fernando-A-Rocha/mta-add-models)

## Installing

**No stable release has yet been released! Proceed at your own risk.**

### Download Everything

- Go to the latest **mta-add-models** release page: [link](https://github.com/Fernando-A-Rocha/mta-add-models/releases/latest)
- Download the following resources (dependencies):
  - `newmodels`
  - `sampobj_reloaded`
    - [Download](https://www.mediafire.com/file/mgqrk0rq7jrgsuc/models.zip/file) `models.zip` containing all dff/txd/col files required (SA-MP Objects)
- Go to the latest **mta-samp-maploader** release page: [link](https://github.com/Fernando-A-Rocha/mta-samp-maploader/releases/latest)
- Download the `samp_maploader` resource
- Place the 3 folders you downloaded in your server's resources folder
- Execute command `refresh` in server console to see if all 3 resources are loaded successfully

### Edit the Dependencies

Here are some changes you could make to the dependencies:

- Remove the test commands from `newmodels`
- Disable debug messages in [newmodels/_config.lua](/newmodels/_config.lua)
- Remove all predefined mods in [newmodels/mod_list.lua](/newmodels/mod_list.lua), [newmodels/meta.xml](/newmodels/meta.xml) and 'models' folder
- Remove the test commands from `sampobj_reloaded`

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
    - If you don't have a collision file for your model check [this tutorial](/.github/docs/TUTORIAL_COL.md)

4. List custom model files (**dff + txd + col**) in [samp_maploader/meta.xml](samp_maploader/meta.xml) under `<!-- SA-MP Map Models -->`
    - This is required if your map has any `added objects` using `AddSimpleModel` 
    - This allows the resource to send these files to the client when they join so the models can be loaded when requested in a map file

5. Define **maps to load** in [samp_maploader/map_list.lua](samp_maploader/map_list.lua) inside `mapList`
    - Read the comments to understand how to define your map

6. Use `start samp_maploader` to initiate the resource

7. ‼️ **Important**: If you restart `newmodels`, you will also need to restart `samp_maploader`.

# Important Info

- MTA currently limits the amount of objects you can stream within a small radius (memory issue). It's very noticeable when in SA-MP interiors with a lot of objects, e.g. test map #2

# Generating Collision Files

There's a tool to generate a `.col` file from a given `.dff` model. Check out the tutorial [here](/.github/docs/TUTORIAL_COL.md).

# Final Note

Feel free to update this README.md if you wish to improve it.

Thank you for reading, have fun!
