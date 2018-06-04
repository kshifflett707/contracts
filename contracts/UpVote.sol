// pragma solidity ^0.4.23;

// import "./AnswerFactory.sol";

// /*
//  * The upvote contract allows users to upvote their favorite answers.
//  * Users must be given the ability to vote by the Owner of the contract
//  * they are only allowed to vote once per question.
//  * A future edition of this contract plans on implementing a single transferable vote
//  * as well as making reputation and ability to vote more decentralized
//  *
//  */
// contract UpVote is AnswerFactory {
  
//     struct Vote {
//         address voter;
//         uint aid;
//     }

//     Vote[] public votes;

//     mapping(uint => uint[]) public questionIdToVoteIds;
//     mapping(address => uint) public reputation;

//     function giveRightToVote(address _voter, uint16 _reputation) public onlyOwner {
//         reputation[_voter] = _reputation;
//     }

//     function didVote(uint _qid, address _voter) internal view returns (bool) {
//         uint[] memory _questionVotes = questionIdToVoteIds[_qid];

//         for (uint i = 0; i < _questionVotes.length; i++) {
//             address voted = votes[_questionVotes[i]].voter;
//             if (_voter == voted) {
//                 return true;
//             }
//         }
//         return false;
//     } 

//     function upVote(address _voter, uint _aid) public {
//         uint _qid = getQuestionId(_aid);
//         uint _weight = reputation[msg.sender];
        
//         require(answerStruct[_aid].giver != _voter, "Can't vote on your own answer");
//         require(!didVote(_qid, msg.sender), "Cannot vote twice");

//         uint _voteId = votes.push(Vote(msg.sender, _aid)) - 1;
//         questionIdToVoteIds[_qid].push(_voteId);
//         answerStruct[_aid].score = answerStruct[_aid].score + _weight;     
//     }

//     function payoutWinner(uint _qid) public returns (uint reward) {
//         Question memory question = questionStruct[_qid];
//         Answer memory bestAnswer;
//         require(!question.payedOut, "Question already payed out");
//         uint winningScore = 0;
//         reward = question.bounty;
        
//         for (uint i = 0; i < answerList.length; i++) {
//             Answer memory answer = answerStruct[answerList[i]];
//             if (answer.qid == _qid) {
//                 reward = reward + answer.stake - (10000000000000 wei * i);
//                 if(answer.score > winningScore) {
//                     winningScore = answer.score;
//                     bestAnswer = answer;
//                 }
//             }
//         }

//         if (winningScore == 0) {
//             question.asker.transfer(reward);
//         } else {
//             bestAnswer.giver.transfer(reward);           
//         }

//         question.payedOut = true;
//         return reward;
//     }
// }