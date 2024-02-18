// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract Tree {
    // H1  H2  H3  H4
    // TX1 TX2 TX3 TX4

    bytes32[] public hashes;
    string[4] transactions = [
        "TX1: Sherlock -> John",
        "TX2: John -> Sherlock",
        "TX3: John -> Mary",
        "TX4: Mary -> Sherlock"
    ];

    constructor() {
        for (uint256 i = 0; i < transactions.length; i++) {
            bytes32 _hash = makeHash(transactions[i]);
            hashes.push(_hash);
        }

        uint256 count = transactions.length;
        uint256 offset = 0;

        while (count > 0) {
            for (uint256 i = 0; i < count - 1; i += 2) {
                bytes32 _hash = keccak256(
                    abi.encodePacked(hashes[offset + i], hashes[offset + i + 1])
                );
                hashes.push(_hash);
            }
            offset += count;
            count = count / 2;
        }
    }

    function encode(string memory input) public pure returns (bytes memory) {
        return abi.encodePacked(input);
    }

    function makeHash(string memory input) public pure returns (bytes32) {
        return keccak256(encode(input));
    }

    function verify(
        string memory transaction,
        uint256 index,
        bytes32 root,
        bytes32[] memory proof
    ) public pure returns (bool) {
        bytes32 hash = makeHash(transaction);
        for (uint256 i = 0; i < proof.length; i++) {
            bytes32 element = proof[i];
            if (index % 2 == 0) {
                hash = keccak256(abi.encodePacked(hash, element));
            } else {
                hash = keccak256(abi.encodePacked(element, hash));
            }

            index = index / 2;
        }

        return hash == root;
    }
}
