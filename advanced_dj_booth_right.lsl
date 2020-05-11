/* Advanced DJ Booth for OpenSim
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

yoption advflowctl;

integer version = 5;
integer tracks;
integer track = 0;
key notecardQueryId;
integer notecardLine;
integer soundcount;
integer listener;
integer pages = 0;
integer numperpage = 10;
string albumName;
key albumArtKey;
integer lastSegmentLength;
integer currentSegment;
string currentAlbum;
list trackNames;
list trackLSmL;
list trackLengths;
list trackStarts;
list trackArtists;
list segments;
integer currentTrack;
integer sectionCounter;
integer mode=0;
integer STARTED;
integer PLAYING;
integer LOADING;
integer artChannel = 45699;
integer prechannelRight = 35687;
integer playchannelRight = 35689;
integer volumechannelRight = 35679;
integer prechannelLeft = 55687;
integer playchannelLeft = 55689;
integer volumechannelLeft = 55679;
integer prechannelMono = 45687;
integer playchannelMono = 45689;
integer volumechannelMono = 45679;
integer PLAYLOOP;
integer VERSIONMODE;
integer VOLUME=0;

purgeInventory()
{
    while(llGetInventoryNumber(INVENTORY_NOTECARD)>0)
    {
        llRemoveInventory(llGetInventoryName(INVENTORY_NOTECARD,0));
    }
}

startSpin()
{
    llSetLinkPrimitiveParamsFast(20,[PRIM_OMEGA,<0,0,-1>,10,0.01]);
}

stopSpin()
{
    llSetLinkPrimitiveParamsFast(20,[PRIM_OMEGA,<0,0,0>,0,0]);
}

stopPlayback()
{
    stopSpin();
    llPlaySound((key)"0d0f06a3-daf3-d572-b19e-7622a114e40c",0);
    llRegionSay(playchannelRight,(key)"0d0f06a3-daf3-d572-b19e-7622a114e40c");
    STARTED=FALSE;
    PLAYING=FALSE;
    llStopSound();
}

toggleVolume()
{
    if(VOLUME==1)
    {
        VOLUME=0;
        llSetLinkPrimitiveParamsFast(36,[PRIM_COLOR,ALL_SIDES,<1,0,0>,1]);
    }
    else
    {                        startSpin();
        if(currentAlbum!=""&&PLAYING==TRUE)
        {
            llRegionSay(artChannel,albumArtKey);
        }
        VOLUME=1;
        llSetLinkPrimitiveParamsFast(36,[PRIM_COLOR,ALL_SIDES,<0,1,0>,1]);
    }
    llRegionSay(volumechannelRight,(string)VOLUME);
}

importNotecard(string notecard)
{
    tracks=0;
    track=1;
    trackNames=[];
    trackLSmL=[];
    segments=[];
    trackLengths=[];
    trackArtists=[];
    mode=0;
    trackStarts=[0];
    currentTrack=0;
    integer sectionCounter;
    integer notecardLine;
    integer notecardLength = osGetNumberOfNotecardLines(notecard);
    string data;
    for(;notecardLine<notecardLength;++notecardLine)
    {
        data = osGetNotecardLine(notecard,notecardLine);
        if(data=="[META]")
        {
            mode=1;
            sectionCounter=0;
        }
        else if(data=="[SONG]")
        {
            if(mode==2&&sectionCounter>4)
            {
                trackStarts=trackStarts+(llGetListLength(segments));
                trackLengths=trackLengths+(string)(sectionCounter-3);
            }
            mode=2;
            ++tracks;
            if(tracks==1)
            {
                llSetText("Loading: 1 Track\n "+currentAlbum+"\n\n\n\n",llGetColor(ALL_SIDES),1);
            }
            else
            {
                llSetText("Loading: "+(string)tracks+" Tracks\n "+currentAlbum+"\n\n\n\n",llGetColor(ALL_SIDES),1);
            }
            sectionCounter=0;
        }
        else
        {
            ++sectionCounter;
            if(mode == 1)
            {
                switch (sectionCounter)
                {
                    case 1:
                    {
                        if((integer)data == 0)
                        {
                            llOwnerSay("ERROR: Version identifier empty");
                            break;
                        }
                        else if(version < (integer)data)
                        {
                            llOwnerSay("ERROR: This album is made for a later version of this player. Results may vary.");
                            break;
                        }
                        else if(version > (integer)data)
                        {
                            llOwnerSay("ERROR: This album is for an earlier version of this player. Results may vary.");
                        }
                        break;
                    }
                    case 2:
                    {
                        if((integer)data!=1 && (integer)data!=2)
                        {
                            llOwnerSay("sectionCounter: "+sectionCounter+" Stereo/Mono selector overfolow: "+data);
                        }
                        else
                        {
                            VERSIONMODE=(integer)data;
                        }
                        break;
                    }
                    case 3:
                    {
                        albumName = data;
                        break;
                    }
                    case 4:
                    {
                        setArtwork(data);
                        break;
                    }
                    default:
                    {
                        llOwnerSay("ERROR: Header data out of bounds: "+(integer)sectionCounter);
                        break;
                    }
                }
            }
            else
            {
                switch (sectionCounter)
                {
                    case 1:
                    {
                        trackNames=trackNames+data;
                        break;
                    }
                    case 2:
                    {
                        trackArtists=trackArtists+data;
                        break;
                    }
                    case 3:
                    {
                        trackLSmL=trackLSmL+data;
                        break;
                    }
                    default:
                    {
                        segments+=data;
                        break;
                    }
                }
            }
        }
    }
    if(mode==2&&sectionCounter>2)
    {
        trackLengths=trackLengths+(string)(sectionCounter-2);
    }
    LOADING=FALSE;
    stopSpin();
    setMeta("Loaded "+(string)tracks+" tracks");
}

setArtwork(key artwork)
{
    if(VOLUME==1)
    {
       llRegionSay(artChannel,artwork);
    }
    llSetLinkPrimitiveParamsFast(20,[PRIM_TEXTURE,0,artwork,<1,1,0>,<0,0,0>,0]);
}

setMeta(string stage)
{
    llSetText(stage+":\n Track "+(string)(currentTrack+1)+"\n "+llList2String(trackNames,currentTrack)+"\n By: "+llList2String(trackArtists,currentTrack)+"\n From: "+albumName+"\n\n\n\n",llGetColor(ALL_SIDES),1);
}

default
{
    state_entry()
    {
        purgeInventory();
        stopPlayback();
        setArtwork((key)"96b9ec80-cffd-4353-a25c-7914411ac521");
        llSetText("",llGetColor(ALL_SIDES),1);
        llSetLinkPrimitiveParamsFast(36,[PRIM_COLOR,ALL_SIDES,<1,0,0>,1]);
    }

    state_exit()
    {
        llListenRemove(listener);
    }

    link_message(integer sender_num, integer num, string list_argument, key id)
    {
        if(currentAlbum!="")
        {
            if(LOADING)
            {
                llRegionSayTo(llDetectedKey(0),0,"Unable to use controls while loading an album.");
            }
            else
            {
                if(num==15)
                {
                    //Play Button
                    if(llGetInventoryNumber(INVENTORY_NOTECARD)!=0)
                    {
                        if(PLAYING==FALSE)
                        {
                            if(VOLUME)
                            {
                                setArtwork(albumArtKey);
                            }
                            PLAYING=TRUE;
                            startSpin();
                            STARTED=TRUE;
                            setMeta("Preping");
                            llPreloadSound(llList2Key(segments,currentTrack));
                            llSetTimerEvent(0.01);
                        }
                    }
                    else
                    {
                        llRegionSayTo(llDetectedKey(0),0,"Please load an album before pressing play.");
                    }
                }
                else if(num==16)
                {
                    if(currentAlbum!="")
                    {
                        //Stop Button
                        stopPlayback();
                        setMeta("Loaded");
                        llSetTimerEvent(0);
                        llSleep(1);
                    }
                }
                else if(num==29|num==22|num==24)
                {
                    //Back Button
                    currentTrack=currentTrack-1;
                    if(currentTrack<0)
                    {
                        currentTrack=(tracks-1);
                    }
                    if(PLAYING)
                    {
                        llStopSound();
                        setMeta("Preping");
                        STARTED=TRUE;
                        llSetTimerEvent(1);
                    }
                    else
                    {
                        setMeta("Loaded");
                    }
                }
                else if(num==23|num==28|num==30)
                {
                    //Forward Button
                    currentTrack=currentTrack+1;
                    if(currentTrack>(tracks-1))
                    {
                        currentTrack=0;
                    }
                    if(PLAYING)
                    {
                        llStopSound();
                        setMeta("Preping");
                        STARTED=TRUE;
                        llSetTimerEvent(0.01);
                    }
                    else
                    {
                        setMeta("Loaded");
                    }
                }
                else if(num==35|num==27|num==26|num==25)
                {
                    //Toggle Volume Button
                    toggleVolume();
                }
                else if(num==31|num==32)
                {
                    //Eject Button
                    purgeInventory();
                    stopPlayback();
                    setArtwork((key)"96b9ec80-cffd-4353-a25c-7914411ac521");
                    albumArtKey=NULL_KEY;
                    currentAlbum="";
                    LOADING=TRUE;
                    STARTED=FALSE;
                    PLAYING=FALSE;
                    llSetText("",llGetColor(ALL_SIDES),1);
                    tracks=0;
                    track=0;
                    notecardLine=0;
                    trackNames=[];
                    trackLSmL=[];
                    segments=[];
                    trackLengths=[];
                    trackStarts=[];
                    trackArtists=[];
                    sectionCounter=0;
                    mode=0;
                    trackStarts=[0];
                    currentTrack=0;
                    llSetTimerEvent(0);
                }
            }
        }
    }

    changed(integer change)
    {
        if(change & CHANGED_INVENTORY)
        {
            if(llGetInventoryNumber(INVENTORY_NOTECARD)>1)
            {
                llOwnerSay("There are too many albums loaded into this bank. Please eject before trying to switch albums.");
            }
            else if(llGetInventoryNumber(INVENTORY_NOTECARD)==1)
            {
                stopPlayback();
                setArtwork((key)"96b9ec80-cffd-4353-a25c-7914411ac521");
                LOADING=TRUE;
                STARTED=FALSE;
                PLAYING=FALSE;
                startSpin();
                llSetTimerEvent(0);
                llSleep(1);
                currentAlbum=llGetSubString(llGetInventoryName(INVENTORY_NOTECARD,0),4,-1);
                llSetText("Loading: \n "+currentAlbum+"\n\n\n\n",llGetColor(ALL_SIDES),1);
                importNotecard("(cd)"+currentAlbum);
                llSetTimerEvent(0);
            }
        }
    }

    timer()
    {
        if(PLAYING)
        {
            if(STARTED)
            {
                currentSegment=llList2Integer(trackStarts,currentTrack);
                llSetTimerEvent(10);
                setMeta("Playing");
                STARTED=FALSE;
            }
            if(currentSegment==(llList2Integer(trackLengths,currentTrack)-1))
            {
                ++currentTrack;
                if(PLAYLOOP)
                {
                    if(currentTrack>(tracks-1))
                    {
                        currentTrack=0;
                    }
                    llSetTimerEvent(llList2Integer(trackLSmL,currentTrack));
                    STARTED=TRUE;
                }
                else
                {
                    if(currentTrack>(tracks-1))
                    {
                        currentTrack=0;
                        PLAYING=FALSE;
                        stopSpin();
                    }
                    else
                    {
                        llSetTimerEvent(llList2Integer(trackLSmL,currentTrack));
                        STARTED=TRUE;
                    }
                }
            }
            if(VERSIONMODE==2)
            {
                llSetLinkPrimitiveParamsFast(39,[PRIM_FULLBRIGHT,ALL_SIDES,1]);
                if(currentSegment<llGetListLength(segments)-1)
                {
                    llShout(prechannelLeft,llList2Key(segments,currentSegment+2));
                    llShout(prechannelRight,llList2Key(segments,currentSegment+3));
                }
                llShout(playchannelLeft,llList2Key(segments,currentSegment));
                llShout(playchannelRight,llList2Key(segments,currentSegment+1));
                currentSegment=currentSegment+2;
            }
            else
            {
                llSetLinkPrimitiveParamsFast(39,[PRIM_FULLBRIGHT,ALL_SIDES,0]);
                if(currentSegment<llGetListLength(segments)-1)
                {
                    llShout(prechannelMono,llList2Key(segments,currentSegment+1));
                    llPreloadSound(llList2Key(segments,currentSegment+1));
                }
                llShout(playchannelMono,llList2Key(segments,currentSegment));
                ++currentSegment;
            }
        }
        else
        {
            stopPlayback();
            setMeta("Loaded");
            STARTED=FALSE;
            llSetTimerEvent(0);
        }
    }
}
