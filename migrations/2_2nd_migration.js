// const AnswerFactory = artifacts.require('./AnswerFactory.sol');
// const Question = artifacts.require('./Question.sol');
// const QuestionFactory = artifacts.require('./QuestionFactory.sol');
const UpVote = artifacts.require('./UpVote.sol');
// const Upvote = artifacts.require('./Upvote.sol');

module.exports = function(deployer) {
  deployer.deploy(UpVote);
};
