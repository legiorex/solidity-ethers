// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "./Ownable.sol";
import "./Balances.sol";

contract MyContract is Ownable, Balances {
    // constructor() Ownable(msg.sender) {}
    constructor(address _owner) Ownable(_owner) {}

    function withdraw(
        address payable _to
    ) public override(Balances, Ownable) onlyOwner {
        // Balances.withdraw(_to); //указываем с какого конкретного контракта вызывать функцию
        super.withdraw(_to); //поднятся на один уровень вверх по наследованию контрактов
    }
}
