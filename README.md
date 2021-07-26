# M9k Remastered

Workshop Link: https://steamcommunity.com/sharedfiles/filedetails/?id=2169649722

This is a Remastered version of the Legacy M9k Weapon packs.
It includes all Legacy M9k extensions:
 * Small arms pack
 * Heavy weapons pack
 * Assault rifles pack
 * Specialties pack

They have been merged together and heavily optimized. Some features were removed, some were changed, and some were added.

Can I use this to get all the Materials, Models and Sounds for other Servers? .. Yes!

This Addon is being maintained and updated constantly. Reported bugs WILL be fixed, so if you find one, please report it!

# Console Commands
> 0 = Disabled - 1 = Enabled
- m9k_spawn_with_ammo ( 0 / 1 ) - When enabled, weapons start with ammo in magazines.
- m9k_spawn_with_reserve ( 0 / 1 ) - When enabled, spawning a weapon supplies the player with additional ammo.
- m9k_annoying_serverprint ( 0 / 1 ) - Turns off the annoying informational console print on server start.
- m9k_zoomtoggle ( 0 / 1 ) - When enabled, scopes will use a toggle behavior instead of a hold behavior. ( Counter-Strike vs Legacy M9k )
- m9k_zoomstages ( 0 / 1 ) - Whether scoped weapons should make use of their zoom stages, when set to 0, scoped weapons will use their maximum zoom stage. ( Counter-Strike vs Legacy M9k )

**IMPORTANT:**

**m9k_spawn_with_ammo** and **m9k_spawn_with_reserve** are enabled by default. If you're running a roleplay gamemode then you might want to disable these.

By default, scopes will us the Legacy M9k behavior, hold and without zoom stages. Set both m9k_zoomtoggle and m9k_zoomstages to 1 in the server console for the remastered behavior.

# Most noticeable changes

Dynamic weapon accuracy (Similar to how weapons behave in CS:S or CS:GO)
 * All weapons have been changed to be more accurate while standing still and to be even more accurate while crouching and being still.
 * This effect is most noticeable on sniper rifles as its nearly impossible to hit anything without being scoped in and standing still.

All weapons have been rebalanced to be more fair and more fun at the same time.
 * Damage, RPM, Spread, Recoil etc.. Has been adjusted to be more fun and fair to shoot, and play against. (Yay for roleplayers).

Shotguns are actual shotguns now as they all shoot "birdshot" rounds instead of generic shotgun rounds.
 * NumShots drastically increased, damage drastically reduced.

Scopes have received QoL updates:
 * Changed max zooms for every scoped base weapon from 2 to 3. ( When **m9k_zoomstages** is set to 1 )
 * Can now 'unzoom' by pressing the Reload key. ( When **m9k_zoomtoggle** is set to 1 )
 
Not all Weapons have made it back.
 * Some weapons have been removed but MIGHT be re-added in the future.
 
 **Full list of missing weapons:**
 * Davy crockett
 * Fists
 * IED Detonator
 * Orbital Strike Canon
 * Suicide bomb

**Hard to notice changes for non-developers:**
 * Every single script file has been optimized and modernized drastically. Around 70% of original code lines were removed since they basically do nothing or are not required anymore.
 * A massload of bugfixes, especially involving shotguns and weapons from the specialties pack.
 
# Compatibility

This version of M9k is NOT compatible with Legacy M9k packs. Weapons and packs have to be specifically coded for this addon to function properly!

It is highly recommended to uninstall all non-M9k Remastered packs before installing this addon!

# Credits

Models, Materials, and Sounds are made by the Original Creator(s). I do not claim copyright over them.

This project is licensed under the GPL-3.0 License. Do note that only the script files (*.lua) fall under this license. Models, Materials and Sounds are not subject to this License and belong to the Original Creator(s).
