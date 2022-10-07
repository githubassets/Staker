// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Reward is ERC20, Ownable{
    constructor () ERC20("Reward","JOB") Ownable() { }

    address public controller;

    event Mint(address indexed to, uint wad);

    modifier restricted() {
        require(msg.sender == controller, "Unauthorized");
        _;
    }

    function setStaker(address _controller) external onlyOwner {
        controller = _controller;
    }

    function mint(address to, uint wad) external restricted() {
        _mint(to,wad);
        emit Mint(to,wad);
    }
}
