// ============================================================
// expanpoli_patch_fnc_horn — airhorn audio loop
// ============================================================
//
// Hold-to-play airhorn via single #particlesource dummy.
// Identical to Mean patch — sound stops instantly on release.
// ============================================================

if (!hasInterface) exitWith {};
params ["_car"];

private _airhorn     = "ivory_ss2000_airhorn";
private _airhornTime = 9.932;

while {alive _car} do
{
    if (alive _car && !isNull driver _car && _car getVariable "ani_horn" > 0 && (player distance _car <= 350)) then {

        private _dummy = "#particlesource" createVehicleLocal ASLToAGL getPosWorld _car;
        _dummy attachTo [_car, [0, 0, 0]];

        [_car, _airhorn, _airhornTime, _dummy] spawn {
            params ["_car", "_airhorn", "_airhornTime", "_dummy"];
            while {_car getVariable "ani_horn" == 1} do {
                private _timeStarted = time;
                _dummy say3D [_airhorn, 250];
                waitUntil { time >= _timeStarted + _airhornTime || _car getVariable "ani_horn" != 1 };
            };
        };

        waitUntil { _car getVariable "ani_horn" == 0 };

        deleteVehicle _dummy;

    } else {
        waitUntil {sleep 0.01; !alive _car || (!isNull driver _car && _car getVariable ["ani_horn", 0] > 0 && (player distance _car <= 350))};
    };
};
