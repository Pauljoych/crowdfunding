// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.13;

import "../lib/forge-std/src/Test.sol";
import "../src/FundingToken.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC1155/utils/ERC1155Receiver.sol";

contract FundingTokenTest is Test, ERC1155Receiver, ERC1155Holder {
    FundingToken c;

    function setUp() public {
        c = new FundingToken(0);
		c.setPool(address(this));
    }
	
	function test_createToken() public {
		c.createToken(1000, 1);
		assertEq(c.tokenOwnerById(0), address(this));
	}	

	function test_mintToken() public {
		c.setPool(address(this));
		c.createToken(1000, 1);
		c.mintTokenById(address(this), 0, 1000);
		assertEq(c.balanceOf(address(this), 0), 1000);
	}
}
