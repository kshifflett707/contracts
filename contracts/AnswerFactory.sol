pragma solidity ^0.4.23;

import "./QuestionFactory.sol";

/*
 * the AnswerFactory allows user to post answers to questions
 */
contract AnswerFactory is QuestionFactory {

    uint public currentStake = 10000000000000 wei;

    struct Answer {
        address giver;
        uint stake;
        uint qid;
        uint score;
    }

    mapping(uint => Answer) public answerStruct;
    uint[] public answerList;

    function createAnswer(uint _id, uint _qid) public payable returns (uint index) {
        require(msg.value > currentStake, "Must stake more than the last answer");
        currentStake = msg.value;
        answerStruct[_id].giver = msg.sender;
        answerStruct[_id].stake = msg.value;        
        answerStruct[_id].qid = _qid;
        answerStruct[_id].score = 0;
        return answerList.push(_id)-1;
    }

    function answerCount(uint _qid) public view returns (uint count) {
        count = 0;
        for (uint i = 0; i < answerList.length; i++) {
            if (answerStruct[answerList[i]].qid == _qid) {
                count++;
            }
        }
        return count;
    }

    function getQuestionId(uint _id) public view returns (uint qid) {
        return answerStruct[_id].qid;
    }
}