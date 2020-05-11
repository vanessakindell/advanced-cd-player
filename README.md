# Advanced CD Player
Advanced CD Player for OpenSim<br/>
<br/>
This program is free software: you can redistribute it and/or modify<br/>
it under the terms of the GNU General Public License as published by<br/>
the Free Software Foundation, either version 3 of the License, or<br/>
(at your option) any later version.<br/>
<br/>
This program is distributed in the hope that it will be useful,<br/>
but WITHOUT ANY WARRANTY; without even the implied warranty of<br/>
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the<br/>
GNU General Public License for more details.<br/>
<br/>
You should have received a copy of the GNU General Public License<br/>
along with this program.  If not, see <https://www.gnu.org/licenses/>.<br/>
<br/>
Created for Mobius fork of OpenSim<br/>
Will play correctly formatted album notecards.<br/>
<br/>
Format explanation:<br/>
[META]                                  - Section header<br/>
5                                       - Version
1                                       - Mono (2 for stereo)<br/>
Hyperland                               - Album title<br/>
6d36dcbc-1426-4072-a0c6-8588cf54b827    - UUID of album cover image<br/>
[SONG]                                  - Section header<br/>
Hyperland                               - Song title<br/>
V~Nessy                                 - Artist name<br/>
10                                      - Number of seconds of the last audio clip<br/>
ccec1d37-794a-4b09-9629-25d92f65dff2    - UUIDs of sound clips in choronological order<br/>
e6ecc7b4-2068-4ffb-8193-73092273b5eb    - UUIDs of sound clips in choronological order

(If stereo, every other clip should be the right channel version of the same audio clip i.e. in order left, right, left, right)
