pragma solidity ^0.8.0;

import "src/levels/08Vault/Vault.sol";
import "src/core/Ethernaut.sol";
import "src/levels/08Vault/VaultFactory.sol";

import "forge-std/Test.sol";
import "forge-std/Vm.sol";

contract TestVault is Test{
    Ethernaut ethernaut;
    address myEoaAddress = 0xB5Da00630Ca5fdE4d9cED2fcdA0C607cE198F159;
    function setUp() public{
        ethernaut = new Ethernaut();
        vm.deal(payable(myEoaAddress), 1 ether);
    }

    function testVault() public {
        VaultFactory vaultFactory = new VaultFactory();
        ethernaut.registerLevel(vaultFactory);
        vm.startPrank(myEoaAddress);
        address instanceAddress = ethernaut.createLevelInstance(vaultFactory);
        Vault vaultInstance = Vault(payable(instanceAddress));
        bytes32 data = vm.load(instanceAddress, bytes32(uint256(1)));

        emit log_named_bytes32("Password in hex form:", data);
        emit log_named_string("Password in text form after hex2text", "A very strong secret password :)");
        vaultInstance.unlock("A very strong secret password :)");
        vm.stopPrank();
        bool result = vaultFactory.validateInstance(payable(instanceAddress), myEoaAddress);
        assertTrue(result);
    }

}