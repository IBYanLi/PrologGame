:- dynamic
	items/1.

items([]).

%check if a certain item is in inventory

checkInv(X, [X]).
checkInv(X, [X|_]).
checkInv(X, [_|Y]) :- checkInv(X, Y).
checkInv(X) :- items(Y), checkInv(X, Y).

% helper to iterate on inventory items
list_items([X|Y]) :-
	tab(2), write(X), nl,
	list_items(Y).

% LIST INVENTORY CONTENTS
inventory :-
	items(ILIST),
	length(ILIST, N), N is 0, % have no items
	nl,
	write("You don't have anything useful in your pockets."), nl,
	fail.

inventory :-
	items(ILIST),
	length(ILIST, N), N > 0,
	nl,
	write("You have: "), nl,
	list_items(ILIST).

% ADD AN ITEM TO THE LIST
add_item(ITEM) :-
	items(LIST),
	append(LIST, ITEM, RESULT),
	retract(items(_)),
	assert(items(RESULT)).

append([H|T], ITEM, [H|R]) :-
	append(T, ITEM, R).

append([], ITEM, [ITEM | []]).

% REMOVE AN ITEM FROM THE LIST
remove_item(ITEM) :-
	items(LIST),
	removeOne(LIST, ITEM, RESULT),
	retract(items(_)),
	assert(items(RESULT)).

removeOne([H|T], ITEM, [H|R]) :-
	dif(H, ITEM),
	removeOne(T, ITEM, R).

removeOne([ITEM|T], ITEM, T).
