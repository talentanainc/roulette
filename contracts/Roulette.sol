pragma solidity ^0.4.11;


 contract  Roulette {

    enum Color {Black, Red }   
    enum BetType{Inside,Outside} 

    struct Bet{
        //1 for Black, 2 for Red
        uint color;
        //1 for Inside, 2 for Outside
        uint theType;
        uint betNumber;
        uint amount;
    }
    mapping (address => Bet) bets;
    mapping (uint => address) betsNumber;

    bool betFinished;

    event betOver(uint time);

    event announceWinner(address winner, uint prize);

    modifier afterBetOver(){
        require(betFinished == true);
        _;
    }

    modifier beforeBedOver(){
        require (! betFinished);
        _;
    }

    function putBet(uint color,uint betType,uint betNumber,uint amount) beforeBedOver payable {

        require(amount > 0);
        betsNumber[betNumber] = msg.sender;
        bets[msg.sender] = Bet (color,betType,betNumber,amount);
    }

    function spin() afterBetOver returns (address winner,uint prize){
        // random color (between 1 and 2)
        // random number between (0 - 36)
        //uint winningColor = randColor(true);
        uint winningNumber = randNumber(20);

        winner = betsNumber[winningNumber];
        prize = bets[winner].amount * 3;
    }

    function randColor(bool decide) internal  returns (uint rc){        
        if(decide){
            rc = 1;
        }
        rc = 2;
    }

    function randNumber(uint base) internal returns (uint number){
        //It is hard to generate a random number, since it will be a differenct one on each node, and we will not get a consensus
        if(base > 36){
            number = 36;
        }
        number = base % (base - 10);
    }
}