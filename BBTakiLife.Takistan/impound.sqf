_vcl = _this select 0;
_art = _this select 1;

if(_art == "impound") then
{
	if ((count crew _vcl) > 0) exitWith {hintSilent "The vehicle is not empty!"};
	if(_vcl distance (getMarkerPos "impoundarea2") < 30)exitwith{hintSilent "the vehicle is already impounded!"};
	if(_vcl isKindOf "air")exitwith{hintSilent "you cannot impound this vehicle!"};
	if(typeOf _vcl == "SearchLight_US_EP1") exitwith {hintSilent "you cannot impound objects!"};

	_dollarz = 200;
	_txt = format ["%1 has impounded vehicle %2!",name player, _vcl];
	(format ['["add","police","Hi",false] execVM "armitxes\logs.sqf";',_txt]) call toClients;
	
	if (_vcl isKindOf "Motorcycle" || damage _vcl > 0.9) then { _dollarz = 100; deleteVehicle _vcl; } else {
		_vcl setdamage 0;
		_vcl engineOn false;
		_vcl setvehiclelock "locked";
		(format ["%1 enableSimulation false;",_vcl]) call broadcast;
		_vcl setpos [(getPos impoundarea1 select 0)-(random 50)+(random 50), (getPos impoundarea1 select 1)-(random 50)+(random 50), getPos impoundarea1 select 2];
	};

	['dollarz', _dollarz] call INV_AddInventoryItem;
	["add","finances",format["The government of Takistan sent you $%1 for the impound!",_dollarz],false] execVM "armitxes\logs.sqf";
};

if (_art == "buy") then {
  _dollarz = "dollarz" call INV_getitemamount;
  _fine = 250;
  if (_vcl isKindOf "Motorcycle") then { _fine = 75; };  
  if(_dollarz < _fine)exitWith{hintSilent "You do not have enough money"};
  ["dollarz", -_fine] call INV_AddInventoryItem;
  
  _vcl = call compile format["%1", _vcl];
  _impounds = ["impoundarea2","ccarspawn","uncarspawn"];
  _closestDis = 100000;
  _closestImpound = "";
  
  {
    _dist = player distance (getMarkerPos _x);
    if (_closestDis > _dist) then {
      _closestDis = _dist;
      _closestImpound = _x;
    };
  } forEach (_impounds);
  
  (format ["%1 enableSimulation true;",_vcl]) call broadcast;
  _vcl setpos (getMarkerPos _closestImpound);
  _vcl setdir (markerDir _closestImpound);

  hintSilent "You payed the fine and retrieved your vehicle!";
};





