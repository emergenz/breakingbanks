//SPDX-License-Identifier: Unlicense
pragma solidity 0.7.0;

import "./interfaces/IBank.sol";
import "./interfaces/IPriceOracle.sol";

contract Bank is IBank {

    // The keyword "public" makes variables
    // accessible from other contracts
    mapping (address => Account[2]) public balances;


    constructor(address _priceOracle, address _hakToken) {
    }
    function deposit(address token, uint256 amount)
        payable
        external
        override
        returns (bool) {
        initAccount();
    }

    function withdraw(address token, uint256 amount)
        external
        override
        returns (uint256) {
    }

    function borrow(address token, uint256 amount)
        external
        override
        returns (uint256) {
        initAccount();
        if(token != 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE){
            revert("token not supported");
        }

    }

    function repay(address token, uint256 amount)
        payable
        external
        override
        returns (uint256) {
        initAccount();
    }

    function liquidate(address token, address account)
        payable
        external
        override
        returns (bool) {
        initAccount();
    }

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
        if(token == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE){
            return balances[msg.sender][0].deposit;
        } else if (token == 0xBefeeD4CB8c6DD190793b1c97B72B60272f3EA6C){
            return balances[msg.sender][1].deposit;
        } else {
            revert("token not supported");
        }
    }

    function initAccount() private {
        // workaround: checking whether account has already been initialized.
        // this only works if we immediately compute the interest upon account
        // initialization and 'lastInterestBlock' is set to a non-zero value
        if(balances[msg.sender][0].lastInterestBlock == 0){
            balances[msg.sender][0] = Account(0, 0, 0);
            calculateDepositInterest();
        }
        if(balances[msg.sender][1].lastInterestBlock == 0){
            balances[msg.sender][1] = Account(0, 0, 0);
            calculateDepositInterest();
        }
    }

    function calculateDepositInterest() private {
        // TODO: actual calculation not implemented yet

        // set lastInterestBlock to current block
        // FIXME: is block.number right?
        //balances[msg.sender].lastInterestBlock = block.number;
    }
}
