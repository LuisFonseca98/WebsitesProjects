class DrawingObjects
{
    constructor (px, py, name) {
        if (this.constructor === DrawingObjects) {
            // Error Type 1. Abstract class can not be constructed.
            throw new TypeError("Can not construct abstract class.");
        }

        //else (called from child)
        // Check if all instance methods are implemented.
        if (this.draw === DrawingObjects.prototype.draw) {
            // Error Type 4. Child has not implemented this abstract method.
            throw new TypeError("Please implement abstract method draw.");
        }

        if (this.mouseOver === DrawingObjects.prototype.mouseOver) {
            // Error Type 4. Child has not implemented this abstract method.
            throw new TypeError("Please implement abstract method mouseOver.");
        }

        this.posx = px;
        this.posy = py;
        this.name = name;
    }

   /* set_color(){

    }*/

    draw (cnv) {
        // Error Type 6. The child has implemented this method but also called `super.foo()`.
        throw new TypeError("Do not call abstract method draw from child.");
    }

    mouseOver(mx, my) {
        // Error Type 6. The child has implemented this method but also called `super.foo()`.
        throw new TypeError("Do not call abstract method mouseOver from child.");
    }


    sqDist(px1, py1, px2, py2) {
        let xd = px1 - px2;
        let yd = py1 - py2;

        return ((xd * xd) + (yd * yd));
    }
}

class Rect extends DrawingObjects
{

    constructor (px, py, w, h, c) {
        super(px, py, 'R');
        this.w = w;
        this.h = h;
        this.color = c;
    }

    draw (cnv) {
        let ctx = cnv.getContext("2d");

        ctx.fillStyle = this.color;
        ctx.fillRect(this.posx, this.posy, this.w, this.h);

    }

    mouseOver(mx, my) {
        return ((mx >= this.posx) && (mx <= (this.posx + this.w)) && (my >= this.posy) && (my <= (this.posy + this.h)));

    }
}

class Picture extends DrawingObjects
{

    constructor (px, py, w, h, impath) {
        super(px, py, 'P');
        this.w = w;
        this.h = h;
        this.impath = impath;
        this.imgobj = new Image();
        this.imgobj.src = this.impath;
    }

    draw (cnv) {
        let ctx = cnv.getContext("2d");

        if (this.imgobj.complete) {
            ctx.drawImage(this.imgobj, this.posx, this.posy, this.w, this.h);
            console.log("Debug: N Time");

        } else {
            console.log("Debug: First Time");
            let self = this;
            this.imgobj.addEventListener('load', function () {
                ctx.drawImage(self.imgobj, self.posx, self.posy, self.w, self.h);
            }, false);
        }
    }

    mouseOver(mx, my) {
        return ((mx >= this.posx) && (mx <= (this.posx + this.w)) && (my >= this.posy) && (my <= (this.posy + this.h)));
    }
}

class Oval extends DrawingObjects
{
    constructor (px, py, r, hs, vs, c) {
        super(px, py, 'O');
        this.r = r;
        this.radsq = r * r;
        this.hor = hs;
        this.ver = vs;
        this.color = c;
    }

    mouseOver (mx, my) {
        let x1 = 0;
        let y1 = 0;
        let x2 = (mx - this.posx) / this.hor;
        let y2 = (my - this.posy) / this.ver;

        return (this.sqDist(x1,y1,x2,y2) <= (this.radsq));
    }

    draw (cnv) {
        let ctx = cnv.getContext("2d");

        ctx.save();
        ctx.translate(this.posx,this.posy);
        ctx.scale(this.hor,this.ver);
        ctx.fillStyle = this.color;
        ctx.beginPath();
        ctx.arc(0, 0, this.r, 0, 2*Math.PI, true);
        ctx.closePath();
        ctx.fill();
        ctx.restore();
    }
}


class Heart extends DrawingObjects
{
    constructor (px, py, w, c) {
        super(px, py, 'H');
        this.h = w * 0.7;
        this.drx = w / 4;
        this.radsq = this.drx * this.drx;
        this.ang = .25 * Math.PI;
        this.color = c;
    }

    outside (x, y, w, h, mx, my) {
        return ((mx < x) || (mx > (x + w)) || (my < y) || (my > (y + h)));
    }

    draw (cnv) {
        let leftctrx = this.posx - this.drx;
        let rightctrx = this.posx + this.drx;
        let cx = rightctrx + this.drx * Math.cos(this.ang);
        let cy = this.posy + this.drx * Math.sin(this.ang);
        let ctx = cnv.getContext("2d");

        ctx.fillStyle = this.color;
        ctx.beginPath();
        ctx.moveTo(this.posx, this.posy);
        ctx.arc(leftctrx, this.posy, this.drx, 0, Math.PI - this.ang, true);
        ctx.lineTo(this.posx, this.posy + this.h);
        ctx.lineTo(cx,cy);
        ctx.arc(rightctrx, this.posy, this.drx, this.ang, Math.PI, true);
        ctx.closePath();
        ctx.fill();
    }

    mouseOver (mx, my) {
        let leftctrx = this.posx - this.drx;
        let rightctrx = this.posx + this.drx;
        let qx = this.posx - 2 * this.drx;
        let qy = this.posy - this.drx;
        let qwidth = 4 * this.drx;
        let qheight = this.drx + this.h;

        let x2 = this.posx;
        let y2 = this.posy + this.h;
        let m = (this.h) / (2 * this.drx);

        //quick test if it is in bounding rectangle
        if (this.outside(qx, qy, qwidth, qheight, mx, my)) {
            return false;
        }

        //compare to two centers
        if (this.sqDist (mx, my, leftctrx, this.posy) < this.radsq) return true;
        if (this.sqDist(mx, my, rightctrx, this.posy) < this.radsq) return true;

        // if outside of circles AND less than equal to y, return false
        if (my <= this.posy) return false;

        // compare to each slope
        // left side
        if (mx <= this.posx) {
            return (my < (m * (mx - x2) + y2));
        } else {  //right side
            m = -m;
            return (my < (m * (mx - x2) + y2));
        }
    }
}

class Bear extends DrawingObjects
{

    constructor (px,py,h,w,c,c1){
        super(px, py, 'B');
        this.c = c;
        this.h = h;
        this.w = w;
        this.c1 = c1;
        this.color = c;
        this.fundo = new Rect(this.posx,this.posy, this.w,this.h,this.c1);
        this.face = new Oval(this.posicX, this.posicY, this.rat, 0, this.c);
        this.earL = new Oval(this.leftctrx, this.posicY - 0.8 * this.rat, this.earrat, 0, this.c);
        this.earR = new Oval(this.rightctrx, this.posicY - 0.8 * this.rat,this. earrat, 0, this.c);
        this.inEarL= new Oval(this.leftctrx, this.posicY - 0.8 * this.rat, this.earrat/2, 0, this.c1);
        this.inEarR = new Oval(this.rightctrx, this.posicY - 0.8 * this.rat, this.earrat/2, 0, this.c1);
        this.eyeL= new Oval(this.posicX - 0.35 * this.rat, this.posicY  -  0.30 * this.rat, this.earrat/3, 0, this.c1);
        this.eyeR = new Oval(this.posicX + 0.35 * this.rat, this.posicY  -  0.30 * this.rat, this.earrat/3, 0, this.c1);
        this.eyeLs= new Oval(this.posicX - 0.39 * this.rat, this.posicY  -  0.35 * this.rat, this.earrat/10, 0);
        this.eyeRs = new Oval(this.posicX + 0.31 * this.rat, this.posicY  -  0.35 * this.rat, this.earrat/10, 0);
        this.noseS = new Oval(this.posicX - 0.15 * this.rat, this.posicY - 0.08 * this.rat , this.earrat/10, 1 , 1);
        this.nose = new Oval(this.posicX , this.posicY  , this.earrat/2, 1.4 , 1, this.c1);
    }

    atulizing_parameters(){
        this.rat = this.h/2.3;
        this.posicX = (this.posx + this.w/2);
        this.posicY = (this.posy + this.h/2 + 0.11*this.rat);
        this.leftctrx = this.posicX - (this.rat - 0.3 * (this.rat));
        this.rightctrx = this.posicX + (this.rat - 0.3 * (this.rat));
        this.earrat = this.rat *0.4;

        this.fundo.posx = this.posx;
        this.fundo.posy = this.posy;
        this.fundo.h = this.h;
        this.fundo.w = this.w;
        this.fundo.color = this.c1;

        this.earL.posx = this.leftctrx;
        this.earL.posy =  this.posicY - 0.8 * this.rat;
        this.earL.r = this.earrat;
        this.earL.color = this.c;

        this.earR.posx = this.rightctrx;
        this.earR.posy =  this.posicY - 0.8 * this.rat;
        this.earR.r = this.earrat;
        this.earR.color = this.c;

        this.inEarL.posx = this.leftctrx;
        this.inEarL.posy =  this.posicY - 0.8 * this.rat;
        this.inEarL.r = this.earrat/2;
        this.inEarL.color = this.c1;


        this.inEarR.posx = this.rightctrx;
        this.inEarR.posy =  this.posicY - 0.8 * this.rat;
        this.inEarR.r = this.earrat/2;
        this.inEarR.color = this.c1;

        this.face.posx = this.posicX;
        this.face.posy = this.posicY;
        this.face.r = this.h/2.3;
        this.face.color = this.c;

        this.eyeL.posx = this.posicX - 0.35 * this.rat;
        this.eyeL.posy = this.posicY  -  0.30 * this.rat;
        this.eyeL.r = this.earrat/3;
        this.eyeL.color = this.c1;

        this.eyeR.posx = this.posicX + 0.35 * this.rat;
        this.eyeR.posy = this.posicY  -  0.30 * this.rat;
        this.eyeR.r = this.earrat/3;
        this.eyeR.color = this.c1;

        this.eyeLs.posx = this.posicX - 0.39 * this.rat;
        this.eyeLs.posy = this.posicY  -  0.35 * this.rat;
        this.eyeLs.r =  this.earrat/10;
        this.eyeLs.color = "white";

        this.eyeRs.posx = this.posicX + 0.31 * this.rat;
        this.eyeRs.posy = this.posicY  -  0.35 * this.rat;
        this.eyeRs.r =  this.earrat/10;
        this.eyeRs.color = "white";

        this.noseS.posx = this.posicX - 0.15 * this.rat;
        this.noseS.posy =  this.posicY - 0.08 * this.rat;
        this.noseS.r =  this.earrat/10;
        this.noseS.color = "white";

        this.nose.posx = this.posicX;
        this.nose.posy =  this.posicY;
        this.nose.r =   this.earrat/2;
        this.nose.hor = 1.4;
        this.nose.ver = 1;
        this.nose.color = this.c1;
    }
    draw (cnv) {
        let ctx = cnv.getContext("2d");

        this.atulizing_parameters();

        ctx.beginPath();

       this.fundo.draw(cnv);

        this.earL.draw(cnv);

        this.earR.draw(cnv);

        this.inEarL.draw(cnv);

        this.inEarR.draw(cnv);

        this.face.draw(cnv);

        this.eyeL.draw(cnv);

        this.eyeR.draw(cnv);

        this.eyeLs.draw(cnv);

        this.eyeRs.draw(cnv);

        this.nose.draw(cnv);

        this.noseS.draw(cnv);

        ctx.beginPath();
        ctx.arc(this.posicX+0.27*this.rat, this.posicY+0.18*this.rat, this.w/9, -Math.PI, 0,  this.c1);
        ctx.stroke();
        ctx.closePath();

        ctx.beginPath();
        ctx.arc(this.posicX-0.27*this.rat, this.posicY+0.18*this.rat, this.w/9, -Math.PI, 0,  this.c1);
        ctx.stroke();
        ctx.closePath();

    }
    mouseOver (mx, my) {

        return ((mx >= this.posx) && (mx <= (this.posx + this.w)) && (my >= this.posy) && (my <= (this.posy + this.h)));
    }

}

class Homer  extends DrawingObjects {

    constructor (px,py,h,w,c,c1){
        super(px, py, 'M');
        this.c = c;
        this.h = h;
        this.w = w;
        this.color = c;
        this.c1 = c1;
        this.fundo = new Rect(this.posx,this.posy, this.w,this.h,this.c1);
        this.faceUP = new Oval(this.posicX, this.posicY, this.rat, 0.6,0.8 , this.c);
        this.faceMID = new Rect(this.posx, this.posicY, this.w/1.92,this.h/3,this.c);
        this.faceDOWN = new Oval(this.posicX, this.posicY, this.rat, 0.6,0.4 , this.c);
        this.faceUPinner = new Oval(this.posicX, this.posicY, this.rat, 0.6,0.8 , this.c);
        this.faceMIDinner = new Rect(this.posx, this.posicY, this.w/1.95,this.h/3.3,this.c);
        this.faceDOWNinner = new Oval(this.posicX, this.posicY, this.rat, 0.6,0.4 , this.c);
        this.earL = new Oval(this.leftctrx, this.posicY - 0.9 * this.rat, this.earrat/3, 0, this.c);
        this.earR = new Oval(this.rightctrx, this.posicY - 0.8 * this.rat,this. earrat/3, 0, this.c);
        this.inEarL= new Oval(this.leftctrx, this.posicY - 0.8 * this.rat, this.earrat/2, 0, this.c1);
        this.inEarR = new Oval(this.rightctrx, this.posicY - 0.8 * this.rat, this.earrat/2, 0, this.c1);
        this.eyeLback= new Oval(this.posicX - 0.35 * this.rat, this.posicY  -  0.30 * this.rat, this.earrat/3, 0, this.c1);
        this.eyeL= new Oval(this.posicX - 0.35 * this.rat, this.posicY  -  0.30 * this.rat, this.earrat/3, 0, this.c1);
        this.eyeRback = new Oval(this.posicX + 0.35 * this.rat, this.posicY  -  0.30 * this.rat, this.earrat/3, 0, this.c1);
        this.eyeR = new Oval(this.posicX + 0.35 * this.rat, this.posicY  -  0.30 * this.rat, this.earrat/3, 0, this.c1);
        this.eyeLs= new Oval(this.posicX - 0.39 * this.rat, this.posicY  -  0.35 * this.rat, this.earrat/10, 0);
        this.eyeRs = new Oval(this.posicX + 0.31 * this.rat, this.posicY  -  0.35 * this.rat, this.earrat/10, 0);
        this.noseS = new Oval(this.posicX - 0.15 * this.rat, this.posicY - 0.08 * this.rat , this.earrat/10, 1.4 , 1,this.c);
        this.nose = new Oval(this.posicX , this.posicY  , this.earrat/2, 1.4 , 1, this.c1);
    }

    atulizing_parameters(){
        this.rat = this.h/2.3;
        this.posicX = (this.posx + this.w/2);
        this.posicY = (this.posy + this.h/2 - 0.2*this.rat);
        this.leftctrx = this.posicX - (this.rat - 0.4 * (this.rat));
        this.rightctrx = this.posicX + (this.rat - 0.4 * (this.rat));
        this.earrat = this.rat *0.4;

        this.fundo.posx = this.posx;
        this.fundo.posy = this.posy;
        this.fundo.h = this.h;
        this.fundo.w = this.w;
        this.fundo.color = this.c1;

        this.earL.posx = this.leftctrx;
        this.earL.posy =  this.posicY + 0.3 * this.rat;
        this.earL.r = this.earrat/3;
        this.earL.hor = 1;
        this.earL.ver = 1.4;
        this.earL.color = this.c;

        this.earR.posx = this.rightctrx;
        this.earR.posy =  this.posicY + 0.3 * this.rat;
        this.earR.hor = 1;
        this.earR.ver = 1.4;
        this.earR.r = this.earrat/3;
        this.earR.color = this.c;

        this.inEarL.posx = this.leftctrx;
        this.inEarL.posy =  this.posicY + 0.3 * this.rat;
        this.inEarL.hor = 1;
        this.inEarL.ver = 1.4;
        this.inEarL.r = this.earrat/2.7;
        this.inEarL.color = "black";


        this.inEarR.posx = this.rightctrx;
        this.inEarR.posy =  this.posicY + 0.3 * this.rat;
        this.inEarR.hor = 1;
        this.inEarR.ver = 1.4;
        this.inEarR.r = this.earrat/2.7;
        this.inEarR.color = "black";

        this.faceMIDinner.posx = this.posx + 1.07*this.rat/2;
        this.faceMIDinner.posy = this.posicY;
        this.faceMIDinner.h = this.h/3;
        this.faceMIDinner.w = this.w/1.87;
        this.faceMIDinner.color = "black";

        this.faceMID.posx = this.posx + 1.1*this.rat/2;
        this.faceMID.posy = this.posicY;
        this.faceMID.h = this.h/3;
        this.faceMID.w = this.w/1.92;
        this.faceMID.color = this.c;

        this.faceUPinner.posx = this.posicX;
        this.faceUPinner.posy = this.posicY;
        this.faceUPinner.r = this.h/2.25;
        this.faceUPinner.color = "black";

        this.faceUP.posx = this.posicX;
        this.faceUP.posy = this.posicY;
        this.faceUP.r = this.h/2.3;
        this.faceUP.color = this.c;

        this.faceDOWNinner.posx = this.posicX;
        this.faceDOWNinner.posy = this.posicY + this.h/3;
        this.faceDOWNinner.r = this.h/2.15;
        this.faceDOWNinner.color = "black";

        this.faceDOWN.posx = this.posicX;
        this.faceDOWN.posy = this.posicY + this.h/3;
        this.faceDOWN.r = this.h/2.2;
        this.faceDOWN.color = "tan";

        this.eyeLback.posx = this.posicX - 0.35 * this.rat;
        this.eyeLback.posy = this.posicY  +  0.1* this.rat;
        this.eyeLback.r = this.earrat/1.4;
        this.eyeLback.color = "black";

        this.eyeL.posx = this.posicX - 0.35 * this.rat;
        this.eyeL.posy = this.posicY  +  0.1* this.rat;
        this.eyeL.r = this.earrat/1.5;
        this.eyeL.color = "white";


        this.eyeRback.posx = this.posicX + 0.35 * this.rat;
        this.eyeRback.posy = this.posicY  +  0.1* this.rat;
        this.eyeRback.r = this.earrat/1.4;
        this.eyeRback.color = "black";

        this.eyeR.posx = this.posicX + 0.35 * this.rat;
        this.eyeR.posy = this.posicY  +  0.10 * this.rat;
        this.eyeR.r = this.earrat/1.5;
        this.eyeR.color = "white";

        this.eyeLs.posx = this.posicX - 0.45 * this.rat;
        this.eyeLs.posy = this.posicY  + 0.1 * this.rat;
        this.eyeLs.r =  this.earrat/10;
        this.eyeLs.color = "black";

        this.eyeRs.posx = this.posicX + 0.45 * this.rat;
        this.eyeRs.posy = this.posicY  +  0.1 * this.rat;
        this.eyeRs.r =  this.earrat/10;
        this.eyeRs.color = "black";

        this.noseS.posx = this.posicX;
        this.noseS.posy =  this.posicY + 0.35 * this.rat;
        this.noseS.r =  this.earrat/2.7;
        this.nose.hor = 1.4;
        this.nose.ver = 1;
        this.noseS.color = "black";

        this.nose.posx = this.posicX;
        this.nose.posy =  this.posicY + 0.35 * this.rat;
        this.nose.r =   this.earrat/3;
        this.nose.hor = 1.4;
        this.nose.ver = 1;
        this.nose.color = this.c;
    }
    draw (cnv) {
        let ctx = cnv.getContext("2d");
        this.atulizing_parameters();

        //ctx.beginPath();

        //this.fundo.draw(cnv);

        this.inEarL.draw(cnv);

        this.inEarR.draw(cnv);


        this.faceMIDinner.draw(cnv);

        this.faceUPinner.draw(cnv);

        this.faceUP.draw(cnv);

        this.earL.draw(cnv);

        this.earR.draw(cnv);


        this.faceMID.draw(cnv);

        this.faceDOWNinner.draw(cnv);

        this.faceDOWN.draw(cnv);

        this.eyeLback.draw(cnv);

        this.eyeL.draw(cnv);

        this.eyeRback.draw(cnv);

        this.eyeR.draw(cnv);

        this.eyeLs.draw(cnv);

        this.eyeRs.draw(cnv);

        this.noseS.draw(cnv);

        this.nose.draw(cnv);

        ctx.beginPath();
        ctx.arc(this.posicX, this.posicY-this.h/3.3, this.w/11,  0, Math.PI,  this.c1);
        ctx.stroke();
        ctx.closePath();

        ctx.beginPath();
        ctx.arc(this.posicX, this.posicY-this.h/3.3, this.w/8,  0, Math.PI,  this.c1);
        ctx.stroke();
        ctx.closePath();

        ctx.beginPath();
        ctx.arc(this.posicX-this.rat*0.15, this.posicY + this.h/3, this.w/10, -Math.PI, 1.5,  this.c1);
        ctx.stroke();
        ctx.closePath();

        ctx.beginPath();
        ctx.arc(this.posicX - this.rat*0.23, this.posicY + this.h/2.4, this.w/20, Math.PI/2 -0.8, 0,  this.c1);
        ctx.stroke();
        ctx.closePath();

        ctx.beginPath();
        ctx.arc(this.posicX - this.rat*0.33, this.posicY + this.h/2.7, this.w/20, Math.PI/2 - 3, Math.PI/2 + 2.2, this.c1);
        ctx.stroke();
        ctx.closePath();

    }
    mouseOver (mx, my) {

        return ((mx >= this.posx) && (mx <= (this.posx + this.w)) && (my >= this.posy) && (my <= (this.posy + this.h)));
    }


}

class Texto extends DrawingObjects
{

    constructor(px,py,text,c){

        super(px,py,"T",c);

        this.text = text;

        this.width = null;

        this.fontSize = 30;

        this.height = this.fontSize;

        this.color = c;
        console.log(this.color);

    }

    mouseOver(mx, my) {

        return ((mx >= this.posx) && (mx <= (this.posx + this.width)) && (my <= this.posy) && (my >= (this.posy - this.height)));
    }


    draw(cnv){

        let ctx = cnv.getContext("2d");

        ctx.font = this.fontSize + "px Arial";

        ctx.fillStyle = this.color;

        this.width = ctx.measureText(this.text).width;

        ctx.fillText(this.text,this.posx,this.posy);

    }

}

////CLASSE FANTASMA/////

class Ghost extends DrawingObjects
{
    constructor (px, py, w, h, c) {
        super(px, py, 'G');
        this.w = w;
        this.h = h;
        this.color = c;
    }

    mouseOver (mx, my) {
        return ((mx >= (this.posx-this.w*0.04)) && (mx <= (this.posx+this.w*1.04)) && (my >= (this.posy-0.62*this.h)) && (my <= (this.posy+1.8*this.h)));
    }


    draw (cnv) {
        let ctx = cnv.getContext("2d");
        ctx.beginPath();
        ctx.rect(this.posx, this.posy, this.w, this.h);
        ctx.fill();

        ctx.fillStyle=this.color;
        ctx.arc(this.posx+this.w/2,this.posy,this.w/2, 0,Math.PI, true);
        ctx.moveTo(this.posx,this.posy+this.h);
        ctx.lineTo(this.posx+0.15*this.w, 1.7*this.h+this.posy);
        ctx.lineTo(this.posx+0.25*this.w, this.posy+this.h+3);
        ctx.lineTo(this.posx+0.4*this.w, 1.7*this.h+this.posy);
        ctx.lineTo(this.posx+0.5*this.w, this.posy+this.h+3);
        ctx.lineTo(this.posx+0.6*this.w, 1.7*this.h+this.posy);
        ctx.lineTo(this.posx+0.75*this.w, this.posy+this.h+3);
        ctx.lineTo(this.posx+0.85*this.w, 1.7*this.h +this.posy);
        ctx.lineTo(this.posx+1.0*this.w, this.posy+this.h);
        ctx.closePath();
        ctx.stroke();
        ctx.fill();


        ctx.fillStyle = "red";
        ctx.beginPath();
        ctx.arc(this.posx+(this.w/3.5),this.posy,15,0,2*Math.PI);
        ctx.closePath();
        ctx.fill();
        ctx.stroke();
        ctx.beginPath();
        ctx.arc(this.posx+(this.w/1.4),this.posy,15,0,2*Math.PI);
        ctx.closePath();
        ctx.fill();
        ctx.stroke();

        ctx.fillStyle = "black";
        ctx.beginPath();
        ctx.arc(this.posx+(this.w/3.5)-4,this.posy,8,0,2*Math.PI);
        ctx.closePath();
        ctx.fill();
        ctx.stroke();
        ctx.beginPath();
        ctx.arc(this.posx+(this.w/1.4)-4,this.posy,8,0,2*Math.PI);
        ctx.closePath();
        ctx.fill();
        ctx.stroke();
    }
}
