const colyseus = require('colyseus');
const schema = require('@colyseus/schema');
const http = require("http");
const express = require("express");
const port = process.env.port || 9000;

const app = express();

var amUsers = -1;
var theY = 0;
var users = [];
var uuids = [];
var hasAdmin = [];
var chatHistory;
var thefullassmessage;

app.use(express.json());

const gameServer = new colyseus.Server({
  server: http.createServer(app)
});
before(async () => new Promise((resolve) => {
    gameServer.listen(port);

    console.log("Server has started up!\n>");

    gameServer
    .define("chat", ChatRoom)
    .on("create", (room) => {
        this.onMessage("action", (client, message) => {
            
        });
    })
    .on("dispose", (room) => {
        
    })
    .on("join", (room, client) => {
        amUsers++

    })
    .on("leave", (room, client) => {
        
    }).enableRealtimeListing();
}));

/*
server.addEventListener(NetworkEvent.CONNECTED, function() {
    test++;
    uuids.push(server.clients[test].uuid);
    hasAdmin.push(false);
    server.clients[test].send({ chathist: chatHistory, axY: theY, motd: motd, rules: rules, uslist: users}); // - 1
    server.send({message: "Server: User has joined the chat!", uslist: users});
    chatHistory += "Server: User has joined the chat!" + "\n";
    console.log("User has connected!\n");
    theY -= 20;
  });
  
  server.addEventListener(NetworkEvent.DISCONNECTED, function() {
    users.splice(uuids.indexOf(event.client.uuid), 1);
    hasAdmin.splice(uuids.indexOf(event.client.uuid), 1);
    uuids.remove(event.client.uuid);
    test--;
    cpp.Lib.print("User has disconnected!\n");
    server.send({message: "Server: User has disconnected from the chat."});
    chatHistory += "Server: User has disconnected from the chat." + "\n";
    theY -= 20;
    server.send({uslist: users});
  });

  server.addEventListener(NetworkEvent.MESSAGE_RECEIVED, function() {
    if(event.data.message != null) theY -= 20;
    if(event.data.nen != null) users.push(event.data.nen);
    if(event.data.message != null){
      thefullassmessage = "<" + event.data.name + "> " + event.data.message;
      console.log(thefullassmessage + "\n");
      chatHistory += thefullassmessage + "\n";
      server.send({message: thefullassmessage});
    }
  });
*/