//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

struct Transaction {
    uint balance;
    uint dailylimit;
}

contract Payment {
    string private greeting;
    address public owner; // only allow tokens from this address
    mapping(address => Transaction) transactions;

    constructor(string memory _greeting) {
        console.log("Deploying a Greeter with greeting:", _greeting);
        greeting = _greeting;
    }

    function authorize(string memory _merchantId, string memory _transactionId, uint256 amount) public view returns (string memory response) {

    }

    function capture(string memory _merchantId, string memory _transactionId, uint256 amount) public view returns (string memory response) {

    }

    function refund(string memory _merchantId, string memory _transactionId, uint256 amount) public view returns (string memory response) {

    }

    function greet() public view returns (string memory) {
        return greeting;
    }

    function setGreeting(string memory _greeting) public {
        console.log("Changing greeting from '%s' to '%s'", greeting, _greeting);
        greeting = _greeting;
    }
}
