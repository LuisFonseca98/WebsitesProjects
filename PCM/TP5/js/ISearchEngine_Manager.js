
let app = null;

function main() {
    let canvas = document.querySelector("canvas");
    app = new ISearchEngine("XML/Image_database.xml");
    app.init(canvas);
}

function Generate_Image(canvas) {
    let ctx = canvas.getContext("2d");
    let imgData = ctx.createImageData(100, 100);

    for (let i = 0; i < imgData.data.length; i += 4) {
        imgData.data[i + 0] = 204;
        imgData.data[i + 1] = 0;
        imgData.data[i + 2] = 0;
        imgData.data[i + 3] = 255;
        if ((i >= 8000 && i < 8400) || (i >= 16000 && i < 16400) || (i >= 24000 && i < 24400) || (i >= 32000 && i < 32400))
            imgData.data[i + 1] = 200;
    }
    ctx.putImageData(imgData, 150, 0);
    return imgData;
}

function searchByKeywords(){
    let canvas = document.querySelector("canvas");
    let keyword = document.getElementById("textBar").value;
    app.searchKeywords(keyword.toLowerCase());
    app.gridView(canvas);
}

function searchColor(color, idButton) {
    let canvas = document.querySelector("canvas");
    let keyword = document.getElementById("Colors").value;
    if (keyword === "") {
        document.getElementById(idButton).style.borderColor = "red";
    }
    else {
        app.searchColor(keyword.toLowerCase(), color);
        app.gridView(canvas);
    }
}

function searchISimilarity(event) {
    let canvas = document.querySelector("canvas");
    let mx, my = 0;

    if ( event.layerX ||  event.layerX === 0) {
        mx = event.layerX;
        my = event.layerY;
    } else if (event.offsetX || event.offsetX === 0) {
        mx = event.offsetX;
        my = event.offsetY;
    }

    for(let i = 0; i < app.allpictures.stuff.length; i++){
        if(app.allpictures.stuff[i].mouseOver(mx, my)){
            document.getElementById("txtBusca").value = "";
            app.searchISimilarity(app.allpictures.stuff[i].impath);
            app.gridView(canvas);
            break;
        }
    }
}


