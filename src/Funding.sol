// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./FundingPool.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

/*
 * @author @pauljoych
 * @title Funding token for Kullolabs
 */

error tokenNotExist();
error tokenReachMaxSupply();

contract Funding is Ownable, ERC1155 {
    event TokenCreated(address owner, uint256 tokenId, uint256 tokenMaxSupply);
    event TokenMinted(address to, uint256 tokenId, uint256 amount);

    struct TokenData {
        address tokenOwner;
        uint256 tokenMaxSupply;
        uint256 tokenCurrentSupply;
    }

    // @notice Token pool address
    address fundingPool;

    // @notice Funding token data
    uint256 private tokenId;
    mapping(uint256 => TokenData) tokenList;

    constructor(uint256 tokenId_) ERC1155("") {
        tokenId = tokenId_;
    }

    modifier onlyPool() {
        require(fundingPool == tx.origin, "caller is not the pool");
        _;
    }

    // @notice Create funding token identifier by current tokenId
    // @dev tokeniId is auto index
    // @param tokenSupply_ total supply limit
    function createToken(uint256 tokenMaxSupply_) external {
        tokenList[tokenId].tokenOwner = msg.sender;
        tokenList[tokenId].tokenMaxSupply = tokenMaxSupply_;
        tokenList[tokenId].tokenCurrentSupply = 0;

        emit TokenCreated(msg.sender, tokenId, tokenMaxSupply_);

        tokenId++;
    }

    // @notice Mint token by id
    // @param to_ The token reciver
    // @param tokenId_ The token id
    // @param amout_ The token amount
    // @dev Only pool can use it
    function mintTokenById(
        address to_,
        uint256 tokenId_,
        uint256 amount_
    ) external onlyPool {
        if ()
            _mint(to_, tokenId_, amount_, "");

        emit TokenMinted(to_, tokenId_, amount_);
    }

    // @notice
    function totalSupplyById(uint256 tokenId_) external view returns (uint256) {
        if (tokenList[tokenId_].tokenOwner == address(0x0))
            revert tokenNotExist();

        return tokenList[tokenId_].tokenCurrentSupply;
    }

    // @notice Get total token supply by id
    // @dev Return token supply
    // @param tokenId_ The token id
    function totalMaxSupplyById(uint256 tokenId_)
        external
        view
        returns (uint256)
    {
        if (tokenList[tokenId_].tokenOwner == address(0x0))
            revert tokenNotExist();

        return tokenList[tokenId_].tokenMaxSupply;
    }

    // @notice Get token ownership
    // @dev Return token owner address
    // @param tokenId_ The token id
    function tokenOwnerById(uint256 tokenId_) external view returns (address) {
        if (tokenList[tokenId_].tokenOwner == address(0x0))
            revert tokenNotExist();

        return tokenList[tokenId_].tokenOwner;
    }
}
