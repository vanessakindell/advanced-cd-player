/* Advanced Screen for Advanced CD Player for OpenSim
Copyright © 2018-2020 Vanessa Kindell

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see www.gnu.org/licenses/ */

integer prechannelMono = 45687;
integer playchannelMono = 45689;
integer volumechannelMono = 45679;
integer artchannel = 45699;
integer VOLUME;

integer listenHandel;
integer listenHandel2;
integer listenHandel3;
integer listenHandel4;

default
{
    state_entry()
    {
        listenHandel = llListen(prechannelMono,"",NULL_KEY,"");
        listenHandel2 = llListen(playchannelMono,"",NULL_KEY,"");
        listenHandel3 = llListen(artchannel,"",NULL_KEY,"");
        listenHandel4 = llListen(volumechannelMono,"",NULL_KEY,"");
    }
    state_exit()
    {
        llListenRemove(listenHandel);
        llListenRemove(listenHandel2);
        llListenRemove(listenHandel3);
        llListenRemove(listenHandel4);
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
        else if(channel == volumechannelMono)
        {
            VOLUME=(integer)message;
            llAdjustSoundVolume(VOLUME);
        }
        else
        {
            llSetLinkPrimitiveParamsFast(2,[PRIM_TEXTURE,ALL_SIDES,message,<1,1,0>,<0,0,0>,0]);
        }
    }
}

