package;

import networking.Network;
import networking.utils.NetworkEvent;
import networking.utils.NetworkMode;

class Main {
    public static var amUsers:Int;
    public static var chatHistory:String;
    public static var thefullassmessage:String;

    public static function main(){
        var server = Network.registerSession(NetworkMode.SERVER, { 
            ip: '0.0.0.0',
            port: 9000,
            max_connections: 10
        });

        cpp.Lib.print("Server has started up!\n>");
        
        server.addEventListener(NetworkEvent.CONNECTED, function(event: NetworkEvent) {
            server.clients[Network.sessions.length - 1].send({ chathist: chatHistory });
            cpp.Lib.print("User has connected!\n");
          });
          
          server.addEventListener(NetworkEvent.DISCONNECTED, function(event: NetworkEvent) {
            cpp.Lib.print("User has disconnected!\n");
          });

          server.addEventListener(NetworkEvent.MESSAGE_RECEIVED, function(event: NetworkEvent) {
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
                    cpp.Lib.print("There are " + Network.sessions.length + " connected right now.\n>");
                  case "test":
                    cpp.Lib.print("The server is working properly.\n");
                  case "save":
                    sys.io.File.saveContent("ChatHistory.txt", chatHistory);
                    cpp.Lib.print("Saved the chat history to ChatHistory.txt!\n");
                  case "fetch":
                    chatHistory = sys.io.File.getContent("ChatHistory.txt");
                    cpp.Lib.print("Fetched the previous chat history!\n");
                  case "help":
                    cpp.Lib.print("list - list all online users\ntest - check if the server works properly\nsave - save the current chat history to a text file\nfetch - fetch the previous chat history\n");  
                  default:
                    cpp.Lib.print("Unknown command. Type help for list of available commands.\n>");	
              }
            });     
    }
}