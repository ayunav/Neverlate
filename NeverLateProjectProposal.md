# ACFinalProjectProposal


# Access Code 2.2 Final Project Proposal

**Project Name: NeverLate**  
**Team Name: NeverLate**  
**Team Members: Charles Kang, Eric Sze, Ayuna Vogel**  

## The Problem 

NeverLate is an iOS app for people who are often late and want to get into habit of getting to places on time.   
Existing products in the goal setting/habit building category that we currently use do not satisfy our needs as potential users: the apps are overly complicated, and do not engage and bring a user back into the app beyond sending reminders.      

NeverLate solves the issues above by gamifying a user's experience, bringing in social aspect (do it with your friend aka accountability buddy) and monetary incentive aspect (a user will bet an amount of money (for example, $10) that will be sent to her accountability buddy in case she is late to a class/work/another place she has to be at on a regular schedule). In surveying the App Store, we could find no such combination. Popular existing resources include:

* [Stickk] (https://scratch.mit.edu/) - open-source graphical programming language (free, web + desktop only).
* [Tynker.com] (https://www.tynker.com/) - Scratch-based online programming courses for kids ($50 single course - $250 learning pathway).  

We envision our primary users to be kids as young as 5 and as old as teens (realizing that we'll need a UI/UX that can appeal to this full age range). Our app would be engaging to a child while also being able to interest adults in helper roles (parents, teachers). Users would range from a child learning independently, parent(s) with a child, or a teacher with a classroom full of students.

## The Solution 

The project consists of two parts: hardware (the robot) and software (an Android-based environment to control robot movement with a graphical programming language, introducing the principles of programming to kids as they play).

 * Low-cost DIY robot (less than $40) that functions well and looks good. Built from open-source, easily acquired components with a simple, proven design.
 * Basic enough for a kid to put together in a weekend. The app will include an assembly walkthrough.
 * Both graphical + text-based programming interfaces to control the robot with an Android device. 
 * Designed for learning and growth. No upper limit for 'hackability'.

By building on Android, our project becomes accessible to the more than 1 billion Android users worldwide -- especially in markets where cost places existing robotics experimentation kits out of reach. Our experience at Access Code (and subsequent alignment with C4Q's mission and values) strongly informs our belief that lowering the financial barrier to hardware experimentation by 60% has significant, impactful value for the following groups:
- A child saving to purchase his/her own components
- Parent(s) with multiple children
- Teacher/school purchasing for students (electronics sold in bulk would actually reduce the cost per "kit" in this use case)
- Low-income families, whether they be American or in developing nations

Building the project around a physical object (the robot) captures the excitement and possibility of programming and blends "screen time" into a creative, hands-on activity with limitless possiblity.

Ultimately, we want to inspire the learning skills and confidence for kids to engage with the project -- and with all technology in their lives -- not just as users but as collaborators and creators.

#### Baseline features

The robot:
 * Built around a widely available open-source microcontroller ([Arduino](https://www.arduino.cc/)).
 * Forward, backward and rotational movement (2x [continuous rotation servos](https://learn.adafruit.com/adafruit-motor-selection-guide/continuous-rotation-servos)).
 * Chassis constructed from low-cost and/or recycled materials (e.g. cardboard - [example design we will use as our starting point](http://www.foxytronics.com/learn/robots/how-to-make-your-first-arduino-robot/parts)).
 * Battery powered and controlled via Bluetooth with an Android device ([existing library for Android <--> Arduino via Bluetooth](https://github.com/aron-bordin/Android-with-Arduino-Bluetooth)).
 * Simple and flexible design encourages user modifications: paint it, decorate it, add hardware mods.
 
The app:
 * Android-based programming environment.
 * Simple, graphical programming language/interface (think [Scratch](https://scratch.mit.edu/)) with native methods for controlling the robot.
  * [Google Blockly](https://developers.google.com/blockly/?hl=en) provides a 100% client-side, customizable library with tons of functionality built-in.
  * Wrapping series of long, potentially complex Arduino commands in one GUI element for the user.
  * 10 basic commands (move forward/backward/left/right, rotate n degrees, blink x color y times, etc.) to start, with flexibility to modify and expand the language/interface by creating new methods (see [Custom Blocks with Blockly](https://developers.google.com/blockly/custom-blocks/overview)).
 * Option for advanced users to move to a text-based environment.
 * Elegant, enjoyable + easy to use UI/UX.
 * On first launch, the user is presented with a guide on sourcing and building the robot. Features illustration, text and/or video instructions.

**[Project Resources](https://github.com/jaellysbales/access-robot/blob/master/resources.md)**

#### Bonus features

 * Simple web platform for sharing robot patterns + programs (Google Blockly enables this via [cloud storage](https://developers.google.com/blockly/installation/cloud-storage)).
 * Robot add-ons: lights, sensors, internet connectivity.
 * Translation to other spoken languages (e.g. Spanish).

### Wireframe
Please review wireframes [here](https://github.com/jaellysbales/access-robot/blob/master/wireframes/wireframes.md).

## Execution

#### Timeline

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

**Jae:**

UI/UX - Wireframes of screens, storyboards of new user experience, sitemap to show activities that users have access to from each activity, maintaining consistent design feel through the app, working with programming language to decide how the interface is setup.

**Allison:**

Creating a programming language to control the robot's movements - creating Scratch-like programming language that is an engaging but easy to understand, drag-and-drop interface on Android. Ensuring language is inline with robot's capabilities.

**Kadeem:**

Communication between Android and Arduino/robot - communication between Arduino and Android device through serial port, ensuring our programming language commands are properly transferred between hardware, possibly use a translator.

**Ramona:**

Manages the team to ensure work is on track with timeline, rotates between jobs to help where needed, design of robot, will help with the communication between Arduino and Android, will help with programming language, parts are already ordered and should be here between Monday and Tuesday ([project hardware inventory](https://github.com/jaellysbales/access-robot/blob/master/hardware-list.md)).
