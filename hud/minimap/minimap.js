// var canvas = document.getElementById("direction-hud");
// var ctx = canvas.getContext("2d");

function drawTriangle(ctx, x, y, size, color){
    ctx.beginPath();
    ctx.moveTo(x-(size/2), y);
    ctx.lineTo(x+(size/2), y);
    ctx.lineTo(x, y+Math.sqrt(Math.pow(size/2,2)+(size*size)));
    ctx.closePath();
    ctx.fillStyle = color;
    ctx.fill();
}

// let markers = {}
// let lastHeading = 0;

// function SetHUDMarker(name, h, r, g, b){
//     if(h === undefined){
//         markers[name] = undefined;
//     }else{
//         markers[name] = {
//             h: h,
//             r: r,
//             g: g,
//             b: b
//         };
//     }
// }

// let directionNames = {
//     0: "N",
//     45: "NE",
//     90: "E",
//     135: "SE",
//     180: "S",
//     225: "SW",
//     270: "W",
//     315: "NW"
// }

// function SetHUDHeading(heading){
//     canvas
//     lastHeading = heading;
//     ctx.clearRect(0, 0, 600, 60);
//     ctx.fillStyle = "rgba(50,50,50,0.3)";
//     ctx.fillRect(0, 0, 600, 60);
//     ctx.fillStyle = "rgba(50,50,50,0.4)";
//     ctx.fillRect(0, 30, 600, 20);
//     ctx.fillStyle = "rgb(255,255,255)";
//     for(let i=0; i<360; i+=15){
//         let h = (i+heading+75) % 360;
//         if(h > 180){
//             h -= 360;
//         }
//         if(i % 45 == 0){
//             ctx.fillRect((h*4)-1, 10, 2, 15);
//             let offset = directionNames[i].length > 1 ? 10 : 4;
//             ctx.font = "bold 15px sans-serif";
//             ctx.fillText(directionNames[i], (h*4)-offset, 45);
//         }else{
//             ctx.fillRect(h*4, 10, 1, 15);
//             let offset = i > 99 ? 9 : (i > 9 ? 6 : 3);
//             ctx.font = "15px sans-serif";
//             ctx.fillText(i, (h*4)-offset, 45);
//         }
//     }
//     for(let name of Object.keys(markers)){
//         let h = (markers[name].h+heading+75) % 360;
//         if(h > 180){
//             h -= 360;
//         }
//         drawTriangle(ctx, h*4, 0, 12, "rgb("+markers[name].r+","+markers[name].g+","+markers[name].b+")");
//     }
//     drawTriangle(ctx, 300, 0, 8, "rgb(255,255,255)");
// }

var canvas2 = document.getElementById("map-hud");
var ctx2 = canvas2.getContext("2d");

let nullloc = [-49091,-283713];

function locationToPixel(x, y){
    x = 128569 - (x - 128569);
    return [((y-nullloc[1])/305)-1, ((x-nullloc[0])/315)-1];
}

const image = new Image();
let imageLoaded = false;
image.onload = () => imageLoaded = true;
image.src = 'OnsetMap.png';

function SetMap(x, y, h){
    if(imageLoaded){
        canvas2.style.display = "unset";
        ctx2.fillStyle = "#002533";
        ctx2.fillRect(0, 0, 250, 250);
        let pixel = locationToPixel(x, y);
        ctx2.drawImage(image, (pixel[0]*-1)+125, (pixel[1]*-1)+125);
        ctx2.beginPath();
        ctx2.arc(125, 125, 5, 0, 2 * Math.PI, false);
        ctx2.fillStyle = 'green';
        ctx2.fill();
        ctx2.lineWidth = 1;
        ctx2.strokeStyle = '#003300';
        ctx2.stroke();
        drawTriangle(ctx2, 125, 0, 10, "orange");
    }
    if(h%90==0)
        h+=0.00001;
    canvas2.style.transform = "rotate("+(h*-1)+"deg)";
}