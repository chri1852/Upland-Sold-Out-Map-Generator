#region /* Object Functions */

function GetNewNeighborhoodInfoObject()
{
    param(
        [int]$Id,
        [string]$Name,
        [string]$City,
        [int]$X = 0,
        [int]$Y = 0
    )

    return New-Object -TypeName psobject -Property @{

        "Id" = $Id
        "Name" = $Name
        "City" = $City
        "Unminted" = 0
        "Minted" = 0
        "Locked" = 0
        "ForSale" = 0
        "PercentMinted" = 0
        "OnlyLocked" = $false
        "X" = $X
        "Y" = $Y
     }
 }

function GetNewCityObject
{
    param(
        [int]$Id,
        [string]$Name,
        [bool]$AutoMapping = $false
    )

    return New-Object -TypeName psobject -Property @{

        "Id" = $Id
        "Name" = $Name
        "AutoMapping" = $AutoMapping
        "Colors" = @()
        "Neighborhoods" = @()
    }
}

function GetNewMouseLocationObject
{
    param(
        [int]$X,
        [int]$Y,
        [string]$Name
    )

    return New-Object -TypeName psobject -Property @{

        "X" = $X
        "Y" = $Y
        "Name" = $Name
    }
}

function GetNewToolsObject
{
    return New-Object -TypeName psobject -Property @{

        "Pipette" = $Pipette
        "Fill" = $Fill
    }
}

#endregion /* Object Functions */

#region /* C# Code */

$GLOBAL:DRAWCODE = @'
using System;
using System.Drawing;
using System.Runtime.InteropServices;
using System.Windows.Forms;
public class Clicker
{
//https://msdn.microsoft.com/en-us/library/windows/desktop/ms646270(v=vs.85).aspx
[StructLayout(LayoutKind.Sequential)]
struct INPUT
{ 
    public int        type; // 0 = INPUT_MOUSE,
                            // 1 = INPUT_KEYBOARD
                            // 2 = INPUT_HARDWARE
    public MOUSEINPUT mi;
}

//https://msdn.microsoft.com/en-us/library/windows/desktop/ms646273(v=vs.85).aspx
[StructLayout(LayoutKind.Sequential)]
struct MOUSEINPUT
{
    public int    dx ;
    public int    dy ;
    public int    mouseData ;
    public int    dwFlags;
    public int    time;
    public IntPtr dwExtraInfo;
}

//This covers most use cases although complex mice may have additional buttons
//There are additional constants you can use for those cases, see the msdn page
const int MOUSEEVENTF_MOVED      = 0x0001 ;
const int MOUSEEVENTF_LEFTDOWN   = 0x0002 ;
const int MOUSEEVENTF_LEFTUP     = 0x0004 ;
const int MOUSEEVENTF_RIGHTDOWN  = 0x0008 ;
const int MOUSEEVENTF_RIGHTUP    = 0x0010 ;
const int MOUSEEVENTF_MIDDLEDOWN = 0x0020 ;
const int MOUSEEVENTF_MIDDLEUP   = 0x0040 ;
const int MOUSEEVENTF_WHEEL      = 0x0080 ;
const int MOUSEEVENTF_XDOWN      = 0x0100 ;
const int MOUSEEVENTF_XUP        = 0x0200 ;
const int MOUSEEVENTF_ABSOLUTE   = 0x8000 ;

const int screen_length = 0x10000 ;

//https://msdn.microsoft.com/en-us/library/windows/desktop/ms646310(v=vs.85).aspx
[System.Runtime.InteropServices.DllImport("user32.dll")]
extern static uint SendInput(uint nInputs, INPUT[] pInputs, int cbSize);

public static void LeftClickAtPoint(int x, int y)
{
    //Move the mouse
    INPUT[] input = new INPUT[3];
    input[0].mi.dx = x*(65535/System.Windows.Forms.Screen.PrimaryScreen.Bounds.Width);
    input[0].mi.dy = y*(65535/System.Windows.Forms.Screen.PrimaryScreen.Bounds.Height);
    input[0].mi.dwFlags = MOUSEEVENTF_MOVED | MOUSEEVENTF_ABSOLUTE;
    //Left mouse button down
    input[1].mi.dwFlags = MOUSEEVENTF_LEFTDOWN;
    //Left mouse button up
    input[2].mi.dwFlags = MOUSEEVENTF_LEFTUP;
    SendInput(3, input, Marshal.SizeOf(input[0]));
}
}
'@

#endregion /* C# Code */

#region /* Data */

function GetTools()
{
    $Tools = GetNewToolsObject
    $Tools.Pipette = GetNewMouseLocationObject -X 51 -Y 306 -Name "TOOL_PIPETTE"
    $Tools.Fill = GetNewMouseLocationObject -X 21 -Y 258 -Name "TOOL_FILL"

    return $Tools
}

function BuildCityData()
{
    $cities = @()
    $cities += BuildCityData_SanFrancisco
    $cities += BuildCityData_Manhattan
    $cities += BuildCityData_Fresno
    $cities += BuildCityData_Brooklyn
    $cities += BuildCityData_Oakland
    $cities += BuildCityData_StatenIsland
    $cities += BuildCityData_Bakersfield
    $cities += BuildCityData_Chicago
    $cities += BuildCityData_Cleveland
    
    return $cities
}

function BuildCityData_SanFrancisco()
{
    $city = GetNewCityObject -Id 1 -Name "San Francisco"
    
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 94 -Name "Alamo Square" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 95 -Name "Anza Vista" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 96 -Name "Apparel City" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 97 -Name "Aquatic Park / Ft. Mason" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 98 -Name "Ashbury Heights" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 99 -Name "Balboa Terrace" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 100 -Name "Bayview" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 101 -Name "Bernal Heights" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 102 -Name "Bret Harte" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 103 -Name "Buena Vista" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 104 -Name "Candlestick Point Sra" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 105 -Name "Castro" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 106 -Name "Cathedral Hill" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 107 -Name "Cayuga" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 108 -Name "Central Waterfront" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 109 -Name "Chinatown" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 110 -Name "Civic Center" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 111 -Name "Clarendon Heights" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 112 -Name "Cole Valley" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 113 -Name "Corona Heights" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 114 -Name "Cow Hollow" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 115 -Name "Crocker Amazon" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 116 -Name "Diamond Heights" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 117 -Name "Dogpatch" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 118 -Name "Dolores Heights" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 119 -Name "Downtown / Union Square" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 120 -Name "Duboce Triangle" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 121 -Name "Eureka Valley" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 122 -Name "Excelsior" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 123 -Name "Fairmount" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 124 -Name "Financial District" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 125 -Name "Fishermans Wharf" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 126 -Name "Forest Hill" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 127 -Name "Forest Knolls" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 128 -Name "Glen Park" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 129 -Name "Golden Gate Heights" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 130 -Name "Golden Gate Park" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 131 -Name "Haight Ashbury" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 132 -Name "Hayes Valley" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 133 -Name "Holly Park" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 134 -Name "Hunters Point" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 135 -Name "India Basin" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 136 -Name "Ingleside" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 137 -Name "Ingleside Terraces" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 138 -Name "Inner Richmond" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 139 -Name "Inner Sunset" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 140 -Name "Japantown" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 141 -Name "Laguna Honda" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 142 -Name "Lake Street" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 143 -Name "Lakeshore" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 144 -Name "Laurel Heights / Jordan Park" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 145 -Name "Little Hollywood" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 146 -Name "Lone Mountain" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 147 -Name "Lower Haight" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 148 -Name "Lower Nob Hill" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 149 -Name "Lower Pacific Heights" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 150 -Name "Marina" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 151 -Name "Mclaren Park" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 152 -Name "Merced Heights" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 153 -Name "Merced Manor" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 154 -Name "Midtown Terrace" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 155 -Name "Mint Hill" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 156 -Name "Miraloma Park" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 157 -Name "Mission" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 158 -Name "Mission Bay" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 159 -Name "Mission Dolores" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 160 -Name "Mission Terrace" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 161 -Name "Monterey Heights" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 162 -Name "Mt. Davidson Manor" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 163 -Name "Nob Hill" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 164 -Name "Noe Valley" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 165 -Name "North Beach" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 166 -Name "Northern Waterfront" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 167 -Name "Oceanview" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 168 -Name "Outer Mission" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 169 -Name "Outer Richmond" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 170 -Name "Outer Sunset" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 171 -Name "Pacific Heights" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 172 -Name "Panhandle" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 173 -Name "Parkmerced" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 174 -Name "Parkside" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 175 -Name "Parnassus Heights" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 176 -Name "Peralta Heights" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 177 -Name "Polk Gulch" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 178 -Name "Portola" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 179 -Name "Potrero Hill" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 180 -Name "Presidio Heights" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 181 -Name "Presidio National Park" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 182 -Name "Presidio Terrace" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 183 -Name "Produce Market" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 184 -Name "Rincon Hill" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 185 -Name "Russian Hill" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 186 -Name "Seacliff" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 187 -Name "Sherwood Forest" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 188 -Name "Showplace Square" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 189 -Name "Silver Terrace" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 190 -Name "South Beach" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 191 -Name "South Of Market" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 192 -Name "St. Francis Wood" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 193 -Name "St. Marys Park" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 194 -Name "Stonestown" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 195 -Name "Sunnydale" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 196 -Name "Sunnyside" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 197 -Name "Sutro Heights" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 198 -Name "Telegraph Hill" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 199 -Name "Tenderloin" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 200 -Name "Union Street" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 201 -Name "University Mound" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 202 -Name "Upper Market" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 203 -Name "Visitacion Valley" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 204 -Name "West Portal" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 205 -Name "Western Addition" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 206 -Name "Westwood Highlands" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 207 -Name "Westwood Park" -City "San Francisco"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 208 -Name "Yerba Buena Island" -City "San Francisco"
    
    return $city
}

function BuildCityData_Manhattan()
{
    $city = GetNewCityObject -Id 2 -Name "Manhattan"
    
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 209 -Name "Battery Park City" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 210 -Name "Carnegie Hill" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 211 -Name "Chelsea" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 212 -Name "Chinatown" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 213 -Name "Civic Center" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 214 -Name "Columbus Circle" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 215 -Name "East Harlem" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 216 -Name "East Village" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 217 -Name "Financial District" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 218 -Name "Flatiron District" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 219 -Name "Fort George" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 220 -Name "Garment District" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 221 -Name "Gramercy" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 222 -Name "Greenwich Village" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 223 -Name "Hamilton Heights" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 224 -Name "Harlem" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 225 -Name "Hell'S Kitchen" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 226 -Name "Herald Square" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 227 -Name "Hudson Heights" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 228 -Name "Hudson Square" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 229 -Name "Hudson Yards" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 230 -Name "Inwood" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 231 -Name "Kips Bay" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 232 -Name "Koreatown" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 233 -Name "Lenox Hill" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 234 -Name "Lincoln Square" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 235 -Name "Little Italy" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 236 -Name "Lower East Side" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 237 -Name "Manhattan Valley" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 238 -Name "Manhattanville" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 239 -Name "Marble Hill" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 240 -Name "Meatpacking District" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 241 -Name "Midtown" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 242 -Name "Midtown East" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 243 -Name "Midtown South" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 244 -Name "Morningside Heights" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 245 -Name "Murray Hill" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 246 -Name "Noho" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 247 -Name "Nomad" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 248 -Name "Rose Hill" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 249 -Name "Soho" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 250 -Name "Stuy Town" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 251 -Name "Sugar Hill" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 252 -Name "Theater District" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 253 -Name "Tribeca" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 254 -Name "Tudor City" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 255 -Name "Turtle Bay" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 256 -Name "Two Bridges" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 257 -Name "Union Square" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 258 -Name "Upper East Side" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 259 -Name "Upper West Side" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 260 -Name "Washington Heights" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 261 -Name "West Village" -City "Manhattan"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 262 -Name "Yorkville" -City "Manhattan"
    
    return $city
}

function BuildCityData_Fresno()
{
    $city = GetNewCityObject -Id 3 -Name "Fresno"
    
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 263 -Name "Adoline-Palm Historic District" -City "Fresno"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 264 -Name "Biola Junction" -City "Fresno"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 265 -Name "Bullard" -City "Fresno"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 266 -Name "Calwa" -City "Fresno"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 267 -Name "Central Fresno" -City "Fresno"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 268 -Name "Chinatown" -City "Fresno"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 269 -Name "Edison" -City "Fresno"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 270 -Name "Fig Garden" -City "Fresno"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 271 -Name "Fig Garden Loop" -City "Fresno"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 272 -Name "Fresno High-Roeding" -City "Fresno"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 273 -Name "Hammond" -City "Fresno"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 274 -Name "Herndon" -City "Fresno"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 275 -Name "Highway City" -City "Fresno"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 276 -Name "Hoover" -City "Fresno"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 277 -Name "Little Italy" -City "Fresno"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 278 -Name "Lowell" -City "Fresno"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 279 -Name "Malaga" -City "Fresno"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 280 -Name "Mclane" -City "Fresno"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 281 -Name "North Growth Area" -City "Fresno"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 282 -Name "Pinedale" -City "Fresno"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 283 -Name "Roosevelt" -City "Fresno"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 284 -Name "Sierra Sky Park" -City "Fresno"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 285 -Name "Southeast Growth Area" -City "Fresno"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 286 -Name "Sunnyside" -City "Fresno"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 287 -Name "Tarpey" -City "Fresno"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 288 -Name "The Bluffs" -City "Fresno"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 289 -Name "Tower District" -City "Fresno"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 290 -Name "Van Ness Extension" -City "Fresno"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 291 -Name "West Fresno" -City "Fresno"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 292 -Name "West Pinedale" -City "Fresno"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 293 -Name "Woodward Park" -City "Fresno"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 294 -Name "West Clovis" -City "Fresno"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 295 -Name "Old Town" -City "Fresno"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 296 -Name "North Clovis" -City "Fresno"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 297 -Name "South Clovis" -City "Fresno"
    
    return $city
}

function BuildCityData_Brooklyn()
{
    $city = GetNewCityObject -Id 4 -Name "Brooklyn"
    
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 353 -Name "Bath Beach" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 354 -Name "Bay Ridge" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 355 -Name "Bedford" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 356 -Name "Bensonhurst" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 357 -Name "Bergen Beach" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 358 -Name "Boerum Hill" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 359 -Name "Borough Park" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 360 -Name "Brighton Beach" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 361 -Name "Brooklyn Heights" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 362 -Name "Brownsville" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 363 -Name "Bushwick" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 364 -Name "Canarsie" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 365 -Name "Carroll Gardens" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 366 -Name "City Line" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 367 -Name "Clinton Hill" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 368 -Name "Cobble Hill" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 369 -Name "Columbia Waterfront" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 370 -Name "Coney Island" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 371 -Name "Crown Heights" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 372 -Name "Cypress Hills" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 373 -Name "Ditmas Park" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 374 -Name "Downtown Brooklyn" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 375 -Name "Dumbo" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 376 -Name "Dyker Heights" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 377 -Name "East Flatbush" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 378 -Name "East New York" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 379 -Name "East Williamsburg" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 380 -Name "Flatbush" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 381 -Name "Flatlands" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 382 -Name "Fort Greene" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 383 -Name "Fort Hamilton" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 384 -Name "Gerritsen Beach" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 385 -Name "Gowanus" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 386 -Name "Gravesend" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 387 -Name "Greenpoint" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 388 -Name "Kensington" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 389 -Name "Manhattan Beach" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 390 -Name "Mapleton" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 391 -Name "Marine Park" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 392 -Name "Midwood" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 393 -Name "Mill Basin" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 394 -Name "Navy Yard" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 395 -Name "New Lots" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 396 -Name "Ocean Hill" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 397 -Name "Park Slope" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 398 -Name "Prospect Heights" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 399 -Name "Prospect-Lefferts Gardens" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 400 -Name "Red Hook" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 401 -Name "Sea Gate" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 402 -Name "Sheepshead Bay" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 403 -Name "South Slope" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 404 -Name "Spring Creek" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 405 -Name "Starrett City" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 406 -Name "Stuyvesant Heights" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 407 -Name "Sunset Park" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 408 -Name "Vinegar Hill" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 409 -Name "Weeksville" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 410 -Name "Williamsburg - Northside" -City "Brooklyn"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 411 -Name "Windsor Terrace" -City "Brooklyn"
    
    return $city
}

function BuildCityData_Oakland()
{
    $city = GetNewCityObject -Id 5 -Name "Oakland"
    
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 539 -Name "Acorn/ Acorn Industrial" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 540 -Name "Adams Point" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 541 -Name "Allendale" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 542 -Name "Arroyo Viejo" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 543 -Name "Bancroft Business/ Havenscourt" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 544 -Name "Bartlett" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 545 -Name "Bella Vista" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 546 -Name "Brookfield Village" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 547 -Name "Bushrod" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 548 -Name "Caballo Hills" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 549 -Name "Castlemont" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 550 -Name "Chabot Park" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 551 -Name "Chinatown" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 552 -Name "Civic Center" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 553 -Name "Claremont" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 554 -Name "Clawson" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 555 -Name "Cleveland Heights" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 556 -Name "Clinton" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 557 -Name "Coliseum" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 558 -Name "Coliseum Industrial" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 559 -Name "Columbia Gardens" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 560 -Name "Cox" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 561 -Name "Crestmont" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 562 -Name "Crocker Highland" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 563 -Name "Dimond" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 564 -Name "Downtown" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 565 -Name "Durant Manor" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 566 -Name "Eastmont" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 567 -Name "Eastmont Hills" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 568 -Name "East Peralta" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 569 -Name "Elmhurst Park" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 570 -Name "Embarcadero" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 571 -Name "Fairfax" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 572 -Name "Fairfax Business" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 573 -Name "Fairview Park" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 574 -Name "Fitchburg" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 575 -Name "Foothill Square" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 576 -Name "Forestland" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 577 -Name "Fremont" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 578 -Name "Frick" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 579 -Name "Fruitvale Station" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 580 -Name "Gaskill" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 581 -Name "Glen Highlands" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 582 -Name "Glenview" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 583 -Name "Golden Gate" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 584 -Name "Grand Lake" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 585 -Name "Harrington" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 586 -Name "Hawthorne" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 587 -Name "Hegenberger" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 588 -Name "Highland" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 589 -Name "Highland Park" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 590 -Name "Highland Terrace" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 591 -Name "Hiller Highlands" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 592 -Name "Hoover-Foster" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 593 -Name "Iveywood" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 594 -Name "Ivy Hill" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 595 -Name "Jefferson" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 596 -Name "Lakeshore" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 597 -Name "Lakewide" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 598 -Name "Las Palmas" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 599 -Name "Laurel" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 600 -Name "Leona Heights" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 601 -Name "Lincoln Highlands" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 602 -Name "Lockwood Tevis" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 603 -Name "Longfellow" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 604 -Name "Maxwell Park" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 605 -Name "Mcclymonds" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 606 -Name "Melrose" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 607 -Name "Merritt" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 608 -Name "Merriwood" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 609 -Name "Mills College" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 610 -Name "Millsmont" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 611 -Name "Montclair" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 612 -Name "Montclair Business" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 613 -Name "Mosswood" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 614 -Name "Northgate" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 615 -Name "North Kennedy Tract" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 616 -Name "North Stonehurst" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 617 -Name "Oak Center" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 618 -Name "Oak Knoll-Golf Links" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 619 -Name "Oakland Ave/ Harrison St" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 620 -Name "Oakmore" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 621 -Name "Oak Tree" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 622 -Name "Old City" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 623 -Name "Panoramic Hill" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 624 -Name "Paradise Park" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 625 -Name "Patten" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 626 -Name "Peralta Hacienda" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 627 -Name "Peralta/ Laney" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 628 -Name "Piedmont" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 629 -Name "Piedmont Avenue" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 630 -Name "Piedmont Pines" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 631 -Name "Pill Hill" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 632 -Name "Prescott" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 633 -Name "Produce & Waterfront" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 634 -Name "Ralph Bunche" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 635 -Name "Rancho San Antonio" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 636 -Name "Redwood Heights" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 637 -Name "Reservoir Hill" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 638 -Name "Rockridge" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 639 -Name "San Pablo Gateway" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 640 -Name "Santa Fe" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 641 -Name "Sausal Creek" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 642 -Name "School" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 643 -Name "Seminary" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 644 -Name "Sequoyah" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 645 -Name "Shafter" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 646 -Name "Sheffield" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 647 -Name "Shepherd Canyon" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 648 -Name "Skyline - Hillcrest Estates" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 649 -Name "Sobrante Park" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 650 -Name "South Kennedy Tract" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 651 -Name "South Prescott" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 652 -Name "South Stonehurst" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 653 -Name "St. Elizabeth" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 654 -Name "Temescal" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 655 -Name "Toler Heights" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 656 -Name "Trestle Glen" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 657 -Name "Tuxedo" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 658 -Name "Upper Dimond" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 659 -Name "Upper Laurel" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 660 -Name "Upper Peralta Creek" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 661 -Name "Upper Rockridge" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 662 -Name "Waverly" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 663 -Name "Webster" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 664 -Name "Woodland" -City "Oakland"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 665 -Name "Woodminster" -City "Oakland"
    
    return $city
}

function BuildCityData_StatenIsland()
{
    $city = GetNewCityObject -Id 6 -Name "Staten Island"
    
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 666 -Name "Annadale" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 667 -Name "Arden Heights" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 668 -Name "Arrochar" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 669 -Name "Bay Terrace" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 670 -Name "Bloomfield" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 671 -Name "Bulls Head" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 672 -Name "Butler Manor" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 673 -Name "Castleton Corners" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 674 -Name "Charleston" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 675 -Name "Chelsea-Travis" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 676 -Name "Clifton" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 677 -Name "Clove Lake" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 678 -Name "Dongan Hills" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 679 -Name "Elm Park" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 680 -Name "Eltingville" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 681 -Name "Emerson Hill" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 682 -Name "Fort Wadsworth" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 683 -Name "Fresh Kills" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 684 -Name "Fresh Kills Park" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 685 -Name "Graniteville" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 686 -Name "Grant City" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 687 -Name "Grasmere - Concord" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 688 -Name "Great Kills" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 689 -Name "Greenridge" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 690 -Name "Grymes Hill" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 691 -Name "Heartland Village" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 692 -Name "Huguenot" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 693 -Name "La Tourette Park" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 694 -Name "Lighthouse Hill" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 695 -Name "Mariner'S Harbor" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 696 -Name "Meiers Corners" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 697 -Name "Midland Beach" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 698 -Name "New Brighton" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 699 -Name "New Dorp" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 700 -Name "New Dorp Beach" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 701 -Name "New Springville" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 702 -Name "Oakwood" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 703 -Name "Old Town" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 704 -Name "Park Hill" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 705 -Name "Pleasant Plains" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 706 -Name "Port Ivory" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 707 -Name "Port Richmond" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 708 -Name "Prince'S Bay" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 709 -Name "Randall Manor" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 710 -Name "Richmond Town" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 711 -Name "Richmond Valley" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 712 -Name "Rosebank" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 713 -Name "Rossville" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 714 -Name "Shore Acres" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 715 -Name "Silver Lake" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 716 -Name "South Beach" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 717 -Name "Stapleton" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 718 -Name "St. George" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 719 -Name "Sunnyside" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 720 -Name "Todt Hill" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 721 -Name "Tompkinsville" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 722 -Name "Tottenville" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 723 -Name "West Brighton" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 724 -Name "Westerleigh" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 725 -Name "Willowbrook" -City "Staten Island"
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 726 -Name "Woodrow" -City "Staten Island"
    
    return $city
}

function BuildCityData_Bakersfield()
{
    $city = GetNewCityObject -Id 7 -Name "Bakersfield" -AutoMapping $true
    
    $city.Colors += GetNewMouseLocationObject -X 1210 -Y 809 -Name "9"
    $city.Colors += GetNewMouseLocationObject -X 1210 -Y 850 -Name "20"
    $city.Colors += GetNewMouseLocationObject -X 1210 -Y 894 -Name "30"
    $city.Colors += GetNewMouseLocationObject -X 1210 -Y 932 -Name "40"
    $city.Colors += GetNewMouseLocationObject -X 1210 -Y 970 -Name "50"
    $city.Colors += GetNewMouseLocationObject -X 1455 -Y 804 -Name "60"
    $city.Colors += GetNewMouseLocationObject -X 1455 -Y 851 -Name "70"
    $city.Colors += GetNewMouseLocationObject -X 1455 -Y 887 -Name "80"
    $city.Colors += GetNewMouseLocationObject -X 1455 -Y 935 -Name "90"
    $city.Colors += GetNewMouseLocationObject -X 1455 -Y 974 -Name "99"
    $city.Colors += GetNewMouseLocationObject -X 1210 -Y 758 -Name "100"
    
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 727 -Name "42Nd Street" -City "Bakersfield" -X 539 -Y 839
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 728 -Name "Amberton" -City "Bakersfield" -X 638 -Y 547
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 729 -Name "Artisan" -City "Bakersfield" -X 470 -Y 779
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 730 -Name "Avalon" -City "Bakersfield" -X 438 -Y 172
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 731 -Name "Bakersfield Country Club" -City "Bakersfield" -X 1228 -Y 365
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 732 -Name "Belsera" -City "Bakersfield" -X 311 -Y 219
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 733 -Name "Benton Park" -City "Bakersfield" -X 869 -Y 590
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 734 -Name "Campus Park" -City "Bakersfield" -X 545 -Y 764
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 735 -Name "Castle Ranch" -City "Bakersfield" -X 960 -Y 935
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 736 -Name "Central Bakersfield" -City "Bakersfield" -X 790 -Y 609
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 737 -Name "City In The Hills" -City "Bakersfield" -X 1451 -Y 237
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 738 -Name "College Heights" -City "Bakersfield" -X 1072 -Y 290
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 739 -Name "Cottonwood" -City "Bakersfield" -X 1013 -Y 562
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 740 -Name "Crystal Ranch" -City "Bakersfield" -X 476 -Y 222
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 741 -Name "Downtown" -City "Bakersfield" -X 929 -Y 362
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 742 -Name "East Bakersfield" -City "Bakersfield" -X 1023 -Y 391
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 743 -Name "Eastridge Estates" -City "Bakersfield" -X 1302 -Y 390
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 744 -Name "Emerald Estates" -City "Bakersfield" -X 405 -Y 255
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 745 -Name "Fairway Oaks" -City "Bakersfield" -X 465 -Y 442
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 746 -Name "Fox Run" -City "Bakersfield" -X 400 -Y 220
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 747 -Name "Fruitvale" -City "Bakersfield" -X 635 -Y 256
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 748 -Name "Greenfield" -City "Bakersfield" -X 970 -Y 839
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 749 -Name "Haggin Oaks" -City "Bakersfield" -X 553 -Y 534
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 750 -Name "Hampton Woods" -City "Bakersfield" -X 479 -Y 145
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 751 -Name "Hidden Oak" -City "Bakersfield" -X 385 -Y 811
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 752 -Name "Highgate" -City "Bakersfield" -X 275 -Y 588
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 753 -Name "Hillcrest" -City "Bakersfield" -X 1169 -Y 339
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 754 -Name "Homaker Park" -City "Bakersfield" -X 941 -Y 286
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 755 -Name "Kern City" -City "Bakersfield" -X 700 -Y 536
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 756 -Name "La Cresta" -City "Bakersfield" -X 1007 -Y 299
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 757 -Name "Lakeview" -City "Bakersfield" -X 1028 -Y 468
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 758 -Name "Laurel Glen" -City "Bakersfield" -X 628 -Y 645
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 759 -Name "Legacy" -City "Bakersfield" -X 261 -Y 476
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 760 -Name "Liberty" -City "Bakersfield" -X 620 -Y 822
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 761 -Name "Madison Grove" -City "Bakersfield" -X 475 -Y 186
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 762 -Name "Mondavi" -City "Bakersfield" -X 536 -Y 382
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 763 -Name "Morning Star" -City "Bakersfield" -X 1368 -Y 246
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 764 -Name "Mountain Meadows" -City "Bakersfield" -X 1439 -Y 326
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 765 -Name "Nottingham Estates" -City "Bakersfield" -X 399 -Y 182
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 766 -Name "Oakridge" -City "Bakersfield" -X 1168 -Y 453
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 767 -Name "Oleander/Sunset" -City "Bakersfield" -X 905 -Y 457
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 768 -Name "Olive Drive Area" -City "Bakersfield" -X 586 -Y 151
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 769 -Name "Park Avenue" -City "Bakersfield" -X 462 -Y 834
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 770 -Name "Park Stockdale" -City "Bakersfield" -X 685 -Y 435
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 771 -Name "Pheasant Run" -City "Bakersfield" -X 549 -Y 441
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 772 -Name "Polo Grounds" -City "Bakersfield" -X 537 -Y 315
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 773 -Name "Quailwood" -City "Bakersfield" -X 637 -Y 429
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 774 -Name "Rexland Acres" -City "Bakersfield" -X 1032 -Y 714
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 775 -Name "Ridgeview Estates" -City "Bakersfield" -X 703 -Y 836
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 776 -Name "Rio Bravo" -City "Bakersfield" -X 1631 -Y 249
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 777 -Name "Riverlakes" -City "Bakersfield" -X 582 -Y 213
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 778 -Name "River Oaks" -City "Bakersfield" -X 391 -Y 544
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 779 -Name "Riviera/Westcheste" -City "Bakersfield" -X 840 -Y 379
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 780 -Name "Sagepointe" -City "Bakersfield" -X 695 -Y 603
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 781 -Name "San Lauren" -City "Bakersfield" -X 792 -Y 297
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 782 -Name "San Trope" -City "Bakersfield" -X 542 -Y 225
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 783 -Name "Seven Oaks" -City "Bakersfield" -X 461 -Y 574
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 784 -Name "Seven Oaks At Grand Island" -City "Bakersfield" -X 403 -Y 612
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 785 -Name "Shiloh Estates" -City "Bakersfield" -X 255 -Y 409
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 786 -Name "Silver Creek" -City "Bakersfield" -X 627 -Y 742
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 787 -Name "West Bakersfield" -City "Bakersfield" -X 352 -Y 327
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 788 -Name "Southern Oaks" -City "Bakersfield" -X 468 -Y 704
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 789 -Name "Southgate" -City "Bakersfield" -X 930 -Y 582
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 790 -Name "South San Lauren" -City "Bakersfield" -X 695 -Y 310
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 791 -Name "Spice Tract" -City "Bakersfield" -X 697 -Y 653
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 792 -Name "Stockdale West" -City "Bakersfield" -X 283 -Y 521
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 793 -Name "Stone Creek" -City "Bakersfield" -X 755 -Y 900
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 794 -Name "Stonegate" -City "Bakersfield" -X 795 -Y 867
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 795 -Name "Stone Meadows" -City "Bakersfield" -X 844 -Y 876
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 796 -Name "Terra Vista" -City "Bakersfield" -X 466 -Y 743
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 797 -Name "Tevis Ranch" -City "Bakersfield" -X 467 -Y 664
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 798 -Name "The Oaks" -City "Bakersfield" -X 551 -Y 678
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 799 -Name "The Seasons" -City "Bakersfield" -X 702 -Y 746
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 800 -Name "Tuscany" -City "Bakersfield" -X 1586 -Y 183
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 801 -Name "Tyner Homes" -City "Bakersfield" -X 1273 -Y 542
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 802 -Name "Villages Of Brimhall/Brimhall Classics" -City "Bakersfield" -X 404 -Y 479
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 803 -Name "Vonola" -City "Bakersfield" -X 860 -Y 755
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 804 -Name "West Park Community" -City "Bakersfield" -X 751 -Y 424
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 805 -Name "Windsong" -City "Bakersfield" -X 589 -Y 375
    
    return $city
}

function BuildCityData_Chicago()
{
    $city = GetNewCityObject -Id 8 -Name "Chicago" -AutoMapping $true
    
    $city.Colors += GetNewMouseLocationObject -X 692 -Y 906 -Name "9"
    $city.Colors += GetNewMouseLocationObject -X 692 -Y 925 -Name "20"
    $city.Colors += GetNewMouseLocationObject -X 692 -Y 942 -Name "30"
    $city.Colors += GetNewMouseLocationObject -X 692 -Y 961 -Name "40"
    $city.Colors += GetNewMouseLocationObject -X 692 -Y 980 -Name "50"
    $city.Colors += GetNewMouseLocationObject -X 805 -Y 906 -Name "60"
    $city.Colors += GetNewMouseLocationObject -X 805 -Y 925 -Name "70"
    $city.Colors += GetNewMouseLocationObject -X 805 -Y 942 -Name "80"
    $city.Colors += GetNewMouseLocationObject -X 805 -Y 962 -Name "90"
    $city.Colors += GetNewMouseLocationObject -X 805 -Y 979 -Name "99"
    $city.Colors += GetNewMouseLocationObject -X 692 -Y 885 -Name "100"

    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 806 -Name "Albany Park" -City "Chicago" -X 964 -Y 261
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 807 -Name "Andersonville" -City "Chicago" -X 1051 -Y 225
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 808 -Name "Archer Heights" -City "Chicago" -X 949 -Y 621
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 809 -Name "Armour Square" -City "Chicago" -X 1110 -Y 562
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 810 -Name "Ashburn" -City "Chicago" -X 979 -Y 773
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 811 -Name "Auburn Gresham" -City "Chicago" -X 1067 -Y 773
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 812 -Name "Austin" -City "Chicago" -X 894 -Y 443
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 813 -Name "Avalon Park" -City "Chicago" -X 1193 -Y 766
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 814 -Name "Avondale" -City "Chicago" -X 975 -Y 323
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 815 -Name "Belmont Cragin" -City "Chicago" -X 889 -Y 351
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 816 -Name "Beverly" -City "Chicago" -X 1046 -Y 855
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 817 -Name "Boystown" -City "Chicago" -X 1088 -Y 314
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 818 -Name "Bridgeport" -City "Chicago" -X 1081 -Y 549
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 819 -Name "Brighton Park" -City "Chicago" -X 999 -Y 612
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 820 -Name "Bucktown" -City "Chicago" -X 1032 -Y 364
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 821 -Name "Burnside" -City "Chicago" -X 1174 -Y 810
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 822 -Name "Calumet Heights" -City "Chicago" -X 1204 -Y 802
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 823 -Name "Chatham" -City "Chicago" -X 1137 -Y 782
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 824 -Name "Chicago Lawn" -City "Chicago" -X 1008 -Y 701
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 825 -Name "Chinatown" -City "Chicago" -X 1105 -Y 521
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 826 -Name "Clearing" -City "Chicago" -X 894 -Y 692
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 827 -Name "Douglas" -City "Chicago" -X 1139 -Y 567
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 828 -Name "Dunning" -City "Chicago" -X 815 -Y 304
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 829 -Name "East Side" -City "Chicago" -X 1286 -Y 837
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 830 -Name "East Village" -City "Chicago" -X 1042 -Y 413
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 831 -Name "Edgewater" -City "Chicago" -X 1058 -Y 205
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 832 -Name "Edison Park" -City "Chicago" -X 796 -Y 157
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 833 -Name "Englewood" -City "Chicago" -X 1074 -Y 707
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 834 -Name "Fuller Park" -City "Chicago" -X 1112 -Y 623
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 835 -Name "Gage Park" -City "Chicago" -X 1004 -Y 654
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 836 -Name "Galewood" -City "Chicago" -X 828 -Y 380
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 837 -Name "Garfield Park" -City "Chicago" -X 963 -Y 463
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 838 -Name "Garfield Ridge" -City "Chicago" -X 884 -Y 661
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 839 -Name "Gold Coast" -City "Chicago" -X 1120 -Y 397
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 840 -Name "Grand Boulevard" -City "Chicago" -X 1134 -Y 616
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 841 -Name "Grand Crossing" -City "Chicago" -X 1136 -Y 729
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 842 -Name "Grant Park" -City "Chicago" -X 1133 -Y 468
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 843 -Name "Greektown" -City "Chicago" -X 1085 -Y 459
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 844 -Name "Hegewisch" -City "Chicago" -X 1268 -Y 986
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 845 -Name "Hermosa" -City "Chicago" -X 935 -Y 360
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 846 -Name "Humboldt Park" -City "Chicago" -X 971 -Y 412
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 847 -Name "Hyde Park" -City "Chicago" -X 1177 -Y 656
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 848 -Name "Irving Park" -City "Chicago" -X 945 -Y 287
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 849 -Name "Jackson Park" -City "Chicago" -X 1200 -Y 686
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 850 -Name "Jefferson Park" -City "Chicago" -X 872 -Y 241
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 851 -Name "Kenwood" -City "Chicago" -X 1175 -Y 618
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 852 -Name "Lake View" -City "Chicago" -X 1065 -Y 323
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 853 -Name "Lincoln Park" -City "Chicago" -X 1104 -Y 356
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 854 -Name "Lincoln Square" -City "Chicago" -X 1017 -Y 250
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 855 -Name "Little Italy" -City "Chicago" -X 1033 -Y 488
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 856 -Name "Little Village" -City "Chicago" -X 975 -Y 559
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 857 -Name "Logan Square" -City "Chicago" -X 973 -Y 358
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 858 -Name "Loop" -City "Chicago" -X 1116 -Y 456
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 859 -Name "Lower West Side" -City "Chicago" -X 1034 -Y 537
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 860 -Name "Magnificent Mile" -City "Chicago" -X 1126 -Y 419
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 861 -Name "Mckinley Park" -City "Chicago" -X 1037 -Y 578
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 862 -Name "Millenium Park" -City "Chicago" -X 1133 -Y 449
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 863 -Name "Montclare" -City "Chicago" -X 825 -Y 346
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 864 -Name "Morgan Park" -City "Chicago" -X 1042 -Y 902
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 865 -Name "Mount Greenwood" -City "Chicago" -X 984 -Y 889
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 866 -Name "Museum Campus" -City "Chicago" -X 1140 -Y 493
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 867 -Name "Near South Side" -City "Chicago" -X 1124 -Y 504
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 868 -Name "New City" -City "Chicago" -X 1056 -Y 609
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 869 -Name "North Center" -City "Chicago" -X 1026 -Y 304
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 870 -Name "North Lawndale" -City "Chicago" -X 959 -Y 505
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 871 -Name "North Park" -City "Chicago" -X 960 -Y 214
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 872 -Name "Norwood Park" -City "Chicago" -X 811 -Y 212
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 873 -Name "Oakland" -City "Chicago" -X 1166 -Y 588
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 874 -Name "O'Hare" -City "Chicago" -X 742 -Y 231
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 875 -Name "Old Town" -City "Chicago" -X 1101 -Y 393
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 876 -Name "Portage Park" -City "Chicago" -X 885 -Y 298
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 877 -Name "Printers Row" -City "Chicago" -X 1118 -Y 480
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 878 -Name "Pullman" -City "Chicago" -X 1169 -Y 854
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 879 -Name "Riverdale" -City "Chicago" -X 1152 -Y 976
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 880 -Name "River North" -City "Chicago" -X 1103 -Y 420
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 881 -Name "Rogers Park" -City "Chicago" -X 1048 -Y 165
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 882 -Name "Roseland" -City "Chicago" -X 1121 -Y 872
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 883 -Name "Rush & Division" -City "Chicago" -X 1116 -Y 412
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 884 -Name "Sauganash" -City "Chicago" -X 898 -Y 198
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 885 -Name "Sheffield & Depaul" -City "Chicago" -X 1075 -Y 349
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 886 -Name "South Chicago" -City "Chicago" -X 1252 -Y 779
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 887 -Name "South Deering" -City "Chicago" -X 1229 -Y 878
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 888 -Name "South Shore" -City "Chicago" -X 1212 -Y 731
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 889 -Name "Streeterville" -City "Chicago" -X 1134 -Y 420
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 890 -Name "Ukrainian Village" -City "Chicago" -X 1016 -Y 414
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 891 -Name "United Center" -City "Chicago" -X 1032 -Y 453
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 892 -Name "Uptown" -City "Chicago" -X 1070 -Y 266
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 893 -Name "Washington Heights" -City "Chicago" -X 1089 -Y 841
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 894 -Name "Washington Park" -City "Chicago" -X 1140 -Y 660
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 895 -Name "West Elsdon" -City "Chicago" -X 956 -Y 664
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 896 -Name "West Lawn" -City "Chicago" -X 953 -Y 710
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 897 -Name "West Loop" -City "Chicago" -X 1065 -Y 450
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 898 -Name "West Pullman" -City "Chicago" -X 1117 -Y 938
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 899 -Name "West Ridge" -City "Chicago" -X 1005 -Y 189
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 900 -Name "West Town" -City "Chicago" -X 1068 -Y 425
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 901 -Name "Wicker Park" -City "Chicago" -X 1022 -Y 393
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 902 -Name "Woodlawn" -City "Chicago" -X 1167 -Y 694
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 903 -Name "Wrigleyville" -City "Chicago" -X 1067 -Y 296
    
    return $city
}

function BuildCityData_Cleveland()
{
    $city = GetNewCityObject -Id 9 -Name "Cleveland" -AutoMapping $true
    
    $city.Colors += GetNewMouseLocationObject -X 377 -Y 222 -Name "9"
    $city.Colors += GetNewMouseLocationObject -X 377 -Y 260 -Name "20"
    $city.Colors += GetNewMouseLocationObject -X 377 -Y 305 -Name "30"
    $city.Colors += GetNewMouseLocationObject -X 377 -Y 341 -Name "40"
    $city.Colors += GetNewMouseLocationObject -X 377 -Y 385 -Name "50"
    $city.Colors += GetNewMouseLocationObject -X 622 -Y 219 -Name "60"
    $city.Colors += GetNewMouseLocationObject -X 622 -Y 263 -Name "70"
    $city.Colors += GetNewMouseLocationObject -X 622 -Y 311 -Name "80"
    $city.Colors += GetNewMouseLocationObject -X 622 -Y 344 -Name "90"
    $city.Colors += GetNewMouseLocationObject -X 622 -Y 386 -Name "99"
    $city.Colors += GetNewMouseLocationObject -X 377 -Y 170 -Name "100"
    
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 904 -Name "Bellaire-Puritas" -City "Cleveland" -X 597 -Y 936
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 905 -Name "Broadway-Slavic Village" -City "Cleveland" -X 1182 -Y 800
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 906 -Name "Brooklyn Centre" -City "Cleveland" -X 952 -Y 798
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 907 -Name "Buckeye Shaker" -City "Cleveland" -X 1364 -Y 656
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 908 -Name "Central" -City "Cleveland" -X 1166 -Y 603
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 909 -Name "Clark Fulton" -City "Cleveland" -X 946 -Y 712
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 910 -Name "Collinwood Nottingham" -City "Cleveland" -X 1431 -Y 296
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 911 -Name "Cudell" -City "Cleveland" -X 751 -Y 702
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 912 -Name "Cuyahoga Valley" -City "Cleveland" -X 1075 -Y 714
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 913 -Name "Detroit-Shoreway" -City "Cleveland" -X 854 -Y 658
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 914 -Name "Downtown" -City "Cleveland" -X 1001 -Y 557
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 915 -Name "Edgewater" -City "Cleveland" -X 744 -Y 651
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 916 -Name "Euclid Green" -City "Cleveland" -X 1498 -Y 330
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 917 -Name "Fairfax" -City "Cleveland" -X 1248 -Y 590
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 918 -Name "Glenville" -City "Cleveland" -X 1302 -Y 401
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 919 -Name "Goodrich-Kirtland Park" -City "Cleveland"  -X 1112 -Y 506
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 920 -Name "Hopkins" -City "Cleveland" -X 406 -Y 963
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 921 -Name "Hough" -City "Cleveland" -X 1201 -Y 507
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 922 -Name "Jefferson" -City "Cleveland" -X 637 -Y 809
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 923 -Name "Kamms Corners" -City "Cleveland" -X 491 -Y 889
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 924 -Name "Kinsman" -City "Cleveland" -X 1249 -Y 696
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 925 -Name "Lee-Harvard" -City "Cleveland" -X 1503 -Y 833
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 926 -Name "Lee-Seville" -City "Cleveland" -X 1491 -Y 899
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 927 -Name "Mount Pleasant" -City "Cleveland" -X 1403 -Y 750
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 928 -Name "North Shore Collinwood" -City "Cleveland" -X 1451 -Y 214
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 929 -Name "Ohio City" -City "Cleveland" -X 932 -Y 666
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 930 -Name "Old Brooklyn" -City "Cleveland" -X 915 -Y 912
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 931 -Name "Saint Clair-Superior" -City "Cleveland" -X 1187 -Y 439
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 932 -Name "Stockyards" -City "Cleveland" -X 866 -Y 757
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 933 -Name "Tremont" -City "Cleveland" -X 1013 -Y 687
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 934 -Name "Union-Miles Park" -City "Cleveland" -X 1375 -Y 828
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 935 -Name "University Circle" -City "Cleveland" -X 1315 -Y 539
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 936 -Name "West Boulevard" -City "Cleveland" -X 751 -Y 760
    $city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 937 -Name "Woodland Hills" -City "Cleveland" -X 1286 -Y 662
    
    return $city
}

#endregion /* Data */

#region /* Console Display Functions */

function WriteDownloadProgress()
{
    param(
        [Object[]] $Jobs,
        [int] $Count
    )
    $percentComplete = [math]::Round((($Jobs | Where-Object { $_.State -eq "Completed" }).Count /$Count)*100, 2)
    Write-Progress -Activity "Downloading" -Status "$($percentComplete)% Complete:" -PercentComplete $percentComplete
}

function GetCity()
{
    param(
        [Object[]]$Cities
    )
    Write-host "Select a City: "
    Write-Host ""

    foreach($item in $Cities)
    {
        Write-host "  $($item.Id) " -foregroundColor "Yellow" -NoNewLine
        Write-Host "- $($item.Name)" -foregroundColor "Cyan" -NoNewline
        
        if($item.AutoMapping)
        {
            Write-host " *Auto Map Supported* " -ForegroundColor "Red"
        }
        else
        {
            Write-Host ""
        }
    }

    Write-Host ""

    $cityNum = Read-host "City Number"

    foreach($item in $Cities)
    {
        if($cityNum -eq $item.Id)
        {
            return $item
        }
    }

    throw "Invalid City!"
}

#endregion /* Console Display Functions */

function GetCityData()
{
    param(
        [Object]$CityObject
    )

    $data = @()
    $runningJobs = @()
    $hoodCount = $CityObject.Neighborhoods.Count

    foreach($hood in $CityObject.Neighborhoods)
    { 
        WriteDownloadProgress -Jobs $runningJobs -Count $hoodCount
    
        $uri = "https://api.up2land.com/neighborhood_deepinfo/$($hood.Id)"

        while(($runningJobs | Where-Object { $_.State -eq "Running" }).Count -ge 10)
        {
            Start-Sleep -Milliseconds 500
        }

        $jobScriptBlock = {
            param(
                [String] $Uri,
                [Object] $HoodObject
            )

            $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
            $headers.Add('Origin','https://upx.world')
            $headers.Add('Referer','https://upx.world/')
            $headers.Add('User-Agent','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36')
            $headers.Add('Accept','application/json')
            $headers.Add('sec-ch-ua','" Not;A Brand";v="99", "Google Chrome";v="91", "Chromium";v="91"')
            $headers.Add('sec-ch-ua-mobile','?0')
            $headers.Add('Sec-Fetch-Site','cross-site')
            $headers.Add('Sec-Fetch-Mode','cors')
            $headers.Add('Sec-Fetch-Dest','empty')
            $headers.Add('Accept-Language','en-US,en;q=0.9')
            $headers.Add('Host','api.up2land.com')

            $result = Invoke-WebRequest -Method Get -Uri $Uri -Headers $headers

            $jsonResult = $result.Content| ConvertFrom-Json

            if($jsonResult.Status -eq "success")
            {
                $HoodObject.Unminted = $jsonResult.data.deepInfo.Unminted
                $HoodObject.Minted = $jsonResult.data.deepInfo.Minted
                $HoodObject.Locked = $jsonResult.data.deepInfo.Locked
                $HoodObject.ForSale = $jsonResult.data.deepInfo.ForSale

                $totalProps = $HoodObject.Minted + $HoodObject.Locked + $HoodObject.Unminted
                if($totalProps -eq 0)
                {
                    $HoodObject.PercentMinted = 100
                }
                else
                {
                    $HoodObject.PercentMinted = [Math]::Round($HoodObject.Minted * 100 / $totalProps)
                }

                if($HoodObject.Unminted -eq 0 -and $HoodObject.Locked -gt 0)
                {
                    $HoodObject.OnlyLocked = $true
                }
            }

            return $HoodObject
        }
            
        $runningJobs += Start-Job -ScriptBlock $jobScriptBlock -ArgumentList  $uri, $hood
    }

    while(($runningJobs | Where-Object { $_.State -ne "Completed" }).Count -ge 1)
    {
        Start-Sleep -Milliseconds 500
        WriteDownloadProgress -Jobs $runningJobs -Count $hoodCount
    }

    foreach($job in $runningJobs)
    {
        $jobResult = Receive-Job $job
        
        foreach($hood in $CityObject.Neighborhoods)
        {
            if($hood.Id -eq $jobResult.Id)
            {
                $hood.Unminted = $jobResult.Unminted
                $hood.Minted = $jobResult.Minted
                $hood.Locked = $jobResult.Locked
                $hood.ForSale = $jobResult.ForSale
                $hood.PercentMinted = $jobResult.PercentMinted
                $hood.OnlyLocked = $jobResult.OnlyLocked
                break
            }
        }
    }

    return $CityObject
}

function ClickCorrectColor()
{
    param(
        [Object]$Hood,
        [Object[]]$Colors
    )

    $color = $null

    if($hood.PercentMinted -eq 100 -or $hood.OnlyLocked)
    {
        $color = $Colors | Where-Object {$_.Name -eq "100" }
    }
    elseif($hood.PercentMinted -lt 10)
    {
        $color = $Colors | Where-Object {$_.Name -eq "9" }
    }
    elseif($hood.PercentMinted -le 20)
    {
        $color = $Colors | Where-Object {$_.Name -eq "20" }
    }
    elseif($hood.PercentMinted -le 30)
    {
        $color = $Colors | Where-Object {$_.Name -eq "30" }
    }
    elseif($hood.PercentMinted -le 40)
    {
        $color = $Colors | Where-Object {$_.Name -eq "40" }
    }
    elseif($hood.PercentMinted -le 50)
    {
        $color = $Colors | Where-Object {$_.Name -eq "50" }
    }
    elseif($hood.PercentMinted -le 60)
    {
        $color = $Colors | Where-Object {$_.Name -eq "60" }
    }
    elseif($hood.PercentMinted -le 70)
    {
        $color = $Colors | Where-Object {$_.Name -eq "70" }
    }
    elseif($hood.PercentMinted -le 80)
    {
        $color = $Colors | Where-Object {$_.Name -eq "80" }
    }
    elseif($hood.PercentMinted -le 90)
    {
        $color = $Colors | Where-Object {$_.Name -eq "90" }
    }
    elseif($hood.PercentMinted -le 99)
    {
        $color = $Colors | Where-Object {$_.Name -eq "99" }
    }

    if($color -eq $null)
    {
        [Clicker]::LeftClickAtPoint($hood.X, $hood.Y)
    }
    else
    {
        [Clicker]::LeftClickAtPoint($color.X, $color.Y)
    }

}

function DrawMap()
{
    param(
        [Object]$City
    )

    Add-Type -TypeDefinition $GLOBAL:DRAWCODE -ReferencedAssemblies System.Windows.Forms,System.Drawing

    $Tools = GetTools 

    $sleepTime = 100

    foreach($hood in $City.Neighborhoods)
    {
        [Clicker]::LeftClickAtPoint($Tools.Pipette.X, $Tools.Pipette.Y)
        Start-Sleep -Milliseconds $sleepTime
        ClickCorrectColor -Hood $hood -Colors $City.Colors
        Start-Sleep -Milliseconds $sleepTime
        [Clicker]::LeftClickAtPoint($Tools.Fill.X, $Tools.Fill.Y)
        Start-Sleep -Milliseconds $sleepTime
        [Clicker]::LeftClickAtPoint($hood.X, $hood.Y)
        Start-Sleep -Milliseconds $sleepTime
    }
}

function MainScriptFunction()
{
    $cities = BuildCityData

    $city = GetCity -Cities $cities

    $city = GetCityData -CityObject $city

    Write-Host ""
    Write-Host "Found " -ForegroundColor Cyan -NoNewline
    Write-Host "$($city.Neighborhoods.Count)" -ForegroundColor Yellow -NoNewline
    Write-Host " Neighborhoods in " -ForegroundColor Cyan -NoNewline
    Write-Host "$($city.Name)" -ForegroundColor Yellow
    Write-Host ""

    $city.Neighborhoods | Sort-Object -Property PercentMinted -Descending | Select-Object -Property Name, PercentMinted, OnlyLocked

    if($city.AutoMapping)
    {
        DrawMap -City $city
    }
}

MainScriptFunction
