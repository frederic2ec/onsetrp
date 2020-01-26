# Onset RP Framework

Roleplay framework for the game [Onset](https://store.steampowered.com/app/1105810/Onset/)

## Host Requirements

- Windows / Linux Host
- MariaDB 10.4+ (database on lower version need to be tweaked)

## Packages requirements

- [i18n](https://github.com/OnfireNetwork/i18n)
- [dialogui](https://github.com/OnfireNetwork/dialogui)
- [cinematicui](https://github.com/rdlh/cinematicui)
- [salsi](https://github.com/Onset-RP/salsi)
- [onsetworld](https://github.com/Onset-RP/onsetworld)

## Example packages setup
```
"packages": [
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

## More information / Support

- [Discord](https://discord.gg/ejRhqMF)
- [Twitch](https://twitch.tv/frederiic2ec)
