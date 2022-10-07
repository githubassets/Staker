// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/INFTY.sol";
import "./interfaces/IReward.sol";

/** 
 * @title NFT staking contract
 * @notice Allows to stake, unstake and distribute rewards
 * @dev github.com/githubassets
 */
contract Staker is Ownable {
    uint256 constant MULTIPLIER = 10e18;
    IReward immutable Reward;
    INFTY immutable NFTY;

    /** 
     * @notice user info
     * @dev contains details about a single user
     * @custom:member staked how much currently staked
     * @custom:member skipped number that is subtracted from rewards
     */
    struct User {
        uint16 staked;
        uint256 skipped;
    }

    /// mapping of users
    mapping(address => User) public users;
    /// tracks nft owners
    mapping(uint256 => address) public owners;

    /**
     * Indicates all rewards that would've been accrued by a single 
     * nft since the first stake, updated by update() function
     */
    uint256 private reward;
    /// @dev block.number of last update
    uint256 private time;
    
    event Staked(address user, uint16 count);
    event Unstaked(address user, uint16 count);

    constructor (address _reward, address grifty) Ownable() {
        Reward = IReward(_reward);
        NFTY = INFTY(grifty);
    }

    /** 
     * @notice Stake, update and distribute rewards
     * @param token NFT id
     */
    function stake(uint256 token) external {
        User storage user = users[msg.sender];

        update();

        if (user.staked > 0) {
            /* (reward-user.skipped) is how much a single nft would earn
               since user last harvested */
            uint256 pending = user.staked * (reward - user.skipped);
            if (pending > 0) 
                Reward.mint(msg.sender, pending);
        }
        user.skipped = reward;

        NFTY.transferFrom(msg.sender, address(this), token);
        owners[token] = msg.sender;
        emit Staked(msg.sender, ++user.staked);
    }

    /** 
     * @notice Unstake, update and distribute rewards
     * @param token NFT id
     */
    function unstake(uint256 token) external {
        require(owners[token] == msg.sender,"Not the staker");
        User storage user = users[msg.sender];

        update();

        uint256 pending = user.staked * (reward - user.skipped);
        if (pending > 0) 
            Reward.mint(msg.sender, pending);
        user.skipped = reward;

        NFTY.transferFrom(address(this), msg.sender, token);
        owners[token] = address(0);
        emit Unstaked(msg.sender, --user.staked);
    }

    /** 
     * @notice Get accrued rewards
     * @param _user user's address
     * @return rewards pending rewards
     */
    function accrued(address _user) external view returns(uint256 rewards) {
        User storage user = users[_user];
        uint256 delay = MULTIPLIER * (block.number - time) / NFTY.balanceOf(address(this));
        return user.staked * (reward + delay - user.skipped);
    }

    /** 
     * @notice Update reward information
     * @dev We add rewards between current block and last execution
     */
    function update() public {
        uint256 staked = NFTY.balanceOf(address(this));
        if (staked > 0)
            reward += MULTIPLIER * (block.number - time) / staked;
        time = block.number;
    }
}
