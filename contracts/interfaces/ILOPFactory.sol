pragma solidity >=0.4.21 < 0.7.0;

interface IUniswapV2Factory {
    event PoolCreated(address indexed underlyingAddress, address Pool, uint allPools);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPool(address _underlyingAddress) external view returns (address Pool);
    function allPools(uint) external view returns (address Pool);
    function allPoolsLength() external view returns (uint);

    function createPool(address _underlyingAddress, address _underlyingAcceptedCurrency) external returns (address Pool);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}