//SPDX-License-Identifier: Unlicense
pragma solidity 0.7.0;

import "./interfaces/IBank.sol";
import "./interfaces/IPriceOracle.sol";

contract Bank is IBank {

    // The keyword "public" makes variables
    // accessible from other contracts
    address public minter;
    mapping (address => Account) public balances;


    constructor(address _priceOracle, address _hakToken) {
        minter = msg.sender;
    }
    function deposit(address token, uint256 amount)
        payable
        external
        override
        returns (bool) {}

    function withdraw(address token, uint256 amount)
        external
        override
        returns (uint256) {}

    function borrow(address token, uint256 amount)
        external
        override
        returns (uint256) {}

    function repay(address token, uint256 amount)
        payable
        external
        override
        returns (uint256) {}

    function liquidate(address token, address account)
        payable
        external
        override
        returns (bool) {}

    function getCollateralRatio(address token, address account)
        view
        public
        override
        returns (uint256) {}

    function getBalance(address token)
        view
        public
        override
        returns (uint256) {
        initAccount();
        return balances[msg.sender].deposit;
    }
    /*
    function initAccount() private {
        if(bytes(balances[msg.sender]).length == 0){
            balances[msg.sender] = Account(0, 0, 0);
        }
    }
    */
}
