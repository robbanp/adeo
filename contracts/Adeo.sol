//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "hardhat/console.sol";


// This is the main building block for smart contracts.
contract Token is ERC20 {
    // Some string type variables to identify the token.
    // The `public` modifier makes a variable readable from outside the contract.

    // An address type variable is used to store ethereum accounts.
    address public owner;
    mapping(address => mapping (address => uint256)) _allowances;

    /**
     * Contract initialization.
     *
     * The `constructor` is executed only once when the contract is created.
     */

     constructor() ERC20("Adeo", "ADEO") {
        _mint(msg.sender, 1000000);
        owner = msg.sender;
    }

    // sender is the contract
    function approve(address delegate, uint256 numTokens) public override returns (bool) {
        _allowances[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        console.log("Amount %s is reserved", numTokens);
        console.log("on contract ", delegate);
        console.log("for account holder ", msg.sender);
        return true;
    }

    function allowance(address _owner, address spender) public view virtual override returns (uint256) {
        console.log("Checking allowance");        
        console.log("Owner ", _owner);
        console.log("Contract ", spender);

        return _allowances[_owner][spender];
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        unchecked {
            _approve(sender, _msgSender(), currentAllowance - amount);
        }

        return true;
    }
}