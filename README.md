# afk_bot

Minetest Client Side Mod that notifies players you are offline when they say a keyword

**PLEASE REPORT ANY BUGS HERE: https://github.com/LoneWolfHT/afk_bot/issues**

## Commands

* `.afk`
	* `<add/remove/list> <(add/remove)-keyword> | Add or remove keywords the bot looks for in chat`
	* `<cooldown> <(optional)-timeinseconds> | list or set the time that has to pass before the bot can send a message`
	* `<help/h> lists availiable commands with explanations for each`
	* `<toggle/t> turns bot on/off`

## Other Info

Bot will automatically turn off if you send a chat message.
Keywords and cooldown are saved to modstorage. SO you don't have to enter them in every time you join.
Cooldown limit is set to 5 to prevent spam.
