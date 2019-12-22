# Onset RP Framework
Roleplay framework for the game [Onset](https://store.steampowered.com/app/1105810/Onset/)
 
## Host Requirements
- Windows / Linux Host
- MariaDB 10.4+ (database on lower version need to be tweaked)

## Packages requirements (They need to be put in orders and before the framework in the config file)
- [i18n](https://github.com/OnfireNetwork/i18n)
- [dialogui](https://github.com/OnfireNetwork/dialogui)

## How To Install OnsetRP

- Create a MariaDB Server if you don't have one. (You can find a tutorial on the Internet)
- Import the .sql file in your database.
- add i18n in your server_config.json file. (Keep it in order)
- add dialogui in your server_config.json file. (Keep it in order)
- add onsetrp in your server_config.json file. (Keep it in order)
- remove default in your server_config.json file.
- configure misc/s_database.json with your MariaDB credentials
- restart your onset server.

## More information / Support
- [Discord](https://discord.gg/ejRhqMF)
- [Twitch](https://twitch.tv/frederiic2ec)
