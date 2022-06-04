// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)

pragma solidity ^0.8.0;

import "../../lib/openzeppelin-contracts/contracts/utils/introspection/IERC165.sol";

/**
 * @dev Required interface of an ERC1155 compliant contract, as defined in the
 * https://eips.ethereum.org/EIPS/eip-1155[EIP].
 *
 * _Available since v3.1._
 */
interface IFundingToken is IERC165 {
    /**
     * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
     */
    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);

    /**
     * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
     * transfers.
     */
    event TransferBatch(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256[] ids,
        uint256[] values
    );

    /**
     * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
     * `approved`.
     */
    event ApprovalForAll(address indexed account, address indexed operator, bool approved);

    /**
     * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
     *
     * If an {URI} event was emitted for `id`, the standard
     * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
     * returned by {IERC1155MetadataURI-uri}.
     */
    event URI(string value, uint256 indexed id);

    /**
     * @dev Returns the amount of tokens of token type `id` owned by `account`.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function balanceOf(address account, uint256 id) external view returns (uint256);

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
     *
     * Requirements:
     *
     * - `accounts` and `ids` must have the same length.
     */
    function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
        external
        view
        returns (uint256[] memory);

    /**
     * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
     *
     * Emits an {ApprovalForAll} event.
     *
     * Requirements:
     *
     * - `operator` cannot be the caller.
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
     *
     * See {setApprovalForAll}.
     */
    function isApprovedForAll(address account, address operator) external view returns (bool);

    /**
     * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
     *
     * Emits a {TransferSingle} event.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
     * - `from` must have a balance of tokens of type `id` of at least `amount`.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
     * acceptance magic value.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes calldata data
    ) external;

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
     *
     * Emits a {TransferBatch} event.
     *
     * Requirements:
     *
     * - `ids` and `amounts` must have the same length.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
     * acceptance magic value.
     */
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] calldata ids,
        uint256[] calldata amounts,
        bytes calldata data
    ) external;


	/**
	* @dev Set token price by `tokenId_` to `tokenPrice_`
	* 
	* Requirements:
	*
	* - `msg.sender` Must be token owner
	*/
	function setTokenPrice(
		uint256 tokenId_,
		uint256 tokenPrice_
	) external;

	/*
	* @dev Create token set supply by `tokenMaxSuppply_` and token ipo price by `tokenPrice_`.
	* 
	* Emits a {TokenCreated} events.
	*/
	function createToken(
		uint256 tokenMaxSuppply_,
		uint256 tokenPrice_
	) external;

	/*
	* @dev Mint `amount_` of token `to_` by it `tokenId_`.
	*
	* Requirements:
	*
	* - Must be token pool address to call this function.
	*/
	function mintTokenById(
		address to_,
		uint256 tokenId_,
		uint256 amount_
	) external;

	/*
	* @dev Returns token price by `tokenId_` 
	*
	* Requirements:
	*
	* - Token id owner can't be 0x0 or nil.
	*/
	function tokenPriceById(
		uint256 tokenId_
	) external view returns (uint256);
	
	/*
	* @dev Returns token current supply by `tokenId_` 
	*
	* Requirements:
	*
	* - Token id owner can't be 0x0 or nil.
	*/
	function tatalSupplyById(
		uint256 tokenId_
	) external view returns (uint256);
	
	/*
	* @dev Returns token max supply by `tokenId_` 
	*
	* Requirements:
	*
	* - Token owner can't be 0x0 or nil.
	*/
	function totalMaxSupplyById(
		uint256 tokenId_
	) external view returns (uint256);

	/*
	* @dev Returns token owner by `tokenId_` 
	*
	* Requirements:
	*
	* - Token owner can't be 0x0 or nil.
	*/
	function tokenOwnerById(
		uint256 tokenId_
	) external view returns (uint256);
}
