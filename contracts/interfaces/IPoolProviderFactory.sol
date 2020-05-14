pragma solidity >=0.4.21 <0.7.0;

interface IPoolProviderFactory {
    function createPool(address _underlyingAcceptedCurrency) external returns (address newPoolAddress);
}