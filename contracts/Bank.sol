//SPDX-License-Identifier: Unlicense
pragma solidity 0.7.0;

import "./interfaces/IBank.sol";
import "./interfaces/IPriceOracle.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "hardhat/console.sol";

contract Bank is IBank {
    using SafeMath for uint256;

    // The keyword "public" makes variables
    // accessible from other contracts

    // Account[0] is ETH-Account
    // Account[1] is HAK-Account
    mapping (address => Account[2]) private balances;
    mapping (address => uint256) private borrowed;
    address hakToken;
    IPriceOracle oracle;
    bool isLocked = false;

    constructor(address _priceOracle, address _hakToken) {
        hakToken = _hakToken;
        oracle = IPriceOracle(_priceOracle);
    }
    function deposit(address token, uint256 amount)
        payable
        external
        override
        returns (bool) {
            require(!isLocked);
            isLocked = true;

            initAccount();

            require(token == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE || hakToken == token,  "token not supported");
            require(amount > 0, "Amount to deposit should be greater than 0");

            uint x = token == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE ? 0 : 1;

            balances[msg.sender][x].interest = balances[msg.sender][x].interest.add(balances[msg.sender][x].deposit.div(10000).mul(block.number.sub(balances[msg.sender][x].lastInterestBlock)).mul(3));
            balances[msg.sender][x].lastInterestBlock = block.number;

            if (token == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE) {
                require(msg.value == amount, "given amount and transferred money didnt match");

                balances[msg.sender][0].deposit = balances[msg.sender][0].deposit.add(amount);
                emit Deposit(msg.sender, token, amount.add(balances[msg.sender][0].interest));
            } else if (token == hakToken) {
                ERC20 t = ERC20(token);
                require(t.transferFrom(msg.sender, address(this), amount));

                balances[msg.sender][1].deposit = balances[msg.sender][1].deposit.add(amount);
                emit Deposit(msg.sender, token, amount.add(balances[msg.sender][1].interest));
            }

            isLocked = false;
            return true;
        }

    function withdraw(address token, uint256 amount)
        external
        override
        returns (uint256) {
        require(token == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE || hakToken == token,  "token not supported");
            require(!isLocked);
            isLocked = true;

            // x = Account-Index (0 for ETH, 1 for HAK)
            uint x = token == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE ? 0 : 1;

            balances[msg.sender][x].interest = balances[msg.sender][x].interest.add(balances[msg.sender][x].deposit.div(10000).mul(block.number.sub(balances[msg.sender][x].lastInterestBlock)).mul(3));
            balances[msg.sender][x].lastInterestBlock = block.number;

            require (token == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE || token == hakToken, "token not supported");
            require (balances[msg.sender][x].deposit > 0, "no balance");
            if (amount == 0){
                uint256 withdrawal = balances[msg.sender][x].deposit;
                msg.sender.transfer(withdrawal);
                balances[msg.sender][x].deposit = 0;
                if (token == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE) {
                } else if (token == hakToken) {
                    ERC20 t = ERC20(token);
                    if(t.transfer(msg.sender, amount)){
                    } else {
                        revert("transferFrom failed");
                    }
                }
                emit Withdraw(msg.sender, token, withdrawal.add(balances[msg.sender][x].interest));
                isLocked = false;
                return withdrawal.add(balances[msg.sender][x].interest);
            }
            else if (balances[msg.sender][x].deposit >= amount){
                msg.sender.transfer(amount);
                balances[msg.sender][x].deposit = balances[msg.sender][x].deposit.sub(amount);
                // TODO: interest
                emit Withdraw(msg.sender, token, amount.add(balances[msg.sender][x].interest));
                isLocked = false;
                return amount.add(balances[msg.sender][x].interest);
            } else {
                revert("amount exceeds balance");
            }
}
    function borrow(address token, uint256 amount)
        external
        override
        returns (uint256) {
            require(!isLocked);
            isLocked = true;

            initAccount();

            require(token == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE, "token not supported");

            balances[msg.sender][1].interest = balances[msg.sender][1].interest.add(balances[msg.sender][1].deposit.div(10000).mul((block.number.sub(balances[msg.sender][1].lastInterestBlock)).mul(3)));
            balances[msg.sender][1].lastInterestBlock = block.number;

            borrowed[msg.sender] = borrowed[msg.sender].add(amount);
            uint256 _collateral_ratio = getCollateralRatio(hakToken, msg.sender);

            require(_collateral_ratio != 0, "no collateral deposited");
            require(_collateral_ratio >= 15000, "borrow would exceed collateral ratio");

            if (amount == 0) {
                // deposit : collateral_ratio = x : 15000
                uint256 _max = balances[msg.sender][1].deposit.mul(15000).div(_collateral_ratio);
                borrowed[msg.sender] = borrowed[msg.sender].add(convertHAKToETH(_max));
            }

            emit Borrow(msg.sender, token, amount, _collateral_ratio);

            isLocked = false;
        }

    function repay(address token, uint256 amount)
        payable
        external
        override
        returns (uint256) {
            require(!isLocked);
            isLocked = true;

            initAccount();

            require(token == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE, "token not supported");

            uint x = token == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE ? 0 : 1;

            balances[msg.sender][x].interest = balances[msg.sender][x].interest.add(balances[msg.sender][x].deposit.div(10000).mul(block.number.sub(balances[msg.sender][x].lastInterestBlock)).mul(3));
            balances[msg.sender][x].lastInterestBlock = block.number;


            borrowed[msg.sender] = borrowed[msg.sender].add(amount);
            uint256 _collateral_ratio = getCollateralRatio(hakToken, msg.sender);

            require(_collateral_ratio != 0, "nothing to repay");
            require(_collateral_ratio >= 15000, "borrow would exceed collateral ratio");

            require(msg.value >= amount, "msg.value < amount to repay");
           if (amount == 0) {
                // deposit : collateral_ratio = x : 15000
                uint256 _max = balances[msg.sender][1].deposit.mul(15000).div(_collateral_ratio);
                borrowed[msg.sender] = borrowed[msg.sender].add(-convertHAKToETH(_max));
            }

            emit Repay(msg.sender, token, amount);

            isLocked = false;
        }

    function liquidate(address token, address account)
        payable
        external
        override
        returns (bool) {
            require(!isLocked);
            isLocked = true;

            initAccount();
            require(token == hakToken, "token not supported");
            require(account != msg.sender, "cannot liquidate own position");
            require(getCollateralRatio(token, account) < 15000, "healty position");

            isLocked = false;
        }

    function getCollateralRatio(address token, address account)
        view
        public
        override
        returns (uint256) {
            if(token != hakToken){
                revert("token not supported");
            }

            uint256 _deposit = convertHAKToETH(balances[account][1].deposit);
            uint256 _interest = convertHAKToETH(balances[account][1].interest);
            uint256 _borrowed = borrowed[account];

            if (_deposit == 0) {
                return 0;
            }
            if (_borrowed == 0) {
                return type(uint256).max;
            }
            return _deposit.add(_interest).mul(10000).div(_borrowed.add(_borrowed.div(200000)));
        }

    function convertHAKToETH(uint256 amount)
        view
        private
        returns (uint256) {
            return amount * oracle.getVirtualPrice(hakToken) / 1000000000000000000;
        }

    function getBalance(address token)
        view
        public
        override
        returns (uint256) {
            if(token == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE){
                uint256 interest = ((block.number - balances[msg.sender][0].lastInterestBlock) * 3)+balances[msg.sender][0].interest;
                return balances[msg.sender][0].deposit+interest;
            } else if (token == hakToken){
                uint256 interest = ((block.number - balances[msg.sender][1].lastInterestBlock) * 3)+balances[msg.sender][1].interest;
                return balances[msg.sender][1].deposit+interest;
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
            calculateInterest(hakToken);
        }
    }

    function calculateInterest(address token) private returns (uint256){
        // TODO: actual calculation not implemented yet
        uint x = token == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE ? 0 : 1;
        uint256 interest = (block.number.sub(balances[msg.sender][x].lastInterestBlock)).mul(3);

        // set lastInterestBlock to current block

        // FIXME: is block.number right?
        balances[msg.sender][x].lastInterestBlock = block.number;

        return interest;
    }
}
