pragma solidity ^0.4.17;


contract Roulette {

    address _croupier;
    enum Color {Black, Red }   
    enum BetType{Inside,Outside} 

    struct Bet {
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

    function constructor() public {
        _croupier = msg.sender;
    }

    function () public payable {
        msg.sender.transfer(msg.value);
    }

    function putBet(uint color,uint betType,uint betNumber,uint amount) beforeBedOver public payable {

        require(amount > 0);
        betsNumber[betNumber] = msg.sender;
        bets[msg.sender] = Bet (color,betType,betNumber,amount);
    }

    function spin() afterBetOver internal returns (address winner,uint prize) {
        // random color (between 1 and 2)
        // random number between (0 - 36)
        //uint winningColor = randColor(true);
        uint winningNumber;
        uint winningColor;
        (winningNumber,winningColor ) = randNumber(20);

        winner = betsNumber[winningNumber];
        prize = bets[winner].amount * 3;
    }

    function randColor(bool decide) internal pure returns (uint rc){        
        if(decide){
            rc = 1;
        }
        rc = 2;
    }

    function randNumber(uint base) internal pure returns (uint number,uint color){
        //It is hard to generate a random number, since it will be a differenct one on each node, and we will not get a consensus
        //So we will return a number and color based on the base in a tuple
        if(base > 36){
            number = 36;
            color = 1;
        }else{
            color = 2;
            number = base % (base - 10);
        }        
    }
}