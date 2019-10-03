//Version 3

integer prechannelMono = 45687;
integer playchannelMono = 45689;
integer volumechannelMono = 45679;
integer VOLUME=1;

integer listenHandel;
integer listenHandel2;
integer listenHandel3;

default
{
    state_entry()
    {
        listenHandel = llListen(prechannelMono,"",NULL_KEY,"");
        listenHandel2 = llListen(playchannelMono,"",NULL_KEY,"");
        listenHandel3 = llListen(volumechannelMono,"",NULL_KEY,"");
    }
    state_exit()
    {
        llListenRemove(listenHandel);
        llListenRemove(listenHandel2);
        llListenRemove(listenHandel3);
    }
    listen(integer channel, string name, key id, string message)
    {
        if(channel == playchannelMono)
        {
            llStopSound();
            llPlaySound(message,VOLUME);
        }
        else if(channel == prechannelMono)
        {
            llPreloadSound(message);
        }
        else
        {
            VOLUME=(integer)message;
            llAdjustSoundVolume(VOLUME);
        }
    }
}
