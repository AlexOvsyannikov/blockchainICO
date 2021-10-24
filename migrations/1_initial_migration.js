const Migrations = artifacts.require("Migrations");

const IcoToken = artifacts.require("tokenForIco")
const IcoContract = artifacts.require("icoContract")


var now_time = 1634390142;
var ten_minuts = 1634629829;

module.exports = async function (deployer) {
  await deployer.deploy(Migrations);
  // await deployer.deploy(SafeMath);
  await deployer.deploy(IcoToken, 10000000000);
  const token = await IcoToken.deployed();

  await deployer.deploy(IcoContract, now_time, ten_minuts, token.address, 10000000000);
  const ico_contract = await IcoContract.deployed();

  // await console.log(token)
  await token.setIcoAddress(ico_contract.address)
}
