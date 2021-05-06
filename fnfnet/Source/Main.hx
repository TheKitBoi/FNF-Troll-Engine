package;

import networking.Network;
import networking.utils.NetworkEvent;
import networking.utils.NetworkMode;

/////////////////////////////////////////
//
//      FNFNet
//        Created by bit of trolling
//      Legend:
//      test - amount of users
//      theY - y position of chatText
//      
//
/////////////////////////////////////////

class Main {
    public static var amUsers:Int;
    public static var theY:Float;

    public static var chatHistory:String;
    public static var thefullassmessage:String;

    public static function main(){
      #if linux
      var output = new sys.io.Process("whoami", []).stdout.readAll().toString();
      if (output=="root" && Sys.args()[0] != "--root") {
        cpp.Lib.print("Warning: You are running the server as root, which is strongly discouraged!\nOnly run this server as root if you know what you are doing!\nIf you want to run this as root anyway, pass the --root parameter.\n");
      }
      #end
        var server = Network.registerSession(NetworkMode.SERVER, { 
            ip: '0.0.0.0',
            port: 9000,
            max_connections: 10
        });
        theY += 0.1;
        cpp.Lib.print("Server has started up!\n>");
        var test:Int = -1;

        server.addEventListener(NetworkEvent.CONNECTED, function(event: NetworkEvent) {
            test++;
            server.clients[test].send({ chathist: chatHistory, axY: theY }); // - 1
            cpp.Lib.print("User has connected!\n");
          });
          
          server.addEventListener(NetworkEvent.DISCONNECTED, function(event: NetworkEvent) {
            test--;
            cpp.Lib.print("User has disconnected!\n");
          });

          server.addEventListener(NetworkEvent.MESSAGE_RECEIVED, function(event: NetworkEvent) {
            if(event.data.message != null) theY -= 20;
            thefullassmessage = "<" + event.data.name + "> " + event.data.message;
            cpp.Lib.print(thefullassmessage + "\n");
            chatHistory += thefullassmessage + "\n";
            server.send({message: thefullassmessage});
          });
          server.start();
            // ... and run it!
            sys.thread.Thread.create(() -> {
              while(true)
                switch(Sys.stdin().readLine()){
                  case "stop":
                    cpp.Lib.print("Server is shutting down!\n");
                    server.stop();
                    Sys.exit(0);
                  case "list":
                    cpp.Lib.print("There are " + test + " connected right now.\n>");
                  case "test":
                    cpp.Lib.print("The server is working properly.\n");
                    cpp.Lib.print(theY + "\n");
                  case "save":
                    sys.io.File.saveContent("ChatHistory.txt", chatHistory);
                    cpp.Lib.print("Saved the chat history to ChatHistory.txt!\n");
                  case "fetch":
                    chatHistory = sys.io.File.getContent("ChatHistory.txt");
                    cpp.Lib.print("Fetched the previous chat history!\n");
                  case "clear":
                    chatHistory = "";
                    theY = 0;
                    cpp.Lib.print("Cleared the chat history!\n");   
                  case "help":
                    cpp.Lib.print("list - list all online users\ntest - check if the server works properly\nsave - save the current chat history to a text file\nfetch - fetch the previous chat history\nclear - clears the chat history\n");  
                  default:
                    cpp.Lib.print("Unknown command. Type help for list of available commands.\n>");	
              }
            });     
    }
}