const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Staking of one nft", function() {
    it("Should stake an nft and console.log the reward for the first staking cycle", async function() {
        const [owner, addr1, addr2, addr3] = await ethers.getSigners();

        const deployer = owner.address;
        const nullAddress = "0x0000000000000000000000000000000000000000";
        const account1 = addr1.address;
        const account2 = addr2.address;
        const account3 = addr3.address;
        console.log(account3);

        /// factories
        const NFTYFactory = await ethers.getContractFactory("NFTY");
        const RewardFactory = await ethers.getContractFactory("Reward");
        const StakerFactory = await ethers.getContractFactory("Staker");

        /// @notice that the nft and the toke are being deployed

        const NFTYContract = await NFTYFactory.deploy();
        const RewardContract = await RewardFactory.deploy();

        await NFTYContract.deployed();
        await RewardContract.deployed();

        // we use their address as parameters for the Staking system

        const StakerContract = await StakerFactory.deploy(
            RewardContract.address,
            NFTYContract.address
        );

        // setting approval for all in the nft contract to the staking system contract
        console.log((StakerContract.address, account1, 0));
        await expect(NFTYContract.setApprovalForAll(StakerContract.address, true))
            .to.emit(NFTYContract, "ApprovalForAll")
            .withArgs(deployer, StakerContract.address, true);

        console.log("Staker deployed: ", StakerContract.address);

        // we need the staker to setApproval for all to the staking system contract
        await expect(
            NFTYContract.connect(addr1).setApprovalForAll(
                StakerContract.address,
                true
            )
        )
            .to.emit(NFTYContract, "ApprovalForAll")
            .withArgs(account1, StakerContract.address, true);
        expect(
            RewardContract.connect(owner).setStaker(
                StakerContract.address,
            )
        )
        await expect(
            NFTYContract.connect(addr2).setApprovalForAll(
                StakerContract.address,
                true
            )
        )
            .to.emit(NFTYContract, "ApprovalForAll")
            .withArgs(account2, StakerContract.address, true);
        expect(
            RewardContract.connect(owner).setStaker(
                StakerContract.address,
            )
        )
        await expect(
            NFTYContract.connect(addr3).setApprovalForAll(
                StakerContract.address,
                true
            )
        )
            .to.emit(NFTYContract, "ApprovalForAll")
            .withArgs(account3, StakerContract.address, true);
        expect(
            RewardContract.connect(owner).setStaker(
                StakerContract.address,
            )
        )

        // console.log(account1)
        await expect(StakerContract.connect(addr1).stake(1))
            .to.emit(StakerContract, "Staked")
            .withArgs(account1, 1);
        console.log("Staked ");
        await network.provider.send("evm_increaseTime", [200])
        await network.provider.send("evm_mine")
        await network.provider.send("evm_mine")
        await network.provider.send("evm_mine")
        pausecomp(1000)
        console.log(await StakerContract.accrued(account1));
        await expect(StakerContract.connect(addr2).stake(2))
            .to.emit(StakerContract, "Staked")
            .withArgs(account2, 1);
        console.log("Staked ");
        await expect(StakerContract.connect(addr3).stake(3))
            .to.emit(StakerContract, "Staked")
            .withArgs(account3, 1);
        console.log("Staked ");

        console.log(await StakerContract.accrued(account1));
        await network.provider.send("evm_mine")
        await expect(StakerContract.connect(addr2).unstake(2))
            .to.emit(StakerContract, "Unstaked")
            .withArgs(account2, 0);
        console.log("Unstaked ");
        console.log(await StakerContract.accrued(account1));
        await network.provider.send("evm_mine")

        console.log(await StakerContract.accrued(account1));
        // console.log(await StakerContract.accrued(account2));
        console.log(await RewardContract.balanceOf(account2));
        await expect(StakerContract.connect(addr1).unstake(1))
            .to.emit(StakerContract, "Unstaked")
            .withArgs(account1, 0);
        console.log("Unstaked ");
        pausecomp(10000)
    });
});
function pausecomp(millis) {
    var date = new Date();
    var curDate = null;
    do { curDate = new Date(); }
    while (curDate - date < millis);
}
