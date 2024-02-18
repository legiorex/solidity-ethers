// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

interface IERC20 {
    //название токена (частью стандарта не явл)
    function name() external view returns (string memory);

    // краткое название токена (частью стандарта не явл)
    function symbol() external view returns (string memory);

    // количество знаков после запятой (частью стандарта не явл)
    function decimals() external pure returns (uint);

    // количество токенов в обороте
    function totalSupply() external view returns (uint);

    // посмотреть количество токенов на определенном адресе
    function balanceOf(address account) external view returns (uint);

    // передача токена на определенный адрес
    function transfer(address to, uint amount) external;

    // ф-ция, разрешающя отправлять токены третьему лицу
    function allowance(
        address owner,
        address spender
    ) external view returns (uint);

    // ф-ция, подтверждающая списание определённого количество токенов на адрес
    function approve(address spender, uint amount) external;

    // списывание токенов с одного адреса на другой
    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external;

    event Transfer(address indexed from, address indexed to, uint amount);
    event Approve(address indexed owner, address indexed to, uint amount);
}
