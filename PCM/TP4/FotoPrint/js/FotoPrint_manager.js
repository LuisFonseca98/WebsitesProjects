'use strict';

let app = null;

function main() {
    let cnv = document.getElementById('canvas');
    let cnv2 = document.getElementById('canvas2');
    app = new FotoPrint();
    drawCanvasRect(cnv2);
    drawCanvasRect(cnv);

    app.init();
    app.drawObjSelect(cnv2);
    app.drawObj(cnv);

    cnv2.addEventListener('click',get_object,false);
    cnv.addEventListener('mousedown',set_object,false);
    cnv.addEventListener('mousedown', drag, false);
    cnv.addEventListener('dblclick', makenewitem, false);
}

function drawCanvasRect(cnv) {
    let ctx = cnv.getContext("2d");
    let bgcolor = app.getBGColor();

     if(bgcolor == null){
         bgcolor = "white";
     }
    ctx.fillStyle = bgcolor;
    ctx.fillRect(0, 0, cnv.width, cnv.height);
    ctx.strokeStyle = "black";
    ctx.lineWidth = 2;
    ctx.strokeRect(0, 0, cnv.width, cnv.height);
    ctx.fill();
    app.drawObj(cnv);
}

//Drag & Drop operation
//drag
function drag(ev) {
    let mx = null;
    let my = null;
    let cnv = document.getElementById('canvas');

    let xPos = 0;
    let yPos = 0;
    [xPos, yPos] = getMouseCoord(cnv);
    mx = ev.x - xPos;
    my = ev.y - yPos;

    if (app.dragObj(mx, my)) {
        cnv.style.cursor = "pointer";
        cnv.addEventListener('mousemove', move, false);
        cnv.addEventListener('mouseup', drop, false);
    }

}

//Drag & Drop operation
//move
function move(ev) {
    let mx = null;
    let my = null;
    let cnv = document.getElementById('canvas');

    let xPos = 0;
    let yPos = 0;
    [xPos, yPos] = getMouseCoord(cnv);
    mx = ev.x - xPos;
    my = ev.y - yPos;

    app.moveObj(mx, my);
    drawCanvasRect(cnv);
    app.drawObj(cnv);
}

//Drag & Drop operation
//drop
function drop() {
    let cnv = document.getElementById('canvas');

    cnv.removeEventListener('mousemove', move, false);
    cnv.removeEventListener('mouseup', drop, false);
    cnv.style.cursor = "crosshair";
}

//Insert a new Object on Canvas
//dblclick Event
function makenewitem(ev) {
    let mx = null;
    let my = null;
    let cnv = document.getElementById('canvas');

    let xPos = 0;
    let yPos = 0;
    [xPos, yPos] = getMouseCoord(cnv);
    mx = ev.x - xPos;
    my = ev.y - yPos;



    if (app.insertObj(mx, my)) {
        drawCanvasRect(cnv);
        app.drawObj(cnv);
    }
}

function get_object(ev){
    let mx = null;
    let my = null;
    let newitem = null;
    let cnv2 = document.getElementById('canvas2');

    let xPos = 0;
    let yPos = 0;

    [xPos, yPos] = getMouseCoord(cnv2);
    mx = ev.x - xPos;
    my = ev.y - yPos;

    newitem = app.save_object_selected(mx,my);
    console.log(newitem);
}

function set_object(ev) {
    let mx = null;
    let my = null;
    let xPos = 0;
    let yPos = 0;

    let cnv = document.getElementById('canvas');

    [xPos, yPos] = getMouseCoord(cnv);
    mx = ev.x - xPos;
    my = ev.y - yPos;

    if(app.insertObjSelected(mx, my)) {
        drawCanvasRect(cnv);
        app.drawObj(cnv);
    }
}

function ChangeColor(){
    let color = document.getElementById('color1').value;

    app.setColor(color);
}

function changeBGcolor(){
    let cnv = document.getElementById("canvas");
    let color = document.getElementById("bgColor").value;
    app.setBGColor(color);
    drawCanvasRect(cnv);
    app.drawObj(cnv);
}

function setText(ev){
    let idText = document.getElementById("canvas");
    let writeText = prompt("Escreva aqui o que prentende representar no fotoPrint:");

    if(writeText !== null){
        app.setTextObj(idText,writeText);
        drawCanvasRect(idText);
        app.drawObj(idText);
    }
}

function setPictures(){
    let idCanvas = document.getElementById("canvas");
    let idImages = document.getElementById("images");
    const fileURL = window.URL.createObjectURL(idImages.files[0]);
    app.setPicturesObj(idCanvas,fileURL);
    app.drawObj(idCanvas);
}

//Delete button
//Onclick Event
function remove() {
    let cnv = document.getElementById('canvas');

    app.removeObj();
    drawCanvasRect(cnv);
    app.drawObj(cnv);
}

//Save button
//Onclick Event
function saveasimage() {
    try {
        window.open(document.getElementById('canvas').toDataURL("imgs/png"));}
    catch(err) {
        alert("You need to change browsers OR upload the file to a server.");
    }
}


//Mouse Coordinates for all browsers
function getMouseCoord(el) {
    let xPos = 0;
    let yPos = 0;

    while (el) {
        if (el.tagName === "BODY") {
            // deal with browser quirks with body/window/document and page scroll
            let xScroll = el.scrollLeft || document.documentElement.scrollLeft;
            let yScroll = el.scrollTop || document.documentElement.scrollTop;

            xPos += (el.offsetLeft - xScroll + el.clientLeft);
            yPos += (el.offsetTop - yScroll + el.clientTop);
        } else {
            // for all other non-BODY elements
            xPos += (el.offsetLeft - el.scrollLeft + el.clientLeft);
            yPos += (el.offsetTop - el.scrollTop + el.clientTop);
        }

        el = el.offsetParent;
    }
    return [xPos,yPos];
}
