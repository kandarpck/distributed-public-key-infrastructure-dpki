pragma solidity ^0.4.16;

contract HelloWorld {
    uint256 counter = 5;
    address owner = msg.sender; //set owner as msg.sender

    function add() public {
        counter++;
    }

    function subtract() public {
        counter--;
    }

    function getCounter() public constant returns (uint256){
        return counter;
    }

    function kill() public {
        if (msg.sender == owner) {
            selfdestruct(owner);
        }
    }

    function() public payable {

    }
}