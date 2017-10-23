% Type game_start to begin your adventure!
% Answer scenarios by typing the word in lowercase.

% :- dynamic HP/1.

% beginning of story
% HP(10).

% change_HP(hp) :-
%	HP(X),
%	Y is (X - 5),
%	retract(HP(_)), 
%	asserta(HP(Y)).


game_start :-
  nl,
  write('Welcome to our prolog adventure game. Choose how to proceed in your journey, and survive until the end!'), nl, 
  nl,
  write('Your cousin Sam had invited you to over for Christmas. His house is on a mountain above the city, and you planned to drive to his place.'),nl,
  write('Unfortunately, your car has broken down in the middle of the road, and with no one around you and no signal on your phone, you decide to leave your car.'),nl,
  nl,
  write('It is getting late and snow is falling lightly. Do you stay in your car?'),nl,
  write('A: Leave.'),nl,
  write('B: Stay.'),nl,
  fail.
  
leave :- 
  nl,
  write('You chose to leave the car, and walk through the forest towards your cousin\'s house'), nl, 
  nl,
  write('You hear the sound of something rustling in the bushes.'),nl,
  write('Worried, you:'),nl,
  nl,
  write('A: Run.'),nl,
  write('B: Investigate.'),nl,
  fail.
  
stay :- 
  nl,
  write('The temperature is dropping steadily, and your car doesn\'t turn on.'), nl, 
  nl,
  write('You feel that you may get sick if you stay in the car.'),nl,
  write('Eventually you decide to:'),nl,
  nl,
  write('A: Sleep.'),nl,
  write('B: Leave.'),nl,
  fail.
  
sleep :- 
  nl,
  write('You never wake up.'), nl, 
  write('Game Over.'),nl,
  fail.

  
