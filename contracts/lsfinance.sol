// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20FlashMintUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

/// @custom:security-contact rooney.c.rep@gmail.com
contract LsToken is
    Initializable,
    ERC20Upgradeable,
    ERC20BurnableUpgradeable,
    AccessControlUpgradeable,
    ERC20FlashMintUpgradeable
{
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    address private default_currency;
    address public current_currency;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
        current_currency = default_currency;
    }

    function initialize() public initializer {
        __ERC20_init("LsToken", "MTK");
        __ERC20Burnable_init();
        __AccessControl_init();
        __ERC20FlashMint_init();

        _mint(msg.sender, 100 * 10**decimals());
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }

    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }

    // Add and Remove Mintes
    // Minters can not add or revoke other Minters

    function giveMinterRole(address _target)
        public
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        _grantRole(MINTER_ROLE, _target);
    }

    function removeMinterRole(address _target)
        public
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        _revokeRole(MINTER_ROLE, _target);
    }

    // Simple Bank and Loan Feature

    function updateCurrency(address _currency)
        public
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        require(current_currency != _currency, " ");
        current_currency = _currency;
    }
}
