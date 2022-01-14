'use strict';

class ISearchEngine {
    constructor(dbase) {
        this.allpictures = new Pool(3000);
        this.colors = ["red", "orange", "yellow", "green", "Blue-green", "blue", "purple", "pink", "white", "grey", "black", "brown"];
        this.redColor = [204, 251, 255, 0, 3, 0, 118, 255, 255, 153, 0, 136];
        this.greenColor = [0, 148, 255, 204, 192, 0, 44, 152, 255, 153, 0, 84];
        this.blueColor = [0, 11, 0, 0, 198, 255, 167, 191, 255, 153, 0, 24];
        this.categories = ["beach", "birthday", "face", "indoor", "manmade/artificial", "manmade/manmade","manmade/urban", "marriage", "nature", "no_people", "outdoor", "party", "people", "snow"];
        this.XML_file = dbase;
        this.XML_db = new XML_Database();
        this.LS_db = new LocalStorageXML();
        this.num_Images = 100;
        this.numshownpic = 30;
        this.imgWidth = 190;
        this.imgHeight = 140;
    }

    init(cnv) {
        //this.databaseProcessing(cnv);
        //this.searchColor("no_people","white");
        //this.searchKeywords("beach");
        //this.gridView(cnv);

    }

    // method to build the database which is composed by all the pictures organized by the XML_Database file
    // At this initial stage, in order to evaluate the image algorithms, the method only compute one image.
    // However, after the initial stage the method must compute all the images in the XML file
    databaseProcessing (cnv) {
        let h12color = new ColorHistogram(this.redColor, this.greenColor, this.blueColor);
        let colmoments = new ColorMoments();
        let XMLdoc = this.XML_db.loadXMLfile(this.XML_file);

        for(let i = 0; i < this.categories.length; i++){
            let imagesPath = this.XML_db.SearchXML(this.categories[i], XMLdoc, this.num_Images);
            for(let j = 0; j < imagesPath.length; j++){
                let img = new Picture(0, 0, this.imgWidth, this.imgHeight, imagesPath[j], this.categories[i]);

                let eventname = "processed_picture_" + img.impath;
                let eventP = new Event(eventname);
                let self = this;
                document.addEventListener(eventname, function(){
                    self.imageProcessed(img, eventname);
                },false);

                img.computation(cnv, h12color, colmoments, eventP);
            }

        }
    }

    //When the event "processed_picture_" is enabled this method is called to check if all the images are
    //already processed. When all the images are processed, a database organized in XML is saved in the localStorage
    //to answer the queries related to Color and Image Example
    imageProcessed (img, eventname) {
        this.allpictures.insert(img);
        console.log("image processed " + this.allpictures.stuff.length + eventname);
        if (this.allpictures.stuff.length === (this.num_Images * this.categories.length)) {
            this.createXMLColordatabaseLS();
            this.createXMLIExampledatabaseLS();
        }
    }

    //Method to create the XML database in the localStorage for color queries
    createXMLColordatabaseLS() {

        for(let i = 0; i < this.categories.length; i++) {
            let ordem = [];
            let xmlRowString = "<images>";

            for(let j = 0 ; j < this.allpictures.stuff.length; j++ ){
                //this.LS_db.saveLS_XML(i,this.allpictures.stuff[j].hist);
                if(this.allpictures.stuff[j].category === this.categories[i]){
                    ordem.push(this.allpictures.stuff[j]);
                }
            }

            for(let m = 0; m < this.colors.length; m++){
                this.sortbyColor(m, ordem);
                for(let n = 0; n < this.num_Images; n++){
                    xmlRowString += '<image class="' + this.colors[m] + '">';
                    xmlRowString += '<path>' + ordem[n].impath + '</path>';
                    xmlRowString += '</image>';
                }
            }
            xmlRowString += '</images>';
            this.LS_db.saveLS_XML(this.categories[i],xmlRowString);
        }
    }

    //Method to create the XML database in the localStorage for Image Example queries
    createXMLIExampledatabaseLS() {
        let list_images = new Pool(this.allpictures.stuff.length);
        this.zscoreNormalization();

        for(let i = 0; i < this.allpictures.stuff.length; i++){
            for(let j = 0; j < this.allpictures.stuff.length; j++){
                let distancia = this.calcManhattanDist(this.allpictures.stuff[i], this.allpictures.stuff[j]);
                this.allpictures.stuff[i].manhattanDist.push(distancia);
            }
        }

        let imagens = this.allpictures.stuff.slice();

        for(let i = 0; i < this.allpictures.stuff.length; i++) {

            let xmlRowString = "<images>";

            this.sortbyManhattanDist(i, imagens);

            for (let x = 0; x < this.numshownpic; x++) {
                xmlRowString += "<image class=\"Manhattan\"><path>" + imagens[x].impath + "</path></image>";
            }

            xmlRowString += "</images>";

            this.LS_db.saveLS_XML(this.allpictures.stuff[i].impath, xmlRowString);
        }
    }

    //A good normalization of the data is very important to look for similar images. This method applies the
    // zscore normalization to the data
    zscoreNormalization() {
        let overall_mean = [];
        let overall_std = [];

        // Inicialization
        for (let i = 0; i < this.allpictures.stuff[0].color_moments.length; i++) {
            overall_mean.push(0);
            overall_std.push(0);
        }

        // Mean computation I
        for (let i = 0; i < this.allpictures.stuff.length; i++) {
            for (let j = 0; j < this.allpictures.stuff[0].color_moments.length; j++) {
                overall_mean[j] += this.allpictures.stuff[i].color_moments[j];
            }
        }

        // Mean computation II
        for (let i = 0; i < this.allpictures.stuff[0].color_moments.length; i++) {
            overall_mean[i] /= this.allpictures.stuff.length;
        }

        // STD computation I
        for (let i = 0; i < this.allpictures.stuff.length; i++) {
            for (let j = 0; j < this.allpictures.stuff[0].color_moments.length; j++) {
                overall_std[j] += Math.pow((this.allpictures.stuff[i].color_moments[j] - overall_mean[j]), 2);
            }
        }

        // STD computation II
        for (let i = 0; i < this.allpictures.stuff[0].color_moments.length; i++) {
            overall_std[i] = Math.sqrt(overall_std[i]/this.allpictures.stuff.length);
        }

        // zscore normalization
        for (let i = 0; i < this.allpictures.stuff.length; i++) {
            for (let j = 0; j < this.allpictures.stuff[0].color_moments.length; j++) {
                this.allpictures.stuff[i].color_moments[j] = (this.allpictures.stuff[i].color_moments[j] - overall_mean[j]) / overall_std[j];
            }
        }
    }

    populate(searchType, paths){
        this.allpictures.empty_Pool();

        for (let i = 0; i < this.numshownpic; i++){
            this.allpictures.insert(new Picture(0,0,this.imgWidth, this.imgHeight, paths[i], searchType));
        }
    }

    //Method to search images based on a selected color
    searchColor(category, color) {
        let XMLdoc = this.LS_db.readLS_XML(category);
        let paths = this.XML_db.SearchXML(color, XMLdoc, this.numshownpic);
        this.populate("SearchByColor", paths)

    }

    //Method to search images based on keywords
    searchKeywords(category) {
        let XMLdoc = this.XML_db.loadXMLfile(this.XML_file);
        let paths = this.XML_db.SearchXML(category, XMLdoc, this.numshownpic);
        this.populate("SearchByKeywords", paths);
    }

    //Method to search images based on Image similarities
    searchISimilarity(IExample, dist) {
        let XMLdoc = this.LS_db.readLS_XML(IExample);
        let paths = this.XML_db.SearchXML(dist, XMLdoc, this.numshownpic);
        this.populate("searchISimilarity", paths)
    }


    //Method to compute the Manhattan difference between 2 images which is one way of measure the similarity
    //between images.
    calcManhattanDist(img1, img2){
        let manhattan = 0;

        for(let i=0; i < img1.color_moments.length; i++){
            manhattan += Math.abs(img1.color_moments[i] - img2.color_moments[i]);
        }
        manhattan /= img1.color_moments.length;
        return manhattan;
    }

    //Method to sort images according to the Manhattan distance measure
    sortbyManhattanDist(idxdist,list){
        list.sort(function (a, b) {
            return a.manhattanDist[idxdist] - b.manhattanDist[idxdist];
        });
    }

    //Method to sort images according to the number of pixels of a selected color
    sortbyColor (idxColor, list) {
        list.sort(function (a, b) {
            return b.hist[idxColor] - a.hist[idxColor];
        });
    }

    //Method to visualize images in canvas organized in columns and rows
    gridView (canvas) {
        let nRows = 5;
        let nCols = 6;

        let incWidth = canvas.width / nCols;
        let incHeight = canvas.height / nRows;

        for (let i = 0; i < nRows; i++){
            for (let j = 0; j < nCols; j++){
                this.allpictures.stuff[nCols*i+j].setPosition(j * incWidth, i * incHeight);
                this.allpictures.stuff[nCols*i+j].draw(canvas);
            }
        }
    }

}


class Pool {
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

    empty_Pool () {
        while (this.stuff.length > 0) {
            this.remove();
        }
    }
}

