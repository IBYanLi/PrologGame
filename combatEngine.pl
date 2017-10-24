% flexible combat engine for encounters.
% currently starts with 'encounter.' call

:- dynamic
	inCombat,
	playerHealth/1,
	wolfHealth/1,
	dodged/0,
	gameover/0.

playerHealth(3).
wolfHealth(3).

encounter :-
	\+ inCombat,
	\+ gameover,
	write("You lock eyes with the wolf as it snarls. You slowly kneel to the ground and grasp for something"), nl,
	write("to fend it off with. You feel around in the cold snow and find a stick. You pick it up and continue"), nl,
	write("to track the wolf with your eyes."), nl,
	nl,
	asserta(inCombat),
	combatOptions.

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

endCombat :-
	retract(inCombat),
	\+ gameover,
	end_investigate.


% default end for each combat dialogue
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

strike :- % randomizer for strike outcome
	\+ dodged,
	inCombat,
	random_between(0, 2, RES),
	strike(RES).

strike :- % after dodging
	inCombat,
	dodged, retract(dodged),
	nl,
	write("You take advantage of your position."), nl,
	write("You side step the wolf and swing hard into the wolf's side, finding purchase in its soft underbelly."), nl,
	nl,
	subHealth(wolf, 2),
	combatOptions.

strike(0) :-
	nl,
	write("You lunge for the wolf and swing your stick wildly."), nl,
	write("You surprise even yourself when it makes solid contact into the wolf's side. It staggers, shocked."), nl,
	nl,
	subHealth(wolf, 1),
	combatOptions.

strike(1) :-
	nl,
	write("You lunge for the wolf and swing your stick wildly."), nl,
	write("You miss the wolf, slamming the stick straight into the powdered snow."), nl,
	nl,
	combatOptions.

strike(2) :-
	nl,
	write("You lunge for the wolf and swing your stick wildly."), nl,
	write("You miss the wolf and lose your footing, not expecting the cold asphalt to be as slippery as it is."), nl,
	nl,
	write("The wolf sees its opportunity and leaps towards you, closing its jaws around your thigh."), nl,
	write("You yell out in pain. That was a mistake."), nl,
	nl,
	subHealth(player, 2),
	combatOptions.

dodge :- % randomizer for dodge outcome
	assert(dodging), % to ensure single instance of dodge is called
	\+ dodged,
	inCombat,
	random_between(0, 2, RES),
	dodge(RES).

dodge :- % for dodging twice in a row
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
	endCombat,
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
	endCombat,
	fail.

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