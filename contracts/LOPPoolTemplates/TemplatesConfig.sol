pragma solidity >=0.4.21 < 0.7.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract TemplatesConfig is Ownable {
    //@dev to be looked up from aave pool contract
//TODO a public mapping (provider=> mapping(key=>value))
    uint16 public aaveReferralCode;
    uint256 public MINIMUM_DEPOSIT = 5000000000;
    address public aaveAddressProvider;

    function setAaveReferralCode(uint16 _ref) public onlyOwner {
        aaveReferralCode = _ref;
    }
    function setAaveAddressProvider(address _addr) public onlyOwner {
        aaveAddressProvider = _addr;
    }
    function setMinimumDeposit(uint256 _amount) public onlyOwner {
        MINIMUM_DEPOSIT = _amount;
    }
}