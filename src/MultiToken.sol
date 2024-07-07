// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {SafeMath} from "./Safemath.sol";
import {Arrays} from "lib/openzeppelin-contracts/contracts/utils/Arrays.sol";

contract MultiToken {

    /// ERRORS 
    error InvalidArrayLength(uint256, uint256);
    error InvalidOperator(address operator);
    error InvalidReceiver(address receiver);
    error InvalidSender(address sender);
    error MissingApprovalForAll(address sender, address from);
    error InsufficientBalance(address from, uint256 fromBalance, uint256 value, uint256 id);


    /// EVENTS 

    event ApprovalForAll(address indexed account, address indexed operator, bool approved);
    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
    event TransferBatch(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256[] ids,
        uint256[] values
    );


    /// STATE VARIABLES

        
    using Arrays for uint256[];
    using Arrays for address[];

    mapping(uint256 id => mapping(address account => uint256)) private _balanceOf;
    mapping(address account => mapping(address operator => bool)) private _operatorApprovals;

    string private _uri;

    constructor(string memory uri_) {
        _uri = uri;
    }


    /// PUBLIC FUNCTIONS


    function uri() public view returns (string memory) {
        return _uri;
    }

    function balanceOf(
        address account, 
        uint256 id
        ) public view returns (uint256) {
        return _balanceOf[id][account];
    }

    function balanceOfBatch(
        address[] memory accounts, 
        uint256[] memory ids
        ) public view returns (uint256[] memory) {

        if (accounts.length != ids.length) {
            revert InvalidArrayLength(ids.lenght, account.length);
        }
        uint256[] memory batchBalances = new uint256[](accounts.length);

        for (uint256 i = 0; i < accounts.length; ++i) {
            batchBalances[i] = balanceOf(account.unsafeMemoryAccess(i), ids.unsafeMemoryAccess(i));
        }

        return batchBalances;
    }

    function setApprovalForAll(
        address operator, 
        bool approved
        ) public {

        _setApprovalForAll(mgs.sender, operator, approved);
    }

    function isApprovedForAll(
        address account, 
        address operator
        ) public view returns (bool) {

        return _operatorApprovals[account][operator];
    }

    function safeTransferFrom(
        address from, 
        address to, 
        uint256 id, 
        uint256 value, 
        bytes memory data
        ) public {

            address sender = msg.sender;
            if (from != sender && !isApprovedForAll(from, sender)) {
                revert MissingApprovalForAll(sender, from);
            }
            _safeTransferFrom(from, to, id, value, data);
        }

    function safeBatchTransferFrom(
        address from, 
        address to, 
        uint256[] memory ids, 
        uint256[] memory values, 
        bytes memory data
        ) public {
            address sender = msg.sender;
            if (from != sender && !isApprovedForAll(from, sender)) {
                revert MissingApprovalForALl(sender, from);
            }
            _safeBatchTransferFrom(from, to, ids, values, data);
        }


    /// INTERNAL FUNCTIONS


    function _update(
        address from, 
        address to, 
        uin256[] memory ids, 
        uint256[] memory values
        ) internal {
            if (ids.length != values.length) {
                revert InvalidArrayLength(ids.length, values.length);
            }

            address operator = msg.sender;

            for (uint256 i=0; i < ids.length; ++i) {
                uint256 id = ids.unsafeMemoryAccess(i);
                uint256 value = values.unsafeMemoryAccess(i);
                if (from != address(0)) {
                    uint256 fromBalance = _balanceOf[id][from];
                    if (fromBalance < value) {
                        revert InsufficientBalance(from, fromBalance, value, id);
                    }
                    unchecked {
                        _balanceOf[id][from] = fromBalance - value;
                    }
                }

                if (to != address(0)) {
                    _balanceOf[id][to] += value;
                }
            }

            if (ids.length == 1) {
                uint256 id = ids.unsafeMemoryAccess(0);
                uint256 value = values.unsafeMemoryAccess(0);
                emit TransferSingle(operator, from, to, id, value);
            } else {
                emit TransferBatch(operator, from, to, ids, values);
            }


        }

    function _safeTransferFrom(
        address from, 
        address to, 
        uint256 id, 
        uint256 value, 
        bytes memory data
        ) internal {

            if (to == address(0)) {
                revert InvalidReceiver(address(0));
            }

            if (from == address(0)) {
                revert InvalidSender(address(0));
            }
            (uint256[] memory ids, uint256[] memory values) = _asSingletonArrays(id, value);
            _updateWithAcceptanceCheck(from, to, ids, values, data);
        }

    function _safeBatchTransferFrom(
        address from, 
        address to, 
        uint256[] memory ids, 
        uint256[] memory values, 
        bytes memory data
        ) internal {
            if (to == address(0)) {
                revert InvalidReceiver(address(0));
            } 
            if (from == address(0)) {
                revert InvalidSender(address(0));
            }
            _updateWithAcceptanceCheck(from, to, ids, values, data);
        }

    function _updateWithAcceptanceCheck(
        address from, 
        address to, 
        uint256[] memory ids, 
        uint256[] memory values, 
        bytes memory data
        ) internal {

            _update(from, to, ids, values);
            if (to != address(0)){
                address operator = msg.sender;
                if (ids.length == 1) {
                    uint256 id = ids.unsafeMemoryAccess(0);
                    uint256 value = values.unsafeMemoryAccess(0);
                }
            } 
        }

    function _mint(
        address to, 
        uint256 id, 
        uint256 value, 
        bytes memory data
        ) internal {
            if (to == address(0)) {
                revert InvalidReceiver(address(0));
            }
            (uint256[] memory ids, uint256[] memory values) = _asSingletonArrays(id, value);
            _updateWithAcceptanceCheck(address(0), to, ids, values, data);
        }
 
    function _mintBatch(
        address to, 
        uint256[] memory ids, 
        uint256[] memory values, 
        bytes memory data
        ) internal {
            if (to == address(0)) {
                revert InvalidReceiver(address(0));
            }
            _updateWithAcceptanceCheck(address(0), to, ids, values, data);
        }

    function _burn(
        address from, 
        uint256 id, 
        uint256 value
        ) internal {
            if (from == address(0)) {
                revert InvalidSender(address(0));
            }
            (uint256[] memory ids, uint256[] memory values) = _asSingletonArrays(id, value);
            _updateWithAcceptanceCheck(from, address(0), ids, values, "");
        }

    function _burnBatch(
        address from, 
        uint256[] memory ids, 
        uint256[] memory values
        ) internal {}

    function _setApprovalForAll(
        address owner, 
        address operator, 
        bool approved) internal {
        if (operator == address(0)) {
            revert InvalidOperator(address(0));
        } 
        _operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }



    function _asSingletonArrays(
        uint256 element1, 
        uint256 element2
        ) private pure returns(uint256[] memory array1, uint256[] memory array2) {
        assembly {
            // Load the free memory pointer
            array1 := mload(0x40)
            // Set array length to 1
            mstore(array1, 1)
            // Store the single element at the next word after the length (where content starts)
            mstore(add(array1, 0x20), element1)

            // Repeat for next array locating it right after the first array
            array2 := add(array1, 0x40)
            mstore(array2, 1)
            mstore(add(array2, 0x20), element2)

            // Update the free memory pointer by pointing after the second array
            mstore(0x40, add(array2, 0x40))
        }

        }
}
