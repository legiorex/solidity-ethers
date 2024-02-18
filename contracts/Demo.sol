// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Shop {
    address public owner;
    mapping(address => uint) public payments;

    // Переменные всегда имеют какое-то значение, нет null, undefined

    bool myBool; //булевая переменная, хранится в блокчейне (state)

    // если не присвоить значение переменной, то будет значение по умолчанию,
    // в случае с булевым типом значение false

    constructor() {
        owner = msg.sender;
    }

    function payForItem() public payable {
        payments[msg.sender] = msg.value;
    }

    function withWdrowalAll() public {
        address payable _to = payable(owner);
        address _thisContract = address(this);
        _to.transfer(_thisContract.balance);
    }
}
