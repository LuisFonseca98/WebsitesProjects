//////////////////////////////////////////////METODOS QUE VERiFICAM AS RESPOSTAS DO USER, QUANDO SE ENGANA/////////////////
function checkNoAnswer() {
    let x = document.forms["fdpessoais"]["web"].value;
    if (x === "Não") {
        document.forms["fdpessoais"]["text6"].disabled=true;
        document.forms["fdpessoais"]["text6"].value="";
    }
    else {
        document.forms["fdpessoais"]["text6"].disabled=false;
    }
}

function checkBrowser(elemento) {
    let opcao1 = document.getElementById("primeiro");
    let opcao2 = document.getElementById("segundo");
    let opcao3 = document.getElementById("terceiro");
    if ((elemento.id.localeCompare("primeiro") !== 0) && (elemento.value === opcao1.value)){
        opcao1.value= "";
    }
    if ((elemento.id.localeCompare("segundo") !== 0) && (elemento.value === opcao2.value)){
        opcao2.value= "";
    }
    if ((elemento.id.localeCompare("terceiro") !== 0) && (elemento.value === opcao3.value)){
        opcao3.value= "";
    }
}



/////////////////////////////////////METODO PARA VALIDAR AS RESPOSTAS NO LOCALSTORAGE///////////////////////
function validateForm() {
    let d = new Date();
    let perguntas = ["idade", "sexo", "internet", "browser1", "browser2", "browser3", "web", "text6"];
    let xmlRowString = "<Questionario>";
    for (let i = 0; i < perguntas.length; i++) {
        let Rq = document.forms["fdpessoais"][perguntas[i]].value;
        if (Rq !== "") {
            xmlRowString += '<q id ="' + perguntas[i] + '">' + Rq + '</q>';
        }
        else {
            Rq = "no response";
            xmlRowString += '<q id ="' + perguntas[i] + '">' + Rq + '</q>';
        }
    }
    xmlRowString += "</Questionario>";
    window.localStorage.setItem(d.getTime(), xmlRowString);
}

function validateForm2() {
    let d = new Date();
    let perguntas = ["Tarefa1", "quantity", "Tarefa2", "quantity2","Tarefa3","quantity3", "quantity4", "Tarefa4", "Tarefa5"];
    let xmlRowString = "<Questionario>";
    for (let i = 0; i < perguntas.length; i++) {
        let Rq = document.forms["Tarefas"][perguntas[i]].value;
        if (Rq !== "") {
            xmlRowString += '<q id ="' + perguntas[i] + '">' + Rq + '</q>';
        }
        else {
            Rq = "no response";
            xmlRowString += '<q id ="' + perguntas[i] + '">' + Rq + '</q>';
        }
    }
    xmlRowString += "</Questionario>";
    window.localStorage.setItem(d.getTime(), xmlRowString);
}
function validateForm3() {
    let d = new Date();
    let perguntas = ["AvaliaçãoGlobal", "AvaliaçãoGlobal2", "AvaliaçãoGlobal3", "AvaliaçãoGlobal4", "AvaliaçãoGlobal5", "AvaliaçãoGlobal6",
        "AvaliaçãoGlobal7", "AvaliaçãoGlobal8","AvaliaçãoGlobal9","AvaliaçãoGlobal_10","AvaliaçãoGlobal_11"];
    let xmlRowString = "<Questionario>";
    for (let i = 0; i < perguntas.length; i++) {
        let Rq = document.forms["Avaliação"][perguntas[i]].value;
        if (Rq !== "") {
            xmlRowString += '<q id ="' + perguntas[i] + '">' + Rq + '</q>';
        }
    }
    xmlRowString += "</Questionario>";
    window.localStorage.setItem(d.getTime(), xmlRowString);
}



///////////////////////////////////////METODO PARA IR BUSCAR OS VALORES DO LOCALSTORAGE///////////////////////
function getDataForm() {
    let keysSize = window.localStorage.length;
    let updateQuestions = 1;
    let updateQuestion4 = 1;
    let userNumber = 1;
    let xmlDoc;
    let separateNewUser = "|-----------------------------------------------------------------------------|";
    let separateNewUser2 = separateNewUser.fontcolor("blue");
    document.write("<h1> Respostas do Utilizador: " + userNumber + "</h1>");
    for (let i = 0; i < keysSize; i++) {
        let localStorageRow = window.localStorage.getItem(window.localStorage.key(i));
        if (window.DOMParser) {
            let parser = new DOMParser();
            xmlDoc = parser.parseFromString(localStorageRow, "text/xml");
            console.log(xmlDoc);
        }
        let x = xmlDoc.getElementsByTagName("q");
        for (let i = 0; i < x.length; i++) {
            if (updateQuestions == 27) {
                updateQuestions = 1;
                updateQuestion4 = 1;
                userNumber++;
                document.write("<p>" + separateNewUser2 + "</p>");
                document.write("<h1> Respostas do Utilizador: " + userNumber + "</h1>")
            }
            if(updateQuestions == 4 && updateQuestion4 < 4){
                document.write("<p> Pergunta " + updateQuestions + " , " + updateQuestion4 + " opção "+ " : " + x[i].childNodes[0].nodeValue + "</p>");
                updateQuestion4++;
                if(updateQuestion4 > 3) {
                    updateQuestions = 5 ;
                }
            }
            else{
                document.write("<p> Pergunta " + updateQuestions + " : " + x[i].childNodes[0].nodeValue + "</p>");
                updateQuestions++;
            }
        }
    }
}
