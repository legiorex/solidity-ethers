// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "./Ownable.sol";

abstract contract Balances is Ownable {
    function withdraw(address payable _to) public virtual override onlyOwner {
        _to.transfer(getBalance());
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
