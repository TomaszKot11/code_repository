# Task description
## Introduction
This task was created based on experience from one of our projects that we created a few years ago.
We want to get to know your way of thinking and in general your approach to that kind of task.
To accomplish that he would like to ask you to add 3 features described below.

## Requirements
To solve the task:
* Clone the repo,
* Solve add features listed below,
* Publish the repo with changes and send it back to us.

The features should be covered by tests

The app should be designed to handle high traffic

## Background information:
We have a new project, the client is from the UK and wants to build a ticket-selling platform. The use cases concern mostly cultural events, like music concerts and festivals.
* Name: Ticketworld
* Country: UK
* Currency: British Pounds
* Business: Startup with investors
* Scope of work: API is on our side, frontend integration will be delivered by client on their own.

# Features ToDo:

## 1. Display events list
The user should be able to see list of the events

We need to return available events via API that will be used by FE team to display list of events.

## 2. Reserve and buy ticket.
Users should be able to buy tickets - possibly more than one.

The application should be prepared for many users at the same time so after users select desired tickets we need to make sure that they will be available for the purchase.

After consultation with the client, we decided that tickets should be reserved for 15 mins to allow the purchase process. The payments will be handled by a separate company. For now, we should use mocked payment adapter which will be connected to their API later.

Requirements fot this task:
* Reserve ticket.
* Purchase reserved ticket.
* Release reserved tickets after 15 minutes if not purchased.

The adapter is available here
``` app/adapters/payment/gateway.rb.```

## 3. Display list of tickets.
The user should be able to see list of the tickets for the event with the ticket status.

We need to return tickets for event via API.
