pragma solidity >=0.4.24;

contract SampleStorage {
    string public data;
    
    function setData(string memory _data) public {
        data = _data;
    }
    
    function getData() public view returns(string memory){
        return data;
    }
}