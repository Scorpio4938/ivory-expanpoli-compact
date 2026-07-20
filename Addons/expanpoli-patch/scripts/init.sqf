#include "\a3\editor_f\Data\Scripts\dikCodes.h"

// ──────────────────────────────────────
// Macro: EXPANPOLI_VEHICLE_GATE — gating macro for CBA keybinds
//
// Single-prefix check: all 17 EM_* vehicles match _type find "EM_" >= 0.
// Broader than Mean's 6-prefix approach — covers current and future
// Expanpoli police vehicles without needing to enumerate them.
// ──────────────────────────────────────
#define EXPANPOLI_VEHICLE_GATE \
    private _vcl = vehicle player; \
    if (isNull _vcl) exitWith {}; \
    private _type = typeOf _vcl; \
    if (_type find "EM_" < 0) exitWith {};

// ──────────────────────────────────────
// Macro: EXPANPOLI_DRIVER_GATE — gate for driver-only keybinds
//
// Extends EXPANPOLI_VEHICLE_GATE with dialog check and driver check.
// Ivory restricts all siren controls to the driver.
// ──────────────────────────────────────
#define EXPANPOLI_DRIVER_GATE \
    EXPANPOLI_VEHICLE_GATE \
    if (dialog) exitWith {}; \
    if (driver _vcl != player) exitWith {};

// ──────────────────────────────────────
// Expanpoli lightbar helpers — execVM Expanpoli's native scripts
//
// Unlike Mean (which uses _vcl animate), Expanpoli controls its
// lightbar via scroll-wheel UserActions that execVM these scripts.
// We replicate that logic: execVM the same scripts + set the same
// variables (code2, code3, Police_Sound) to keep the visual system
// consistent.
// ──────────────────────────────────────
#define EXPANPOLI_LIGHTS_ON \
    _vcl execVM "\EM_Police_Faction\scripts\CODE2_On.sqf"; \
    _vcl execVM "\EM_Police_Faction\scripts\Lights_On.sqf"; \
    _vcl setVariable ["code2", 0]; \
    _vcl setVariable ["code3", 0]; \
    _vcl setVariable ["Police_Sound", 0];

#define EXPANPOLI_LIGHTS_OFF \
    _vcl execVM "\EM_Police_Faction\scripts\CODE2_Off.sqf"; \
    _vcl execVM "\EM_Police_Faction\scripts\Lights_Off.sqf"; \
    _vcl setVariable ["code2", 1]; \
    _vcl setVariable ["code3", 1]; \
    _vcl setVariable ["Police_Sound", 0];

// ──────────────────────────────────────
// Horn — hold F
// ──────────────────────────────────────
["Expanpoli Patch", "expanpoli_horn", ["Car Horn", ""], {
    EXPANPOLI_DRIVER_GATE
    _vcl setVariable ["ani_horn", 1, true];
}, {
    private _vcl = vehicle player;
    if (!isNull _vcl) then {
        _vcl setVariable ["ani_horn", 0, true];
    };
}, [DIK_F, [false, false, false]], true] call CBA_fnc_addKeybind;

// ──────────────────────────────────────
// Siren toggle — R (on: siren+lightbar, off: siren only)
// ──────────────────────────────────────
["Expanpoli Patch", "expanpoli_sirens", ["Emergency - Sirens", ""], {
    EXPANPOLI_DRIVER_GATE
    playSound "ivory_beep2";
    if (_vcl getVariable "ani_siren" == 0) then {
        // Turn on: siren + lightbar together
        _vcl setVariable ["ani_lightbar", (_vcl getVariable ["ani_lightbar_todo", 1]), true];
        _vcl setVariable ["ani_siren",    (_vcl getVariable ["ani_siren_todo",    1]), true];
        EXPANPOLI_LIGHTS_ON
    } else {
        // Turn off: siren only, lightbar stays
        _vcl setVariable ["ani_siren", 0, true];
    };
}, {}, [DIK_R, [false, false, false]]] call CBA_fnc_addKeybind;

// ──────────────────────────────────────
// Next siren tone — Shift+R
// ──────────────────────────────────────
["Expanpoli Patch", "expanpoli_sirens_next", ["Emergency - Sirens (Next)", ""], {
    EXPANPOLI_DRIVER_GATE
    playSound "ivory_beep2";

    private _todo = _vcl getVariable ["ani_siren_todo", 1];

    if (_todo == 1) exitWith {
        _vcl setVariable ["ani_siren_todo", 2];
        if (_vcl getVariable "ani_siren" > 0) then { _vcl setVariable ["ani_siren", 2, true]; };
    };
    if (_todo == 2) exitWith {
        _vcl setVariable ["ani_siren_todo", 3];
        if (_vcl getVariable "ani_siren" > 0) then { _vcl setVariable ["ani_siren", 3, true]; };
    };
    if (_todo == 3) exitWith {
        _vcl setVariable ["ani_siren_todo", 4];
        if (_vcl getVariable "ani_siren" > 0) then { _vcl setVariable ["ani_siren", 4, true]; };
    };
    if (_todo == 4) exitWith {
        _vcl setVariable ["ani_siren_todo", 1];
        if (_vcl getVariable "ani_siren" > 0) then { _vcl setVariable ["ani_siren", 1, true]; };
    };
}, {}, [DIK_R, [true, false, false]]] call CBA_fnc_addKeybind;

// ──────────────────────────────────────
// Direct siren tones — 1 / 2 / 3 / 4
// ──────────────────────────────────────
["Expanpoli Patch", "expanpoli_sirens_1", ["Emergency - Sirens (Wail)", ""], {
    EXPANPOLI_DRIVER_GATE
    if (_vcl getVariable "ani_siren" > 0) then {
        _vcl setVariable ["ani_siren", 1, true];
        playSound "ivory_beep2";
    };
    _vcl setVariable ["ani_siren_todo", 1];
}, {}, [DIK_1, [false, false, false]]] call CBA_fnc_addKeybind;

["Expanpoli Patch", "expanpoli_sirens_2", ["Emergency - Sirens (Yelp)", ""], {
    EXPANPOLI_DRIVER_GATE
    if (_vcl getVariable "ani_siren" > 0) then {
        _vcl setVariable ["ani_siren", 2, true];
        playSound "ivory_beep2";
    };
    _vcl setVariable ["ani_siren_todo", 2];
}, {}, [DIK_2, [false, false, false]]] call CBA_fnc_addKeybind;

["Expanpoli Patch", "expanpoli_sirens_3", ["Emergency - Sirens (Priority)", ""], {
    EXPANPOLI_DRIVER_GATE
    if (_vcl getVariable "ani_siren" > 0) then {
        _vcl setVariable ["ani_siren", 3, true];
        playSound "ivory_beep2";
    };
    _vcl setVariable ["ani_siren_todo", 3];
}, {}, [DIK_3, [false, false, false]]] call CBA_fnc_addKeybind;

["Expanpoli Patch", "expanpoli_sirens_4", ["Emergency - Sirens (HiLo)", ""], {
    EXPANPOLI_DRIVER_GATE
    if (_vcl getVariable "ani_siren" > 0) then {
        _vcl setVariable ["ani_siren", 4, true];
        playSound "ivory_beep2";
    };
    _vcl setVariable ["ani_siren_todo", 4];
}, {}, [DIK_4, [false, false, false]]] call CBA_fnc_addKeybind;

// ──────────────────────────────────────
// Lightbar toggle — T
//
// Expanpoli adaptation: instead of Mean's _vcl animate, we execVM
// Expanpoli's native CODE2/Lights scripts and sync code2/code3/
// Police_Sound variables. Off kills siren too.
// ──────────────────────────────────────
["Expanpoli Patch", "expanpoli_lights", ["Emergency - Lights", ""], {
    EXPANPOLI_DRIVER_GATE
    playSound "ivory_beep2";
    if (_vcl getVariable "ani_lightbar" == 0) then {
        // Turn on: lightbar only, siren stays off
        _vcl setVariable ["ani_lightbar", (_vcl getVariable ["ani_lightbar_todo", 1]), true];
        EXPANPOLI_LIGHTS_ON
    } else {
        // Turn off: lightbar + siren both off
        _vcl setVariable ["ani_lightbar", 0, true];
        _vcl setVariable ["ani_siren", 0, true];
        EXPANPOLI_LIGHTS_OFF
    };
}, {}, [DIK_T, [false, false, false]]] call CBA_fnc_addKeybind;

// ──────────────────────────────────────
// Takedown tone — hold C
// ──────────────────────────────────────
["Expanpoli Patch", "expanpoli_takedown", ["Emergency - Takedown", ""], {
    EXPANPOLI_DRIVER_GATE
    _vcl setVariable ["ani_takedown", 1, true];
}, {
    private _vcl = vehicle player;
    if (!isNull _vcl) then {
        _vcl setVariable ["ani_takedown", 0, true];
    };
}, [DIK_C, [false, false, false]], true] call CBA_fnc_addKeybind;

// ──────────────────────────────────────
// Read Manual — Backslash
// ──────────────────────────────────────
["Expanpoli Patch", "expanpoli_manual", ["Read Manual", ""], {
    EXPANPOLI_VEHICLE_GATE
    if (dialog) exitWith {};
    if (driver _vcl == player || (_vcl getCargoIndex player) == 0) then {
        [_vcl] call expanpoli_patch_fnc_manual;
    };
}, {}, [DIK_BACKSLASH, [false, false, false]]] call CBA_fnc_addKeybind;

// ──────────────────────────────────────
// Lazy init — GetIn handler on 17 concrete EM_* classes
//
// Uses GetIn (not init) to avoid the CBA XEH re-init burst that
// caused loading screen hangs in the Mean patch. A one-time scan
// catches editor-placed AI already seated.
//
// Unlike Mean (which registered on 6 base classes), Expanpoli has
// no shared EM base class — we register on 17 concrete classes.
// ──────────────────────────────────────
private _allEMClasses = [
    "EM_Malibu",
    "EM_Malibu_UM",
    "EM_Police_Charger",
    "EM_Police_CrownVic",
    "EM_Police_Civic",
    "EM_Police_Explorer",
    "EM_Police_Explorer_UM",
    "EM_Police_BMWX6",
    "EM_Police_BMWX6_UM",
    "EM_Police_BMWM5",
    "EM_Police_Insurgent",
    "EM_Police_Raptor",
    "EM_Police_Raptor_UM",
    "EM_Police_Savana",
    "EM_Police_Taurus",
    "EM_Police_Taurus_UM",
    "EM_Police_F550_SWAT"
];

{
    [_x, "GetIn", {
        params ["_car"];
        _car spawn expanpoli_patch_fnc_initCar;
    }, true] call CBA_fnc_addClassEventHandler;
} forEach _allEMClasses;

// One-time scan for vehicles that already have drivers (editor-placed AI).
[] spawn {
    sleep 1;
    {
        private _type = typeOf _x;
        if (!isNull driver _x &&
            !(_x getVariable ["expanpoli_patch_initialized", false]) &&
            {_type find "EM_" >= 0}) then {
            [_x] call expanpoli_patch_fnc_initCar;
        };
    } forEach vehicles;
};
