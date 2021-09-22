//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

struct Transaction {
    uint256 amount;
    string id;
    string merchantId;
    address from;
    address to;
}

contract Payment {
    string private greeting;
    IERC20 public token;
    address public tokenContractAddress; // only allow tokens from this address
    address public admin; // only allow modifications from this address
    
    mapping(string => Transaction) auths;
    mapping(address => Transaction) captures;
    mapping(address => Transaction) refunds;

    constructor(string memory _greeting) {
        token = IERC20(tokenContractAddress);
        console.log("Deploying a Greeter with greeting:", _greeting);
        greeting = _greeting;
    }

    function authorize(string memory _merchantId, string memory _transactionId, uint256 _amount, address _receiver) public returns (Transaction memory response) {
        // check that sender is of correct token type
        
        string memory id = newId(_transactionId);        
        Transaction memory trx = Transaction(_amount, id, _merchantId, msg.sender, _receiver);
        auths[id] = trx;
        return trx;
        // lock tokens for xx time
    }

    function capture(string memory _merchantId, string memory _transactionId, uint256 amount) public view returns (string memory response) {

        // transfer tokens to merchant
    }

    function refund(string memory _merchantId, string memory _transactionId, uint256 amount) public view returns (string memory response) {

        // transfer tokens from merchant to consumer

    }

    function newId(string memory id) internal pure returns (string memory) {
        return id;
    }

    function greet() public view returns (string memory) {
        return greeting;
    }

    function setGreeting(string memory _greeting) public {
        console.log("Changing greeting from '%s' to '%s'", greeting, _greeting);
        greeting = _greeting;
    }
}
