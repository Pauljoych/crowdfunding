// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../lib/openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

/*
* @author pauljoych.io
* @title Funding token for Kullolabs
*/

struct TokenData {
	address tokenOwner;
	uint256 tokenSupply;
}

contract Funding is Ownable, ERC1155 {
	event TokenCreated(address owner, uint256 tokenId, uint256 tokenSupply);

	uint256 private tokenId;
	TokenData[] public tokenList;

	constructor() ERC1155("") {
		tokenId = 0;
	}

	function createToken(uint tokenSupply) external {
		tokenList[tokenId].tokenOwner = msg.sender;
		tokenList[tokenId].tokenSupply = tokenSupply;

		_mint(msg.sender, tokenId, tokenSupply^18, "");
		emit TokenCreated(msg.sender, tokenId, tokenSupply);

		tokenId++;
	}
}
