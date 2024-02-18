// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Payments {
    struct Payment {
        uint amount;
        uint timestamp;
        address from;
        string message;
    }

    struct Balance {
        uint totalPayments;
        mapping(uint => Payment) payments;
    }

    mapping(address => Balance) public balances;

    function pay(string memory message) public payable {
        uint paymentNum = balances[msg.sender].totalPayments;
        balances[msg.sender].totalPayments++;

        Payment memory newPayment = Payment(
            msg.value,
            block.timestamp,
            msg.sender,
            message
        );
        balances[msg.sender].payments[paymentNum] = newPayment;
    }

    function getPayment(
        address _addr,
        uint _index
    ) public view returns (Payment memory) {
        return balances[_addr].payments[_index];
    }

    function currentBalance() public view returns (uint) {
        return address(this).balance;
    }
}
