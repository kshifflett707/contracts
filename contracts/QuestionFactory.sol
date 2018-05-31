pragma solidity ^0.4.23;

import "./zeppelin/ownership/Ownable.sol";

contract QuestionFactory is Ownable {

    uint public minBounty = 100000000000000 wei;
    
    struct Question {
        uint bounty;
        address asker;
        bool payedOut;
    }

    mapping(uint => Question) public questionStruct;
    uint[] public questionList;

    function createQuestion(uint _id) public payable returns (uint index) {
        require(msg.value > minBounty);      

        questionStruct[_id].bounty = msg.value;
        questionStruct[_id].asker = msg.sender;
        questionStruct[_id].payedOut = false;

        return questionList.push(_id)-1;
    }

    function getQuestionCount() public view returns (uint) {
        return questionList.length;
    }
    
    function setMinBounty(uint _minBounty) public onlyOwner {
        minBounty = _minBounty;
    }

    constructor() public {
        owner = msg.sender;
    }

}