// pcm 20172018a Blackjack object

//constante com o número máximo de pontos para blackJack
const MAX_POINTS = 21;


// Classe BlackJack - construtor
class BlackJack {
    constructor() {
        // array com as cartas do dealer
        this.dealer_cards = [];
        // array com as cartas do player
        this.player_cards = [];
        // variável booleana que indica a vez do dealer jogar até ao fim
        this.dealerTurn = false;

        // objeto na forma literal com o estado do jogo
        this.state = {
            'gameEnded': false,
            'dealerWon': false,
            'playerBusted': false
        };
        //métodos utilizados no construtor (DEVEM SER IMPLEMENTADOS PELOS ALUNOS)
        this.new_deck = function () {
            const Suits = 4;
            const Cards_Per_Suits = 13;
            let deck = [];
            for (let i = 0; i < Suits*Cards_Per_Suits; i++){
                deck[i] = (i % Cards_Per_Suits) + 1;
            }

            if (deck.length === 52){
                deck = this.shuffle(deck);
            }

            // afeta o new_deck
            return deck; // retorna o array baralhado

        };

        this.shuffle = function (deck) {
            let indexes = [];
            let shuffled = [];
            let index = null;

            for (let n = 0; n < deck.length; n++){
                indexes.push(n);
            }
            for (let n = 0; n < deck.length; n++){
                index = Math.floor((Math.random()*indexes.length));
                shuffled.push(deck[indexes[index]]);
                indexes.splice(index, 1);
            }
            return shuffled;
        };
        this.deck = this.shuffle(this.new_deck());
    }

    // métodos
    // devolve as cartas do dealer num novo array (splice)
    get_dealer_cards() {
        return this.dealer_cards.slice();
    }

    // devolve as cartas do player num novo array (splice)
    get_player_cards() {
        return this.player_cards.slice();
    }

    // Ativa a variável booleana "dealerTurn"
    setDealerTurn (val) {
        this.dealerTurn = true;
    }

    get_cards_value(cards) {
        let noAces = cards.filter(
            function (card) {   return card != 1;        });

        let figtransf = noAces.map(
            function (c) {      return c > 10 ? 10 : c;     });

        let sum = figtransf.reduce(
            function (sum,value) {return sum += value;},   0);

        let numAces = cards.length - noAces.length;

        while(numAces > 0){
            if(sum + 11 > MAX_POINTS){
                return sum + numAces;
            }
            sum += 11;
            numAces -= 1;
        }
        return sum + numAces;
    }
    dealer_move() {
        let card = this.deck[0];//vai buscar a carta na primeira posicao
        this.deck.splice(0,1);//adiciona/remove cartas
        this.dealer_cards.push(card);//coloca a carta na ultima posicao do array do player
        return this.get_game_state();// retorna o estado do jogo na funcao em baixo
    }

    player_move() {
        let card = this.deck[0];//vai buscar a carta na primeira posicao
        this.deck.splice(0,1); //adiciona/remove cartas
        this.player_cards.push(card); //coloca a carta na ultima posicao do array do player
        return this.get_game_state(); // retorna o estado do jogo na funcao em baixo

    }

    get_game_state() {
        let playerPoints = this.get_cards_value(this.player_cards);//Pontos que correspondem as cartas do jogador
        let dealerPoints = this.get_cards_value(this.dealer_cards);//Pontos que conrrespondem as cartas do dealer
        let playerBusted = playerPoints > MAX_POINTS; //verifica se os pontos do jogardor passaram os 21
        let playerWon = playerPoints === MAX_POINTS; //verifica se os pontos do jogador sao iguais a 21
        let dealerBusted = this.dealerTurn && (dealerPoints > MAX_POINTS); //verifica se o dealer obteu um numero menor que 21, e assim o player ganha
        let dealerWon = this.dealerTurn && dealerPoints > playerPoints && dealerPoints <= MAX_POINTS; // verifica se o dealer ganhou
        this.state.gameEnded = playerBusted || playerWon || dealerBusted || dealerWon; //verifica os diferentes estados do jogo
        this.state.playerBusted = playerBusted; //atualiza a variavel se o jogador ganhou
        this.state.dealerWon = dealerWon; //atualiza a variavel se o dealer ganhou
        return this.state; //retorna o estado do jogo
    }

    drawCard(id,cards){

        let cardNode = document.getElementById(id);
        while (cardNode.firstChild) {
            cardNode.removeChild(cardNode.firstChild);
        }

        for(let i = 0; i < cards.length; i++) {
            let src = document.getElementById(id);
            let img = document.createElement("img");
            if((id==="cardsDealer") && (cards.length ===2) && (i===1) && this.state.gameEnded === false ){
                img.src = "IMG/faceDownCard2.png"
            }
            else {
                switch (cards[i]) {
                    case 1:
                        img.src = "img/Ace.png";
                        break;
                    case 2:
                        img.src = "img/2S.png";
                        break;
                    case 3:
                        img.src = "img/3S.png";
                        break;
                    case 4:
                        img.src = "img/4S.png";
                        break;
                    case 5:
                        img.src = "img/5S.png";
                        break;
                    case 6:
                        img.src = "img/6S.png";
                        break;
                    case 7:
                        img.src = "img/7S.png";
                        break;
                    case 8:
                        img.src = "img/8S.png";
                        break;
                    case 9:
                        img.src = "img/9S.png";
                        break;
                    case 10:
                        img.src = "img/10S.png";
                        break;
                    case 11:
                        img.src = "img/JS.png";
                        break;
                    case 12:
                        img.src = "img/QS.png";
                        break;
                    default:
                        img.src = "img/KS.png";
                }
            }
            img.setAttribute("id", "img"+i);
            src.appendChild(img);
        }
    }
}