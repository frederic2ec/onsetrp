//Author: Pindrought
//THIS CODE NEEDS TO BE CLEANED UP - IT IS A MESS 
window.onload = OnLoad;
//The "legendKeys" array stores all of the keys that appear on the legend. Each key element also stores an array of "blips" that can appear on the map if the legend key is enabled.
var legendKeys = []; //Legend keys
//Map width/height is required in order for the scaling to be properly applied.
var mapWidth = 2000;
var mapHeight = 1943;
//Mouse x,y are stored for things like scrolling to scroll towards/out from a certain position
var mousePosX = 0;
var mousePosY = 0;
//Initial mouse x & y when dragging to calculate dx and dy
var mouseStartDragX = 0;
var mouseStartDragY = 0;
//Map div beginning x & y when dragging
var minimapdivStartDragX = 0;
var minimapdivStartDragY = 0;
var minimapdivX = -40;
var minimapdivY = -431;
var mapScale = 1;
//runningFromBrowser will be determined OnLoad and special logic can be called for debugging via browser
var runningFromBrowser = true;
var mapOrientation = -90; //Default is 0, but if you want to change it to rotate the map, here is where you would do that. Expected input is in degrees. ex. 90
var playerX = 0;
var playerY = 0;
var minimapOffsetX = 130;
var minimapOffsetY = 130;

function OnLoad()
{
    if (typeof ue !== 'undefined') //Determine if we're running from browser. If this is not undefined, we are running from game.
    {
        runningFromBrowser = false;
    }

    var bgMaskCanvas = document.getElementById('backgroundMaskCanvas');
    var ctx = bgMaskCanvas.getContext("2d");
    ctx.fillStyle = "rgb(21, 85, 186)";
    ctx.fillRect(0, 0, backgroundMaskCanvas.width, backgroundMaskCanvas.height);

    window.addEventListener('keydown', KeyDown); //keydown to close map with callback when 'M' is pressed
    RefreshMap(mapScale); //Adjust/position the map accordingly.

    if (runningFromBrowser) //Setup stuff that game would normally set up for testing in browser
    {
        RegisterLegendKey('market', 'Market', 'icons/shopping-cart.png');
        //RegisterBlip('market', 129000, 78521);

        RegisterLegendKey('gunstore', 'Gun Store', 'icons/shield.png');
        RegisterBlip('gunstore', 101527, -34633);
        //RegisterBlip('gunstore', 135200, 192240);

        UpdatePlayerPosition(101527, -34633, 0, 1);

        
    }
    
    CallEvent('OnMinimapUILoaded', null); //Call event to main.lua so that it knows that the web ui is loaded. The main.lua needs to know before attempting to send data like legend data, because it is invalid behavior to ExecuteJS before the web ui is loaded.
}

function KeyDown(e) 
{
    var keyCode = e.keyCode; //Get code of key pressed
    if (keyCode==77) //77 = M - If the user presses M, we can Call an event to main.lua to close the map since the input will not be received by main.lua while ui is focused.
    {
        CallEvent('CloseMap', null);
    }
}

function UpdateMousePos(e)
{
    mousePosX = e.clientX;
    mousePosY = e.clientY;
}

function UpdateDestination(worldX, worldY)
{
    var destinationMarker = document.getElementById('destinationmarker')
    var worldCoords = {}
    worldCoords[0] = worldX;
    worldCoords[1] = worldY;
    destinationMarker.worldX = worldCoords[0]; //Store world X for destination marker - this is used when recalculating mapdiv position due to scrolling in/out
    destinationMarker.worldY = worldCoords[1]; //Store world Y for destination marker - this is used when recalculating mapdiv position due to scrolling in/out
    var coords = { };
    coords[0] = MapHelper.WorldToMapImgX(destinationMarker.worldX);
    coords[1] = MapHelper.WorldToMapImgY(destinationMarker.worldY);
    coords = MapHelper.AdjustCoordinatesForMapOrientation(coords);
    destinationMarker.style.left = (coords[0] * mapScale + minimapdivX  - 16) + 'px';
    destinationMarker.style.top = (coords[1] * mapScale + minimapdivY  - 32) + 'px';
    destinationMarker.style.display = "block"; //Show destination marker
}

function ClearDestination()
{
    var destinationMarker = document.getElementById('destinationmarker')
    destinationMarker.style.display = "none"; //Hide destination marker
}

function RefreshMap(prevMapScale) //This is intended to be called after scaling the map to recalculate the dx/dy offsets and reposition the map accordingly.
{
    var map = document.getElementById('mapimg');
    var minimapdiv = document.getElementById('minimapdiv');

    // var coords = {};
    // coords[0] = -MapHelper.WorldToMapImgX(playerX) + minimapOffsetX;
    // coords[1] = -MapHelper.WorldToMapImgY(playerY) + minimapOffsetY;
    // minimapdiv.style.left = Math.floor(coords[0]) + 'px';
    // minimapdiv.style.top = Math.floor(coords[1]) + 'px';

    var coords = {};
    coords[0] = MapHelper.WorldToMapImgX(playerX);
    coords[1] = MapHelper.WorldToMapImgY(playerY);
    coords = MapHelper.AdjustCoordinatesForMapOrientation(coords);

    var mapimg = document.getElementById('mapimg')
    mapimg.style.transform = "rotate(" + mapOrientation+"deg)";

    minimapdiv.style.left = (-coords[0] * mapScale + minimapOffsetX) + 'px';
    minimapdiv.style.top = (-coords[1] * mapScale + minimapOffsetY) + 'px';

    minimapdivX = parseInt(minimapdiv.style.left, 10); //Current Map X
    minimapdivY = parseInt(minimapdiv.style.top, 10); //Current Map Y

    map.width = mapWidth * mapScale; //Adjust Width for new Map Scale
    map.height = mapHeight * mapScale; //Adjust Height for new Map Scale

    factor = mapScale/prevMapScale;
    // var dx = (mousePosX - minimapdivX) * (factor-1);
    // var dy = (mousePosY - minimapdivY) * (factor-1);
    // minimapdivX = minimapdivX - dx;
    // minimapdivY = minimapdivY- dy;

    // minimapdiv.style.left = (minimapdivX) + 'px';
    // minimapdiv.style.top = (minimapdivY) + 'px';
    RefreshBlips(); //Adjust blip locations for landmarks
    //RefreshPlayerMarker(); //Adjust player marker location
}

function RefreshBlips() //Called when map is resized to reposition player marker.
{
    var minimapDiv = document.getElementById('minimapdiv')
    var minimapDivX = parseInt(minimapDiv.style.left)
    var minimapDivY = parseInt(minimapDiv.style.top)

    legendKeys.forEach(key =>
    {
        key.blips.forEach(blip =>
        {
            var coords = { };
            coords[0] = MapHelper.WorldToMapImgX(blip.worldX);
            coords[1] = MapHelper.WorldToMapImgY(blip.worldY);
            coords = MapHelper.AdjustCoordinatesForMapOrientation(coords);
            
            blip.style.left = (coords[0] * mapScale + minimapDivX + 2 - 12) + 'px';
            blip.style.top = (coords[1] * mapScale + minimapDivY + 2 - 12) + 'px';
        });
    });
    //Refresh destination (if one exists)
    var destinationMarker = document.getElementById("destinationmarker");
    if (destinationMarker.style.display == 'block') //If destination marker is visible, update position
    {
        var coords = {};
        coords[0] = MapHelper.WorldToMapImgX(destinationMarker.worldX);
        coords[1] = MapHelper.WorldToMapImgY(destinationMarker.worldY);
        coords = MapHelper.AdjustCoordinatesForMapOrientation(coords);
        destinationMarker.style.left = (coords[0] * mapScale + minimapdivX  - 16) + 'px';
        destinationMarker.style.top = (coords[1] * mapScale + minimapdivY  - 32) + 'px';
    }
}

function UpdateZoomScale(zoomScale)
{
    tempScale = mapScale;
    mapScale = zoomScale;
    RefreshMap(tempScale);
}

function GetLabelWidth(label)
{
    text = document.createElement("span"); 
    document.body.appendChild(text); 

    text.style.font = label.style.fontFamily;
    text.style.fontSize = label.style.fontSize;
    text.style.height = 'auto'; 
    text.style.width = 'auto'; 
    text.style.position = 'absolute'; 
    text.style.whiteSpace = 'no-wrap'; 
    text.innerHTML = label.textContent; 

    width = Math.ceil(text.clientWidth); 
    formattedWidth = width; 

    document.body.removeChild(text); 
    return formattedWidth;
}

function RegisterLegendKey(id, text, iconpath) //This should be called by main.lua via ExecuteJS for setting up a new legend key
{
    var key = [];
    key.id = id;
    key.text = text;
    key.iconpath = iconpath;
    key.blips = [];
    legendKeys.push(key);
}

function RegisterBlip(id, worldX, worldY) //This should be called by main.lua via ExecuteJS for setting up a new blip AFTER the legend key for this "id" has been assigned.
{
    var key = null;
    legendKeys.forEach(e =>
    {
        if (e.id == id)
        {
            key = e;
        }
    });
    if (key != null)
    {
        var blipimg = document.createElement('img');
        blipimg.src = key.iconpath;
        blipimg.className = "blip";
        blipimg.draggable = false;
        blipimg.worldX = worldX;
        blipimg.worldY = worldY;
        blipimg.style.zIndex = 3;

        var coords = { };
        coords[0] = MapHelper.WorldToMapImgX(blipimg.worldX);
        coords[1] = MapHelper.WorldToMapImgY(blipimg.worldY);
        coords = MapHelper.AdjustCoordinatesForMapOrientation(coords);
        blipimg.style.left = (coords[0] * mapScale + 2 - 12) + 'px';
        blipimg.style.top = (coords[1] * mapScale + 2 - 12) + 'px';

        key.blips.push(blipimg);

        var maskdiv = document.getElementById('maskdiv');
        maskdiv.appendChild(blipimg);
    }
}

function ShowKey(id) //This is called from one of the checkboxes that each legend key has
{
    var legendKey = null;

    legendKeys.forEach(key => //forEach loop to get the legend key that the id is tied to
    {
        if (key.id == id) 
        {
            legendKey = key;
        }
    });

    legendKey.blips.forEach(blip => 
    {
        blip.style.visibility = 'visible';
    });
}

function HideKey(id) //This is called from one of the checkboxes that each legend key has
{
    var legendKey = null;

    legendKeys.forEach(key => //forEach loop to get the legend key that the id is tied to
    {
        if (key.id == id) 
        {
            legendKey = key;
        }
    });

    legendKey.blips.forEach(blip => 
    {
        blip.style.visibility = 'hidden';
    });
}

function UpdatePlayerPosition(worldX, worldY, worldZ, angle) //Called from map.lua - updates the player marker location/rotation
{
    playerX = worldX;
    playerY = worldY;
    mapOrientation = -angle;
    RefreshMap(mapScale);
}

class MapHelper //Map Helper class for all of the map math calculations
{
    static AdjustCoordinatesForMapOrientation(coords)
    {
        if (mapOrientation != 0)
        {
            var x = coords[0];
            var y = coords[1];
            var centerX = mapWidth/2;
            var centerY = mapHeight/2;
            var dx = x - centerX;
            var dy = y - centerY;
            var rotatedX = dx * Math.cos(mapOrientation * Math.PI / 180) - dy*Math.sin(mapOrientation *Math.PI / 180);
            var rotatedY = dy * Math.cos(mapOrientation * Math.PI / 180) + dx*Math.sin(mapOrientation *Math.PI / 180);
            var newCoords = {};
            newCoords[0] = rotatedX + centerX;
            newCoords[1] = rotatedY + centerY;
            return newCoords;
        }
        else
        {
            return coords;
        }
    }

    static AdjustCoordinatesForReversedMapOrientation(coords)
    {
        if (mapOrientation != 0)
        {
            var x = coords[0];
            var y = coords[1];
            var centerX = mapWidth/2;
            var centerY = mapHeight/2;
            var dx = x - centerX;
            var dy = y - centerY;
            var rotatedX = dx * Math.cos(-mapOrientation * Math.PI / 180) - dy*Math.sin(-mapOrientation *Math.PI / 180);
            var rotatedY = dy * Math.cos(-mapOrientation * Math.PI / 180) + dx*Math.sin(-mapOrientation *Math.PI / 180);
            var newCoords = {};
            newCoords[0] = rotatedX + centerX;
            newCoords[1] = rotatedY + centerY;
            return newCoords;
        }
        else
        {
            return coords;
        }
    }

    static WorldToMapImgX(worldX)
    {
        return (worldX + 234002.2054794521) / 241.041095890411;
    }

    static WorldToMapImgY(worldY)
    {
        return (worldY + 231101.3928571428) / 242.5535714285714;
    }

    static WorldTominimapdivX(worldX)
    {
        return this.WorldToMapImgX(worldX) * mapScale;
    }

    static WorldTominimapdivY(worldY)
    {
        return this.WorldToMapImgY(worldY) * mapScale;
    }

    static MapImgToWorldX(minimapdivX)
    {
        return 241.041095890411 * minimapdivX - 234002.2054794521;
    }

    static MapImgToWorldY(minimapdivY)
    {
        return 242.5535714285714 * minimapdivY - 231101.3928571428;
    }

    static UIPixelToWorld(pixelCoords)
    {
        var coords = {}
        coords = this.UIPixelToMapImg(pixelCoords);
        coords[0] = this.MapImgToWorldX(coords[0])
        coords[1] = this.MapImgToWorldY(coords[1])
        return coords;
    }

    static UIPixelToMapImg(pixelCoords)
    {
        var minimapdiv = document.getElementById('minimapdiv');
        var coords = {}
        coords[0] = (pixelCoords[0] - parseInt(minimapdiv.style.left)) / mapScale;
        coords[1] = (pixelCoords[1] - parseInt(minimapdiv.style.top)) / mapScale;
        if (mapOrientation != 0)
        {
            coords = this.AdjustCoordinatesForReversedMapOrientation(coords)
        }
        return coords;
    }

    static UIPixelTominimapdivX(uiPixel) //Takes a coordinate in UI space (ex. topleft is 0,0) and converts it to the current map div space for the map div. 
    {
        var minimapdiv = document.getElementById('minimapdiv');
        uiPixel = uiPixel - parseInt(minimapdiv.style.left);
        return uiPixel;
    }

    static UIPixelTominimapdivY(uiPixel) //Takes a coordinate in UI space (ex. topleft is 0,0) and converts it to the current map div space for the map div. 
    {
        var minimapdiv = document.getElementById('minimapdiv');
        uiPixel = uiPixel - parseInt(minimapdiv.style.top);
        return uiPixel;
    }
}