pragma solidity >=0.5.0;

contract AdvancedStroage {
    uint[] public ids;
    
    function add(uint _id) public {
        ids.push(_id);
    }
    
    function get(uint _postion) view public  returns(uint){
        returns ids[_postion]
    }
    
    function getAll() view public returns( uint[] memory) {
        return ids;
    }
    
    function length() view public returns (uint){
        return ids.length;
    }
    
}