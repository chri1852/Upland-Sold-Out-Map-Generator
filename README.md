# Upland-Sold-Out-Map-Generator

## Instructions

To use you will need to have Paint.Net installed, and be on a windows machine. The map painting works via ordering mouse clicks via the script, so it is critical that you have Paint.Net open on your main monitor at a resolution of 1920x1080. When you run the script make sure that the blank map image and the tools bar on Paint.Net are not covered by any other window. Follow the below steps to run the script:

1. Open Paint.Net on your primary monitor, and ensure the tools bar is visable.
2. Open the CityName_Auto.png file for the city you want to run.
3. Open Powershell (ISE or Terminal) and run the BuildNeighborhoodMap.ps1 script.
4. Select the City you wish to build by typing the cooresponding number and pressing enter.
5. The script will then download the data from UPX.World.
6. Once the download is complete it will begin to fill in the map. **DO NOT MOVE THE MOUSE DURING THIS TIME**
7. Once the map is filled in the script will finish, update the date on the map and save it as a new file, and you are done.

## Notes

If your screen is a different resolution, or the mapping is not working right, you may need to update the coordinates in the script. These can be found in the DATA region of the script. The X and Y locations can be found by using the included GetMousePositions.ps1 file. Simple point your mouse to where you want the click to happen and run the script by pressing F5. I added an offset of +6 to X and Y based on what I noticed on my machine, you may need to adjuest this.

## Adding a new City With No Mapping

To add a new city first create a new line in the BuildCityData function following the pattern below. For example:
  ```
  $cities += BuildCityData_Sheboygan
  ```
Then Create a new function, BuildCityData_Sheboygan,  This will be similar to the other build cities functions. Next you will need to scrape the Neighborhood data from UPX.World. This can be done by running Fiddler, a program the watches and displays web calls your computer makes, and then going to Upx.World. Look for a call to Host api.up2land.com, and a URL of /config/frontend. Open the inspector for that call and click on JSON for the response. Chances are the response body is encoded, so click the decode button. Once the decoding is done you should see a JSON object in the JSON tab with two items data, and status=success. Expand data --> neighborhoods, or click expand all. Use the below table to map the data in the JSON to a Neighborhood object:

| Upx.World Value | Neighborhood Object Value |
|-|-|
| value | Id |
| city_name | City |
| text (before comma) | Name |

For each neighborhood in the new city you should have a new entry on the city.neighborhood object in the BuildCityData_Sheboygan function that looks like this:

```
$city.Neighborhoods += GetNewNeighborhoodInfoObject -Id 726 -Name "Downtown" -City "Sheboygan"
```

Once that is done you should be all set. Simply run the script and your new city will be available as an option.

## Adding Mapping to an Existing City

If you want to add mapping to an existing city that does not have it, first you will need to add a new CityName_Auto.png file for that city. Next you will need to open it in Paint.Net, and use the GetMousePositions.ps1 script to add a X and Y coordinate for each Neighbood to the script. You will also need to create a new set of color objects to add locations for the map colors for that City, an example of this can be seen in the BuildCityData function for any city that has automapping enabled. Finally once that is done add a -AutoMapping $true flag to the cooresponding city in its BuildCityData function.
