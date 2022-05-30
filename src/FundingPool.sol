// SPDX-License-identifier: MIT
pragma solidity ^0.8.13;

import "../lib/openzeppelin-contracts/contracts/interfaces/IERC1155.sol";

contract FundingPool {
    IERC1155 fundingToken;

    constructor(IERC1155 fundingToken_) {
        fundingToken = fundingToken_;
    }

    // @notice User can contribute to funding token
    function contributeToToken(uint256 tokenId_) external {}
}
