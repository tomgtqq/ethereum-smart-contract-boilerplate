pragma solidity >= 0.4.1 ;

contract HelloWord {
    function hello() pure public returns(string memory){
        return "Hello How are you ?";
    }
}

contract StarNotery {
    string public starName;
    address public starOwner;
    
    event starClaimed(address owner);
    
    constructor() public {
        starName = "UdaCity star";
    }
    
    function claimStar() public {
        starOwner = msg.sender;
        emit starClaimed(msg.sender);
    }
}