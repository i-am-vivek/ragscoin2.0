// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "./Roles.sol";

contract SuperAccountRole {
  using Roles for Roles.Role;

  event SuperAccountAdded(address indexed account);
  event SuperAccountRemoved(address indexed account);

  Roles.Role private superaccounts;

  address superAdmin;

  constructor() {
    superAdmin = msg.sender;
    superaccounts.add(msg.sender);
  }

  modifier onlySuperAccount() {
    require(isSuperAccount(msg.sender));
    _;
  }

  modifier onlySuperAdmin() {
    require(superAdmin == msg.sender);
    _;
  }

  function isSuperAccount(address account) public view returns (bool) {
    return superaccounts.has(account);
  }

  function addSuperAccount(address account) public onlySuperAdmin {
    superaccounts.add(account);
    emit SuperAccountAdded(account);
  }

  function renounceSuperAccount() public {
    _removeSuperAccount(msg.sender);
  }

  function removeSuperAccount(address account) public onlySuperAdmin {
    superaccounts.remove(account);
    emit SuperAccountRemoved(account);
  }

  function _removeSuperAccount(address account) internal {
    superaccounts.remove(account);
    emit SuperAccountRemoved(account);
  }
}
