local event = require("__flib__.event")
local gui = require("__flib__.gui")
local migration = require("__flib__.migration")
local translation = require("__flib__.translation")

local constants = require("scripts.constants")
local global_data = require("scripts.global-data")
local migrations = require("scripts.migrations")
local on_tick = require("scripts.on-tick")
local player_data = require("scripts.player-data")
local qis_gui = require("scripts.gui.qis")

local string = string

-- -----------------------------------------------------------------------------
-- COMMANDS

commands.add_command("QuickItemSearch", {"qis-message.command-help"},
  function(e)
    local player = game.get_player(e.player_index)
    if e.parameter == "refresh-player-data" then
      local player_table = global.players[e.player_index]
      if player_table.gui then
        qis_gui.destroy(player, player_table)
      end
      player_data.refresh(player, player_table)
    else
      player.print{"qis-message.invalid-parameter"}
    end
  end
)

-- -----------------------------------------------------------------------------
-- EVENT HANDLERS
-- on_tick handler is kept in scripts.on-tick

-- BOOTSTRAP

event.on_init(function()
  gui.init()
  translation.init()

  global_data.init()
  for i in pairs(game.players) do
    player_data.init(i)
  end

  gui.build_lookup_tables()
end)

event.on_load(function()
  on_tick.update()
  gui.build_lookup_tables()
end)

event.on_configuration_changed(function(e)
  if migration.on_config_changed(e, migrations) then
    -- flib module migrations
    gui.check_filter_validity()
    translation.init()
    -- deregister on_tick
    on_tick.update()

    -- update translation data
    global_data.build_prototypes()

    -- refresh all player information
    for i, player in pairs(game.players) do
      local player_table = global.players[i]
      if player_table.gui then
        qis_gui.destroy(player, player_table)
      end
      player_data.refresh(player, player_table)
    end
  end
end)

-- GUI

gui.register_handlers()

event.register(constants.nav_arrow_events, function(e)
  local player_table = global.players[e.player_index]
  local gui_data = player_table.gui
  if gui_data then
    if gui_data.state == "select_result" then
      qis_gui.move_result(player_table, constants.results_nav_offsets[string.gsub(e.input_name, "qis%-nav%-", "")])
    elseif gui_data.state == "select_request_type" then
      qis_gui.move_request_type(player_table)
    end
  end
end)

event.register(constants.nav_confirm_events, function(e)
  local player_table = global.players[e.player_index]
  local gui_data = player_table.gui
  if gui_data then
    if gui_data.state == "select_result" then
      qis_gui.confirm_result(e.player_index, gui_data, e.input_name)
    elseif gui_data.state == "select_request_type" then
      qis_gui.confirm_request_type(e.player_index, player_table)
    end
  end
end)

event.register("qis-search", function(e)
  local player = game.get_player(e.player_index)
  local player_table = global.players[e.player_index]
  if not player.opened then
    qis_gui.toggle(player, player_table)
  end
end)

event.on_lua_shortcut(function(e)
  if e.prototype_name == "qis-search" then
    local player = game.get_player(e.player_index)
    local player_table = global.players[e.player_index]
    qis_gui.toggle(player, player_table)
  end
end)

-- PLAYER

event.on_player_created(function(e)
  player_data.init(e.player_index)
end)

event.on_player_joined_game(function(e)
  local player_table = global.players[e.player_index]
  if player_table.flags.translate_on_join then
    player_table.flags.translate_on_join = false
    player_data.start_translations(e.player_index)
  end
end)

event.on_player_left_game(function(e)
  if translation.is_translating(e.player_index) then
    translation.cancel(e.player_index)
    global.players[e.player_index].flags.translate_on_join = true
  end
end)

event.register(
  {
    defines.events.on_player_ammo_inventory_changed,
    defines.events.on_player_armor_inventory_changed,
    defines.events.on_player_gun_inventory_changed,
    defines.events.on_player_main_inventory_changed
  },
  function(e)
    local player = game.get_player(e.player_index)
    local player_table = global.players[e.player_index]
    if player.controller_type == defines.controllers.character and player_table.flags.has_temporary_requests then
      player_data.check_temporary_requests(player, player_table)
    end
  end
)

event.on_player_removed(function(e)
  global.players[e.player_index] = nil
end)

event.register("qis-quick-trash-all", function(e)
  local player = game.get_player(e.player_index)
  local player_table = global.players[e.player_index]
  player_data.quick_trash_all(player, player_table)
end)

-- SETTINGS

event.on_runtime_mod_setting_changed(function(e)
  if string.sub(e.setting, 1, 4) == "qis-" then
    player_data.update_settings(game.get_player(e.player_index), global.players[e.player_index])
  end
end)

-- TRANSLATIONS

event.on_string_translated(function(e)
  local names, finished = translation.process_result(e)
  if names then
    local player_table = global.players[e.player_index]
    local translations = player_table.translations
    local internal_names = names.items
    for i=1,#internal_names do
      local internal_name = internal_names[i]
      translations[internal_name] = e.translated and e.result or internal_name
    end
  end
  if finished then
    local player = game.get_player(e.player_index)
    local player_table = global.players[e.player_index]
    -- show message if needed
    if player_table.flags.show_message_after_translation then
      player.print{'qis-message.can-open-gui'}
    end
    -- update flags
    player_table.flags.can_open_gui = true
    player_table.flags.translate_on_join = false
    player_table.flags.show_message_after_translation = false
    -- enable shortcut
    player.set_shortcut_available("qis-search", true)
  end
end)