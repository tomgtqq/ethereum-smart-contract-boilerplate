pragma solidity >=0.4.24;

contract ERC20Interface {

    string public constant name = "Udacity Token"; // keep the name short
    string public constant symbol = "UDC"; // stock symbol 
    uint8 public constant decimals = 18;  // 18 is the most common number of decimal places

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

    // 1.minting new thokens 
    // 2.also burn tokens which means that will decrease the supply of tokens.We can also burn tokens by sending them to an address zero
    // (This will not change the total number of tokens. it will just make those tokens unavailable.)
    function totalSupply() public view returns (uint); // totalSupply equals the sum of all balances, which means that is the maximum supply of tokens

    // The balanceOf function provide the number of tokens held by a given address.
    function balanceOf(address tokenOwner) public view returns (uint balance);
    function transfer(address to, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);
    // In the first step, a token holder gives another address of a smart contract approval to transfer up to certain amount of tokens known as allowance.
    // The token holder uses approve to approve this information.
    // In the second step, the smart contract who has been approved can take up to the allowed 
    // number of tokens from its allowance and use the ransferFrom function. 
    function approve(address spender, uint tokens) public returns (bool success);
    
    // The allowance fuction provides the number of tokens allowed to be transferred from a given address by another given address.
    function allowance(address tokenOwner, address spender) public view returns (uint remaining);

}