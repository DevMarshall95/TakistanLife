if(!(alive player) || skipDmg)exitWith{};

_vehicle	= _this select 0;
_selection	= _this select 1;
_damage		= _this select 2;
_shooter	= _this select 3;
_ammo		= _this select 4;           
_nvcls		= nearestObjects [getpos _vehicle, ["LandVehicle"], 5];

if([player] call plr_isUnConscious) exitWith { player setDamage 1; [_shooter, _nvcls] execVM "victim.sqf"; };
if(player == _vehicle && (_ammo in ["B_12Gauge_74Slug","F_40mm_White",1,"B_9x19_SD","15Rnd_9x19_M9SD"])) exitWith {["hit", _shooter, _selection, _damage] execVM "stun.sqf";};

[_selection,_damage,_shooter, _nvcls] spawn {
  _selection	= _this select 0;
  _damage		= _this select 1;
  _shooter	= _this select 2;
  _nvcls		= _this select 3;
  
  if(_selection == "head_hit") then { hint str(_selection); }; 
  if((alive player) && ((damage player) + _damage) >= 1 && (_selection != "head_hit")) then { 
    skipDmg = true;    
    if (vehicle player != player) then { player action ["eject", vehicle player]; sleep 2; };
    player playMove "AdthPercMstpSlowWrf_beating";
    
    if (!(createDialog "ja_nein")) exitWith {hint "Dialog Error!"};
    ctrlSetText [1,"You are unconscious, want to call a medic? Pressing no or closibg this window will result in a suicide."];
    sleep 3;
    
    waitUntil{(not(ctrlVisible 1023)) || !(alive player)};
    skipDmg = false;
    
    if(!alive player) then { while { ctrlVisible 1023 } do { closeDialog 1023; }; } else {
      if (Antwort == 1) then {
        _medCount = 0;
        {
          if((typeOf _x) in ["Dr_Hladik_EP1","USMC_LHD_Crew_Blue","Doctor"]) then { _medCount = _medCount + 1; }; 
        } forEach civarray;
      
        if (_medCount > 0) then {
          ["call_medic"] execVM "armitxes\phone.sqf";
          systemChat "EMERGENCY CALL SENT";
        } else {
          systemChat "No medic responded. You died.";
          player setDamage 1;
        };
    	} else { player setDamage 1; systemChat "You suicided"; };
      Antwort = 2;
    };

  } else { player setHit [_selection, _damage]; };

	if(alive player)exitwith{};
	[_shooter, _nvcls] execVM "victim.sqf";
};

false