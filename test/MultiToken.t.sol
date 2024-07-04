// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {DeployMultiToken} from "../script/Deploy_MultiToken.sol";
import {MultiToken} from "../src/MultiToken.sol";

contract MultiTokenTest is Test {
    MultiToken public multiToken;

    function setUp() public {
        DeployMultiToken deploy_multitoken = new DeployMultiToken();

        multiToken = deploy_multitoken.run();
    }

}
