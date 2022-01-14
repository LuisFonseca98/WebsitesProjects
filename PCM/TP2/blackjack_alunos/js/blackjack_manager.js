let game = null;

function debug(an_object) {
    document.getElementById("debug").innerHTML = JSON.stringify(an_object);
}
function buttons_initialization(){
    document.getElementById("card").disabled     = false;
    document.getElementById("stand").disabled     = false;
    document.getElementById("new_game").disabled = true;
}

function finalize_buttons(){
    document.getElementById("card").disabled     = true;
    document.getElementById("stand").disabled     = true;
    document.getElementById("new_game").disabled = false;
}


//FUNÇÕES QUE DEVEM SER IMPLEMENTADOS PELOS ALUNOS
function new_game(){
    game = new BlackJack();
    game.dealer_move();
    game.dealer_move();
    game.player_move();
    update_dealer(game.get_game_state());
    update_player(game.get_game_state());
    buttons_initialization();
    debug(game);
}

function update_dealer(state){
    let wonD = "";
    if (game.get_dealer_cards().length == 2){
        document.getElementById("dealer").innerHTML =  wonD;
    }
    if(state.gameEnded && state.dealerWon){
        wonD = " Dealer Won!";
        finalize_buttons();
    }
    if(state.gameEnded && !state.dealerWon){
        wonD = " Dealer Lost!";
        finalize_buttons();
    }
    if(state.gameEnded && state.dealerWon && state.playerBusted){
        wonD = " Dealer Won!";
        finalize_buttons();
    }
    document.getElementById("dealer").innerHTML = wonD;
    game.drawCard("cardsDealer",game.get_dealer_cards());
}

function update_player(state){
    let wonP = "";
    game.get_cards_value(game.get_player_cards()) === 1;
    if(state.gameEnded && !state.playerBusted){
        wonP = " Player Won! ";
        finalize_buttons();
    }
    if(state.gameEnded && state.playerBusted){
        wonP = " Player Lost! ";
        finalize_buttons();
    }

    document.getElementById("player").innerHTML =  wonP;
    game.drawCard("cardsPlayer",game.get_player_cards());
}



function dealer_new_card(){
    game.dealer_move();
    this.update_dealer(game.state);
    return game.state;
}

function player_new_card(){
    game.player_move();
    this.update_player(game.state);
    return game.state;
}

function dealer_finish(){
    game.setDealerTurn(true);
    let state = game.get_game_state();
    while(!game.state.gameEnded){
        update_dealer(state);
        if(game.get_cards_value(game.get_dealer_cards())<
            game.get_cards_value(game.get_player_cards())){
            dealer_new_card(state);
        }
        game.get_game_state()
    }
    game.state.gameEnded;
    update_dealer(state);

}