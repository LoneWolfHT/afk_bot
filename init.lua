local modstore = minetest.get_mod_storage()

local keywords = minetest.deserialize(modstore:get_string("keywords")) or {}
local cooldown = modstore:get_int("cooldown")
local enabled = 0
local can_reply = true

if cooldown == 0 then
	cooldown = 60
end

-- register_on_receiving_chat_message(s) and register_on_sending_chat_message(s) backwards compatibility
if not minetest.register_on_receiving_chat_message then
    minetest.register_on_receiving_chat_message = minetest.register_on_receiving_chat_messages
end
-- (Thanks ChimneySwift :P)

minetest.register_on_receiving_chat_messages(function(message)
	local msg = minetest.strip_colors(message)
	local name

	if enabled == 0 or not (msg:find("<") and msg:find(">")) or can_reply == false then
		return false
	else
		name = msg:sub(2, msg:find(">")-1)
	end

	for k, word in ipairs(keywords) do
		if msg:find(word) then
			can_reply = false

			minetest.send_chat_message(name..": I am AFK")
			minetest.after(cooldown, function() can_reply = true end)
			break
		end
	end

	return false
end)

minetest.register_on_sending_chat_messages(function(message)
	if enabled == 1 then
		enabled = 0
	end

	return false
end)

if minetest.registered_chatcommands["afk"] then
	minetest.unregister_chatcommand("afk")
end

minetest.register_chatcommand("afk", {
	description = "Command for the afk_bot CSM.\n.afk help",
	func = function(param)
		minetest.log("Localplayer runs command: .afk "..dump(param))

		if param == "help" or parm == "h" then
			minetest.display_chat_message(minetest.colorize("cyan", ".afk <add/remove/list> <keyword> | Keywords the bot searches the chat for\n"..
			".afk cooldown <time in seconds> | How long it takes before the bot can respond to a keyword.\n"..
			".afk <t/toggle> | Turns the AFK bot off/on"))
		elseif param:find("add") then
			local word = param:sub(5)

			minetest.log("[add] Word found. "..dump(word))

			keywords[#keywords+1] = word
			modstore:set_string("keywords", minetest.serialize(keywords))
			minetest.display_chat_message(minetest.colorize("orange", "[AFK_BOT] ").."Added keyword "..dump(word))
		elseif param:find("remove") then
			local word = param:sub(8)

			minetest.log("[remove] Word found. "..dump(word))

			for n, w in ipairs(keywords) do
				if w == word then
					table.remove(keywords, n)
					break
				end
			end

			modstore:set_string("keywords", minetest.serialize(keywords))
			minetest.display_chat_message(minetest.colorize("orange", "[AFK_BOT] ").."Removed keyword "..dump(word))
		elseif param:find("list") then
			minetest.display_chat_message(minetest.colorize("orange", "[AFK_BOT] ").."Keywords: "..table.concat(keywords, ", ")..".")
		elseif param:find("cooldown") then
			if param:len() <= 9 then
				minetest.display_chat_message(minetest.colorize("orange", "[AFK_BOT] ").."Cooldown is set to to "..dump(cooldown))
				return
			end

			cooldown = tonumber(param:sub(10))

			if cooldown < 5 then
				cooldown = 5
			end

			modstore:set_int("cooldown", cooldown)
			minetest.display_chat_message(minetest.colorize("orange", "[AFK_BOT] ").."Set Cooldown to "..dump(cooldown))
		elseif param:find("toggle") or param == "t" then
			if enabled == 1 then
				enabled = 0
				minetest.display_chat_message(minetest.colorize("orange", "[AFK_BOT] ").."Disabled")
			else
				enabled = 1
				minetest.display_chat_message(minetest.colorize("orange", "[AFK_BOT] ").."Enabled")
			end
		else
			minetest.display_chat_message(minetest.colorize("red", "[AFK_BOT] Invalid command. '.afk help' to see all commands"))
		end
	end
})