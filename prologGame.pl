% Type game_start to begin your adventure!
% Answer scenarios by typing the word in lowercase.

:- dynamic
  scene/1,
  gameover.

:- discontiguous
  leave/0.

% beginning of story
% HP(10).

% change_HP(hp) :-
%	HP(X),
%	Y is (X - 5),
%	retract(HP(_)), 
%	asserta(HP(Y)).

scene(s001). % starting point

% helper to change scenes from S1 to S2.
change_scene(S1, S2) :-
  \+ gameover,
  scene(S1),
  retract(scene(S1)),
  asserta(scene(S2)).

change_scene(_, _) :-
  gameover,
  write("You died. If you wish to try again, you can 'change_your_mind', or you can 'restart'."), nl,
  fail.

% TODO: change_your_mind should reset the player to the last scene where they made
%       the choice that killed them. Not sure how to dynamically call a method...

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
  write("It is getting late and snow is falling lightly. Do you stay in your car?"), nl,
  write("A: leave."),nl, % s002
  write("B: stay."),nl. % s003

restart :-
  retract(gameover),
  retract(scene(_)),
  asserta(scene(s001)),
  nl,
  game_start.

% s001 -> s002
leave :-
  change_scene(s001, s002),
  nl,
  write("You choose to leave the car, and walk through the forest towards your cousin's house"), nl, 
  nl,
  write("You hear the sound of something rustling in the bushes."), nl,
  write("Worried, you:"),nl,
  nl,
  write('A: run.'),nl, % s006
  write('B: investigate.'),nl. % s007

% s002 -> s006
run :- 
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
  write("B: call. (and try your cell phone again)"), nl. % s009

% s002 -> s010
proceed :-
  change_scene(s006, s010),
  nl,
  write("You continue walking up the mountain, considering the choices that led you to this predicament."), nl,
  write("The coldness has picked up as the night grows darker. You follow the road, hoping that"), nl,
  write("someone might drive by and pick up a hitchiker in need."), nl, nl,
  write("After half an hour trudging up the cold and dark mountain, you see headlights in the distance."), nl,
  write("You frantically wave your arms like a man possessed, and the car alights beside you."), nl,
  write("The driver rolls down the windows, and the man inside introduces himself."), nl, nl,
  write("'Hey, my name is Kemper. Do you need a ride?'"), nl,
  write("A: yes_to_ride."), nl, %s011
  write("B: no_to_ride."), nl.

% s002 -> s007
investigate :-
  change_scene(s002, s007),
  nl,
  write("Curiousity killed the cat. You die."), nl,
  write("Game Over."),
  asserta(gameover).

% s006 -> s009
call :-
  change_scene(s006, s009),
  nl,
  write("You pull out your Samsung Note 7 to check for a signal again."), nl,
  write("You smack your phone against your hand as the screen doesn't turn on in response to the power button."), nl,
  write("Maybe it's too cold? You hit the phone a few times against the concrete barricade."), nl,
  nl,
  write("It's too much for the poor cellphone to handle. It explodes, and you die a fiery death."), nl,
  write("Game Over."), nl,
  asserta(gameover).


% s001 -> s003
stay :- 
  change_scene(s001, s003),
  nl,
  write("The temperature is dropping steadily, and your car doesn't want to start."), nl, 
  nl,
  write("You feel that you may get sick if you stay in the car."), nl,
  write("Eventually you:"), nl,
  nl,
  write("A: fall_asleep."), nl, % s004
  write("B: leave."), nl. % s005

% s003 -> s004
fall_asleep :- 
  change_scene(s003, s004),
  nl,
  write("You never wake up."), nl, 
  write("Game Over."), nl,
  asserta(gameover).

% s003 -> s005
leave :-
  change_scene(s003, s005).

