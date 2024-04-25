// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "lib/forge-std/src/Test.sol";
import {BoxV2} from "../src/BoxV2.sol";
import {BoxV1} from "../src/BoxV1.sol";

import {DeployBox} from "../script/DeployBox.s.sol";
import {UpgradeBox} from "../script/UpgradeBox.s.sol";

contract DeployAndUpgradeTest is Test {
    DeployBox public deployer;
    UpgradeBox public upgrader;
    address public owner = makeAddr("owner");

    address public proxy;
     function setUp() public {
      deployer = new DeployBox();
      upgrader = new UpgradeBox();
      proxy = deployer.run();
     }

     function testBoxV1IsProxy() public {
      address proxyAddress = deployer.deployBox();
      uint256 expectedValue = 7;
      vm.expectRevert();
      BoxV2(proxyAddress).setNumber(expectedValue);
     }

     function testUpgrades() public {
        BoxV2 box2 = new BoxV2();
        upgrader.upgradeBox(proxy, address(box2));

        uint256 expectedValue = 2;
        assertEq(expectedValue , BoxV2(proxy).version());

        BoxV2(proxy).setNumber(7);
        assertEq(7 , BoxV2(proxy).getNumber());
     }
}