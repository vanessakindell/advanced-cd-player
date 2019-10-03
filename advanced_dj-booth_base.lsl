purgeInventory()
{
    while(llGetInventoryNumber(INVENTORY_NOTECARD)>0)
    {
        llRemoveInventory(llGetInventoryName(INVENTORY_NOTECARD,0));
    }
}

default
{
    state_entry()
    {
        purgeInventory();
    }
    touch_end(integer unused)
    {
        if(llDetectedKey(0)==llGetOwnerKey(llGetKey()))
        {
            if(llGetInventoryNumber(INVENTORY_NOTECARD)>0)
            {
                if(llGetInventoryNumber(INVENTORY_NOTECARD)>1)
                {
                    llOwnerSay("OVERFLOW ERROR: Please only load one album at a time.");
                    purgeInventory();
                }
                else
                {
                    if(llDetectedLinkNumber(0)==35|llDetectedLinkNumber(0)==38)
                    {
                        if(llDetectedLinkNumber(0)==38)
                        {
                            //Bank 1
                             llGiveInventory(llGetLinkKey(13),llGetInventoryName(INVENTORY_NOTECARD,0));
                             llOwnerSay("Loaded into Bank 1.");
                             purgeInventory();
                        }
                        else
                        {
                            //Bank 2
                            llGiveInventory(llGetLinkKey(21),llGetInventoryName(INVENTORY_NOTECARD,0));
                            llOwnerSay("Loaded into Bank 2.");
                            purgeInventory();
                        }
                    }
                    else
                    {
                        llMessageLinked(LINK_SET,llDetectedLinkNumber(0),"",NULL_KEY);
                    }
                }
            }
            else
            {
                llMessageLinked(LINK_SET,llDetectedLinkNumber(0),"",NULL_KEY);
            }
        }
    }
    changed(integer change)
    {
        if(change & CHANGED_INVENTORY)
        {
            if(llGetInventoryNumber(INVENTORY_NOTECARD)>0)
            {
                llOwnerSay("Select bank to load disc to.");
            }
        }
    }
}