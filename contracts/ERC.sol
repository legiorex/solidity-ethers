// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "./IRC20.sol";

contract ERC20 is IERC20 {
    uint totalTokens;
    address owner;
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowances;
    string _name;
    string _symbol;

    constructor(
        string memory name_,
        string memory symbol_,
        uint initialSupply,
        address shop
    ) {
        _name = name_;
        _symbol = symbol_;
        owner = msg.sender;
        // начисление токенов в магазин
        mint(initialSupply, shop);
    }

    function mint(uint amount, address shop) public onlyOwner {
        _beforTokenTransfer(address(0), shop, amount);
        balances[shop] += amount;
        totalTokens += amount;

        emit Transfer(address(0), shop, amount);
    }

    function name() external view returns (string memory) {
        return _name;
    }

    function symbol() external view returns (string memory) {
        return _symbol;
    }

    function decimals() external pure returns (uint) {
        return 18; // 1 token = 1 wei
    }

    function totalSupply() external view returns (uint) {
        return totalTokens;
    }

    function balanceOf(address account) public view returns (uint) {
        return balances[account];
    }

    function transfer(
        address to,
        uint amount
    ) external enoughtTokens(msg.sender, amount) {
        _beforTokenTransfer(msg.sender, to, amount);

        balances[msg.sender] -= amount;
        balances[to] += amount;

        emit Transfer(msg.sender, to, amount);
    }

    function allowance(
        address _owner,
        address spender
    ) public view returns (uint) {
        return allowances[_owner][spender];
    }

    function approve(address spender, uint amount) external {
        _approve(msg.sender, spender, amount);
    }

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external enoughtTokens(sender, amount) {
        _beforTokenTransfer(sender, recipient, amount);

        allowances[sender][recipient] -= amount;

        balances[sender] -= amount;
        balances[recipient] += amount;
        // emit Transfer(sender)
    }

    function _approve(
        address sender,
        address spender,
        uint amount
    ) internal virtual {
        allowances[sender][spender] = amount;

        emit Approve(sender, spender, amount);
    }

    function _beforTokenTransfer(
        address from,
        address to,
        uint amount
    ) internal virtual {}

    modifier enoughtTokens(address _from, uint _amount) {
        require(balanceOf(_from) >= _amount, "not enough tokens!");
        _;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "not an owner");
        _;
    }
}
