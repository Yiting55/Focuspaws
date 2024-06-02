## Team Name:
FocusPaw

## Proposed Level of Achievement 
Artemis

## Motivation 
In this era, there are usually too many things that can easily distracts us from things we are supposed to do, which has caused a great decrease in working efficiency. Conforming to this phenomenon, FocusPaw is born. 

We hope people can be attracted to focus actively by combining focus with cute dogs and cats which they might be interested in, especially for pet lovers. This is also a way to expand our target audience. 

Except for the idea to help people to focus, another important idea is to educate users about how to raise a real pet and understand that they shall be responsible for their decision to raise a pet. We hope exposing suffering of some pets can be a warning to educate people to treat their pets well. 

## Vision
FocusPaw is 

## Storyline
# Setting
The story starts from the Rest Centre!
This is a shop connected with Cat Star and Dog Star and you are a staff here. 
Your job is to heal your customer, the soul of dogs and cats. 

Every year, there are many cats and dogs going back to their respective star(die). Their soul will remember all the pain and sorrow they have experienced during their lifetime, which may cause a great burden on their soul. 
The greater the burden, the worse degeneration its soul will suffer. 

But an immature soul will not be able to reincarnate and go back to earth.  
Your job is to heal it and release its burden so that its soul can grow up until it is mature enough to reincarnate. 
Choose one puppy or kitten to start your work!

# Ending
After the user has successfully raised up the pet he or she choose, there is a choice to be made. 

“My soul seems to be mature enough to reincarnate. But I am still wondering whether I am able to find a good master. What if this time the life is still so painful and sorrowful?” The pet says.

Choice 1: Let it stay. 
Result: “I shall stay here for more time to be better prepared.”

Choice 2: Let it go.
Result: “Thank you for your care. I am ready to go back and find my new master! Good luck to me!”

## User Stories
1. As a user, I want to use this app to help me to better focus at my work.
2. As a user, I want to raise a pet online and understand more about my pets and their suffering.
3. As a user, I enjoy the cute art work and game style which makes my focus not boring.
4. As a user, I want to accompany the pet as well as the pet to accompany me.
5. As a user, I enjoy the feeling of satisfaction when raising it up.

## Features 
Feature 1: User Account Authentication (Login and Password)
User account creation based on email. 
Secure storage of user information with unique passwords.

Feature 2: Time Tracker
Users can create and name the schedules for tasks and then start timing. 
Track total focus time on the front page: End when user switches to another app before the timer stops, which means this task fails. 

Calendar and Analysis Reports
Users can check their active days on focusing in calendar. 
Clicking on an active date, users can have an overview of their focus tasks in that day. 
This report would include total number of tasks, total focus durations, as well as successful tasks and failure tasks. Active durations in a day would be analyzed. 
Choosing a period in the calendar generates a report for that period. Report would be similar to a daily report. In addition, a line chart of focus times change over the period would be generated (or other visualization charts).  

Electronic Pet with Health and Growth Values
Users can only have 1 alive pet at a moment.
Users can choose between a dog and a cat as their virtual pet.   
Display a widget on the home screen showing the pet’s health value. 
Health value decreases by 2 health value per 1 hour, and increases by feeding sets of food
Set 1: 1 low level vege and meat each, 5 health points
Set 2: 1 medium level vege and meat each, 10 health points
Set 3: 1 high level vege and meat each, 20 health points + 1 growth point
Health value’s upper limit is 100, below 40 triggers a weak notification to the user, and reaching 0 results in the pet’s death.
At each day’s 0000AM, if the pet’s health point is above 80, the growth point will increase by 1.
There must be at least 6 hours between 2 feeds.
Growth value has a default value of 0 and a maximum value of 50.
Growth value increases based on the pet’s health value: above 80 for 1 day adds 1 growth value (health value would be checked everyday at 00:00 am). 
Pet has default level of level 1, (0-50 growth point = level 1; 50-100 growth value = level 2; 100-150 growth value = level 3) 
The pet’s outlook would be changed when it levels up.
Users have the ability to obtain a new pet after reaching level 3 and the current pet would be placed in the achievement book as a record.  

Reward System
Completion of scheduled tasks (at least 0.5 hour) rewards vege/meat (different levels with different time)
30 min level 1 vege/meat
1h level 2 vege/meat
2h level 3 vege/meat
Feeding the pet using different sets of food will cause different increase in health points
Users would not lose their accumulated rewards when switching between cats and dogs as their new pet. 

Pet Shop
Users choose their initial pet when logging into FocusPaws with default health value at 80.
Pet shop is accessible when a pet is successfully raised or dies, allowing users to select a new pet.
Two categories are available: cat and dog.
 
Achievement Book 
Records successfully raised (level 3 alive) pets.
Displays pet’s outlook. 
Clicking on the pet’s outlook redirects to the growth timeline of the pet, showing milestones. 
 
Sleep Time 
Let the pet sleep when users go to bed, fixing the pet's health when sleeping. 
Maximum sleep time is 8 hours.
Minimum awake time before sleeping again is 12 hours.

Foster Your Pet
Users can send their pet to a foster family when not doing work for a period of time due to travel or holidays hence not using FocusPaws. 
Pet's health is fixed at 80 if the health value is above 80, otherwise it remains at its original value.
Maximum foster duration is 10 days. 

Bag
All food obtained as rewards from focus tasks would be stored in the bag. Its name and quantity would be displayed. 
All food are ordered according to their levels. 
Vege and meat has an expiry date of 2 days (48 hours from the time of obtaining it).
The most recent expiry date of a vege/meat would be displayed in the bag. If it is not used until expiry date, it would be automatically removed from the bag. 


[Current Process]
Our current process for FocusPaw only has a main stucture with login function as well as the time tracker functions. 





