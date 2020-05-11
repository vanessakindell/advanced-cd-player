//Version 2.0

integer version = 5;
key user;
integer locked;
integer listen_handle;
list output;
integer mode;
string songName;

default
{
    state_entry()
    {
        llSetText("",<1,1,1>,1);
    }
    state_exit()
    {
        llListenRemove(listen_handle);
    }
    touch_end(integer unused)
    {
        if(!locked)
        {
            while(llGetInventoryNumber(INVENTORY_TEXTURE)>0)
            {
                llRemoveInventory(llGetInventoryName(INVENTORY_TEXTURE,0));
            }
            while(llGetInventoryNumber(INVENTORY_SOUND)>0)
            {
                llRemoveInventory(llGetInventoryName(INVENTORY_SOUND,0));
            }
            while(llGetInventoryNumber(INVENTORY_NOTECARD)>0)
            {
                llRemoveInventory(llGetInventoryName(INVENTORY_NOTECARD,0));
            }
            mode = 0;
            output = ["[META]",version];
            llAllowInventoryDrop(TRUE);
            user = llDetectedKey(0);
            locked = TRUE;
            llSetText("In use by "+llGetUsername(user),<1,1,1>,1);
            llInstantMessage(user,"This is used to create (cd) format notecards.");
            llInstantMessage(user,"You have 2 minutes to use the machine.");
            llInstantMessage(user,"Drop all the song clips as well as the album cover image inside and touch again when ready.");
            llSetTimerEvent(120);
        }
        else
        {
            if(llDetectedKey(0)==user)
            {
                if(llGetInventoryNumber(INVENTORY_SOUND)>0 && llGetInventoryNumber(INVENTORY_TEXTURE)>0)
                {
                    mode=1;
                    integer randomChan = (integer)llFrand(2147483647);
                    listen_handle = llListen(randomChan,"",user,"");
                    llTextBox(user,"Number of channels\n(1:mono/2:sterio)\nPress ignore if not yet ready.\n",randomChan);
                }
                else
                {
                    llInstantMessage(user,"You must provide at least 1 sound and 1 album cover image");
                }
            }
            else
            {
                llInstantMessage(llDetectedKey(0),"This machine is in use. Please wait your turn.");
            }
        }
    }
    listen(integer channel, string name, key id, string message)
    {
        if(id == user)
        {
            if(mode > 0 && mode < 6)
            {
                ++mode;
                output = output + message;
            }
            else
            {
                ++mode;
            }
        }
        if(mode == 2)
        {
            integer randomChan = (integer)llFrand(2147483647);
            listen_handle = llListen(randomChan,"",user,"");
            llTextBox(user,"Enter album name:\n",randomChan);
        }
        else if(mode == 3)
        {
            output = output + llGetInventoryKey(llGetInventoryName(INVENTORY_TEXTURE,0));
            output = output + "[SONG]";
            integer randomChan = (integer)llFrand(2147483647);
            listen_handle = llListen(randomChan,"",user,"");
            llTextBox(user,"Enter song name:\n",randomChan);
        }
        else if(mode == 4)
        {
            songName = message;
            integer randomChan = (integer)llFrand(2147483647);
            listen_handle = llListen(randomChan,"",user,"");
            llTextBox(user,"Enter artist name:\n",randomChan);
        }
        else if(mode == 5)
        {
            integer randomChan = (integer)llFrand(2147483647);
            listen_handle = llListen(randomChan,"",user,"");
            llTextBox(user,"How many seconds long is the final segment?\n",randomChan);
        }
        else if(mode == 6)
        {
            integer randomChan = (integer)llFrand(2147483647);
            listen_handle = llListen(randomChan,"",user,"");
            llDialog(user,"Are there more songs?",["Yes","No"],randomChan);
        }
        else if(mode == 7)
        {
            if(message=="Yes")
            {
                while(llGetInventoryNumber(INVENTORY_SOUND)>0)
                {
                    output = output + llGetInventoryKey(llGetInventoryName(INVENTORY_SOUND,0));
                    llRemoveInventory(llGetInventoryName(INVENTORY_SOUND,0));
                }
                llInstantMessage(user,"Drop all the song clips for the next track inside, do not enter song name until done.");
                mode = 3;
                output = output + "[SONG]";
                integer randomChan = (integer)llFrand(2147483647);
                listen_handle = llListen(randomChan,"",user,"");
                llTextBox(user,"Enter song name:\n",randomChan);
            }
            else
            {
                llSetText("Please wait, generating "+songName,<1,1,1>,1);
                while(llGetInventoryNumber(INVENTORY_TEXTURE)>0)
                {
                    llRemoveInventory(llGetInventoryName(INVENTORY_TEXTURE,0));
                }
                while(llGetInventoryNumber(INVENTORY_SOUND)>0)
                {
                    output = output + llGetInventoryKey(llGetInventoryName(INVENTORY_SOUND,0));
                    llRemoveInventory(llGetInventoryName(INVENTORY_SOUND,0));
                }
                string outputName = "(cd)"+llGetSubString((string)llParseString2List(songName, [" "], []),0,23);
                osMakeNotecard(outputName,output);
                llSetText("Done!",<1,1,1>,1);
                llGiveInventory(user,outputName);
                llSleep(3);
                llAllowInventoryDrop(FALSE);
                user = NULL_KEY;
                llSetTimerEvent(0);
                locked = FALSE;
                llSetText("",<1,1,1>,1);
            }
        }
    }
    timer()
    {
        llSetTimerEvent(0);
        llAllowInventoryDrop(FALSE);
        llSetText("",<1,1,1>,1);
        llInstantMessage(user,"Your usage has timed out.");
        user = NULL_KEY;
        locked = FALSE;
    }
}//Version 2.0

integer version = 5;
key user;
integer locked;
integer listen_handle;
list output;
integer mode;
string songName;

default
{
    state_entry()
    {
        llSetText("",<1,1,1>,1);
    }
    state_exit()
    {
        llListenRemove(listen_handle);
    }
    touch_end(integer unused)
    {
        if(!locked)
        {
            while(llGetInventoryNumber(INVENTORY_TEXTURE)>0)
            {
                llRemoveInventory(llGetInventoryName(INVENTORY_TEXTURE,0));
            }
            while(llGetInventoryNumber(INVENTORY_SOUND)>0)
            {
                llRemoveInventory(llGetInventoryName(INVENTORY_SOUND,0));
            }
            while(llGetInventoryNumber(INVENTORY_NOTECARD)>0)
            {
                llRemoveInventory(llGetInventoryName(INVENTORY_NOTECARD,0));
            }
            mode = 0;
            output = ["[META]",version];
            llAllowInventoryDrop(TRUE);
            user = llDetectedKey(0);
            locked = TRUE;
            llSetText("In use by "+llGetUsername(user),<1,1,1>,1);
            llInstantMessage(user,"This is used to create (cd) format notecards.");
            llInstantMessage(user,"You have 2 minutes to use the machine.");
            llInstantMessage(user,"Drop all the song clips as well as the album cover image inside and touch again when ready.");
            llSetTimerEvent(120);
        }
        else
        {
            if(llDetectedKey(0)==user)
            {
                if(llGetInventoryNumber(INVENTORY_SOUND)>0 && llGetInventoryNumber(INVENTORY_TEXTURE)>0)
                {
                    mode=1;
                    integer randomChan = (integer)llFrand(2147483647);
                    listen_handle = llListen(randomChan,"",user,"");
                    llTextBox(user,"Number of channels\n(1:mono/2:sterio)\nPress ignore if not yet ready.\n",randomChan);
                }
                else
                {
                    llInstantMessage(user,"You must provide at least 1 sound and 1 album cover image");
                }
            }
            else
            {
                llInstantMessage(llDetectedKey(0),"This machine is in use. Please wait your turn.");
            }
        }
    }
    listen(integer channel, string name, key id, string message)
    {
        if(id == user)
        {
            if(mode > 0 && mode < 6)
            {
                ++mode;
                output = output + message;
            }
            else
            {
                ++mode;
            }
        }
        if(mode == 2)
        {
            integer randomChan = (integer)llFrand(2147483647);
            listen_handle = llListen(randomChan,"",user,"");
            llTextBox(user,"Enter album name:\n",randomChan);
        }
        else if(mode == 3)
        {
            output = output + llGetInventoryKey(llGetInventoryName(INVENTORY_TEXTURE,0));
            output = output + "[SONG]";
            integer randomChan = (integer)llFrand(2147483647);
            listen_handle = llListen(randomChan,"",user,"");
            llTextBox(user,"Enter song name:\n",randomChan);
        }
        else if(mode == 4)
        {
            songName = message;
            integer randomChan = (integer)llFrand(2147483647);
            listen_handle = llListen(randomChan,"",user,"");
            llTextBox(user,"Enter artist name:\n",randomChan);
        }
        else if(mode == 5)
        {
            integer randomChan = (integer)llFrand(2147483647);
            listen_handle = llListen(randomChan,"",user,"");
            llTextBox(user,"How many seconds long is the final segment?\n",randomChan);
        }
        else if(mode == 6)
        {
            integer randomChan = (integer)llFrand(2147483647);
            listen_handle = llListen(randomChan,"",user,"");
            llDialog(user,"Are there more songs?",["Yes","No"],randomChan);
        }
        else if(mode == 7)
        {
            if(message=="Yes")
            {
                while(llGetInventoryNumber(INVENTORY_SOUND)>0)
                {
                    output = output + llGetInventoryKey(llGetInventoryName(INVENTORY_SOUND,0));
                    llRemoveInventory(llGetInventoryName(INVENTORY_SOUND,0));
                }
                llInstantMessage(user,"Drop all the song clips for the next track inside, do not enter song name until done.");
                mode = 3;
                output = output + "[SONG]";
                integer randomChan = (integer)llFrand(2147483647);
                listen_handle = llListen(randomChan,"",user,"");
                llTextBox(user,"Enter song name:\n",randomChan);
            }
            else
            {
                llSetText("Please wait, generating "+songName,<1,1,1>,1);
                while(llGetInventoryNumber(INVENTORY_TEXTURE)>0)
                {
                    llRemoveInventory(llGetInventoryName(INVENTORY_TEXTURE,0));
                }
                while(llGetInventoryNumber(INVENTORY_SOUND)>0)
                {
                    output = output + llGetInventoryKey(llGetInventoryName(INVENTORY_SOUND,0));
                    llRemoveInventory(llGetInventoryName(INVENTORY_SOUND,0));
                }
                string outputName = "(cd)"+llGetSubString((string)llParseString2List(songName, [" "], []),0,23);
                osMakeNotecard(outputName,output);
                llSetText("Done!",<1,1,1>,1);
                llGiveInventory(user,outputName);
                llSleep(3);
                llAllowInventoryDrop(FALSE);
                user = NULL_KEY;
                llSetTimerEvent(0);
                locked = FALSE;
                llSetText("",<1,1,1>,1);
            }
        }
    }
    timer()
    {
        llSetTimerEvent(0);
        llAllowInventoryDrop(FALSE);
        llSetText("",<1,1,1>,1);
        llInstantMessage(user,"Your usage has timed out.");
        user = NULL_KEY;
        locked = FALSE;
    }
}
