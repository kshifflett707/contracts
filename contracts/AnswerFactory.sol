// pragma solidity ^0.4.23;

// import "./QuestionFactory.sol";

// /*
//  * the AnswerFactory allows user to post answers to questions
//  */
// contract AnswerFactory is QuestionFactory {

//     uint public currentStake = 10000000000000 wei;

//     struct Answer {
//         address giver;
//         uint stake;
//         uint qid;
//         uint score;
//     }

//     mapping(uint => uint[]) public questionIdToAnswerIds;
//     mapping(uint => Answer) public answerStruct;
//     uint[] public answerList;

//     function createAnswer(uint _id, uint _qid) public payable returns (uint index) {
//         require(getAnswers(_qid).length <= 5, "Only 5 answers per question");
//         require(msg.value > currentStake, "Must stake more than the last answer");
//         currentStake = msg.value;
//         answerStruct[_id].giver = msg.sender;
//         answerStruct[_id].stake = msg.value;        
//         answerStruct[_id].qid = _qid;
//         answerStruct[_id].score = 0;
//         return answerList.push(_id)-1;
//     }

//     function answerCount(uint _qid) public view returns (uint count) {
//         count = 0;
//         for (uint i = 0; i < answerList.length; i++) {
//             Answer memory answer = answerStruct[answerList[i]];
//             if (answer.qid == _qid) {
//                 count++;
//             }
//         }
//         return count;
//     }

//     function getAnswers(uint _qid) public view returns (uint[]) {
//         uint[] memory _questionAnswers = questionIdToAnswerIds[_qid];
//         return _questionAnswers;
//     }

//     function getQuestionId(uint _id) public view returns (uint qid) {
//         return answerStruct[_id].qid;
//     }
// }