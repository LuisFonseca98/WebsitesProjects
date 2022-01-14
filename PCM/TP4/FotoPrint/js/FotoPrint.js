'use strict';

class FotoPrint
{
    constructor() {
        this.thingInMotion = null;
        this.offsetx = null;
        this.offsety = null;
        this.shpinDrawing = new Pool(100);
        this.selectingDrawning = new Pool(7);
        this.newitems = null;
        this.colorValue = null;
        this.colorChanged =false;
        this.colorbg = null;
        this.colorbgChanged = false;
    }

    init() {
        let r = new Rect(25, 50, 100, 100, "red");
        this.selectingDrawning.insert(r);

        let o = new Oval(200, 100, 50, 1, 1, "blue");
        this.selectingDrawning.insert(o);

        let h = new Heart(300 ,80, 80, "pink");
        this.selectingDrawning.insert(h);

        let dad = new Picture(350, 50, 100, 100, "imgs/allison1.jpg");
        this.selectingDrawning.insert(dad);

        let bear = new Bear(465,50,100,100, "sandybrown","black");
        this.selectingDrawning.insert(bear);

        let homer = new Homer(665,50,100,100, "yellow","black");
        this.selectingDrawning.insert(homer);

        let ghost = new Ghost(595,65,60,60,"black");
        this.selectingDrawning.insert(ghost);
    }

    drawObj(cnv) {
        for (let i = 0; i < this.shpinDrawing.stuff.length; i++) {
            this.shpinDrawing.stuff[i].draw(cnv);
        }
    }

    drawObjSelect(cnv2) {
        for (let i = 0; i < this.selectingDrawning.stuff.length; i++) {
            this.selectingDrawning.stuff[i].draw(cnv2);
        }
    }

    dragObj(mx, my) {
        let endpt = this.shpinDrawing.stuff.length-1;

        for (let i = endpt; i >= 0; i--) {
            if (this.shpinDrawing.stuff[i].mouseOver(mx, my)) {
                this.offsetx = mx - this.shpinDrawing.stuff[i].posx;
                this.offsety = my - this.shpinDrawing.stuff[i].posy;
                let item = this.shpinDrawing.stuff[i];
                this.thingInMotion = this.shpinDrawing.stuff.length - 1;
                this.shpinDrawing.stuff.splice(i, 1);
                this.shpinDrawing.stuff.push(item);
                return true;
            }
        }
        return false;
    }

    moveObj(mx, my) {
        this.shpinDrawing.stuff[this.thingInMotion].posx = mx - this.offsetx;
        this.shpinDrawing.stuff[this.thingInMotion].posy = my - this.offsety;
    }

    removeObj () {
        this.shpinDrawing.remove();
    }

    insertObj (mx, my) {
        let item = null;
        let endpt = this.shpinDrawing.stuff.length-1;

        for (let i = endpt; i >= 0; i--) {
            if (this.shpinDrawing.stuff[i].mouseOver(mx,my)) {
                item = this.cloneObj(this.shpinDrawing.stuff[i],-1,-1);
                this.shpinDrawing.insert(item);
                return true;
            }
        }
        return false;
    }

    save_object_selected (mx, my) {
        let selIT = this.selectingDrawning.stuff.length-1;
        for (let i = selIT; i >= 0; i--) {
            if (this.selectingDrawning.stuff[i].mouseOver(mx, my)) {
                this.newitems = this.cloneObj(this.selectingDrawning.stuff[i],mx,my);
                return this.newitems;
            }

        }
        return null;
    }

    insertObjSelected (mx, my) {
        if (this.newitems != null) {
            this.shpinDrawing.insert(this.cloneObj(this.newitems,mx,my));
            this.newitems = null;
            return true;
        }
        return false;
    }

    setColor(value){
        this.colorChanged = true;
        this.colorValue = value;
    }

    setBGColor(value){
        this.colorbgChanged = true;
        this.colorbg = value;
        console.log(value);
        console.log(this.colorbg);
        console.log(this.colorbgChanged);
    }

    getBGColor(){
        return this.colorbg;
    }

    setTextObj(cnv,text){

        let item = new Texto(cnv.width/2,cnv.height/2,text,this.colorValue);

        this.shpinDrawing.insert(item);

    }

    setPicturesObj(cnv,picture){

        let item = new Picture(cnv.width/2,cnv.height/2,150,150,picture);

        this.shpinDrawing.insert(item);

    }

    cloneObj (obj,mx,my) {
        let item = {};
        let object_color;
        let posx;
        let posy;

        if(this.colorChanged) {
            object_color = this.colorValue;
        }
        if(!this.colorChanged) {
            object_color = obj.color;
        }

        if(mx == -1 & my == -1 ){
            posx = obj.posx + 20;
            posy = obj.posy + 20;
        }
        if(mx != -1 & my != -1 ) {
            posx = mx;
            posy = my;
        }
        switch(obj.name) {
            case "R":
                item = new Rect(posx, posy, obj.w, obj.h, object_color);
                break;

            case "P":
                item = new Picture(posx, posy, obj.w, obj.h, obj.impath);
                break;

            case "O":
                item = new Oval(posx, posy, obj.r, obj.hor, obj.ver, object_color);
                break;

            case "H":
                item = new Heart(posx, posy, obj.drx * 4,object_color);
                break;

            case "B":
                item = new Bear(posx,posy,obj.w,obj.h, object_color,obj.c1);
                break;

            case "M":
                item = new Homer(posx,posy,obj.w,obj.h, object_color,obj.c1);
                break;

            case "G":
                item = new Ghost(posx, posy,obj.w,obj.h,object_color);
                break;

            default:
                throw new TypeError("Can not clone this type of object");
        }
        return item;
    }
}



class Pool
{
    constructor (maxSize) {
        this.size = maxSize;
        this.stuff = [];

    }

    insert (obj) {
        if (this.stuff.length < this.size) {
            this.stuff.push(obj);
        } else {
            alert("The application is full: there isn't more memory space to include objects");
        }
    }

    remove () {
        if (this.stuff.length !== 0) {
            this.stuff.pop();
        } else {
           alert("There aren't objects in the application to delete");
        }
    }
}
