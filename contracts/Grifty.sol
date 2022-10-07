// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFTY is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() 
        ERC721("NFTY", "NULl")
        Ownable()
    { 
        // mint for tests
        mint(0x70997970C51812dc3A010C7d01b50e0d17dc79C8); 
        mint(0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC);
        mint(0x90F79bf6EB2c4f870365E785982E1f101E93b906);
    }

    function mint(address player) private returns (uint256) {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(player, newItemId);

        return newItemId;
    }
}
