// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {DeployMultiToken} from "../script/Deploy_MultiToken.sol";

contract MultiTokenTest is Test {
    DeployMultiToken public multiToken;

    function setUp() public {
        DeployMultiToken multitoken = new DeployMultiToken();

        token = multitoken.run()
    }

}
