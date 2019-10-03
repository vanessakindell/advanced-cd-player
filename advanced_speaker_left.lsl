//Version 3

integer prechannelLeft = 55687;
integer playchannelLeft = 55689;
integer volumechannelLeft = 55679;
integer VOLUME=1;

integer listenHandel;
integer listenHandel2;
integer listenHandel3;

default
{
    state_entry()
    {
        listenHandel = llListen(prechannelLeft,"",NULL_KEY,"");
        listenHandel2 = llListen(playchannelLeft,"",NULL_KEY,"");
        listenHandel3 = llListen(volumechannelLeft,"",NULL_KEY,"");
    }
    state_exit()
    {
        llListenRemove(listenHandel);
        llListenRemove(listenHandel2);
        llListenRemove(listenHandel3);
    }
    listen(integer channel, string name, key id, string message)
    {
        if(channel == playchannelLeft)
        {
            llStopSound();
            llPlaySound(message,1);
        }
        else if(channel == prechannelLeft)
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
