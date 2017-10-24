%http://wiki.ubc.ca/Course:CPSC312-2017-Choose_Your_Adventure
% directory for matching scene IDs to their function call
prop(s001, scene, game_start).
prop(s001, scene, search_car).
prop(s002, scene, leave).
prop(s003, scene, get_in).
prop(s004, scene, fall_asleep).
prop(s005, scene, wait).
prop(s006, scene, run_away).
prop(s007a, scene, investigate).
prop(c007f, scene, encounter(flashlight)). % with flashlight
prop(c007s, scene, encounter). % with stick
prop(s007b, scene, end_investigate).
prop(s008, scene, call).
prop(s009, scene, call_for_help).
prop(s010, scene, proceed).
prop(s011, scene, sure).
prop(s012, scene, nah).
prop(s013, scene, search_car).
prop(s014, scene, leave_car).
prop(s016, scene, correct_him).

% directory for getting from one scene to another
prop(s001, goto, s002).
prop(s001, goto, s003).
prop(s002, goto, s006).
prop(s002, goto, s007a).
prop(s003, goto, s004).
prop(s003, goto, s005).
prop(s006, goto, s008).
prop(s007a, goto, c007f). % to loop combat back on itself
prop(s007a, goto, c007s). % to loop combat back on itself
prop(c007f, goto, s007b).
prop(c007s, goto, s007b).
prop(s007b, goto, s009).
prop(s007b, goto, s010).
prop(s003, goto, s001).
prop(s010, goto, s011).
prop(s010, goto, s012).
prop(s011, goto, s016).
prop(s011, goto, s014).
prop(s003, goto, s013).
prop(s013, goto, s004).
prop(s013, goto, s005).
