import discord_rpc.DiscordRpc;

class Test
{       
    public static function rpc()
    {

        DiscordRpc.start({
            clientID : "816716716301877269",
            onReady  : onReady,
            onError  : onError,
            onDisconnected : onDisconnected
        });
            while(true) {
                Sys.sleep(1);
                DiscordRpc.process();
            }
        DiscordRpc.shutdown();
        
    }

    public static function onReady()
    {
        DiscordRpc.presence({
            details : 'Gettin freaky on a friday night!',
            state   : 'Playing',
            largeImageKey  : 'funkin',
            largeImageText : 'Friday Night Funkin'
        });
    }

    public static function onError(_code : Int, _message : String)
    {
        trace('Error! $_code : $_message');
    }

    public static function onDisconnected(_code : Int, _message : String)
    {
        trace('Disconnected! $_code : $_message');
    }
}
