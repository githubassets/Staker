// deploy/00_deploy_your_contract.js

const { ethers } = require("hardhat");

module.exports = async ({ getNamedAccounts, deployments, _ }) => {
    if (_);
    const { deploy } = deployments;
    const { deployer } = await getNamedAccounts();
    // console.log(deployer);

    const NFTY = await deploy("NFTY", { from: deployer, log: false, waitConfirmations: 1, });

    await deploy("Reward", { from: deployer, log: false, waitConfirmations: 1, });
    const Reward = await (ethers.getContract("Reward"));
    const Staker = await deploy("Staker", { from: deployer, args: [Reward.address, NFTY.address], log: false, waitConfirmations: 1, });
    await Reward.setStaker(Staker.address);
};
module.exports.tags = ["localnet"];
