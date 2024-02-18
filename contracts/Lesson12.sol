// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;
import "./ILogger.sol";

contract Lesson12 {
    ILogger logger; // объект, который связан со смартконтрактом Logger

    constructor(address _logger) {
        logger = ILogger(_logger); //Делаем (преобразовываем) в правильный объект
    }

    function payment(address _from, uint _index) public view returns (uint) {
        return logger.getEntry(_from, _index);
    }

    receive() external payable {
        logger.log(msg.sender, msg.value);
    }
}
