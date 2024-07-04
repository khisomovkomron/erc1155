// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {MultiToken} from "../src/MultiToken.sol";

contract DeployMultiToken is Script {

    function run() public returns (MultiToken){
        vm.startBroadcast();
        MultiToken multiToken = new MultiToken();

        vm.stopBroadcast();

        return multiToken;
    }
}
