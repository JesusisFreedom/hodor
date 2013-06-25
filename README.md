# Hodor

Hodor is a Simple Invoice Generator for [Toggl](https://toggl.com).
It is built on top of [Linemanjs](https://github.com/testdouble/lineman).

## Requirements
You need nodejs, gruntjs and lineman installed.
Nodejs should be installed first. The easiest way is to use the Node Version Manager [nvm](https://github.com/creationix/nvm).
Once node is installed you should install [gruntjs](http://gruntjs.com/):
```
npm install grunt-cli -g
```
Follow the instructions at [Linemanjs](https://github.com/testdouble/lineman) to install Linemanjs.

## Running the application.
Once inside the application folder, you can run the app with:
```
lineman run
```
You can then access the application by going to __http://localhost:8000__ .


## Basic Functionality
The core responsibility of the __Hodor__ is to add all the hours worked during a
specified period of time and to calculate the billable amount. The user has to provide __Toggl's__ API Key,
a start date, an end date, the user's name and the hourly rate.


## ToDo
1. Validate API Key is present.
2. Validate name is present.
3. Validate hourly rate is present.
4. Validate start date is present.
5. Validate end date is present.
6. Validate end date is not less than start date.
7. Configure push state.
8. Add authentication support.
9. Persist invoices for easier retrieval.
10. Allow user to configure API Key so they don't have to be providing it all the time.

