// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../lib/openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

/*
 * @author @pauljoych
 * @title Funding token for Kullolabs
 */

error tokenOwnerOnly();
error tokenNotExist();
error tokenReachMaxSupply();
contract FundingToken is Ownable, ERC1155 {
    event TokenMinted(address to, uint256 tokenId, uint256 amount);
    event TokenCreated(address owner, uint256 tokenId, uint256 tokenMaxSupply);

    struct TokenData {
        address tokenOwner;
        uint256 tokenMaxSupply;
        uint256 tokenCurrentSupply;
		uint256 tokenPrice;
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
        require(fundingPool == tx.origin, "not the pool");
        _;
    }

	// @param fundingPool_ The new pool address
	// @dev Only owner can call the function
	function setPool(address fundingPool_) external onlyOwner {
		fundingPool =  fundingPool_;
	}

	// @notice Setter for token ipo price
	// @param tokenId_ The token id
	// @param tokenPrice_ The init price for ipo
	// @dev Only token owner can call the fuction
	function setTokenPrice(uint256 tokenId_, uint256 tokenPrice_) 
		external 
	{
		if (tokenList[tokenId_].tokenOwner != msg.sender)
			revert tokenOwnerOnly();
		tokenList[tokenId].tokenPrice = tokenPrice_;	
	}

    // @notice Create funding token identifier by current tokenId
    // @param tokenSupply_ The total supply limit
	// @param tokenPrice_ The init price for ipo
    // @dev tokeniId is auto index
    function createToken(uint256 tokenMaxSupply_, uint256 tokenPrice_) 
		external 
	{
        tokenList[tokenId].tokenOwner = msg.sender;
        tokenList[tokenId].tokenMaxSupply = tokenMaxSupply_;
		tokenList[tokenId].tokenPrice = tokenPrice_;
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
		TokenData storage data = tokenList[tokenId_];
        if (data.tokenMaxSupply >= data.tokenCurrentSupply)
			revert tokenReachMaxSupply();
			
        _mint(to_, tokenId_, amount_, "");

		emit TokenMinted(to_, tokenId_, amount_);
    }

	// @notice Get token ipo price
	// @params tokenId_ The token id
	// @dev Return token ipo price
	function getTokenPriceById(uint256 tokenId_) 
		external
		view
		returns (uint256)
	{
        if (tokenList[tokenId_].tokenOwner == address(0x0))
			revert tokenNotExist();

		return tokenList[tokenId_].tokenPrice;
	}

    // @notice Get current supply by id
	// @params tokenId_ Then funding token id
	// @dev Return token curent supply
    function totalSupplyById(uint256 tokenId_) 
		external 
		view 
		returns (uint256) 
	{
        if (tokenList[tokenId_].tokenOwner == address(0x0))
            revert tokenNotExist();

        return tokenList[tokenId_].tokenCurrentSupply;
    }

    // @notice Get total token supply by id
    // @param tokenId_ The token id
    // @dev Return token supply
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
    function tokenOwnerById(uint256 tokenId_) 
		external
		view 
		returns (address) 
	{
        if (tokenList[tokenId_].tokenOwner == address(0x0))
            revert tokenNotExist();

        return tokenList[tokenId_].tokenOwner;
    }
}
