:- consult(combatEngine).
:- consult(sceneDirectory).

% Type game_start to begin your adventure!
% Answer scenarios by typing the word in lowercase.

:- dynamic
  scene/1,
  lastscene/1,
  gameover,
  changingmind.

:- discontiguous
  leave/0.

scene(s001). % starting point
lastscene(x). % to store previous

% helper to change scenes from S1 to S2.
change_scene(S1, S2) :-
  \+ gameover,
  scene(S1),
  retract(lastscene(_)),
  asserta(lastscene(S1)),
  retract(scene(S1)),
  asserta(scene(S2)).

% helper to change scene whilst retaining lastscene for change_your_mind
change_scene(S1, S2) :-
  gameover,
  changingmind,
  retract(scene(S1)),
  asserta(scene(S2)).

% fail to change scene if player is dead
change_scene(_, _) :-
  gameover,
  \+ changingmind,
  write("You died. If you wish to try again, you can 'redo', or you can 'restart'."), nl,
  fail.

redo :- % for not inCombat
  asserta(changingmind),
  gameover,
  \+ inCombat,
  
  % set the current scene ID correctly to call the last scene without error
  lastscene(PREV),
  scene(CURR),
  prop(GOODCODE, goto, PREV),
  change_scene(CURR, GOODCODE),

  % get the last scene
  prop(PREV, scene, CALL),
  
  retract(changingmind),
  retract(gameover),

  % goto the last scene
  CALL.

redo :- % for inCombat
  asserta(changingmind),
  gameover,
  inCombat,

  % set the current scene correctly to call the last scene without error
  lastscene(PREV),
  scene(CURR),
  prop(GOODCODE, goto, PREV),
  change_scene(CURR, GOODCODE),

  % get the last scene
  prop(PREV, scene, CALL),

  % reset health for combat
  retract(playerHealth(_)),
  retract(wolfHealth(_)),
  asserta(playerHealth(3)),
  asserta(wolfHealth(3)),

  retract(changingmind),
  retract(gameover),

  % goto the last scene
  CALL.

% BEGIN: s001
game_start :-
  nl,
  write("Welcome to our prolog adventure game. Choose how to proceed in your journey "),
  write("and survive until the end!"), nl, 
  nl,
  write("Your cousin Sam had invited you to over for Christmas."), nl,
  write("His house is on a mountain above the city, and you planned to drive to his place."), nl,
  write("Unfortunately, your car has broken down in the middle of the road."), nl,
  write("With no one around you and no signal on your phone, you decide to leave your car."),nl,
  nl,
  write("It is getting late and snow is falling lightly. What do you do?"), nl,
  write("A: leave."),nl, % s002
  write("B: get_in. (return to the car)" ),nl, % s003
  fail.

% restarts for both gameover and non-gameover state
restart :-
  gameover,
  retract(gameover),
  retract(lastscene(_)),
  retract(scene(_)),
  
  asserta(scene(s001)),
  game_start.

restart :-
  retract(lastscene(_)),
  retract(scene(_)),
  
  asserta(scene(s001)),
  game_start.

% s001, s003, s013 -> s002
leave :-
  scene(N), member(N, [s001, s003, s013]), % multiple entry
  change_scene(N, s002),
  nl,
  write("You choose to leave the car, and walk through the forest towards your cousin's house"), nl, 
  nl,
  write("You hear the sound of something rustling in the bushes."), nl,
  write("Worried, you:"),nl,
  nl,
  write('A: run_away.'),nl, % s006
  write('B: investigate.'),nl, % s007
  fail.

% s002 -> s006
run_away :- 
  change_scene(s002, s006),
  nl,
  write("You back away slowly from the bushes. As you turn to make a dash up the side of the road,"), nl,
  write("the bushes rustle again. You ignore the sound and bolt up the road in fear."), nl,
  nl,
  write("You run until your lungs are on fire, and your legs cannot take you another step."), nl,
  write("You look out over the highway barricade, and see that the strip of road you are standing on overlooks the city."), nl,
  write("The twinkling lights of downtown seem so far away now, as you pull your jacket tighter around you."), nl,
  write("You become acutely aware the cold wind cuts easily through your jacket as your heart rate begins to settle."), nl,
  nl,
  write("You decide to:"), nl,
  nl,
  write("A: proceed."), nl, % s008
  write("B: call. (and try your cell phone again)"), nl, % s009
  fail.

% s006 -> s010
proceed :-
  change_scene(s006, s010),
  nl,
  write("You continue walking up the mountain, considering the choices that led you to this predicament."), nl,
  write("The temperatures drop as the night grows darker. You follow the road, hoping that"), nl,
  write("someone might drive by and pick up a hitchiker in need."), nl, nl,
  write("After half an hour trudging up the cold and dark mountain, you see headlights in the distance."), nl,
  write("You frantically wave your arms like a man possessed, and the car stops beside you."), nl,
  write("The driver rolls down the windows, and the man inside introduces himself."), nl, nl,
  write("'Hey, my name is Jeffrey. Do you need a ride?'"), nl,
  write("A: sure."), nl, %s011
  write("B: nah."), nl, %s012
  fail.

% s0010 -> s011
sure :-
  change_scene(s010, s011),
  nl,
  write("'Wow, thanks Bud!' You can't believe your luck. You enter the man's car."), nl,
  write("'You know, my car had broken down and I was worried about how I would get to my cousin's without"), nl,
  write("freezing to death first.' You turn to smile at the man."), nl, nl,
  write("He turns to look back at you and smiles. You quickly explain where you're trying to go and he nods."), nl,
  write("As the car continues along the road, you feel that the area he is driving to doesn't seem like your cousin's."), nl,
  write("You decide to:"), nl, nl,
  write("A: correct_him. (You rather he drive you all the way.)"), nl, %s013
  write("B: leave_car. (You may as well go the rest of the way yourself.)"), nl, %s014
  fail.  

% s0011 -> s013
correct_him :-
  change_scene(s011, s013),
  nl,
  write("You timidly broach the issue."), nl,
  write("'Hey man, it seems that you are going in the wrong direction...?"), nl,
  write("The man grins back at you widely. 'Don't worry. I've driven many people to this place before'."), nl, nl,
  write("You look back at him with uncertainty, and he continues to smile at you."), nl,
  write("'I know my way around here.' He reassures you."), nl,
  write("You finally drop the subject and decide to trust his sense of direction."), nl, 
  write("Looking for a subject of conversation, you ask, 'So, what's your full name?'"), nl, 
  write("He stares ahead at the road and replies, 'Jeffrey Dahmer. You can just call me Jeff.'"), nl, 
  write("'Nice, nice. Thanks again for the ride, Jeff.'"), nl, 
  write("The two of you continued along the road towards the darkness."), nl,
  write("You were never seen at your cousins house that night, nor anywhere else again."), nl,
  write("Game Over."), nl,
  nl,
  asserta(gameover),
  fail.
  
% s0011 -> s014
leave_car :-
  change_scene(s011, s014),
  nl,
  write("Feeling a nagging feeling of doubt towards Jeffrey, you make an escuse that"), nl,
  write("you need to leave the car to relieve yourself. Once he stops the car, you walk towards the bushes"), nl,
  write("and continue into the woods until you can't be seen. Then you start looking for a path to your cousins house."), nl, nl,
  write("Despite Jeffery making the wrong turn, you were much closer to your cousin's place than before you got in the car."), nl,
  write("After an hour of walking, you could finally make out the lights shining in red and green in the dark. "), nl,
  write("Tired and hungry, but with a new spring in your step, you rush towards the light."), nl, nl,
  write("Congratuations, you survived!"), nl,
  nl,
  fail.
 
  % s0010 -> s012
nah :-
  change_scene(s010, s012),
  nl,
  write("You reject the man's offer, not trusting others to help you."), nl,
  write("After all, you are fully capable of getting yourself out of these predicaments."), nl,
  write("Unfortunately... you get more and more lost in the dark woods and the snow just keeps"), nl,
  write("piling on thicker and thicker. You notice your toes are frozen purple."), nl,
  write("You continue on."), nl,
  write("You are sure you will make it."), nl, 
  write("You keep walking through the snow."), nl, 
  write("You can't feel your fingers anymore."), nl, 
  write("How much farther do you need to go?"), nl, 
  write("You collapse."), nl,
  write("Game Over."), nl,
  nl,
  asserta(gameover),
  fail.
  
% s002 -> s007a
investigate :-
  change_scene(s002, s007a),
  nl,
  write("You walk slowly towards the bushes. As you get close, you can hear a low growl."), nl,
  write("Suddenly, a large grey-haired animal leaps out of the tree-line, landing on the snow-covered asphalt."), nl,
  nl,
  change_scene(s007a, c007),
  encounter,
  fail.

end_investigate :-
  change_scene(c007, s007b),
  write("You crawl, painfully, towards the concrete median that separates the two lanes of the highway."), nl,
  write("You sit up against the median for a minute, catching your breath."), nl,
  nl,
  write("It seems you have a few options for what to do next."), nl,
  write("You are still a ways away from your cousin's place, and you are exhausted and beaten down."), nl,
  write("A: call_for_help."), nl, %s009
  write("B: continue_walking."), nl, %s010
  fail.

% s007b -> s010
continue_walking :-
  change_scene(s007b, s010),
  nl,
  write("You continue walking up the mountain, considering the choices that led you to this predicament."), nl,
  write("The temperatures drop as the night grows darker. You follow the road, hoping that"), nl,
  write("someone might drive by and pick up a hitchiker in need."), nl, nl,
  write("After half an hour trudging up the cold and dark mountain, you see headlights in the distance."), nl,
  write("You frantically wave your arms like a man possessed, and the car stops beside you."), nl,
  write("The driver rolls down the windows, and the man inside introduces himself."), nl, nl,
  write("'Hey, my name is Jeffrey. Do you need a ride?'"), nl,
  write("A: sure."), nl, %s011
  write("B: nah."), nl, %s012
  fail.
  
% s006 -> s009
call :-
  change_scene(s006, s009),
  nl,
  write("You pull out your Samsung Note 7 to check for a signal again."), nl,
  write("You smack your phone against your hand as the screen doesn't turn on in response to the power button."), nl,
  write("Maybe it's too cold? You hit the phone a few times against the concrete barricade."), nl,
  nl,
  write("It's too much for the poor cellphone to handle. It explodes, and you die a fiery death."), nl,
  nl,
  write("Game Over."), nl,
  nl,
  asserta(gameover),
  fail.

  
% s007b -> s009
call_for_help :-
  change_scene(s007b, s009),
  nl,
  write("You need to call an ambulance, or your brother, or someone. This night is quickly unfolding into madness."), nl,
  nl,
  write("You pull out your Samsung Note 7 to check for a signal again."), nl,
  write("You smack your phone against your hand as the screen doesn't turn on in response to the power button."), nl,
  write("Maybe it's too cold? You hit the phone a few times against the concrete barricade."), nl,
  nl,
  write("It's too much for the poor cellphone to handle. It explodes, and you die a fiery death."), nl,
  nl,
  write("Game Over."), nl,
  nl,
  asserta(gameover),
  fail.

% s001 -> s003
get_in :- 
  change_scene(s001, s003),
  nl,
  write("The temperature is dropping steadily, and your car doesn't want to start."), nl, 
  nl,
  write("You feel that you may get sick if you stay in the car."), nl,
  nl,
  write("You decide to:"), nl,
  write("A: fall_asleep."), nl, % s004
  write("B: leave."), nl, % s005
  write("C: wait. (maybe the storm will settle)"), nl,
  write("D: search_car."), nl, %s013
  fail.

% s003 -> s004
sleep :- 
  change_scene(s003, s004),

% s003, s013 -> s004
fall_asleep :- 
  scene(N), member(N, [s003, s013]), % multiple entry
  change_scene(N, s004),
  nl,
  write("You never wake up."), nl, 
  nl,
  write("Game Over."), nl,
  nl,
  asserta(gameover),
  fail.

% s003, s013 -> s005
wait :- % later
  scene(N), member(N, [s003, s013]), % multiple entry
  change_scene(N, s005),
  write("You decide to wait out the storm. Maybe the wind will settle down and you can make the trek on foot."), nl,
  write("NOT DONE"), nl,
  fail.

% s003 -> s013
search_car:-
  change_scene(s003, s013),
  asserta(flashlight), nl,
  write("You search your car and picked up the flashlight baton you bought a few months ago."), nl,
    % something like this: https://www.thehomesecuritysuperstore.com/self-defense-self-defense-batons-flashlight-batons-sub=212
  write("This will surely help in the dark."), nl,
  nl,
  write("You look outside at the snow whipping around in the wind. It isn't getting any warmer."), nl,
  nl,
  write("You sit for a second, and decide that you should: "), nl,
  write("A: fall_asleep."), nl, % s004
  write("B: leave."), nl, % s002
  write("C: wait."), nl, %s005
  fail. % s005