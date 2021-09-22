//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

struct Transaction {
    uint256 amount;
    string id;
    string merchantId;
    address from;
    address to;
    uint256 authDate;
    uint256 captureDate;
    string status;
}

interface IERC20 {
  function balanceOf(address owner) external view returns (unit);
  function allowance(address owner, address spender) external view returns (unit);
  function approve(address spender, uint value) external returns (bool);
  function transfer(address to, uint value) external returns (bool);
  function transferFrom(address from, address to, uint value) external returns (bool); 
}

contract Payment {
    string private greeting;
    IERC20 public token;
    address public tokenContractAddress; // only allow tokens from this address
    address public admin; // only allow modifications from this address
    uint256 public totalAuthBalance;
    uint256 public totalCaptureBalance;
    
    mapping(string => Transaction) auths;
    mapping(address => Transaction) captures;
    mapping(address => Transaction) refunds;

    mapping(address => mapping(address => Transaction)) public balances;

    constructor(string memory _greeting) {
        token = IERC20(tokenContractAddress);
        admin = msg.sender;
        totalAuthBalance = 0;
        console.log("Deploying a Greeter with greeting:", _greeting);
//        greeting = _greeting;
    }

    function time() internal pure returns (uint256){
        return now;
    }
    
    function authorize(string memory _merchantId, string memory _transactionId, uint256 _amount, address _receiver) public returns (Transaction memory response) {
        // check that sender is of correct token type
        
        string memory id = newId(_transactionId);        
        Transaction memory trx = Transaction(_amount, id, _merchantId, msg.sender, _receiver, time(), 0, "authorized");
        auths[id] = trx;
        // transfer amount from sender to auth escrow account
        token.transferFrom(msg.sender, address(this), _amount);
        totalAuthBalance += _amount;
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
