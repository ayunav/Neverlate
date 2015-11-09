# ACFinalProjectProposal


# Access Code 2.2 Final Project Proposal

**Project Name: NeverLate**  
**Team Name: NeverLate**  
**Team Members: Charles Kang, Eric Sze, Ayuna Vogel**  

## The Problem   

Not getting to your destination on time; need monetary consequences to be consistently on-time to where you need to be.  

NeverLate is an iOS app for people who are often late and want to get into habit of getting to places on time.
Existing products in the goal setting/habit building category that we currently use do not satisfy our needs as potential users: the apps are overly complicated, and do not engage and bring a user back into the app beyond sending reminders.        

NeverLate solves the above issues by gamifying a user's experience, bringing in social aspect (do it with your friend aka accountability buddy) and monetary incentive aspect (a user will bet an amount of money (for example, $10) that will be sent to her accountability buddy in case she is late to a class/work/another place she has to be on time on a regular schedule). In surveying the App Store, we could find no such combination. Popular existing resources include:

* [Stickk] (http://www.stickk.com/) - a user signs a commitment contract with the Stickk web app. If a user fails her commitment, her money at stake will go to a charity of her choice or anti-charity, an organization a user does not want to receive her money. Stickk assigns another person as a referee who checkins for the user if the user achieved/failed her commitment. 
* [21Habit] (http://thenextweb.com/lifehacks/2012/12/29/20-apps-to-help-you-keep-your-new-year-resolutions/2/) - 21habit lets you break or make a habit and keep track of it for 21 days. When you sign up, you get a choice of a free mode or committed mode. The free mode has no monetary obligations while the committed mode requires that you invest $21 in your habit. For each day that you succeed, you’ll get $1 back and each time you fail, the $1 goes to charity.
* [Beeminder] (https://itunes.apple.com/us/app/beeminder/id551869729?mt=8) - Your goals can be anything quantifiable — weight, pushups, minutes spent on Facebook, points on Duolingo. Answer with your number when Beeminder asks — or connect a device/app below to auto-report — and we'll show your progress and a Yellow Brick Road to follow to stay on track. If you go off track, you pledge money to stay on the road the next time. If you go off track again, we charge you.
* [Aherk] (http://thenextweb.com/lifehacks/2012/12/29/20-apps-to-help-you-keep-your-new-year-resolutions/4/) - self-blackmail service that lets you define a goal, set a deadline and let your Facebook friends decide if you’ve achieved the goal. If not, it uploads a compromising photo of you on Facebook for all your friends to see. You may argue that you can just submit a non-compromising photo of you to the app, rendering the consequence negligible, but at least it incorporates a bit of social pressure into your goal by asking your friends to vet your success.


We envision our primary users to be adults of all ages, primarily classmates or office colleagues. In other words, groups of people who have to be at the same place at the same time on a regular basis (class, office, work, gym, etc.) and see each other at that location in person.

## The Solution 

Enable our users to be make monetary contracts with themselves and another person, with the non-contracted person being the accountability buddy.

We aim to solve two main problems. 

###
\#1 There are many people that are late to important events, such as work, class, or... gym.

\#2 Although there are some accountability apps on the market, non-monetary incentive is not strong enough motive for someone to be on-time when they have a habit of being late.

#### Baseline features

* A user will be able to save the time, days, location they have to be at on time on a regular basis. 
* A user will be able to select their accountability buddy from the list of their phone contacts and connect the app to their venmo account. 
* If a user is late to the place they have to be at by a certain time, the app will send a venmo payment to their accountability buddy of the amount the user set up. 
* Sleek, enjoyable + easy to use UI/UX.
* On first launch, the user is presented with illustration and text instructions on using the app and app's concept.

**Venmo Integration**
* Set up payments between two users, withdrawal or deposit depending on what happens to the contractee. If a user is late to the place they have to be at by a certain time, the app will send a venmo payment to their accountability buddy of the amount the user set up.  

**Apple Maps Integration and Building Geofences**
* Use mapkit to pinpoint current location, search a location or drop a pin to save a user's location "to be on time". The app will build a geofence around the saved locaiton. The app will start tracking user's location, and if a user is not at a place they have to be at by a certain time, the app will send a venmo payment from their account to their accountability buddy. 

#### Bonus features

*Automatic social media updates about lateness/on time status of a user (aka "public shaming").  
*Twilio to be able to send text messages whenever a contract is complete, or when money is taken out of your Venmo account.  


### Wireframe
Please review wireframes [here](place the link to wireframes).

## Execution

#### Timeline

|Week|Day|Activity|Deliverables|
|---|---|---|---|
|1|Tuesday 10/27|[Project Intro](https://docs.google.com/presentation/d/1eiKlYdSkdFxaOHpVqbyYTcl5AyKr9DO7zRITqwCcaB4/edit?usp=sharing)|Come to class with app ideas|
|1|Thursday 10/29|Hackathon Groups + Planning|---|
|1|Saturday 10/31|Hackathon|---|
|1|Sunday 11/1|Hackathon|---|
|2|Tuesday 11/3|Project Proposal Working Session|[Final project proposals](/project_proposals.md) due at 10:00 pm|
|2|Thursday 11/5|Project proposal reviews + Lessons Learned from 2.1 Final Projects|---|
|2|Saturday 11/7|All day UI/Design Workshop|---|
|2|Sunday 11/8|Wireframing|Wireframing due at 6:00 pm <br> [Weekly Retrospective](/weekly_retrospective.md)|
|3|Tuesday 11/10|How to Demo Workshop|---|
|3|Thursday 11/12|---|---|
|3|Saturday 11/14|---|---|
|3|Sunday 11/15|---|[Weekly Retrospective](/weekly_retrospective.md)|
|4|Tuesday 11/17|FIRST RELEASE + [DEMO](/presentation_guidelines.md)<br>Guest: Wesly Ross from Fueled|Push Beta Builds, Logos Due, Presentation Deck Due|
|4|Thursday 11/19|---|---|
|4|Saturday 11/21|---|---|
|4|Sunday 11/22|---|[Weekly Retrospective](/weekly_retrospective.md)|
|5|Tuesday 11/24|SECOND RELEASE + DEMO|Presentation Scripts due|
|5|Thursday 11/26|Thanksgiving Break-No Class|---|
|5|Saturday 11/28|Thanksgiving Break-No Class|---|
|5|Sunday 11/29|Thanksgiving Break-No Class|[Weekly Retrospective](/weekly_retrospective.md)|
|5|Monday 11/30| Individual team demo reviews|---|
|6|Tuesday 12/1|THIRD RELEASE + DEMO|Personal Pitches due|
|6|Thursday 12/3|Individual meetings to review personal pitches|---|
|6|Saturday 12/5|Individual meetings to review demos|---|
|6|Sunday 12/6|---|[Weekly Retrospective](/weekly_retrospective.md)|
|x|Tuesday 12/8|DEMO DAY|Submit final version to App Store|


| Week | Date | Sprint | 
|----|----|---|
| Week 1 | Aug 7 - 9 | Research: Submit project proposal (8/9). Create wireframes. Research robot design and consolidate resources. Order hardware components for experimentation. |
| Week 2 | Aug 9 - 11 | Research II: Submit revised proposal (8/11). Begin experimenting with hardware and writing code to interface Android with hardware. Research programming environments for children. |
| Week 2 | Aug 11 - 16 | Development I: Build Android-Hardware interface. Experiment with programming environment. Prototype graphical language. Experiment with robot design.|
| Week 3 | Aug 17 - 23 | Development II: Build out programming environment. Wrap code to interface with the robot in graphical language commands. Finalize robot design. |
| Week 4 | Aug 24 - 31 | Development III: Enrich UI/UX. Build robot assembly walkthrough activity. Finalize app. |
| Week 5 | Sep 1, 7pm | First Release + Demo |
| Week 5 | Sep 2 - 8 | Testing I: Write tests and debug. Polish features for the second release. Implement bonuses. |
| Week 6 | Sep 9, 7pm | Second Release + Demo |
| Week 6 | Sep 10 - 14 | Testing II: Final round of testing and debugging. |
| Week 7 | Sep 15, 7pm | Final Demo Day |

#### Team Member Responsibilities

**Charles:**

Mapkit, Twilio, Logo.

**Eric:**

UI/UX - Wireframes of screens, storyboard, maintaining consistent design feel through the app.

**Ayuna:**

Manages the team to ensure work is on track with timeline. Venmo integration, Contacts.

