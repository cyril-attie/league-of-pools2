pragma solidity >=0.4.21 <0.7.0;

import "contracts/LOPPoolTemplates/aave/AavePool.sol";
import "contracts/interfaces/IPoolProviderFactory.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AaveFactory is IPoolProviderFactory, Ownable {
    //@dev IPoolProviderFactory implementation
    //@notice to add more pools from Aave
    address configAddress ;
    
    constructor (address _configAddress) public {
        configAddress= _configAddress;
    }
    
    function createPool(address _underlyingAcceptedCurrency) override external returns (address newPoolAddress) {
        ERC20 underlying = ERC20(_underlyingAcceptedCurrency);
        string memory name = string(abi.encodePacked("LOP_",underlying.name(),"_AAVE"));
        string memory symbol = string(abi.encodePacked("LOP_",underlying.symbol(),"_AAVE"));
        AavePool newPool = new AavePool( configAddress, _underlyingAcceptedCurrency, name, symbol );
        newPoolAddress = address(newPool);
    }
}
