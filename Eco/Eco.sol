// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.11;

import "./TRC20.sol";
import "./TRC20Detailed.sol";

/**
 * @title Eco
 * @dev Very simple TRC20 Token example, where all tokens are pre-assigned to the creator.
 * Note they can later distribute these tokens as they wish using `transfer` and other
 * `TRC20` functions.
 */
contract Eco is TRC20, TRC20Detailed {
    
    address private owner;

    event Reward(address recipient, uint256 amount);
    event Burn(address burner, uint256 amount);

    /**
     * @dev Constructor, initial supply is 0
     */
    constructor () TRC20Detailed("Eco", "ECO", 18) {
        owner = msg.sender;
    }
    
    /**
     * Mint ECO to reward a user with. Emits a Reward event for any listeners.
     * Only the owner can reward users :)
     */
    function reward(address _to, uint256 _value) public returns (bool success) {
        require (msg.sender == owner, "Only owner can mint");
        require(_to != address(0), "TRC20: mint to zero address");
        
        _mint(_to, _value);
        
        emit Reward(_to, _value);
        // emit Transfer(address(0), _to, _value);
        
        return true;
    }
    
    /**
     * Burn ECO to redeem a reward. Emits a Burn event.
     */
    function spend(address _spender, uint256 _value) public returns (bool success) {
        require(_spender != address(0), "TRC20: burn from the zero address");
        require(balanceOf(_spender) >= _value, "TRC20: not enough ECO");
        require(_totalSupply >= _value, "TRC20: supply too small");


        _balances[_spender] -= _value;
        _totalSupply -= _value;

        emit Burn(_spender, _value);
        // emit Transfer(msg.sender, address(0), _value);
        
        return true;
    }
}