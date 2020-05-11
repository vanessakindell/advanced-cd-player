integer prechannelRight = 35687;
integer playchannelRight = 35689;
integer volumechannelRight = 35679;
integer prechannelMono = 45687;
integer playchannelMono = 45689;
integer volumechannelMono = 45679;
integer VOLUME;

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
        listenHandel = llListen(prechannelRight,"",NULL_KEY,"");
        listenHandel2 = llListen(playchannelRight,"",NULL_KEY,"");
        listenHandel3 = llListen(volumechannelRight,"",NULL_KEY,"");
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
        if(channel == playchannelRight | channel == playchannelMono)
        {
            llStopSound();
            llPlaySound(message,VOLUME);
        }
        else if(channel == prechannelRight | channel == prechannelMono)
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

