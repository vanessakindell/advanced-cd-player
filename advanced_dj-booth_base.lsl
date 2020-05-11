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
