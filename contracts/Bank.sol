//SPDX-License-Identifier: Unlicense
pragma solidity 0.7.0;

import "./interfaces/IBank.sol";
import "./interfaces/IPriceOracle.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Bank is IBank {

    // The keyword "public" makes variables
    // accessible from other contracts

    // Account[0] is ETH-Account
    // Account[1] is HAK-Account
    mapping (address => Account[2]) public balances;
    address hakToken;
    bool isLocked = false;

    constructor(address _priceOracle, address _hakToken) {
        hakToken = _hakToken;
    }
    function deposit(address token, uint256 amount)
        payable
        external
        override
        returns (bool) {
        isLocked = true;
        initAccount();
        require(token == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE || hakToken == token,  "token not supported");
        require(amount > 0, "Amount to deposit should be greater than 0");
        if (token == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE ){
            require(msg.value == amount, "given amount and transferred money didnt match");
            balances[msg.sender][0].deposit = balances[msg.sender][0].deposit + amount;
            emit Deposit(msg.sender, token, amount);
        } else if (token == hakToken){
            ERC20 t = ERC20(token);
            if(t.transferFrom(msg.sender, address(this), amount)){
                balances[msg.sender][1].deposit = balances[msg.sender][1].deposit + amount;
                emit Deposit(msg.sender, token, amount);
            }
        }
        isLocked = false;
        return true;
   }

    function withdraw(address token, uint256 amount)
        external
        override
        returns (uint256) {
        // x = Account-Index (0 for ETH, 1 for HAK)
        uint x;
        token == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE ? x = 0 : x = 1;
        require (token == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE || token == hakToken, "token not supported");
        require (balances[msg.sender][x].deposit > 0, "no balance");
        if (amount == 0){
            uint256 withdrawal = balances[msg.sender][x].deposit;
            msg.sender.transfer(withdrawal);
            balances[msg.sender][x].deposit = 0;
            if (token == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE) {
                balances[msg.sender][x].interest += calculateInterest(token);
            } else if (token == hakToken) {
                ERC20 t = ERC20(token);
                if(t.transfer(msg.sender, amount)){
                    balances[msg.sender][x].interest += calculateInterest(token);
                } else {
                    revert("transferFrom failed");
                }
            }
            emit Withdraw(msg.sender, token, withdrawal + balances[msg.sender][x].interest);
            return withdrawal + balances[msg.sender][x].interest;
        }
        else if (balances[msg.sender][x].deposit >= amount){
            msg.sender.transfer(amount);
            balances[msg.sender][x].deposit -=amount;
            // TODO: interest
            balances[msg.sender][x].interest += calculateInterest(token);
            emit Withdraw(msg.sender, token, amount + balances[msg.sender][x].interest);
            return amount + balances[msg.sender][x].interest;
        } else {
            revert("amount exceeds balance");
        }
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
        } else if (token == hakToken){
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
            calculateInterest(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
        }

        if(balances[msg.sender][1].lastInterestBlock == 0){
            balances[msg.sender][1] = Account(0, 0, 0);
            calculateInterest(0xBefeeD4CB8c6DD190793b1c97B72B60272f3EA6C);
        }
    }

    function calculateInterest(address token) private returns (uint256){
        // TODO: actual calculation not implemented yet
        uint x;
        token == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE ? x = 0 : x = 1;

        uint256 interest = ((block.number - balances[msg.sender][x].lastInterestBlock) * 3);

        // set lastInterestBlock to current block

        // FIXME: is block.number right?
        balances[msg.sender][x].lastInterestBlock = block.number;

        return interest;

    }
}
