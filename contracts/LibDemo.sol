// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;
import "./Ext.sol";

contract LibDemo {
    using StrExt for string;
    using ArrayExt for uint[];

    function runnerStr(
        string memory str1,
        string memory str2
    ) public pure returns (bool) {
        // return str1.eq(str2); // использование внешней библиотеки. В строке появился метод eq
        return StrExt.eq(str1, str2); // либо можно эту функцию вызвать из глобального объекта библиотеки
    }

    function inArray(uint[] memory array, uint el) public pure returns (bool) {
        return array.inArray(el);
    }
}
