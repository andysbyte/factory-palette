local constants = {}

constants.color_mapping = {
  action_to_color = {
    inventory = "default",
    logistic = "blue",
    unavailable = "red"
  },
  color_to_action = {
    default = "inventory",
    blue = "logistic",
    red = "unavailable"
  }
}
constants.ignored_item_types = {
  ["blueprint-book"] = true,
  ["blueprint"] = true,
  ["copy-paste-tool"] = true,
  ["deconstruction-item"] = true,
  ["item-with-inventory"] = true,
  ["item-with-tags"] = true,
  ["selection-tool"] = true,
  ["upgrade-item"] = true
}
constants.input_sanitizers = {
  ["%("] = "%%(",
  ["%)"] = "%%)",
  ["%.^[%*]"] = "%%.",
  ["%+"] = "%%+",
  ["%-"] = "%%-",
  ["^[%.]%*"] = "%%*",
  ["%?"] = "%%?",
  ["%["] = "%%[",
  ["%]"] = "%%]",
  ["%^"] = "%%^",
  ["%$"] = "%%$"
}
constants.max_integer = 4294967295
constants.nav_arrow_events = {
  "qis-nav-down",
  "qis-nav-left",
  "qis-nav-right",
  "qis-nav-up"
}
constants.nav_confirm_events = {
  "qis-nav-confirm",
  "qis-nav-shift-confirm",
  "qis-nav-control-confirm"
}
constants.results_nav_offsets = {
  down = 5,
  left = -1,
  right = 1,
  up = -5
}
constants.request_type_switcheroos = {
  temporary = "persistent",
  persistent = "temporary"
}
constants.slider_mapping = {
  slider_to_textfield = {
    [0] = 0,
    [1] = 1,
    [2] = 2,
    [3] = 3,
    [4] = 4,
    [5] = 5,
    [6] = 6,
    [7] = 7,
    [8] = 8,
    [9] = 9,
    [10] = 10,
    [11] = 20,
    [12] = 30,
    [13] = 40,
    [14] = 50,
    [15] = 60,
    [16] = 70,
    [17] = 80,
    [18] = 90,
    [19] = 100,
    [20] = 200,
    [21] = 300,
    [22] = 400,
    [23] = 500,
    [24] = 600,
    [25] = 700,
    [26] = 800,
    [27] = 900,
    [28] = 1000,
    [29] = 2000,
    [30] = 3000,
    [31] = 4000,
    [32] = 5000,
    [33] = 6000,
    [34] = 7000,
    [35] = 8000,
    [36] = 9000,
    [37] = 10000,
    [38] = constants.max_integer
  },
  textfield_to_slider = {
    [0] = 0,
    [1] = 1,
    [2] = 2,
    [3] = 3,
    [4] = 4,
    [5] = 5,
    [6] = 6,
    [7] = 7,
    [8] = 8,
    [9] = 9,
    [10] = 10,
    [20] = 11,
    [30] = 12,
    [40] = 13,
    [50] = 14,
    [60] = 15,
    [70] = 16,
    [80] = 17,
    [90] = 18,
    [100] = 19,
    [200] = 20,
    [300] = 21,
    [400] = 22,
    [500] = 23,
    [600] = 24,
    [700] = 25,
    [800] = 26,
    [900] = 27,
    [1000] = 28,
    [2000] = 29,
    [3000] = 30,
    [4000] = 31,
    [5000] = 32,
    [6000] = 33,
    [7000] = 34,
    [8000] = 35,
    [9000] = 36,
    [10000] = 37,
    [constants.max_integer] = 38
  }
}

return constants