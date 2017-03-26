Name: Shrikar Chonkar

ID:   46857243

## Proposed Project

#### Ticket collector

The basic idea is to create a load balancing ticket manager or issues manager.
This is better illustrated as an example:

Consider the SMU's IT Help. They get new tech help requests every few minutes.
My system will take these requests and send them to the help rep who is currently working AND
has a minimum ticket load.

One the rep has solved the case, they can 'close' the ticket and that ticket is deleted.

-----

###### Ambitious Goal

Is to add a module, that will pick the keywords from the tech help request and send it to appropriate rep. For example,
Requests that have word 'projector' get automatically send to AV team, keyword 'spam' gets sent to security team etc.

## Outline Structure

Each person gets their own process and a supervisor looking over them. A top level supervisor will look over this supervisor and an issue pool, which receives all the issues
before they are sent to appropriate reps. I believe, supervisor or a process will have to get the count of
issues with each worker over regular intervals to make the load balancing happen.

All of this could be made possible by following structure similar to the famous Hangman game.

Each person should be able to see a dashboard of the assigned tickets when they log in - accomplished by Phoenix, OAuth and markup.
