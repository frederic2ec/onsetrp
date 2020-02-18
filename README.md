# Onset RP Framework

Roleplay framework for the game [Onset](https://store.steampowered.com/app/1105810/Onset/)

## Host Requirements

- Windows / Linux Host
- MariaDB 10.4+ (database on lower version need to be tweaked)

## Packages requirements

- [soundstreamer](https://github.com/Sheaven/SoundStreamer)
- [i18n](https://github.com/OnfireNetwork/i18n)
- [dialogui](https://github.com/OnfireNetwork/dialogui)
- [cinematicui](https://github.com/rdlh/cinematicui)
- [salsi](https://github.com/Onset-RP/salsi)
- [onsetworld](https://github.com/Onset-RP/onsetworld)

## Example packages setup
```
"packages": [
    "soundstreamer",
    "i18n",
    "dialogui",
    "cinematicui",
    "onsetrp",
    "salsi",
    "onsetworld"
]
```

## How To Install OnsetRP

- Create a MariaDB Server if you don't have one. (You can find a tutorial on the Internet)
- Import the .sql file in your database.
- add dependencies in your server_config.json file (keep the right order).
- remove default in your server_config.json file.
- configure misc/s_database.json with your MariaDB credentials
- update your world.json at the root of your project with the sources in the [onsetrp folder](https://github.com/frederic2ec/onsetrp/blob/master/world.json)
- restart your onset server.

## Frequently Ask Question / Frequent Bug
### 1. My GUI look like craps, how to fix it.
Change the second line in shop/client.lua to flat instead of onsetrp
### 2. My server crash on startup
Look that you have changed your database information in misc/s_database.lua
### 3. I have a lot of error on startup and installed all the package correctly
Verify that you have followed the dependency order in you server_config.json
### 4. I have multiple door and/or have the sandbox editor
Verify that you deleted the "default" and/or "sandbox" package in server_config.json
### 5. Multiple place in the map is empty or missing props
Verify that you have installed onset_world correctly and putted the world.json in the root of your server and not the packages folder
### 6. I have an error concerning the ini file
Verify that you added "ini-plugin" in the plugins section of the server_config.json
### 7. My database have errors when importing
Verify that you are using MariaDB 10.4 and higher

## More information / Support

- [Discord](https://discord.gg/ejRhqMF)
- [Twitch](https://twitch.tv/frederiic2ec)
