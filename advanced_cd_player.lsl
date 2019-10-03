//Version 4

integer version = 2;

integer tracks;
integer track = 0;
key notecardQueryId;
integer notecardLine;
integer soundcount;
integer listener;
integer pages = 0;
integer numperpage = 11;
string albumName;
key albumArtKey;
integer lastSegmentLength = 10;
integer currentSegment;
string currentAlbum;
list trackNames;
list trackLSmL;
list trackLengths;
list trackStarts;
list trackArtists;
list segments;
integer currentTrack;
integer sectionCounter=0;
integer mode=0;
integer STARTED=FALSE;
integer PLAYING=FALSE;
integer LOADING=FALSE;
integer prechannelMono = 45687;
integer playchannelMono = 45689;
integer volumechannelMono = 45679;
integer artChannel = 45699;
integer prechannelRight = 35687;
integer playchannelRight = 35689;
integer volumechannelRight = 35679;
integer prechannelLeft = 55687;
integer playchannelLeft = 55689;
integer volumechannelLeft = 55679;
integer PLAYLOOP=FALSE;
integer VERSIONMODE;
integer VOLUME=1;

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
    llShout(playchannelLeft,(key)"0d0f06a3-daf3-d572-b19e-7622a114e40c");
    llShout(playchannelRight,(key)"0d0f06a3-daf3-d572-b19e-7622a114e40c");
    llShout(playchannelMono,(key)"0d0f06a3-daf3-d572-b19e-7622a114e40c");
    STARTED=FALSE;
    PLAYING=FALSE;
    llStopSound();
}

toggleLoop()
{
    if(PLAYLOOP)
    {
        PLAYLOOP=FALSE;
    }
    else
    {
        PLAYLOOP=TRUE;
    }
    llSetLinkPrimitiveParamsFast(21,[PRIM_FULLBRIGHT,ALL_SIDES,PLAYLOOP]);
    llSetLinkPrimitiveParamsFast(22,[PRIM_FULLBRIGHT,ALL_SIDES,PLAYLOOP]);
}

setArtwork(key artwork)
{
    llShout(artChannel,artwork);
    llSetLinkPrimitiveParamsFast(8,[PRIM_TEXTURE,ALL_SIDES,artwork,<1,1,0>,<0,0,0>,0]);
    llSetLinkPrimitiveParamsFast(20,[PRIM_TEXTURE,0,artwork,<1,1,0>,<0,0,0>,0]);
}

setMeta(string stage)
{
    setLCD((currentTrack+1));
    llSetText(stage+":\n "+llList2String(trackNames,currentTrack)+"\n By: "+llList2String(trackArtists,currentTrack)+"\n From: "+albumName+"\n\n\n\n",llGetColor(ALL_SIDES),1);
}

doPopup(key target)
{
    list buttons;
    integer randomChan=(integer)llFrand(2550)+150;
    integer a;
    integer sounds=llGetInventoryNumber(INVENTORY_NOTECARD);
    for(a=0;a<sounds;++a)
    {
        if(llGetSubString(llGetInventoryName(INVENTORY_NOTECARD,a),0,6)=="(album)")
        {
            string buttonName = llGetSubString(llGetInventoryName(INVENTORY_NOTECARD,a),7,-1);
            if(llSubStringIndex(buttonName," ")>0)
            {
                llOwnerSay("Skipping "+buttonName+" because LSL can't handle spaces in dialogs");
                llOwnerSay("Suggests renaming to (album)"+llGetSubString((string)llParseString2List(buttonName, [" "], []),0,23));
            }
            else if(llStringLength(buttonName)>23)
            {
                llOwnerSay("Skipping "+buttonName+" because LSL can't handle names longer than 24 characters in dialogs.");
                llOwnerSay("Suggests renaming to (album)"+llGetSubString((string)llParseString2List(buttonName, [" "], []),0,16));
            }    
            else
            {
                 integer skipCount=pages*numperpage;
                 integer endy=(pages+1)*numperpage;
                 if(a>=skipCount && a<endy)
                 {
                     buttons=buttons+buttonName;
                 }
             }
        }
        else
        {
            llOwnerSay("Skipping "+llGetInventoryName(INVENTORY_NOTECARD,a)+" because it's not int the correct format.");
        }
    }
    if(sounds>numperpage)
    {
        buttons=buttons+"More";
    }
    llDialog(target,"Trax",buttons,randomChan);
    listener=llListen(randomChan,"",llDetectedKey(0),"");
}

setLCD(integer number)
{
    if(llStringLength((string)number)==1)
    {
        //Single Digit
        llSetLinkPrimitiveParamsFast(25,[PRIM_TEXTURE,0,getLCDTexture(0),<-1,-1,0>,<0,0,0>,0] );
        llSetLinkPrimitiveParamsFast(26,[PRIM_TEXTURE,0,getLCDTexture(number),<-1,-1,0>,<0,0,0>,0] );
    }
    else
    {
        //Double digit
        llSetLinkPrimitiveParamsFast(25,[PRIM_TEXTURE,0,getLCDTexture((integer)llGetSubString((string)number,0,1)),<-1,-1,0>,<0,0,0>,0] );
        llSetLinkPrimitiveParamsFast(26,[PRIM_TEXTURE,0,getLCDTexture((integer)llGetSubString((string)number,1,1)),<-1,-1,0>,<0,0,0>,0] );
    }
}

key getLCDTexture(integer number)
{
    if(number == 0)
    {
        return (key)"3212afd0-bf64-4cb2-998e-69889218c7fe";
    }
    else if(number == 1)
    {
        return (key)"6e97514e-5cb2-4977-ac00-c13d1b4eb7d3";
    }
    else if(number == 2)
    {
        return (key)"d1870f38-c433-48d3-9f56-435dba5495d8";
    }
    else if(number == 3)
    {
        return (key)"a6ca255e-8b2a-43d5-82a2-e0ce2d582f80";
    }
    else if(number == 4)
    {
        return (key)"95bc6385-4bf3-41f8-a804-d09709cb6e97";
    }
    else if(number == 5)
    {
        return (key)"d4423f77-bfc0-43aa-832c-f5bd7faaba0b";
    }
    else if(number == 6)
    {
        return (key)"e7740b21-d19b-4086-805b-e0d227a3d56a";
    }
    else if(number == 7)
    {
        return (key)"b81bc956-7547-4f34-ba9c-ae3cd0454fd4";
    }
    else if(number == 8)
    {
        return (key)"2abae540-2275-405d-970b-92f88cb421e2";
    }
    else if(number == 9)
    {
        return (key)"32ae0deb-0e10-4d6c-acf6-c5e2e4dc2e6f";
    }
    else if(number == -1)
    {
        return (key)"38b86f85-2575-52a9-a531-23108d8da837";
    }
    return NULL_KEY;
}

default
{
    state_entry()
    {
        setLCD(0);
        stopPlayback();
        setArtwork((key)"96b9ec80-cffd-4353-a25c-7914411ac521");
        llSetText("",llGetColor(ALL_SIDES),1);
        llSetLinkPrimitiveParamsFast(21,[PRIM_FULLBRIGHT,ALL_SIDES,PLAYLOOP]);
        llSetLinkPrimitiveParamsFast(22,[PRIM_FULLBRIGHT,ALL_SIDES,PLAYLOOP]);
    }
    
    state_exit()
    {
        llListenRemove(listener);
    }
    
    touch_end(integer unused)
    {
        if(LOADING)
        {
            llRegionSayTo(llDetectedKey(0),0,"Unable to use controls while loading an album.");
        }
        else
        {
            if(llDetectedLinkNumber(0)==16)
            {
                //Album Button
                if(llGetInventoryNumber(INVENTORY_NOTECARD)!=0)
                {
                    doPopup(llDetectedKey(0));
                }
                else
                {
                    llRegionSayTo(llDetectedKey(0),0,"This radio has no albums loaded into it.");
                }
            }
            else if(llDetectedLinkNumber(0)==10)
            {
                //Play Button
                if(llGetInventoryNumber(INVENTORY_NOTECARD)!=0)
                {
                    if(currentAlbum!="")
                    {
                        if(PLAYING==FALSE)
                        {
                            PLAYING=TRUE;
                            startSpin();
                            STARTED=TRUE;
                            setMeta("Preping");
                            llPreloadSound(llList2Key(segments,currentTrack));
                            llSetTimerEvent(1);
                        }
                    }
                    else
                    {
                        llRegionSayTo(llDetectedKey(0),0,"Please load an album before pressing play.");
                    }
                }
                else
                {
                    llRegionSayTo(llDetectedKey(0),0,"This radio has no albums loaded into it.");
                }
            }
            else if(llDetectedLinkNumber(0)==11)
            {
                //Stop Button
                stopPlayback();
                setMeta("Loaded");
                llSetTimerEvent(0);
                llSleep(1);
            }
            else if(llDetectedLinkNumber(0)==12|llDetectedLinkNumber(0)==14|llDetectedLinkNumber(0)==18)
            {
                //Back Button
                currentTrack=currentTrack-1;
                if(currentTrack<0)
                {
                    currentTrack=(tracks-1);
                }
                if(PLAYING)
                {
                    llAdjustSoundVolume(0);
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
            else if(llDetectedLinkNumber(0)==13|llDetectedLinkNumber(0)==15|llDetectedLinkNumber(0)==17)
            {
                //Forward Button
                currentTrack=currentTrack+1;
                if(currentTrack>(tracks-1))
                {
                    currentTrack=0;
                }
                if(PLAYING)
                {
                    llAdjustSoundVolume(0);
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
            else if(llDetectedLinkNumber(0)==21|llDetectedLinkNumber(0)==22)
            {
                toggleLoop();
            }
        }
    }
    
    listen(integer channel,string name,key id,string message)
    {
        if(message=="More")
        {
            ++pages;
            integer albums=llGetInventoryNumber(INVENTORY_NOTECARD);
            if(pages*numperpage>albums)
            {
                integer totalsofar=(integer)(pages*numperpage);
                pages=0;
            }
            llSleep(1.5);
            doPopup(id);
        }
        else
        {
            setLCD(0);
            stopPlayback();
            setArtwork((key)"96b9ec80-cffd-4353-a25c-7914411ac521");
            LOADING=TRUE;
            STARTED=FALSE;
            PLAYING=FALSE;
            startSpin();            
            llSetTimerEvent(0);
            llSleep(1);
            currentAlbum=message;
            llSetText("Loading: \n "+message+"\n\n\n\n",llGetColor(ALL_SIDES),1);
            tracks=0;
            track=1;
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
            notecardQueryId = llGetNotecardLine("(album)"+currentAlbum, notecardLine);
            llSetTimerEvent(0);
        }
    }
    
    dataserver(key query_id, string data)
    {    
        if (query_id == notecardQueryId)
        {
            if (data != EOF)
            {
                ++notecardLine;
                if(data=="[META]")
                {
                    mode=1;
                    sectionCounter=0;
                }
                else if(data=="[SONG]")
                {
                    if(mode==2&&sectionCounter>2)
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
                    if(mode==1 && sectionCounter==1)
                    {
                        VERSIONMODE=(integer)data;
                        if(version < (integer)data)
                        {
                            llOwnerSay("This album is made for a later version of this player. Results may vary.");
                        }
                    }
                    else if(mode==1 && sectionCounter==2)
                    {
                        albumName = data;
                    }
                    else if(mode==1 && sectionCounter==3)
                    {
                        setArtwork(data);
                    }
                    else if(mode==2 && sectionCounter==1)
                    {
                        trackNames=trackNames+data;
                    }
                    else if(mode==2 && sectionCounter==2)
                    {
                        trackArtists=trackArtists+data;
                    }
                    else if(mode==2 && sectionCounter==3)
                    {
                        trackLSmL=trackLSmL+data;
                    }
                    else if(mode==2 && sectionCounter>3)
                    {
                        segments=segments+data;
                    }
                }
                notecardQueryId = llGetNotecardLine("(album)"+currentAlbum, notecardLine);
            }
            else
            {
                if(mode==2&&sectionCounter>2)
                {
                    trackLengths=trackLengths+(string)(sectionCounter-2);
                }
                LOADING=FALSE;
                stopSpin();
                setMeta("Loaded");
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
                if(VERSIONMODE==1)
                {
                    llRegionSay(volumechannelMono,(string)VOLUME);
                }
                else if(VERSIONMODE==2)
                {
                    llRegionSay(volumechannelLeft,(string)VOLUME);
                    llRegionSay(volumechannelRight,(string)VOLUME);
                }                
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
            if(VERSIONMODE==1)
            {
                if(currentSegment<llGetListLength(segments)-1)
                {
                    llShout(prechannelMono,llList2Key(segments,currentSegment+1));
                    llPreloadSound(llList2Key(segments,currentSegment+1));
                }
                llShout(playchannelMono,llList2Key(segments,currentSegment));
                llPlaySound(llList2Key(segments,currentSegment),1);
                ++currentSegment;
            }
            else
            {
                if(currentSegment<llGetListLength(segments)-1)
                {
                    llShout(prechannelLeft,llList2Key(segments,currentSegment+2));
                    llShout(prechannelRight,llList2Key(segments,currentSegment+3));
                }
                llShout(playchannelLeft,llList2Key(segments,currentSegment));
                llShout(playchannelRight,llList2Key(segments,currentSegment+1));
                currentSegment=currentSegment+2;
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
