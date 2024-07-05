// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {SafeMath} from "./Safemath.sol";
import {Arrays} from "lib/openzeppelin-contracts/contracts/utils/Arrays.sol";

contract MultiToken {

    /// ERRORS 



    /// EVENTS 




    /// STATE VARIABLES

        
    using Arrays for uint256[];
    using Arrays for address[];

    mapping(uint256 id => mapping(address account => uint256)) private _balanceOf;

    string private _uri;

    constructor(string memory uri_) {
        _uri = uri;
    }


    /// PUBLIC FUNCTIONS


    function uri() public view returns (string memory) {
        return _uri;
    }

    function balanceOf(address account, uint256 id) public view returns (uint256) {
        return _balanceOf[id][account];
    }

    function balanceOfBatch(address[] memory accounts, uint256[] memory ids) public view returns (uint256[] memory) {}

    function setApprovalForAll(address operator, bool approved) public {}

    function isApprovedForAll(address account, address operator) public view returns (bool) {}

    function safeTransferFrom(address from, address to, uint256 id, uint256 value, bytes memory data) public {}

    function safeBatchTransferFrom(address from, address to, uint256[] memory ids, uint256[] memory values, bytes memory data) public {}


    /// INTERNAL FUNCTIONS


    function _update(address from, address to, uin256[] memory ids, uint256[] memory values) internal {}

    function _safeTransferFrom(address from, address to, uint256 id, uint256 value, bytes memory data) internal {}

    function _safeBatchTransferFrom(address from, address to, uint256[] memory ids, uint256[] memory values, bytes memory data) internal {}

    function _updateWithAcceptanceCheck(address from, address to, uint256[] memory ids, uint256[] memory values, bytes memory data) internal {}

    function _mint(address to, uint256 id, uint256 value, bytes memory data) internal {}
 
    function _mintBatch(address to, uint256[] memory ids, uint256[] memory values, bytes memory data) internal {}

    function _burn(address from, uint256 id, uint256 value) internal {}

    function _burnBatch(address from, uint256[] memory ids, uint256[] memory values) internal {}

    function _setApprovalForAll(address owner, address operator, bool approved) internal {}

    function _doSafeTransferAcceptanceCheck(address operator, address from, address to, uint256 id, uint256 value, bytes memory data) private {}

    function _doSafeBatchTransferAcceptanceCheck(address operator, address from, address to, uint256[] memory ids, uint256[] memory values, bytes memory data) private {}

    function _asSingletonArrays(uint256 element1, uint256 element2) private pure returns(uint256[] memory array1, uint256[] memory array2) {}
}
