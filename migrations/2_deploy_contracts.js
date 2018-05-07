const DPKI = artifacts.require("./DPKI.sol")

module.exports = function(deployer) {
        deployer.deploy(DPKI);
};
const IKP = artifacts.require("./IKP.sol")

module.exports = function(deployer) {
	deployer.deploy(IKP)
};


