% wired devices
solution(device_unplugged,[(issue_domain(audio) ; issue_domain(keyboard_and_mouse)),device_connection(wired), not(resolved(device_unplugged)), not(connected(device))]).
solution(device_recognized,[(issue_domain(audio) ; issue_domain(keyboard_and_mouse)),device_connection(wired), not(resolved(device_recognized)), not(connected(device))]).
% when wired device is not recognized by windows
solution(audio_device_port, [issue_domain(audio),device_connection(wired), not(resolved(audio_device_port)), not(connected(device))]).
solution(usb_port, [issue_domain(keyboard_and_mouse),device_connection(wired), not(resolved(usb_port)), not(connected(device))]).
solution(restart_pc, [(issue_domain(audio) ; issue_domain(keyboard_and_mouse)),device_connection(wired), not(resolved(restart_pc)), not(connected(device))]).

% bluetooth devices
% basic bluetooth troubleshooting
solution(bluetooth_on, [issue_domain(audio) ; issue_domain(keyboard_and_mouse), device_connection(wireless), not(resolved(bluetooth_on)), not(connected(device))]).
solution(bluetooth_device, [(issue_domain(audio) ; issue_domain(keyboard_and_mouse)), device_connection(wireless), not(resolved(bluetooth_device)), not(connected(device))]).
% bluetooth device is connected
solution(bluetooth_device_on, [(issue_domain(audio) ; issue_domain(keyboard_and_mouse)), device_connection(wireless), not(resolved(bluetooth_device_on)), connected(device)]).
solution(bluetooth_unpair, [(issue_domain(audio) ; issue_domain(keyboard_and_mouse)), device_connection(wireless), not(resolved(bluetooth_unpair)), connected(device)]).
% bluetooth device isnt connected 
solution(bluetooth_device_port, [(issue_domain(audio) ; issue_domain(keyboard_and_mouse)), device_connection(wireless), not(resolved(bluetooth_device_port)), not(connected(device))]).
solution(bluetooth_driver, [(issue_domain(audio) ; issue_domain(keyboard_and_mouse)), device_connection(wireless), not(resolved(bluetooth_driver)), not(connected(device))]).

% basic solutions connected to all audio output devices, provided that device is connected and recognized
solution(speakers_and_headphones, [issue_domain(audio),device_type(speakers), not(resolved(speakers_and_headphones))]).
solution(headphones_volume, [issue_domain(audio),(device_type(wired_headphones) ; device_type(wireless_headphones) ; device_type(speakers)), not(resolved(headphones_volume)), connected(device)]).
solution(speakers_volume, [issue_domain(audio),device_type(speakers), not(resolved(speakers_volume)), connected(device)]).
solution(volume_level, [issue_domain(audio), (device_type(wired_headphones) ; device_type(wireless_headphones) ; device_type(speakers)), not(resolved(volume_level)), connected(device)]).
solution(audio_device, [issue_domain(audio), (device_type(wired_headphones) ; device_type(wireless_headphones) ; device_type(speakers)), not(resolved(audio_device)), connected(device)]).

% solutions for audio input devices, assumption that device is  connected and recognized
solution(microphone_privacy, [issue_domain(audio), device_type(microphone), not(resolved(microphone_privacy)), connected(device)]).
solution(mute_button, [issue_domain(audio), device_type(microphone), not(resolved(mute_button)), connected(device)]).
solution(audio_input_device, [issue_domain(audio), device_type(microphone), not(resolved(audio_input_device)), connected(device)]).
solution(input_device_volume, [issue_domain(audio), device_type(microphone), not(resolved(input_device_volume)), connected(device)]).

% solutions for keyboard and mouse, assumption that they are connected and recognized
solution(obstructed_sensor, [issue_domain(keyboard_and_mouse), (device_type(wired_mouse) ; device_type(wireless_mouse)), not(resolved(obstructed_sensor)), connected(device)]).
solution(keyboard_tester, [issue_domain(keyboard_and_mouse), (device_type(wired_keyboard) ; device_type(wireless_keyboard)), not(resolved(keyboard_tester)), connected(device)]).
solution(mouse_driver_update, [issue_domain(keyboard_and_mouse),device_type(touchpad) ; device_type(wired_mouse) ; device_type(wireless_mouse),not(resolved(mouse_driver_update)), connected(device)]).
solution(mouse_driver_reinstall, [issue_domain(keyboard_and_mouse),device_type(touchpad) ; device_type(wired_mouse) ; device_type(wireless_mouse),not(resolved(mouse_driver_reinstall)), connected(device)]).
solution(keyboard_driver_update, [issue_domain(keyboard_and_mouse), device_type(wired_keyboard) ; device_type(wireless_keyboard),not(resolved(keyboard_driver_update)), connected(device)]).
solution(keyboard_driver_reinstall, [issue_domain(keyboard_and_mouse), device_type(wired_keyboard) ; device_type(wireless_keyboard),not(resolved(keyboard_driver_reinstall)), connected(device)]).

% solutions for internet
solution(change_network,[issue_domain(internet_connection),internet_connection_type(wi-fi),(internet_connection_status(on) ; internet_connection_status(connected)),not(resolved(change_network))]).
% solutions based on status in change adapter options
solution(change_adapter_options,[issue_domain(internet_connection),internet_connection_status(on),not(resolved(change_adapter_options))]).
solution(unplug_ethernet,[issue_domain(internet_connection),internet_connection_type(ethernet),internet_connection_status(unplugged), not(resolved(unplug_ethernet))]).
solution(reenable_adapter,[issue_domain(internet_connection),internet_connection_status(not_connected), not(resolved(reenable_adapter))]).
solution(reset_router,[issue_domain(internet_connection),internet_connection_status(not_connected),not(resolved(reset_router))]).
solution(reconnect_network,[issue_domain(internet_connection),internet_connection_status(connected),not(resolved(reconnect_network))]).
% when connection type is wi-fi and it is turned off
solution(wifi_switch,[issue_domain(internet_connection),internet_connection_type(wi-fi),internet_connection_status(off),not(resolved(wifi_switch))]).
solution(airplane_mode_wifi,[issue_domain(internet_connection),internet_connection_type(wi-fi),internet_connection_status(off),not(resolved(airplane_mode_wifi))]).
solution(turn_wifi_on,[issue_domain(internet_connection),internet_connection_type(wi-fi),internet_connection_status(off),not(resolved(turn_wifi_on))]).
solution(replug_wifi_adapter,[issue_domain(internet_connection),internet_connection_type(wi-fi),internet_connection_status(off),not(resolved(replug_wifi_adapter))]).

:- dynamic device_connection/1.
:- dynamic issue_domain/1.
% solution domains - audio, keyboard_and_mouse
:- dynamic device_type/1. 
% audio device types - wireless_headphones, wired_headphones, speakers, microphone
% keyboard and mouse device types - wired/wireless keyboard, wired/wireless mouse, touchpad
:- dynamic resolved/1.
:- dynamic connected/1.
:- dynamic internet_connection_type/1.
% internet connection types - ethernet, wi-fi
:- dynamic internet_connection_status/1.
% internet connection status - on, off, unplugged, not_connected, connected

send_message(Message) :-
        format("~w\n",[Message]),
        flush_output.

check_conditions([]).
check_conditions([C|R]) :-
        C,
        check_conditions(R).

solution_exists() :-
        solution(_,Cs),
        check_conditions(Cs).

didnt_help() :-
        (
        solution_exists() ->
        solution(Y,Cs),
        check_conditions(Cs),
        troubleshoot_solution(Y) ;
        send_message("I'm sorry I have no more solutions")
        ).

next_solution(X,Y) :-
       (
        X = yes ->
        send_message("I'm glad I helped") ;
        asserta(resolved(Y)),
        didnt_help()
        ).

start_troubleshooting() :-
        send_message("What's the domain of your issue?|Available answers:|audio|internet connection|keyboard and mouse"),        
        read(X),
        asserta(issue_domain(X)),
        troubleshoot_domain(X).



% DOMAIN - AUDIO
troubleshoot_domain(audio) :-
        send_message("What's the audio device type?|Available answers:|headphones|speakers|microphone"),
        read(Y),
        (
                Y = headphones ->
                        send_message("are they wireless?|Available answers:|yes|no"),
                        read(Z),
                        (
                                Z = yes ->
                                        X = wireless_headphones,
                                        C = wireless 
                                        ;        
                                        X = wired_headphones,
                                        C = wired
                        ),
                        asserta(device_type(X)),
                        asserta(device_connection(C)),
                        troubleshoot_device(headphones) 
                        ;
                        (
                        Y = speakers ->
                                X = speakers,
                                asserta(device_type(X)),
                                asserta(device_connection(wired)),
                                troubleshoot_device(speakers)
                                ;
                                X = microphone,
                                asserta(device_type(X)),
                                asserta(device_connection(wired)),
                                troubleshoot_device(microphone)
                        )
                        
        ).
      


troubleshoot_device(headphones) :-
        solution(I,Cs),
        check_conditions(Cs),
        troubleshoot_solution(I).

troubleshoot_device(microphone) :-
        solution(I,Cs),
        check_conditions(Cs),
        troubleshoot_solution(I).

troubleshoot_device(speakers) :-
        send_message("Are your headphones plugged in too?|Available answers:|yes|no"),
        read(X),
        (
                X = yes -> 
                        troubleshoot_solution(speakers_and_headphones) 
                        ;
                        asserta(resolved(speakers_and_headphones)),
                        solution(I,Cs),
                        check_conditions(Cs),
                        troubleshoot_solution(I)
        ).



troubleshoot_solution(device_unplugged) :-
        send_message("Check if your device is plugged into the correct port|Did that solve your issue?|Available answers:|yes|no"),
        read(X),
        next_solution(X, device_unplugged).

troubleshoot_solution(device_recognized) :-
        send_message("Unplug the device and plug it back in|is there a Windows popup for the correct device type?|Available answers:|yes|no"),
        read(X),
        (
                X = yes ->
                        asserta(connected(device)),
                        next_solution("no",device_recognized)                        
                        ;                        
                        next_solution("no", device_recognized)
        ).

troubleshoot_solution(speakers_and_headphones) :-
        send_message("If your speakers and headphones are both plugged in, your speakers might not work|unplug your headphones|Did that solve your issue?|Available answers:|yes|no"),
        read(X),
        next_solution(X, speakers_and_headphones).

troubleshoot_solution(audio_device_port) :-
        send_message("If you have multiple audio ports try using a different one|Did that solve your issue?|Available answers:|yes|no"),
        read(X),
        next_solution(X, audio_device_port).

troubleshoot_solution(restart_pc) :-
        send_message("Try restarting your PC|Did that solve your issue?|Available answers:|yes|no"),
        read(X),
        next_solution(X, restart_pc).



troubleshoot_solution(headphones_volume) :-
        send_message("Your headphones might have a volume wheel, try turning it in either direction|Did that solve your issue?|Available answers:|yes|no"),
        read(X),
        next_solution(X, headphones_volume).

troubleshoot_solution(speakers_volume) :-
        send_message("Your speakers might have a volume wheel, try turning it in either direction|Did that solve your issue?|Available answers:|yes|no"),
        read(X),
        next_solution(X, speakers_volume).

troubleshoot_solution(volume_level) :-
        send_message("Open the volume mixer and check your volume levels, try turning all the channels up|Did that solve your issue?|Available answers:|yes|no"),
        read(X),
        next_solution(X, volume_level).

troubleshoot_solution(audio_device) :-
        send_message("Open sound settings and try changing the output device|Did that solve your issue?|Available answers:|yes|no"),
        read(X),
        next_solution(X,audio_device).



troubleshoot_solution(bluetooth_on) :-
        send_message("Go to 'Airplane mode' and see if airplane mode is off and bluetooth is on|Did that solve your issue?|Available answers:|yes|no"),
        read(X),
        next_solution(X, bluetooth_on).

troubleshoot_solution(bluetooth_device) :-
        send_message("Go to 'Bluetooth & other devices' and see if your bluetooth device is on the list|is it on the list?|Available answers:|yes|no"),
        read(X),
        (
                X = yes ->
                        asserta(connected(device)),
                        next_solution('no',bluetooth_device)                        
                        ;                        
                        next_solution('no',bluetooth_device)
        ).

troubleshoot_solution(bluetooth_device_port) :-
        send_message("Try resetting bluetooth or try to plug your bluetooth receiver into a different USB port|Did that solve your issue?|Available answers:|yes|no"),
        read(X),
        next_solution(X, bluetooth_device_port).

troubleshoot_solution(bluetooth_device_on) :-
        send_message("Check if your bluetooth device is on, or if it needs new batteries|Did that solve your issue?|Available answers:|yes|no"),
        read(X),
        next_solution(X, bluetooth_device_on).

troubleshoot_solution(bluetooth_driver) :-
        send_message("Try to update bluetooth drivers using a service like 'Driver Easy'|Did that solve your issue?|Available answers:|yes|no"),
        read(X),
        next_solution(X, bluetooth_driver).

troubleshoot_solution(bluetooth_unpair) :-
        send_message("Unpair your bluetooth device and pair it again|Did that solve your issue?|Available answers:|yes|no"),
        read(X),
        next_solution(X, bluetooth_unpair).



troubleshoot_solution(microphone_privacy) :-
        send_message("Select settings > privacy > microphone|Under 'Allow access to the microphone on this device'|it should state 'Microphone access for this device is on'|Did that solve your issue?|Available answers:|yes|no"),
        read(X),
        next_solution(X, microphone_privacy).

troubleshoot_solution(mute_button) :-
        send_message("Your microphone might have a mute button or a switch, make sure it isn't active|Did that solve your issue?|Available answers:|yes|no"),
        read(X),
        next_solution(X, mute_button).

troubleshoot_solution(audio_input_device) :-
        send_message("Go to Settings > System > Sound|Under 'Input', ensure your microphone is selected under 'Choose your input device'|Did that solve your issue?|Available answers:|yes|no"),
        read(X),
        next_solution(X, audio_input_device).

troubleshoot_solution(input_device_volume) :-
        send_message("Search for 'test your microphone' in Windows, select 'Device properties' for your microphone and check the volume setting|If your device volume is set to 0, increase it|Did that solve your issue?|Available answers:|yes|no"),
        read(X),
        next_solution(X, input_device_volume).



% DOMAIN - KEYBOARD AND MOUSE
troubleshoot_domain(keyboard_and_mouse) :-
        send_message("What type of device are you using?|Available answers:|keyboard|mouse|touchpad"),
        read(X),
        (
                X = touchpad ->
                        asserta(device_type(touchpad)),
                        asserta(connected(device))
                        ;
                        send_message("Is the device wireless?|Available answers:|yes|no"),
                        read(Y),
                (
                X = keyboard ->
                        (
                        Y = yes ->
                                asserta(device_type(wireless_keyboard)),
                                asserta(device_connection(wireless))
                                ;
                                asserta(device_type(wired_keyboard)),
                                asserta(device_connection(wired))
                        )
                        ;
                        (
                        Y = yes ->
                                asserta(device_type(wireless_mouse)),
                                asserta(device_connection(wireless))
                                ;
                                asserta(device_type(wired_mouse)),
                                asserta(device_connection(wired))
                        )
                )
        ),
        solution(I,Cs),
        check_conditions(Cs),
        troubleshoot_solution(I).


troubleshoot_solution(usb_port) :-
        send_message("If you have multiple available USB ports, try a different one|If your device is an USB 3.0 device, make sure you're using a USB 3.0 port|Did that solve your issue?|Available answers:|yes|no"),
        read(X),
        next_solution(X, usb_port).

troubleshoot_solution(mouse_driver_update) :-
        send_message("Go to device manager|under mice and pointing devices, select your device|open it, select driver tab, and select Update driver|Did that solve your issue?|Available answers:|yes|no"),
        read(X),
        next_solution(X, mouse_driver_update).

troubleshoot_solution(mouse_driver_reinstall) :-
        send_message("Go to device manager|under mice and pointing devices, select your device|open it, select driver tab, and select uninstall|restart your PC to reinstall the driver|Did that solve your issue?|Available answers:|yes|no"),
        read(X),
        next_solution(X, mouse_driver_reinstall).

troubleshoot_solution(keyboard_driver_update) :-
        send_message("Go to device manager|under keyboards, select your device|open it, select driver tab, and select Update driver|Did that solve your issue?|Available answers:|yes|no"),
        read(X),
        next_solution(X, keyboard_driver_update).

troubleshoot_solution(keyboard_driver_reinstall) :-
        send_message("Go to device manager|under keyboards, select your device|open it, select driver tab, and select uninstall|restart your PC to reinstall the driver|Did that solve your issue?|Available answers:|yes|no"),
        read(X),
        next_solution(X, keyboard_driver_reinstall).

troubleshoot_solution(obstructed_sensor) :-
        send_message("Flip the mouse over and check your mouse sensor, it might be obstructed in some way|This might prevent the mouse pointer from moving properly|Did that solve your issue?|Available answers:|yes|no"),
        read(X),
        next_solution(X, obstructed_sensor).

troubleshoot_solution(keyboard_tester) :-
        send_message("Your keyboard might have some malfunctioning keys.|Go to a site like keyboardtester.com and check if any keys are working|Did that solve your issue?|Available answers:|yes|no"),
        read(X),
        next_solution(X, keyboard_tester).




% DOMAIN - INTERNET CONNECTION
troubleshoot_domain(internet_connection) :-
        send_message("Do you have problems with wired connection (Ethernet) or with Wi-Fi?|Available answers:|ethernet|wi-fi"),
        read(X),
        (
                X = ethernet ->
                        asserta(internet_connection_type(ethernet)),
                        asserta(internet_connection_status(on))
                        ;
                        asserta(internet_connection_type(wi-fi)),
                        send_message("Is wi-fi on? check in the bottom right part of the taskbar|if wi-fi is on there should be a concentric arch type symbol|if wi-fi is off there should be a globe type symbol|Available answers:|yes|no"),
                        read(Y),
                        (
                                Y = yes ->
                                        asserta(internet_connection_status(on))
                                        ;
                                        asserta(internet_connection_status(off))
                        )
        ),
        solution(I,Cs),
        check_conditions(Cs),
        troubleshoot_solution(I).


troubleshoot_solution(change_network) :-
        send_message("Try connecting to a different network|Did that solve your issue?|Available answers:|yes|no"),
        read(X),
        next_solution(X, change_network).

troubleshoot_solution(change_adapter_options) :-
        send_message("Search 'Network status in the Windows search'|Click on 'Change adapter options'|What is the status of the network adapter that you're trying to connect with?|Available answers:|connected|not connected|network cable unplugged"),
        read(X),
        (
                X = connected ->
                        asserta(internet_connection_status(connected))
                        ;
                        (
                                X = not_connected ->
                                        asserta(internet_connection_status(not_connected))
                                        ;
                                        asserta(internet_connection_status(unplugged))
                        )
        ),
        next_solution('no', change_adapter_options).

troubleshoot_solution(unplug_ethernet) :-
        send_message("Try unplugging the ethernet cable and plugging it back in|Did that solve your issue?|Available answers:|yes|no"),
        read(X),
        next_solution(X, unplug_ethernet).

troubleshoot_solution(reenable_adapter) :-
        send_message("Right click on the adapter and click on 'disable'|After a few moments do the same thing, but click on 'enable'|Did that solve your issue?|Available answers:|yes|no"),
        read(X),
        next_solution(X, reenable_adapter).

troubleshoot_solution(reset_router) :-
        send_message("Try resetting your router|Your router should have either a reset switch or an on-off switch|Wait a few minutes after doing that|Did that solve your issue?|Available answers:|yes|no"),
        read(X),
        next_solution(X, reset_router).

troubleshoot_solution(reconnect_network) :-
        send_message("Right click on the adapter and click on 'disconnect'|After a few moments do the same thing, but click on 'connect'|Make sure you type in the correct password|Did that solve your issue?|Available answers:|yes|no"),
        read(X),
        next_solution(X, reconnect_network).

troubleshoot_solution(wifi_switch) :-
        send_message("Your device might have a physical wi-fi switch, make sure it's flipped to 'on' position|Did that solve your issue?|Available answers:|yes|no"),
        read(X),
        next_solution(X, wifi_switch).

troubleshoot_solution(airplane_mode_wifi) :-
        send_message("Search 'airplane mode' in the Windows search|Make sure the airplane mode is turned off|Did that solve your issue?||Available answers:|yes|no"),
        read(X),
        next_solution(X, airplane_mode_wifi).

troubleshoot_solution(turn_wifi_on) :-
        send_message("In the bottom right corner of the taskbar click on the No internet icon|It should look like a globe|Turn on wi-fi by clicking on the Wi-Fi button|Did that solve your issue?||Available answers:|yes|no"),
        read(X),
        next_solution(X, turn_wifi_on).

troubleshoot_solution(replug_wifi_adapter) :-
        send_message("If you're using a wi-fi adapter try unplugging it and plugging it back in|Try using another USB port|Did that solve your issue?|Available answers:|yes|no"),
        read(X),
        next_solution(X, replug_wifi_adapter).


% Author: Karlo Rusovan - for any questions contact on: krusovan@student.foi.hr