// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract Lesson7 {
    address owner;

    constructor() {
        owner = msg.sender;
    }

    event Paid(address _from, uint _amount, uint _timestamp);

    receive() external payable {
        pay();
    }

    function pay() public payable {
        emit Paid(msg.sender, msg.value, block.timestamp);
    }

    // modifier onlyOwner() {
    //     require(msg.sender != owner, "your are not an owner!");
    //     _;
    // }

    function withdraw(address payable _to) external {
        require(msg.sender == owner, "your are not an owner!");

        // if (msg.sender != owner) {
        //     revert("your are not an owner!");
        // }

        _to.transfer(address(this).balance);
    }
}
