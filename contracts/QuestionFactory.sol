pragma solidity ^0.4.23;

contract Owned {
    address public owner;
    modifier onlyOwner {
        if (msg.sender != owner)
            _;
    }
    constructor() public {
        owner = msg.sender;
    }
}

contract QuestionFactory is Owned {

    constructor() public {
        owner = msg.sender;
    }
    
    struct Question {
        uint id;
        uint[] answerList;
        address user;
        uint bounty;
        uint endTime;
    }

    mapping(uint => Question) private questionStructs;
    uint[] private questionList;

    struct Answer {
        uint id;
        uint questionId;
        mapping(address => Voter) voterStructs;
        address user;
        uint score;       
    }

    mapping(uint => Answer) private answerStructs;
    uint[] private answerList;

    struct Voter {
        bool voted;
    }

    function getQuestionCount() public view returns (uint count) {
        return (questionList.length);
    }

    function getAnswerCount() public view returns (uint count) {
        return (answerList.length);
    }

    function isQuestion(uint qid) private view returns (bool isIndeed) {
        if (questionList.length == 0) return false;
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
        if (answerList.length == 0) return false;
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
        require(!isQuestion(qid), "Question id already exists");
        questionStructs[qid].id = qid;        
        questionStructs[qid].bounty = msg.value;
        questionStructs[qid].user = msg.sender;
        questionStructs[qid].endTime = now + 7 days;        
        questionList.push(qid)-1;
        return true;
    }

    function createAnswer(uint aid, uint qid) public returns(bool success) {
        require(isQuestion(qid), "Cannot post an answer to a question that doesn't exist");  
        require(!isAnswer(aid), "Answer id already exists");
        //require(questionStructs[qid].user != msg.sender, "Cannot post answers to your own question");    
        answerStructs[aid].id = aid;                         
        answerStructs[aid].user = msg.sender;
        answerStructs[aid].questionId = qid;     
        questionStructs[qid].answerList.push(aid)-1; 
        answerList.push(aid)-1;       
        return true;
    }

    function upVote(uint aid) public returns(bool success) {
        require(!hasVoted(msg.sender, aid), "Cannot vote twice");
        //require(answerStructs[aid].user != msg.sender, "Cannot upvote your own answer");
        answerStructs[aid].score += 1;
        answerStructs[aid].voterStructs[msg.sender].voted = true;       
        return true;
    }

    function getAnswerFromQuestion(uint qid, uint aid) private view returns(uint index) { 
        return questionStructs[qid].answerList[aid];
    }

    function increaseBounty(uint qid) public payable returns(bool success) {
        require(isQuestion(qid), "Cannot increase the bounty of a question that doesn't exist"); 
        questionStructs[qid].bounty += msg.value;
        return true;
    }

    function getQuestionAnswersCount(uint qid) public view returns (uint count) {
        return questionStructs[qid].answerList.length;
    }

    function getAnswerScore(uint aid) private view returns (uint score) {
        return answerStructs[aid].score;
    }
    
    function payout(uint qid) public returns (bool success) {
        if (now < questionStructs[qid].endTime) {
            require(questionStructs[qid].user == msg.sender, "Only the question owner can payout bounty first 7 days");
        }
        uint bestAnswerId = getAnswerFromQuestion(qid, 0);
        for (uint i = 1; i < getQuestionAnswersCount(qid); i++) {
            if (getAnswerScore(getAnswerFromQuestion(qid, i)) > getAnswerScore(bestAnswerId)) {
                bestAnswerId = getAnswerFromQuestion(qid, i);
            }
        }
        answerStructs[bestAnswerId].user.transfer(questionStructs[qid].bounty);
        return true;
    }

}