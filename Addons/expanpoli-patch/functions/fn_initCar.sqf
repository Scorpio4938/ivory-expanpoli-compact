// ============================================================
// expanpoli_patch_fnc_initCar — vehicle initialization
// ============================================================
//
// Triggered by GetIn (not config init). Sets up Ivory-compatible
// variables, spawns 3 audio loops, and adds the Read Manual action.
//
// Same architecture as mean_patch_fnc_initCar with Expanpoli-specific
// naming (expanpoli_patch_* prefix).
// ============================================================

if (!hasInterface) exitWith {};

params ["_car"];

// Guard against double-initialisation
if (_car getVariable ["expanpoli_patch_initialized", false]) exitWith {};
_car setVariable ["expanpoli_patch_initialized", true, true];

// Initialise Ivory-style siren / horn variables
_car setVariable ["ani_horn",           0, true];
_car setVariable ["ani_siren",          0, true];
_car setVariable ["ani_siren_todo",     1, true];
_car setVariable ["ani_lightbar",       0, true];
_car setVariable ["ani_lightbar_todo",  1, true];

// Spawn audio loops
_car spawn expanpoli_patch_fnc_horn;
_car spawn expanpoli_patch_fnc_sirens;
_car spawn expanpoli_patch_fnc_takedown;

// Add Read Manual scroll-wheel action
_car addAction [
    "<t color='#4EB1BA'>Read Manual</t>",
    { [_this select 0] call expanpoli_patch_fnc_manual; },
    nil, 1.5, false, true, "",
    "driver _target == player"
];
