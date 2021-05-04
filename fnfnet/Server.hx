package;
import cpp.Lib;
import udprotean.server.UDProteanServer;
import udprotean.server.UDProteanClientBehavior;

class Server {
	public static function main() {
		var server = new UDProteanServer("0.0.0.0", 9000, EchoClientBehavior);

		server.start();
		Lib.print("Server has started up!\n");
		while (true)
		{
    // Synchronously read and process incoming datagrams.
    	server.update();
		}

		server.stop();
	}
}

