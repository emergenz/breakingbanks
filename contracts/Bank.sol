//SPDX-License-Identifier: Unlicense
pragma solidity 0.7.0;

import "./interfaces/IBank.sol";
import "./interfaces/IPriceOracle.sol";

contract Bank is IBank {

    // The keyword "public" makes variables
    // accessible from other contracts
    mapping (address => Account) public balances;


    constructor(address _priceOracle, address _hakToken) {
    }
    function deposit(address token, uint256 amount)
        payable
        external
        override
        returns (bool) {}

    function withdraw(address token, uint256 amount)
        external
        override
        returns (uint256) {
        if(token != 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE || token != 0xBefeeD4CB8c6DD190793b1c97B72B60272f3EA6C){
            revert("token not supported");
        }

        if(amount == 0){
            uint256 withdrawal = balances[msg.sender].deposit;
            balances[msg.sender].deposit = 0;
            emit Withdraw(msg.sender, token, withdrawal);
            return withdrawal;
        }
        if(balances[msg.sender].deposit >= amount){
             balances[msg.sender].deposit -=amount;
             emit Withdraw(msg.sender, token, amount);
             return amount;
        }else {
             revert("amount exceeds balance");
        }
        revert("Something went wrong");
    }

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
        //initAccount();
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
