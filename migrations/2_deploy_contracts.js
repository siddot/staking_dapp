const TokenFarm = artifacts.require("TokenFarm");
const DaiToken = artifacts.require("DaiToken");
const MoodToken = artifacts.require("MoodToken");


module.exports = async function (deployer, network, accounts) {
  await deployer.deploy(DaiToken)
  const daiToken = await DaiToken.deployed();

  await deployer.deploy(MoodToken);
  const moodToken = await MoodToken.deployed()

  await deployer.deploy(TokenFarm, moodToken.address, daiToken.address);
  const tokenFarm = await TokenFarm.deployed()
  
  
  await moodToken.transfer(tokenFarm.address, "1000000000000000000000000")
  await daiToken.transfer(accounts[1], '100000000000000000000')


};
