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
        isLocked = true;
        initAccount();
        require(token == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE || hakToken == token,  "token not supported");
        require(amount > 0, "Amount to deposit should be greater than 0");
        if (token == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE ){
            balances[msg.sender][0].deposit = balances[msg.sender][0].deposit + amount;
        } else if (token == hakToken){
            ERC20 t = ERC20(token);
            if(t.transferFrom(msg.sender, address(this), amount)){
                balances[msg.sender][1].deposit = balances[msg.sender][1].deposit + amount;
            }
        }
        emit Deposit(msg.sender, token, amount);
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
            balances[msg.sender][x].deposit = 0;
            // TODO: interest
            balances[msg.sender][x].interest += calculateInterest(token);
            emit Withdraw(msg.sender, token, withdrawal);
            return withdrawal;
        }
        else if (balances[msg.sender][x].deposit >= amount){
            balances[msg.sender][x].deposit -=amount;
            // TODO: nterest
            balances[msg.sender][x].interest += calculateInterest(token);
            emit Withdraw(msg.sender, token, amount);
            return amount;
        } else {
            revert("amount exceeds balance");
        }
    }

    function borrow(address token, uint256 amount)
        external
        override
        returns (uint256) {
        initAccount();
        require(token == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE, "token not supported");

        borrowed[msg.sender] += amount;
        uint256 _collateral_ratio = getCollateralRatio(hakToken, msg.sender);

        require(_collateral_ratio != 0, "no collateral deposited");
        require(_collateral_ratio >= 15000, "collateral ratio too low");

        emit Borrow(msg.sender, token, amount, _collateral_ratio);
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

            return (_deposit + _interest) * 10000 / (_borrowed + (_borrowed / 20));
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

        uint256 interest = ((block.number - balances[msg.sender][x].lastInterestBlock) * 3) / 10;

        // set lastInterestBlock to current block

        // FIXME: is block.number right?
        balances[msg.sender][x].lastInterestBlock = block.number;

        return interest;

    }
}
