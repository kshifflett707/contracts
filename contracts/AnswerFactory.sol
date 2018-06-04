pragma solidity ^0.4.23;


contract Simple {
    
    struct Question {
        uint id;
        mapping(uint => Answer) answerStructs;
        address user;
        uint bounty;
        uint endTime;
        uint bestAnswerId;
    }

    mapping(uint => Question) private questionStructs;

    struct Answer {
        uint id;
        uint questionId;
        mapping(address => Voter) voterStructs;
        address user;
        uint score;       
    }

    mapping(uint => Answer) private answerStructs;

    struct Voter {
        bool voted;
    }

    function isQuestion(uint qid) private view returns (bool isIndeed) {
        return (questionStructs[qid].id == qid);
    }

    function getQuestion(uint qid) public view returns (uint id, address user, uint bounty) {
        return (
            questionStructs[qid].id,
            questionStructs[qid].user,
            questionStructs[qid].bounty            
        );
    }

    function isAnswer(uint aid) private view returns (bool isIndeed) {
        return (answerStructs[aid].id == aid);
    }

    function getAnswer(uint aid) public view returns (uint id, address user, uint score, uint questionId) {
        return (
            answerStructs[aid].id,
            answerStructs[aid].user,
            answerStructs[aid].score,
            answerStructs[aid].questionId                                    
        );
    }

    function hasVoted(address voter, uint aid) public view returns (bool hasIndeed) {
        return (answerStructs[aid].voterStructs[voter].voted);
    }

    function createQuestion(uint qid) public payable returns(bool success) {
        require(!isQuestion(qid));
        questionStructs[qid].id = qid;        
        questionStructs[qid].bounty = msg.value;
        questionStructs[qid].user = msg.sender;
        questionStructs[qid].endTime = now + 7 days;        
        return true;
    }

    function createAnswer(uint aid, uint qid) public returns(bool success) {
        require(isQuestion(qid));  
        require(!isAnswer(aid));
        //require(questionStructs[qid].user != msg.sender);    
        answerStructs[aid].id = aid;                         
        answerStructs[aid].user = msg.sender;
        answerStructs[aid].questionId = qid;     
        questionStructs[qid].answerStructs[aid] = answerStructs[aid];
        return true;
    }

    function upVote(uint aid) public returns(bool success) {
        //require(!hasVoted(msg.sender, aid));
        //require(answerStructs[aid].user != msg.sender);
        Question memory question = questionStructs[answerStructs[aid].questionId];
        uint bestScore = answerStructs[question.bestAnswerId].score;
        answerStructs[aid].score += 1;
        answerStructs[aid].voterStructs[msg.sender].voted = true;
        if (answerStructs[aid].score > bestScore) {
            questionStructs[getQuestionFromAnswer(aid)].bestAnswerId = aid;
        }       
        return true;
    }

    function getQuestionFromAnswer(uint aid) private view returns(uint index) { 
        return answerStructs[aid].questionId;
    }

    function increaseBounty(uint qid) public payable returns(bool success) {
        require(isQuestion(qid)); 
        questionStructs[qid].bounty += msg.value;
        return true;
    }
    
    function payout(uint qid) public returns (bool success) {
        Question memory question = questionStructs[qid];
        if (now < question.endTime) {
            require(question.user == msg.sender);
        }
        Answer memory bestAnswer = answerStructs[question.bestAnswerId];
        bestAnswer.user.transfer(question.bounty);
        return true;
    }

}