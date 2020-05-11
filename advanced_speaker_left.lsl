integer prechannelLeft = 55687;
integer playchannelLeft = 55689;
integer volumechannelLeft = 55679;
integer prechannelMono = 45687;
integer playchannelMono = 45689;
integer volumechannelMono = 45679;
integer VOLUME=1;

integer listenHandel;
integer listenHandel2;
integer listenHandel3;
integer listenHandel4;
integer listenHandel5;
integer listenHandel6;

default
{
    state_entry()
    {
        VOLUME=1;
        listenHandel = llListen(prechannelLeft,"",NULL_KEY,"");
        listenHandel2 = llListen(playchannelLeft,"",NULL_KEY,"");
        listenHandel3 = llListen(volumechannelLeft,"",NULL_KEY,"");
        listenHandel4 = llListen(prechannelMono,"",NULL_KEY,"");
        listenHandel5 = llListen(playchannelMono,"",NULL_KEY,"");
        listenHandel6 = llListen(volumechannelMono,"",NULL_KEY,"");
    }
    state_exit()
    {
        llListenRemove(listenHandel);
        llListenRemove(listenHandel2);
        llListenRemove(listenHandel3);
        llListenRemove(listenHandel4);
        llListenRemove(listenHandel5);
        llListenRemove(listenHandel6);
    }
    listen(integer channel, string name, key id, string message)
    {
        if(channel == playchannelLeft | channel == playchannelMono)
        {
            llStopSound();
            llPlaySound(message,VOLUME);
        }
        else if(channel == prechannelLeft | channel == prechannelMono)
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
