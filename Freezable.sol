pragma solidity ^0.8.13;
// SPDX-License-Identifier: MIT

import "./SuperAccountRole.sol";

/**
 * @title Freezable
 * @dev The Freezable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */

contract Freezable is SuperAccountRole {

    event Freezed();
    event Unfreezed();
    uint public freezingTime = 0;

    /**
    * @dev called by the owner to freeze, triggers stopped state
    */
    function freeze(uint _freezingTime) public onlySuperAccount {
        freezingTime = block.timestamp + (_freezingTime * 1 minutes);
        emit Freezed();
    }

    /**
    * @dev Modifier to make a function callable only when the contract is not freezed.
    */
    modifier whenNotFreezed() {
        require(freezingTime <= block.timestamp || isSuperAccount(msg.sender));
        _;
    }

    /**
    * @dev Modifier to make a function callable only when the contract is freezed.
    */
    modifier whenFreezed() {
        require(freezingTime > block.timestamp);
        _;
    }

    /**
    * @dev called by the owner to unfreeze, returns to normal state
    */
    function unfreeze() public onlySuperAccount whenFreezed {
        freezingTime = 0;
        emit Unfreezed();
    }

    /**
    * @dev return current block timestamp
    */
    function blocktimestamp() public view virtual returns (uint) {
        return block.timestamp;
    }

    /**
     * @dev Returns true if the contract is freezed 
     * freezed time is over or sender is super account, and false otherwise.
     */
    function isNotFreezed() public view virtual returns (bool) {
        return (freezingTime <= block.timestamp || isSuperAccount(msg.sender));
    }
}
