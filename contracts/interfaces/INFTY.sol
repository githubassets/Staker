// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface INFTY is IERC721{
    function mint(address player) external returns (uint256);
}
