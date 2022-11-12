// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "forge-std/Test.sol";

contract Telephone is Test{

  address public owner;

  constructor() public {
    owner = msg.sender;
  }

  function changeOwner(address _owner) public {
    emit log_named_address("telephone changeOwner() msg.sender:", msg.sender);
    emit log_named_address("telephone changeOwner() tx.origin:", tx.origin);

    if (tx.origin != msg.sender) {
      owner = _owner;
    }
  }
}