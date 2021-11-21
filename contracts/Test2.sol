/**
 *Submitted for verification at Etherscan.io on 2021-11-20
*/

//SPDX-License-Identifier: Unlicense
pragma solidity 0.7.0;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryDiv}.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
}


/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of ERC20 applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /**
     * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
     * a default value of 18.
     *
     * To select a different value for {decimals}, use {_setupDecimals}.
     *
     * All three of these values are immutable: they can only be set once during
     * construction.
     */
    constructor (string memory name_, string memory symbol_) public {
        _name = name_;
        _symbol = symbol_;
        _decimals = 18;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
     * called.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual returns (uint8) {
        return _decimals;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Sets {decimals} to a value other than the default one of 18.
     *
     * WARNING: This function should only be called from the constructor. Most
     * applications that interact with token contracts will not expect
     * {decimals} to ever change, and may work incorrectly if it does.
     */
    function _setupDecimals(uint8 decimals_) internal virtual {
        _decimals = decimals_;
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be to transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}


interface IBank {
    struct Account {
        // Note that token values have an 18 decimal precision
        uint256 deposit; // accumulated deposits made into the account
        uint256 interest; // accumulated interest
        uint256 lastInterestBlock; // block at which interest was last computed
    }
    // Event emitted when a user makes a deposit
    event Deposit(
        address indexed _from, // account of user who deposited
        address indexed token, // token that was deposited
        uint256 amount // amount of token that was deposited
    );
    // Event emitted when a user makes a withdrawal
    event Withdraw(
        address indexed _from, // account of user who withdrew funds
        address indexed token, // token that was withdrawn
        uint256 amount // amount of token that was withdrawn
    );
    // Event emitted when a user borrows funds
    event Borrow(
        address indexed _from, // account who borrowed the funds
        address indexed token, // token that was borrowed
        uint256 amount, // amount of token that was borrowed
        uint256 newCollateralRatio // collateral ratio for the account, after the borrow
    );
    // Event emitted when a user (partially) repays a loan
    event Repay(
        address indexed _from, // accout which repaid the loan
        address indexed token, // token that was borrowed and repaid
        uint256 remainingDebt // amount that still remains to be paid (including interest)
    );
    // Event emitted when a loan is liquidated
    event Liquidate(
        address indexed liquidator, // account which performs the liquidation
        address indexed accountLiquidated, // account which is liquidated
        address indexed collateralToken, // token which was used as collateral
        // for the loan (not the token borrowed)
        uint256 amountOfCollateral, // amount of collateral token which is sent to the liquidator
        uint256 amountSentBack // amount of borrowed token that is sent back to the
        // liquidator in case the amount that the liquidator
        // sent for liquidation was higher than the debt of the liquidated account
    );

    /**
     * The purpose of this function is to allow end-users to deposit a given
     * token amount into their bank account.
     * @param token - the address of the token to deposit. If this address is
     *                set to 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE then
     *                the token to deposit is ETH.
     * @param amount - the amount of the given token to deposit.
     * @return - true if the deposit was successful, otherwise revert.
     */
    function deposit(address token, uint256 amount)
        external
        payable
        returns (bool);

    /**
     * The purpose of this function is to allow end-users to withdraw a given
     * token amount from their bank account. Upon withdrawal, the user must
     * automatically receive a 3% interest rate per 100 blocks on their deposit.
     * @param token - the address of the token to withdraw. If this address is
     *                set to 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE then
     *                the token to withdraw is ETH.
     * @param amount - the amount of the given token to withdraw. If this param
     *                 is set to 0, then the maximum amount available in the
     *                 caller's account should be withdrawn.
     * @return - the amount that was withdrawn plus interest upon success,
     *           otherwise revert.
     */
    function withdraw(address token, uint256 amount) external returns (uint256);

    /**
     * The purpose of this function is to allow users to borrow funds by using their
     * deposited funds as collateral. The minimum ratio of deposited funds over
     * borrowed funds must not be less than 150%.
     * @param token - the address of the token to borrow. This address must be
     *                set to 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE, otherwise
     *                the transaction must revert.
     * @param amount - the amount to borrow. If this amount is set to zero (0),
     *                 then the amount borrowed should be the maximum allowed,
     *                 while respecting the collateral ratio of 150%.
     * @return - the current collateral ratio.
     */
    function borrow(address token, uint256 amount) external returns (uint256);

    /**
     * The purpose of this function is to allow users to repay their loans.
     * Loans can be repaid partially or entirely. When replaying a loan, an
     * interest payment is also required. The interest on a loan is equal to
     * 5% of the amount lent per 100 blocks. If the loan is repaid earlier,
     * or later then the interest should be proportional to the number of
     * blocks that the amount was borrowed for.
     * @param token - the address of the token to repay. If this address is
     *                set to 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE then
     *                the token is ETH.
     * @param amount - the amount to repay including the interest.
     * @return - the amount still left to pay for this loan, excluding interest.
     */
    function repay(address token, uint256 amount)
        external
        payable
        returns (uint256);

    /**
     * The purpose of this function is to allow so called keepers to collect bad
     * debt, that is in case the collateral ratio goes below 150% for any loan.
     * @param token - the address of the token used as collateral for the loan.
     * @param account - the account that took out the loan that is now undercollateralized.
     * @return - true if the liquidation was successful, otherwise revert.
     */
    function liquidate(address token, address account)
        external
        payable
        returns (bool);

    /**
     * The purpose of this function is to return the collateral ratio for any account.
     * The collateral ratio is computed as the value deposited divided by the value
     * borrowed. However, if no value is borrowed then the function should return
     * uint256 MAX_INT = type(uint256).max
     * @param token - the address of the deposited token used a collateral for the loan.
     * @param account - the account that took out the loan.
     * @return - the value of the collateral ratio with 2 percentage decimals, e.g. 1% = 100.
     *           If the account has no deposits for the given token then return zero (0).
     *           If the account has deposited token, but has not borrowed anything then
     *           return MAX_INT.
     */
    function getCollateralRatio(address token, address account)
        external
        view
        returns (uint256);

    /**
     * The purpose of this function is to return the balance that the caller
     * has in their own account for the given token (including interest).
     * @param token - the address of the token for which the balance is computed.
     * @return - the value of the caller's balance with interest, excluding debts.
     */
    function getBalance(address token) external view returns (uint256);
}


interface IPriceOracle {
    /**
     * The purpose of this function is to retrieve the price of the given token
     * in ETH. For example if the price of a HAK token is worth 0.5 ETH, then
     * this function will return 500000000000000000 (5e17) because ETH has 18 
     * decimals. Note that this price is not fixed and might change at any moment,
     * according to the demand and supply on the open market.
     * @param token - the ERC20 token for which you want to get the price in ETH.
     * @return - the price in ETH of the given token at that moment in time.
     */
    function getVirtualPrice(address token) view external returns (uint256);
}


contract HAKTest is ERC20 {

   uint256 public constant STARTING_SUPPLY = 1e24;
   constructor() ERC20("HAKTest", "HAKT") {
      _mint(msg.sender, STARTING_SUPPLY);
   }
}

contract Test2 is IBank {
    mapping(address => uint256) private accountBalanceHAK;
    mapping(address => uint256) private accountBalanceETH;
    mapping(address => uint256) private accountLoanETH;

    mapping(address => uint256) private accountInterestHAK;
    mapping(address => uint256) private accountInterestETH;
    mapping(address => uint256) private accountLoanInterestETH;

    mapping(address => uint256) private accountInterestLastBlockNumberHAK;
    mapping(address => uint256) private accountInterestLastBlockNumberETH;
    mapping(address => uint256) private accountLoanInterestLastBlockNumberETH;

    address private priceOracleAddress;
    IPriceOracle private priceOracle;
    IERC20 private hakToken;
    address private hakTokenAddress;

    address private constant ETH_TOKEN =
        0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    constructor(address _priceOracle, address _hakToken) {
        priceOracleAddress = _priceOracle;
        priceOracle = IPriceOracle(_priceOracle);
        hakTokenAddress = _hakToken;
        hakToken = IERC20(_hakToken);
    }

    function getNewInterest(address accountAddress, address token)
        private
        view
        returns (uint256)
    {
        if (token == hakTokenAddress) {
            uint256 pastBlockCount = block.number -
                accountInterestLastBlockNumberHAK[accountAddress];
            uint256 interest = (accountBalanceHAK[accountAddress] *
                pastBlockCount *
                3) / 10000;
            return interest;
        } else if (token == ETH_TOKEN) {
            uint256 pastBlockCount = block.number -
                accountInterestLastBlockNumberETH[accountAddress];
            uint256 interest = (accountBalanceETH[accountAddress] *
                pastBlockCount *
                3) / 10000;
            return interest;
        } else {
            revert("token not supported");
        }
    }

    function calculateInterest(address accountAddress, address token) private {
        if (token == hakTokenAddress) {
            uint256 interest = getNewInterest(accountAddress, token);
            accountInterestHAK[accountAddress] += interest;
            accountInterestLastBlockNumberHAK[accountAddress] = block.number;
        } else if (token == ETH_TOKEN) {
            uint256 interest = getNewInterest(accountAddress, token);
            accountInterestETH[accountAddress] += interest;
            accountInterestLastBlockNumberETH[accountAddress] = block.number;
        } else {
            revert("token not supported");
        }
    }

    function deposit(address token, uint256 amount)
        external
        payable
        override
        returns (bool)
    {
        require(amount > 0);
        if (token == hakTokenAddress) {
            bool approved = hakToken.transferFrom(
                msg.sender,
                address(this),
                amount
            );
            require(approved, "check your allowance");
            calculateInterest(msg.sender, token);

            accountBalanceHAK[msg.sender] += amount;
            emit Deposit(msg.sender, token, amount);
            return true;
        } else if (token == ETH_TOKEN) {
            require(msg.value == amount);
            calculateInterest(msg.sender, token);

            accountBalanceETH[msg.sender] += amount;
            emit Deposit(msg.sender, token, amount);
            return true;
        }
        revert("token not supported");
    }

    function withdraw(address token, uint256 amount)
        external
        override
        returns (uint256)
    {
        require(amount >= 0);
        if (token == hakTokenAddress) {
            calculateInterest(msg.sender, token);
            uint256 accountTotal = accountBalanceHAK[msg.sender] +
                accountInterestHAK[msg.sender];

            require(accountTotal > 0, "no balance");
            require(accountTotal >= amount, "amount exceeds balance");
            if (amount == 0) {
                amount = accountTotal;
            }

            require(hakToken.balanceOf(address(this)) >= amount);
            bool successful = hakToken.transfer(msg.sender, amount);
            require(successful);
            if (accountInterestHAK[msg.sender] >= amount) {
                accountInterestHAK[msg.sender] -= amount;
            } else {
                accountBalanceHAK[msg.sender] -= (amount -
                    accountInterestHAK[msg.sender]);
                accountInterestHAK[msg.sender] = 0;
            }
            emit Withdraw(msg.sender, token, amount);

            return amount;
        } else if (token == ETH_TOKEN) {
            calculateInterest(msg.sender, token);
            uint256 accountTotal = accountBalanceETH[msg.sender] +
                accountInterestETH[msg.sender];

            require(accountTotal > 0, "no balance");
            require(accountTotal >= amount, "amount exceeds balance");
            if (amount == 0) {
                amount = accountTotal;
            }

            require(address(this).balance >= amount);
            msg.sender.transfer(amount);
            if (accountInterestETH[msg.sender] >= amount) {
                accountInterestETH[msg.sender] -= amount;
            } else {
                accountBalanceETH[msg.sender] -= (amount -
                    accountInterestETH[msg.sender]);
                accountInterestETH[msg.sender] = 0;
            }
            emit Withdraw(msg.sender, token, amount);

            return amount;
        }
        revert("token not supported");
    }

    function borrow(address token, uint256 amount)
        external
        override
        returns (
            uint256
        )
    {
        require(amount >= 0);
        require(token == ETH_TOKEN, "token not supported");
        require(accountBalanceHAK[msg.sender] > 0, "no collateral deposited");

        uint256 pastBlockCount = block.number -
            accountLoanInterestLastBlockNumberETH[msg.sender];
        uint256 newInterest = (accountLoanETH[msg.sender] *
            pastBlockCount *
            5) / 10000;
        accountLoanInterestETH[msg.sender] += newInterest;
        accountLoanInterestLastBlockNumberETH[msg.sender] = block.number;

        if (amount == 0) {
            calculateInterest(msg.sender, hakTokenAddress);
            amount =
                (2 *
                    (accountBalanceHAK[msg.sender] +
                        accountInterestHAK[msg.sender])) /
                3;
            amount -= (accountLoanETH[msg.sender] +
                accountLoanInterestETH[msg.sender]);
        }

        calculateInterest(msg.sender, hakTokenAddress);

        uint256 collateralRatio = ((accountBalanceHAK[msg.sender] +
            accountInterestHAK[msg.sender]) * 10000) /
            (accountLoanETH[msg.sender] +
                accountLoanInterestETH[msg.sender] +
                amount);

        require(
            collateralRatio >= 15000,
            "borrow would exceed collateral ratio"
        );

        accountLoanETH[msg.sender] += amount;
        require(address(this).balance >= amount);
        msg.sender.transfer(amount);

        uint256 newCollateralRatio = getCollateralRatio(
            hakTokenAddress,
            msg.sender
        );
        emit Borrow(msg.sender, token, amount, newCollateralRatio);

        return newCollateralRatio;
    }

    function repay(address token, uint256 amount)
        external
        payable
        override
        returns (uint256)
    {
        require(amount >= 0, "amount is < 0");
        require(token == ETH_TOKEN, "token not supported");

        uint256 pastBlockCount = block.number -
            accountLoanInterestLastBlockNumberETH[msg.sender];
        uint256 interest = (accountLoanETH[msg.sender] * pastBlockCount * 5) /
            10000;
        accountLoanInterestETH[msg.sender] += interest;
        accountLoanInterestLastBlockNumberETH[msg.sender] = block.number;

        if (amount == 0) {
            amount =
                accountLoanETH[msg.sender] +
                accountLoanInterestETH[msg.sender];
        }

        require(accountLoanInterestETH[msg.sender] > 0, "nothing to repay");
        require(msg.value >= amount, "msg.value < amount to repay");

        if (amount <= accountLoanInterestETH[msg.sender]) {
            accountLoanInterestETH[msg.sender] -= amount;
        } else {
            require(
                accountLoanETH[msg.sender] >=
                    (amount - accountLoanInterestETH[msg.sender]),
                "insufficient eth balance in account"
            );
            accountLoanETH[msg.sender] -= (amount -
                accountLoanInterestETH[msg.sender]);
            accountLoanInterestETH[msg.sender] = 0;
        }

        uint256 remainingDebt = accountLoanETH[msg.sender];
        require(
            address(this).balance >= remainingDebt,
            "insufficient eth balance in smart contract"
        );
        msg.sender.transfer(remainingDebt);

        emit Repay(msg.sender, token, remainingDebt);
        return remainingDebt;
    }

    function liquidate(address token, address account)
        external
        payable
        override
        returns (bool)
    {
        require(token == hakTokenAddress, "token not supported");
        require(account != msg.sender, "cannot liquidate own position");
        require(getCollateralRatio(token, account) < 15000, "healty position");

        uint256 pastBlockCount = block.number -
            accountLoanInterestLastBlockNumberETH[account];
        uint256 interest = (accountLoanETH[account] * pastBlockCount * 5) /
            10000;

        require(
            msg.value >= (accountLoanETH[account] + interest),
            "insufficient ETH sent by liquidator"
        );

        uint256 amountOfCollateral = accountBalanceHAK[account] +
            accountInterestHAK[account];
        accountBalanceHAK[msg.sender] += amountOfCollateral;
        accountBalanceHAK[account] = 0;

        uint256 amountSentBack = (msg.value) -
            (accountLoanETH[account] + interest);

        accountLoanETH[account] = 0;
        accountLoanInterestETH[account] = 0;

        bool success = hakToken.transfer(msg.sender, amountOfCollateral);
        require(success, "transaction failed");

        msg.sender.transfer(amountSentBack);

        emit Liquidate(
            msg.sender,
            account,
            token,
            amountOfCollateral,
            amountSentBack
        );
        return true;
    }

    function getCollateralRatio(address token, address account)
        public
        view
        override
        returns (uint256)
    {
        require(token == hakTokenAddress);

        if (accountBalanceHAK[account] == 0) {
            return 0;
        } else if (accountLoanETH[account] == 0) {
            return type(uint256).max;
        } else {
            uint256 newHAKInterest = accountInterestHAK[account] +
                getNewInterest(account, token);

            uint256 hakToEthFactor = priceOracle.getVirtualPrice(
                hakTokenAddress
            ) / 1000000000000000000;

            uint256 collateralRatio = ((accountBalanceHAK[account] +
                newHAKInterest) *
                hakToEthFactor *
                10000) /
                (accountLoanETH[account] + getTotalLoanInterest(account));
            return collateralRatio;
        }
    }

    function getTotalLoanInterest(address account)
        private
        view
        returns (uint256)
    {
        uint256 pastBlockCount = block.number -
            accountLoanInterestLastBlockNumberETH[account];
        uint256 newInterest = (accountLoanETH[account] * pastBlockCount * 5) /
            10000;
        uint256 totalLoanInterest = accountLoanInterestETH[account] +
            newInterest;
        return totalLoanInterest;
    }

    function getBalance(address token) public view override returns (uint256) {
        if (token == hakTokenAddress) {
            return
                accountBalanceHAK[msg.sender] +
                getNewInterest(msg.sender, token);
        } else if (token == ETH_TOKEN) {
            return
                accountBalanceETH[msg.sender] +
                getNewInterest(msg.sender, token);
        } else {
            revert("unsupported token");
        }
    }
}