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
  function balanceOf(address owner) external view returns (uint256);
//  function allowance(address owner, address spender) external view returns (unit);
  function approve(address spender, uint value) external returns (bool);
  function transfer(address to, uint value) external returns (bool);
  function transferFrom(address from, address to, uint value) external returns (bool); 
  function increaseAllowance(address spender, uint256 addedValue) external returns (bool);
  function allowance(address owner, address spender) external view returns (uint256);
}

contract Payment {
    string private greeting;
    IERC20 public token;
    address public tokenContractAddress; // only allow tokens from this address
    address public admin; // only allow modifications from this address
    address payable public owner;
    uint256 public totalAuthBalance;
    uint256 public totalCaptureBalance;
    
    mapping(string => Transaction) auths;
    mapping(address => Transaction) captures;
    mapping(address => Transaction) refunds;

    mapping(address => mapping(address => Transaction)) public balances;

    constructor(address _address, address payable _owner) {
        console.log("Deploying a Payment contract with token address:", _address);
        console.log("Owner address:", _owner);
        tokenContractAddress = _address;
        owner = _owner;
        token = IERC20(tokenContractAddress);
        admin = msg.sender;
        totalAuthBalance = 0;
//        greeting = _greeting;
    }

    function time() internal view returns (uint256){
        return block.timestamp;
    }
    
    function authorize(string memory _merchantId, string memory _transactionId, uint _amount, address payable _receiver) public payable returns (string memory) {
        // check that sender is of correct token type
        string memory id = newId(_transactionId);        
        Transaction memory trx = Transaction(_amount, id, _merchantId, msg.sender, _receiver, time(), 0, "authorized");
        auths[id] = trx;
        // transfer amount from sender to this escrow auth account
//        console.log("transfer from: %s to %s amount %s", msg.sender, _receiver, _amount);
        console.log("via contract: ", address(this));

        //sender need to previously approve allowance to this contract
        console.log("Sender is: ", msg.sender);

        uint avail = token.balanceOf(msg.sender);
        console.log("available amount for sender %s", avail);
        uint allow = token.allowance(msg.sender, address(this));
        console.log("available amount in allowance for contract %s", allow);
        token.transferFrom(msg.sender, address(this), _amount);
        totalAuthBalance += _amount;
        return trx.id;
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
