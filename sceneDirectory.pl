% directory for matching scene IDs to their function call
prop(s001, scene, game_start).
prop(s002, scene, leave).
prop(s003, scene, get_in).
prop(s004, scene, fall_asleep).
prop(s005, scene, wait).
prop(s006, scene, run_away).
prop(s007a, scene, investigate).
prop(c007, scene, encounter).
prop(s007b, scene, end_investigate).
prop(s008, scene, proceed).
prop(s009, scene, call).
prop(s013, scene, search_car).

% directory for getting from one scene to another
prop(s001, goto, s002).
prop(s001, goto, s003).
prop(s002, goto, s006).
prop(s002, goto, s007a).
prop(s003, goto, s004).
prop(s003, goto, s005).
prop(s006, goto, s009).
prop(s007a, goto, c007).
prop(c007, goto, s007b).
prop(s007b, goto, s009).
prop(s003, goto, s013).
prop(s013, goto, s004).
prop(s013, goto, s005).
