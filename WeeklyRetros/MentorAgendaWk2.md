## Mentor Agenda Week 2

**Discuss goals of meeting**:
  * geofence and notifications 
  * VC flow for new user and existing user
  * new layout for Profile screen 
  * bug tracking 
  * demo flow 
  * creating and managing users in database  


**Discuss specific problems and solutions**: 
  * **geofence and local notifications**
    * location manager tracks location of all the goals, set this region for this goal (may have more that one goal that applies to the same region, may need a rule how close it could be to the location of the goal. CLRegion has a center, radius and an identifier.  
    * CLCircularRegion identifier - get the goal id and set as CLCircularRegion identifier 
    * in didEnterRegion method: get query of all goals, compare goal.location with the CLRegion coordinate2D (lat, lng). should be able to compare both of those things. -> then check current time and goal.time -> trigger action
    * figure out what is the acceptable metric for location/time close enough to the goal.location and goal.time, write out these methods into separate methods 
    * these methods above should be on the NLGoal itself. Obj oriented programming. 
    * do we archive completed goals?
    * tools: dash app for for the documentation. David uses hot key ctrl tilde for it.  
  * **New User vs existing User**: 
    * appdelegate - didFinishLaunchingAppWithOptions ->  add logic here, instantiate vc and set it as the root vc.  Slack: link from the stackoverflow.  Artsy/eigen on github - link. 
    * empty state - show CreateGoal VC again 
  * **Discuss new profile screen layout** 
    * David gave positive feedback on the new Profile screen layout 
  * **How do you track bugs?** 
    * Open issues in github, open tickets for yourself and other team members 
  * **Associate users with another users (buddies)** 
    * Check Parse if there's a user registered already that is the user's buddy.  Traditionally: invitation token, personalized link, when clicked - on parse - matches the link clicked to the User and link the new account/user to that.  
    * Simplify: user registration - name and phone number sign up, if the user tells their buddy to download the app, they can download it and sign in right away with the phone number and name 
  * **Demo flow**
    * can cheat a bit, when the username = David, then show this goal. 
    * there could be networking issues 
    * work on the script of the demo and the story, practice twice a day for 8 min. If you ll do it 10 days in a row, you'll practice it 20 times. 
    * Do a script for the demo - step-by-step: new user walk-through, arc of the whole thing. make a list of the specific things we need to get done to be able to do this demo. We'll find out the edge cases if we write a script for the whole user experience/demo flow. 


**Discussion of what group will do during the week**:
  * trigger events (charging/not charging), user testing, finish the mvp 


**Planning for the following meeting**:
  * David: out of town on Fri. Check-in on Tue and on Fri via Slack and Google hangout. Hit me up on slack any time, except Wed-Fri. 
