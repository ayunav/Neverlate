# ACFinalProjectProposal


# Access Code 2.2 Final Project Proposal

**Project Name: NeverLate**  
**Team Name: NeverLate**  
**Team Members: Charles Kang, Eric Sze, Ayuna Vogel**  

## The Problem   

NeverLate is an iOS app for people who are often late and want to get into habit of getting to places on time.
Existing products in the goal setting/habit building category that we currently use do not satisfy our needs as potential users: the apps are overly complicated, and do not engage and bring a user back into the app beyond sending reminders.        

NeverLate solves the above issues by gamifying a user's experience, bringing in social aspect (do it with your friend aka accountability buddy) and monetary incentive aspect (a user will set an amount of money (for example, $10) that will be sent to her accountability buddy in case she is late to a class/work/another place she has to be on time). In surveying the App Store, we could find no such combination. Popular existing resources include:

* [Stickk] (http://www.stickk.com/) - a user signs a commitment contract with the Stickk web app. If a user fails her commitment, her money at stake will go to a charity of her choice or anti-charity, an organization a user does not want to receive her money. Stickk assigns another person as a referee who checkins for the user if the user achieved/failed her commitment. 
* [21Habit] (http://thenextweb.com/lifehacks/2012/12/29/20-apps-to-help-you-keep-your-new-year-resolutions/2/) - 21habit lets you break or make a habit and keep track of it for 21 days. When you sign up, you get a choice of a free mode or committed mode. The free mode has no monetary obligations while the committed mode requires that you invest $21 in your habit. For each day that you succeed, you’ll get $1 back and each time you fail, the $1 goes to charity.
* [Beeminder] (https://itunes.apple.com/us/app/beeminder/id551869729?mt=8) - Your goals can be anything quantifiable — weight, pushups, minutes spent on Facebook, points on Duolingo. Answer with your number when Beeminder asks — or connect a device/app below to auto-report — and we'll show your progress and a Yellow Brick Road to follow to stay on track. If you go off track, you pledge money to stay on the road the next time. If you go off track again, we charge you.
* [Aherk] (http://thenextweb.com/lifehacks/2012/12/29/20-apps-to-help-you-keep-your-new-year-resolutions/4/) - self-blackmail service that lets you define a goal, set a deadline and let your Facebook friends decide if you’ve achieved the goal. If not, it uploads a compromising photo of you on Facebook for all your friends to see. You may argue that you can just submit a non-compromising photo of you to the app, rendering the consequence negligible, but at least it incorporates a bit of social pressure into your goal by asking your friends to vet your success.


We assume that in most use cases, a user will set as an accountability buddy a friend who a user will see at her destination place.  Otherwise, a user can set any friend to be her accountability buddy. We envision our primary users to be adults of all ages, for example, classmates, friends, gym buddies or office colleagues. In other words, people who have to be at a certain place at a certain time (class, office, work, gym, etc.) and, presumably but not necessarily, see in person their friend at that location.

## The Solution 

Enable our users to be make monetary contracts with themselves and another person, with the non-contracted person being the accountability buddy.

We aim to solve two main problems. 

###
\#1 There are many people that are late to important events, such as work, class, or... gym.

\#2 Although there are some accountability apps on the market, non-monetary incentive is not strong enough motive for someone to be on-time when they have a habit of being late.

## Baseline features

* A user will be able to save the time, day, location they have to be at on time. 
* A user will be able to select their accountability buddy from the list of their phone contacts and connect the app to their Venmo account. 
* If a user is late to the place they have to be at by a certain time, the app will send a Venmo payment to their accountability buddy of the amount the user set up. 
* Sleek, enjoyable + easy to use UI/UX.
* On first launch, the user is presented with illustration and text instructions on how to use the app and app's concept.

**Venmo Integration**
* Set up payments between two users, withdrawal or deposit depending on what happens to the contractee. If a user is late to the place they have to be at by a certain time, the app will send a Venmo payment to their accountability buddy of the amount the user set up.  

**Apple Maps Integration and Building Geofences**
* Use mapkit to pinpoint current location, search a location or drop a pin to save a user's location "to be on time". The app will build a geofence around the saved locaiton. The app will start tracking user's location, and if a user is not at a place they have to be at by a certain time, the app will send a Venmo payment from their account to their accountability buddy. 

**Bonus features**

* Automatic social media updates about lateness/on time status of a user (aka "public shaming") with an opt-out feature.  
* Twilio to be able to send text message to an accountability buddy with a deep link to the app in the App Store, and/or to "accept the challenge" and to participate in the goal to be on time.  


### Wireframes
Please review wireframes [here](https://www.dropbox.com/sh/9kjgqti1tr437rx/AAAswrCjfBdhP-NHhuG3btlya?dl=0).


[Presentation Deck] (https://www.dropbox.com/s/h6eqccpx3hknhs7/NLPresentationDeck.key?dl=0)


## Execution

#### Timeline  

Google Doc - [Project Plan Timeline] (https://docs.google.com/spreadsheets/d/1NR0xm_aVJFg5N8yvTe-yZC4WhvOKhMwkkTMJs5-q5IE/edit?usp=sharing)


| Week | Date | Sprint | 
|----|----|---|
| Week 1 | Oct 27 - Nov 2 | Research, brainstorming and discussion: Submit project proposal (11/3). |
| Week 2 | Nov 3 - 9 | Research II, Development I: Submit revised proposal (11/10). Create wireframes. Begin experimenting with parts of the project and writing code to test technical implementation ideas: maps, venmo, contacts, calendar, time picker, UI, data storage, data structure and model. |
| Week 3 | Nov 10 - 16 | Development II: Build interface and code for the MVP. Experiment with design. Create logo, presentation deck. Push beta builds. |
| Week 3 | Nov 15, Sun | Development II: Weekly Retrospective |
| Week 3 | Nov 17, Tue | **First Release + Demo. Logo, presentation deck, beta build due.** |
| Week 4 | Nov 17 - 23 | Development III: Finalize the app design. Prepare the app for the second release. Prepare presentation scripts. |
| Week 4 | Nov 22, Sun | Development III: Weekly Retrospective |
| Week 5 | Nov 24, Tue | **Second Release + Demo. Scripts due.** |
| Week 5 | Nov 24 - 30 | Development IV: Enrich UI/UX. Finalize app. Prepare personal pithes and rehearse the demo. Testing I: Write tests and debug. Polish features for the third release. Implement bonuses.|
| Week 5 | Nov 29, Sun | Development IV: Weekly Retrospective |
| Week 5 | Nov 30, Mon | Development IV: Individual team demo review |
| Week 6 | Dec 1, Tue | **Third Release + Demo** |
| Week 6 | Dec 1 - 8 | Testing II: Final round of testing and debugging. Submit final version to App Store. Rehearse and polish demo. |
| Week 6 | Dec 3, Thu | Individual Pitches Review |
| Week 6 | Dec 5, Sat | Individual Demo Review |
| Week 6 | Dec 6, Sun | Testing II: Weekly Retrospective |
| Week 6 | Dec 8, 7pm | **Final Demo Day** |

### Team Member Responsibilities

**Ayuna:**

Manages the team to ensure work is on track with timeline. Venmo integration, Contacts. Back-end database. Data architecture. Product management.  


**Eric:**

UI/UX - Wireframes of screens, storyboard, maintaining consistent design feel through the app. Popover views. 

**Charles:**

Mapkit, Twilio, Logo, Push notifications.


