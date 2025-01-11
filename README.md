# Fork de https://github.com/snesrev/zelda3
Alterado para compilar usando Docker para Linux, Windows e Switch.

Necessário fornecer uma ROM original na pasta "extras" com o nome de "zelda3.sfc", este projeto não fornece nenhuma ROM!

Se quiser compilar o jogo para outro idioma, forneça uma ROM traduzida na pasta "extras" com o nome zelda3-translate.sfc e altere o idioma no powershell builds/build_com_docker.ps1.

Para compilar para Windows é necessário baixar o Simple DirectMedia Layer (SDL) (https://github.com/libsdl-org/SDL/releases), testado com a versão 2.30.11, baixe a versão para mingw e copie o conteúdo da pasta "x86_64-w64-mingw32" para a pasta "extras/SDL2".

Para compilar execute o script powershell builds/build_com_docker.ps1, altere nele o destino da compilação e o idioma da ROM traduzida.

Os arquivos compilados ficarão na subpasta "builds" dentro de uma pasta com o destino fornecido (linux, windows ou switch). 
Caso tenha traduzido a ROM altere o zelda3.ini e insira o campo "Language = pt" com a sigla fornecida no powershell em vez de "pt".

# Zelda3
A reimplementation of Zelda 3.

Our discord server is: https://discord.gg/AJJbJAzNNJ

## About

This is a reverse engineered clone of Zelda 3 - A Link to the Past.

It's around 70-80kLOC of C code, and reimplements all parts of the original game. The game is playable from start to end.

You need a copy of the ROM to extract game resources (levels, images). Then once that's done, the ROM is no longer needed.

It uses the PPU and DSP implementation from [LakeSnes](https://github.com/elzo-d/LakeSnes), but with lots of speed optimizations.
Additionally, it can be configured to also run the original machine code side by side. Then the RAM state is compared after each frame, to verify that the C implementation is correct.

I got much assistance from spannerism's Zelda 3 JP disassembly and the other ones that documented loads of function names and variables.

## Additional features

A bunch of features have been added that are not supported by the original game. Some of them are:

Support for pixel shaders.

Support for enhanced aspect ratios of 16:9 or 16:10.

Higher quality world map.

Support for MSU audio tracks.

Secondary item slot on button X (Hold X in inventory to select).

Switching current item with L/R keys.

## How to Play:

Option 1: Launcher by RadzPrower (windows only) https://github.com/ajohns6/Zelda-3-Launcher

Option 2: Building it yourself

Visit Wiki for more info on building the project: https://github.com/snesrev/zelda3/wiki

### Build the game
Ensure the rom named zelda3.sfc is in the `tables` directory

#### Build for Linux
```sh
docker run --rm --mount type=bind,source="$(pwd)",destination=/zelda3 zelda3 make
```

## More Compilation Help

Look at the wiki at https://github.com/snesrev/zelda3/wiki for more help.

The ROM needs to be named `zelda3.sfc` and has to be from the US region with this exact SHA256 hash
`66871d66be19ad2c34c927d6b14cd8eb6fc3181965b6e517cb361f7316009cfb`

In case you're planning to move the executable to a different location, please include the file `zelda3_assets.dat`.

## Usage and controls

The game supports snapshots. The joypad input history is also saved in the snapshot. It's thus possible to replay a playthrough in turbo mode to verify that the game behaves correctly.

The game is run with `./zelda3` and takes an optional path to the ROM-file, which will verify for each frame that the C code matches the original behavior.

| Button | Key         |
| ------ | ----------- |
| Up     | Up arrow    |
| Down   | Down arrow  |
| Left   | Left arrow  |
| Right  | Right arrow |
| Start  | Enter       |
| Select | Right shift |
| A      | X           |
| B      | Z           |
| X      | S           |
| Y      | A           |
| L      | C           |
| R      | V           |

The keys can be reconfigured in zelda3.ini

Additionally, the following commands are available:

| Key | Action                |
| --- | --------------------- |
| Tab | Turbo mode |
| W   | Fill health/magic     |
| Shift+W   | Fill rupees/bombs/arrows     |
| Ctrl+E | Reset            |
| P   | Pause (with dim)                |
| Shift+P   | Pause (without dim)                |
| Ctrl+Up   | Increase window size                |
| Ctrl+Down   | Decrease window size                |
| T   | Toggle replay turbo mode  |
| O   | Set dungeon key to 1  |
| K   | Clear all input history from the joypad log  |
| L   | Stop replaying a shapshot  |
| R   | Toggle between fast and slow renderer |
| F   | Display renderer performance |
| F1-F10 | Load snapshot      |
| Alt+Enter | Toggle Fullscreen     |
| Shift+F1-F10 | Save snapshot |
| Ctrl+F1-F10 | Replay the snapshot |
| 1-9 | Load a dungeons playthrough snapshot |
| Ctrl+1-9 | Run a dungeons playthrough in turbo mode |


## License

This project is licensed under the MIT license. See 'LICENSE.txt' for details.
