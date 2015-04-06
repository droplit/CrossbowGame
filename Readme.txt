(Please either change your text editor font to Comic Sans, or just imagine that you are reading this in said font. -Thanks)

    __  _____    ______     ______                     __                     ______                   
   /  |/  / /   / ____/    / ____/________  __________/ /_  ____ _      __   / ____/___ _____ ___  ___ 
  / /|_/ / /   / / __     / /   / ___/ __ \/ ___/ ___/ __ \/ __ \ | /| / /  / / __/ __ `/ __ `__ \/ _ \
 / /  / / /___/ /_/ /    / /___/ /  / /_/ (__  |__  ) /_/ / /_/ / |/ |/ /  / /_/ / /_/ / / / / / /  __/
/_/  /_/_____/\____/     \____/_/   \____/____/____/_.___/\____/|__/|__/   \____/\__,_/_/ /_/ /_/\___/ 
                                                                                                       


---------------
How To Install:
---------------

Drag crossbowgame into your gamemodes folder
ex: \garrysmod\gamemode\*HERE*

Remove any previous installations of crossbowgame before moving this one in
If you put crossbowgame in addons, it will NOT work!


---------
Commands:
---------
Layout: cmd - default value - description 
	Clientside:
- mlg_hud_kills - 1 - If the killstreak number in the bottom left should be rendered.
- mlg_hud_players - 1 - If the playernames above the players should be rendered.
- mlg_hud_timer - 1 - If the "Blaze Timer" should be rendered, does not control the sounds emitted from said timer.
- mlg_hud_crosshair - 1 - If our custom Hitmark-esque crosshair should be rendered instead of the default one.
- hax_mlgplayers - 0 - 420 wallhack m8 (sv_cheats must be enabled)
	Serverside:
- mlg_sound - 1 - If the MLG sound effects should play.


--------------------------------
What to do, if a problem occurs:
--------------------------------

There are three kinds of problems that can happen in CrossbowGame:
- The problem caused by the end user (think of a bad modification or a bad setting)
- The problem caused by us, the developers/

The very first step of solving your problem is figuring out who caused it. Often this is easy to figure out. If errors started to occur
when you edited your HUD, it's probably your fault (or the server host's). If the server starts in sandbox, or if you get the error
"couldn't include file crossbowgame\gamemode\cl_init.lua (File not found)"
it's your fault.

If it's your fault, blame yourself. If you caused a problem you don't know how to solve, you have two options:
1. ask on a forum or ask your friends for help. If you contact mod developers,
	they might get mad at you for being asked something they have nothing to do with
2. undo the change that broke it. To do this, always make sure you have a backup

If it's the fault of a third party mod developer, contact them to report the bug. They are the only ones who can (and are willing to)
solve the problems caused by their mod.

--------------------------------
Reporting a bug for CrossbowGame
--------------------------------
Only report bugs for issues of which you are VERY SURE that it is the fault of the developers.

To report a bug for CrossbowGame, you need to follow very strict rules. These rules exist so the bugs can be easily identified and solved.

The most important rules are:
1. Do not ask for help. We can try to fix it, but not set it up.
2. Do not report an issue when you are unable to install CrossbowGame.
3. Do not report problems that you caused yourself.
4. Do not report problems for other mods.
5. Do not report problems for a server that you do not own or develop for
6. Never just post that "It doesn't work" that's no information to work on.

How to report a bug:
1. Enter lua_log_sv 1 in RCon or the server console
2. Make the problem happen
	if a weapon messes up when you shoot, shoot the weapon.
	if it happens on server start, change level or restart the server
	if it happens when the mayor tries to place a lawboard, make the mayor try to spawn a lawboard
	etc.
3. Go to the FTP of your server.
4. In the garrysmod/ folder you should see "lua_errors_server.txt" and/or "clientside_errors.txt"
 	upload the contents of BOTH these files to www.pastebin.com
 	if you don't see those files, make sure you did everything right (lua_log_sv must be 1).
 	if you don't see the files and you're sure that you did the logging right, mention this in the bug report:
 	"No error log files were generated."
 	If you only see one file, upload that one file to www.pastebin.com and mention the following in the bug report:
 	"The other error log file was not generated."

 	Thanks. Errors help A LOT.
5. Go to https://github.com/jpinz/CrossbowGame/issues/new (DON'T SKIP THE PREVIOUS STEPS)
6. Think of an appropriate title. Try to be specific here
7. Take the issue template from "github issue template.txt" and copy paste it into the "Write" field.
8. Fill it in, try not to leave anything empty!
	MORE information = MUCH HIGHER chance that the problem will be solved
9. Click "Submit new issue"