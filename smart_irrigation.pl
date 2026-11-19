% SMART IRRIGATION DECISION SYSTEM
% SWI-Prolog

soil_status(Moisture, dry) :-
    Moisture < 30.

soil_status(Moisture, normal) :-
    Moisture >= 30,
    Moisture =< 60.

soil_status(Moisture, wet) :-
    Moisture > 60.


temperature_status(Temperature, high) :-
    Temperature >= 35.

temperature_status(Temperature, normal) :-
    Temperature < 35.


humidity_status(Humidity, low) :-
    Humidity < 40.

humidity_status(Humidity, normal) :-
    Humidity >= 40.


% Rainfall expected

irrigation(_, _, _, _, yes, postponed, none,
    'Rainfall is expected, so irrigation is postponed.') :- !.


% Wet soil

irrigation(_, wet, _, _, no, not_required, none,
    'Soil is already wet, so irrigation is not required.') :- !.


% Tomato rules

irrigation(tomato, dry, high, low, no, required, high,
    'Soil is dry and the temperature is high, so tomato needs high irrigation.') :- !.

irrigation(tomato, dry, _, _, no, required, medium,
    'Soil is dry, so tomato needs medium irrigation.') :- !.

irrigation(tomato, normal, high, _, no, required, low,
    'Soil is normal but temperature is high, so low irrigation is suggested.') :- !.


% Corn rules

irrigation(corn, dry, high, _, no, required, high,
    'Soil is dry and temperature is high, so corn needs high irrigation.') :- !.

irrigation(corn, dry, _, _, no, required, medium,
    'Soil is dry, so corn needs medium irrigation.') :- !.

irrigation(corn, normal, _, low, no, required, low,
    'Humidity is low, so low irrigation is suggested for corn.') :- !.


% Potato rules

irrigation(potato, dry, _, low, no, required, medium,
    'Soil is dry and humidity is low, so potato needs medium irrigation.') :- !.

irrigation(potato, dry, _, _, no, required, low,
    'Soil is dry, so low irrigation is suggested for potato.') :- !.

irrigation(potato, normal, high, _, no, required, low,
    'Temperature is high, so low irrigation is suggested for potato.') :- !.


% Normal soil

irrigation(_, normal, _, _, no, not_required, none,
    'Soil moisture is normal, so irrigation is not required.').


% Display result

show_result(Crop, Soil, Temperature, Humidity, Rain,
            Decision, Level, Reason) :-

    crop_name(Crop, CropName),
    soil_name(Soil, SoilName),
    temperature_name(Temperature, TemperatureName),
    humidity_name(Humidity, HumidityName),
    rain_name(Rain, RainName),
    decision_name(Decision, DecisionName),
    level_name(Level, LevelName),

    nl,
    writeln('SMART IRRIGATION SYSTEM'),
    format('Crop: ~w~n', [CropName]),
    format('Soil Condition: ~w~n', [SoilName]),
    format('Temperature: ~w~n', [TemperatureName]),
    format('Humidity: ~w~n', [HumidityName]),
    format('Rainfall Expected: ~w~n', [RainName]),
    format('Recommendation: ~w~n', [DecisionName]),
    format('Suggested Level: ~w~n', [LevelName]),
    format('Reason: ~w~n', [Reason]).


crop_name(tomato, 'Tomato').
crop_name(corn, 'Corn').
crop_name(potato, 'Potato').

soil_name(dry, 'Dry').
soil_name(normal, 'Normal').
soil_name(wet, 'Wet').

temperature_name(high, 'High').
temperature_name(normal, 'Normal').

humidity_name(low, 'Low').
humidity_name(normal, 'Normal').

rain_name(yes, 'Yes').
rain_name(no, 'No').

decision_name(required, 'Irrigation Required').
decision_name(not_required, 'No Irrigation Required').
decision_name(postponed, 'Irrigation Postponed').

level_name(high, 'High').
level_name(medium, 'Medium').
level_name(low, 'Low').
level_name(none, 'No Irrigation').


read_number(Message, Value) :-
    write(Message),
    read_line_to_string(user_input, Input),
    number_string(Value, Input).


read_word(Message, Value) :-
    write(Message),
    read_line_to_string(user_input, Input),
    string_lower(Input, Lower),
    atom_string(Value, Lower).


start :-

    writeln('SMART IRRIGATION INPUT'),

    read_word('Enter Crop (tomato / corn / potato): ', Crop),

    read_number('Enter Soil Moisture (%): ', Moisture),

    read_number('Enter Temperature (C): ', Temperature),

    read_number('Enter Humidity (%): ', Humidity),

    read_word('Rainfall Expected? (yes / no): ', Rain),

    soil_status(Moisture, Soil),
    temperature_status(Temperature, Temp),
    humidity_status(Humidity, HumidityStatus),

    irrigation(
        Crop,
        Soil,
        Temp,
        HumidityStatus,
        Rain,
        Decision,
        Level,
        Reason
    ),

    show_result(
        Crop,
        Soil,
        Temp,
        HumidityStatus,
        Rain,
        Decision,
        Level,
        Reason
    ).
