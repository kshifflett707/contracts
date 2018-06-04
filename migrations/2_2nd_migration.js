const QuestionFactory = artifacts.require('./QuestionFactory.sol');

module.exports = function(deployer) {
  deployer.deploy(QuestionFactory);
};
