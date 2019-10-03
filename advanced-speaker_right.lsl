integer prechannelRight = 35687;
integer playchannelRight = 35689;
integer volumechannelRight = 35679;
integer VOLUME=1;

integer listenHandel;
integer listenHandel2;
integer listenHandel3;

default
{
    state_entry()
    {
        listenHandel = llListen(prechannelRight,"",NULL_KEY,"");
        listenHandel2 = llListen(playchannelRight,"",NULL_KEY,"");
        listenHandel3 = llListen(volumechannelRight,"",NULL_KEY,"");
    }
    state_exit()
    {
        llListenRemove(listenHandel);
        llListenRemove(listenHandel2);
        llListenRemove(listenHandel3);
    }
    listen(integer channel, string name, key id, string message)
    {
        if(channel == playchannelRight)
        {
            llStopSound();
            llPlaySound(message,VOLUME);
        }
        else if(channel == prechannelRight)
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
