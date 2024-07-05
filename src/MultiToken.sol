// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {SafeMath} from "./Safemath.sol";
import {Arrays} from "lib/openzeppelin-contracts/contracts/utils/Arrays.sol";

contract MultiToken {
    using Arrays for uint256[];
    using Arrays for address[];

    mapping(uint256 id => mapping(address account => uint256)) private _balanceOf;

    string private _uri;

    constructor(string memory uri_) {
        _uri = uri;
    }

    function uri() public view returns (string memory) {
        return _uri;
    }

    function balanceOf(address account, uint256 id) public view returns (uint256) {
        return _balanceOf[id][account];
    }

}
