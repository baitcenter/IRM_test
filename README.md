# IRM_test
*14/08/2019: Firebase auth disabled and server shut down*

calendar app being developed for job application @ ireachm.com

1. **Objective**

"Build a way for us to create appointments in a calendar, you may choose mobile or web as a platform.
We have no particular preference in the programming language that you use, but keep in mind that we use a particular technology stack at iReachm."

Deadline was August 9 before end of business hours

2. **Stack**

- Mobile app: Flutter

- Backend: Nodejs Express Server

- Database: MongoDB

- Authentication: Firebase

- Hosting: DigitalOcean

Development tools: ngrok, Postman, Robo3T 


Given the stack at iReachM, Flutter was the obvious choice for the mobile app. 

For the backend, the company uses Meteor, which I have never worked with, and couldn't learn on the go given the time frame of the assignment. I chose to use Express, so we stay in the JS/NodeJs family, with a MongoDB Database, which is the type of DB used by Meteor.

3. **App features**
- Calendar displaying list of events for each day
- Login with phone number
- Create events through the app that are also written in your phone
- Invite other users to your event. The event is created in their phone as well
- Guests: accept or decline to attend to events
- Event owner: delete event

4. **Known bugs** 

- logging out of Firebase then logging back in without closing the app will cause it to crash
- events created are shown on the event list, but no bullet is created on the calendar unless the app is closed and relaunched.
- Past events can't be deleted from phone through the app
- event won't be deleted in calendar if phone calendar is open while dleting the event in the app
- Wrong date format from user can cause bugs.
- Synchonization with DB will bring user back to calendar page
- Wrong label for calendar display: label says "2 weeks" when month is displayed and vice-versa

5. **Process**

Given the timeframe and the context, I wanted to chose a stack that matched the company as much as possible, while trying to use technologies I had at least some previous contact with.
My first priority was to deliver something within the deadline. I tried to limit the "learning on the spot" so I used a library ([Table Calendar](https://pub.dev/packages/table_calendar)) to implement the in-app calendar and another ([Device Calendar](https://pub.dev/packages/device_calendar)) to read/write events in the phone calendars. Libraries are always a bit of a gamble - combining 2 you have not used before even moreso - but it seemed a safer bet than learning to communicate with calendars on both iOS and Android while designing and coding the whole app.

I identified the minimum requirements of the tool: create events and sync between phones, invite guests with possibility to rsvp, delete events, which gave me the skeleton of the app. Other nice to have features would come if time allowed it, but I took some into account early on, e.g. reprogram a cancelled event, in order to design the app architecture accordingly.

6. **Result**

The apk file was sent on August 9 at 16:21. Since I'm not yet part of the Apple Developer program, I couldn't build an iOS executable, so I'll have to showcase the iOS version on the simulator when I go the company.

The Express server has been deployed on DigitalOcean.




