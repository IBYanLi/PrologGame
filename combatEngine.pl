% flexible combat engine for encounters.
% currently starts with 'encounter.' call
%http://wiki.ubc.ca/Course:CPSC312-2017-Choose_Your_Adventure
:- dynamic
	inCombat,
	playerHealth/1,
	wolfHealth/1,
	dodged/0,
	gameover/0.

playerHealth(3).
wolfHealth(3).

% BEGIN encounter with flashlight
encounter(flashlight):-
	\+ inCombat,
	\+ gameover,
	write("You lock eyes with the wolf as it snarls. You hold your metallic flashlight by the handle"), nl,
	write("and eye the wolf warily, like a bomb ready to blow at the merest motion."), nl,
	nl,
	asserta(inCombat),
	combatOptions.

% BEGIN encounter without flashlight
encounter :-
	\+ inCombat,
	\+ gameover,
	write("You lock eyes with the wolf as it snarls. You slowly kneel to the ground and grasp for something"), nl,
	write("to fend it off with. You feel around in the cold snow and find a stick. You pick it up and continue"), nl,
	write("to track the wolf with your eyes."), nl,
	add_item(stick),
	nl,
	asserta(inCombat),
	combatOptions.

% HEALTH SETTERS
subHealth(player, D) :-
	playerHealth(OH),
	NH is OH - D,
	retract(playerHealth(OH)),
	asserta(playerHealth(NH)).

subHealth(wolf, D) :-
	wolfHealth(OH),
	NH is OH - D,
	retract(wolfHealth(OH)),
	asserta(wolfHealth(NH)).

% reset combat state (w/ flashlight) and return to story
endCombat :-
	checkInv(flashlight),
	retract(inCombat),
	\+ gameover,
	write("You discard your bloody and broken flashlight. It won't do you any good now."), nl, nl,
  	remove_item(flashlight),
	end_investigate.

% reset combat state (w/ stick) and return to story
endCombat :-
	checkInv(stick),
	retract(inCombat),
	\+ gameover,
	end_investigate.

% PROVIDE COMBAT OPTIONS TO PLAYER AT END OF EACH CYCLE
combatOptions :-
	checkPlayerState,
	checkWolfState,
	playerHealth(PH),
	wolfHealth(WH),
	inCombat, % to see if game has ended from death
	write("Your health is currently: "), print(PH), write("/3"),nl,
	write("The wolf's health is currently: "), print(WH), write("/3"),nl,
	write("You stare down the wolf as it continues to circle you."), nl,
	nl,
	write("What do you do?"), nl,
	write("A: strike."), nl,
	write("B: dodge."), nl,
	write("C: run."), nl,
	nl,
	fail.

% STRIKE entry point
strike :- % with stick
	asserta(striking),
	inCombat,
	checkInv(stick),
	strike(stick).

strike :- % with flashlight
	inCombat,
	checkInv(flashlight),
	strike(flashlight).

% randomizers for strike outcomes
strike(stick) :- % with stick
	striking,
	\+ dodged,	
	random_between(0, 2, RES),
	strike(RES).

strike(flashlight) :- % with flashlight
	striking,
	\+ dodged,
	random_between(0, 3, RES),
	strike(RES, flashlight).

% for striking after a dodge
strike(_) :- % after dodging
	dodged, retract(dodged),
	striking,
	inCombat,
	nl,
	write("You take advantage of your position."), nl,
	write("You side step the wolf and swing hard into the wolf's side, finding purchase in its soft underbelly."), nl,
	nl,
	subHealth(wolf, 2),
	retract(striking),
	combatOptions.

% resolve outcomes for striking with stick
strike(0) :-
	striking,
	nl,
	write("You lunge for the wolf and swing your stick wildly."), nl,
	write("You surprise even yourself when it makes solid contact into the wolf's side. It staggers, shocked."), nl,
	nl,
	subHealth(wolf, 1),
	retract(striking),
	combatOptions.

strike(1) :-
	striking,
	nl,
	write("You lunge for the wolf and swing your stick wildly."), nl,
	write("You miss the wolf, slamming the stick straight into the powdered snow."), nl,
	nl,
	retract(striking),
	combatOptions.

strike(2) :-
	striking,
	nl,
	write("You lunge for the wolf and swing your stick wildly."), nl,
	write("You miss the wolf and lose your footing, not expecting the cold asphalt to be as slippery as it is."), nl,
	nl,
	write("The wolf sees its opportunity and leaps towards you, closing its jaws around your thigh."), nl,
	write("You yell out in pain. That was a mistake."), nl,
	nl,
	subHealth(player, 2),
	retract(striking),
	combatOptions.

% resolve outcomes for striking with flashlight
strike(0, flashlight) :-
	striking,
	nl,
	write("You swing your baton just as the wolf lunges, smashing your weapon against its head with a sickly crunch."), nl,
	write("The wolf impacts the snowy ground with an impressive OOMPH, and twitched once."), nl,
	write("It did not move."), nl,
	nl,
	retract(striking),
	endCombat.

strike(1, flashlight) :-
	striking,
	nl,
	write("You lunge for the wolf and swing your baton wildly."), nl,
	write("You surprise even yourself when it makes solid contact into the wolf's side. It staggers, shocked."), nl,
	nl,
	subHealth(wolf, 2),
	retract(striking),
	combatOptions.

strike(2, flashlight) :-
	striking,
	nl,
	write("You lunge for the wolf and swing your baton wildly."), nl,
	write("You miss the wolf, slamming the baton straight into the powdered snow."), nl,
	nl,
	retract(striking),
	combatOptions.

strike(3, flashlight) :-
	striking,
	nl,
	write("You lunge for the wolf and swing your baton wildly."), nl,
	write("You miss the wolf and lose your footing, not expecting the cold asphalt to be as slippery as it is."), nl,
	nl,
	write("The wolf sees its opportunity and leaps towards you, closing its jaws around your thigh."), nl,
	write("You force it off with your baton before it gets a good grip, but still you yell out in pain. That was a mistake."), nl,
	nl,
	subHealth(player, 1),
	retract(striking),
	combatOptions.

% DODGE ENTRY POINT
dodge :-
	assert(dodging), % to ensure single instance of dodge is called
	\+ dodged,
	inCombat,
	random_between(0, 2, RES), % dodge outcome randomizer
	dodge(RES).

% to remove dodge bonus if dodging twice in succession
dodge :-
	dodging,
	dodged, retract(dodged),
	inCombat,
	nl,
	write("You back away from the wolf, paralyzed with fear."), nl,
	write("The wolf scrambles back to its feet, and turns to find your gaze again."), nl,
	nl,
	write("Seems you've missed your opportunity."), nl,
	nl,
	retract(dodging),
	combatOptions.

% resolve outcomes for dodge
dodge(N) :-
	dodging,
	N > 0,
	inCombat,
	nl,
	write("You carefuly observe the wolf's movements. It pauses for just a second before leaping into the air towards you."), nl,
	write("You move out of the way just in time and the wolf's jaws snap where your head was just moments ago."), nl,
	write("Surprised, it hits the ground and loses its footing, and slips."), nl,
	nl,
	write("This may be a good time to take a swing..."), nl,
	nl,
	asserta(dodged),
	retract(dodging),
	combatOptions.

dodge(0) :-
	dodging,
	inCombat,
	nl,
	write("You carefully observe the wolf's movements."), nl,
	write("It growls, but does not make a move towards you. It appears to be waiting for you to make the first move."), nl,
	nl,
	retract(dodging),
	combatOptions.

% RUN ENTRY POINT
run :-
	inCombat,
	nl,
	write("You panic. You've never seen a wolf before, and it's large yellow eyes hypnotize you."), nl,
	write("You turn run back towards the car."), nl,
	nl,
	write("Before you even make it three steps, you feel a massive impact on your back, plowing you into the ground."), nl,
	write("The last thing you feel are sharp teeth closing around your neck. You really shouldn't turn your back on a wolf."), nl,
	nl,
	write("Game Over."),
	asserta(gameover),
	fail.

% check player state before providing options
checkPlayerState :- % player is fine
	playerHealth(N),
	N > 1.

checkPlayerState :- % player close to death
	playerHealth(N),
	N is 1,
	write("Your vision blurs as you and begins to narrow as you continue to bleed out. This could be it."), nl,
	nl.

checkPlayerState :- % player died
	playerHealth(N),
	N < 1,
	write("The exertion was too much for you. Your vision fades and you slam into the snowy ground."), nl,
	nl,
	write("Game Over."), nl,
	asserta(gameover),
	fail.

% check wolf state before providing options
checkWolfState :-
	wolfHealth(N),
	N > 1.

checkWolfState :- % wolf close to death
	wolfHealth(N),
	N is 1,
	write("You can see the wolf's fur begin to mat as blood drips from its side."), nl,
	write("It is visibly in pain, and probably close to death."), nl,
	nl.

checkWolfState :- % wolf died
	wolfHealth(N),
	N < 1,
	write("The wolf stumbles, and the light leaves its eyes. Its knees lock and it hits the ground in a shower of snow."), nl,
	write("You collapse to the ground, unable to believe what has just transpired."), nl,
	nl,
	endCombat.