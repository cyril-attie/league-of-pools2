pragma solidity ^0.6.7;

import "contracts/interfaces/IPoolProviderFactory.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LOPPoolFactory is Ownable {
    address[] public allPools;
    mapping (address => bytes32) public poolProviderOf;
    bytes32[] public poolProviders;
    mapping(bytes32 => bool) public poolProviderIsActive; //pool providers like aave, compound... uniswap, balancer
    mapping(bytes32 => address) public templateAddressFor;
    mapping(bytes32 => mapping(address => address)) public getPool; //provider.underlyingAddress

    event PoolCreated(
        address indexed underlyingAddress,
        address Pool,
        uint256 allPools
    );

    event ProviderCreated(
        bytes32 providerName,
        address providerTemplateAddress
    );

    //@dev should this function should only be called from the governance cause we cannot
    function createPoolProviderTemplate(
        bytes32 _poolProvider,
        address _poolTemplate
    ) external onlyOwner {
        require(_poolTemplate != address(0), "League Of Pools: ZERO_ADDRESS");
        require(
            templateAddressFor[_poolProvider] == address(0),
            "League Of Pools: TEMPLATE_EXISTS"
        );
        templateAddressFor[_poolProvider] = _poolTemplate;
    }

    function createPool(
        bytes32 _poolProvider,
        address _underlyingAddress,
        address _underlyingAcceptedCurrency 
    ) external onlyOwner returns (address pool) {
        require(
            _underlyingAddress != address(0),
            "League Of Pools: ZERO_ADDRESS"
        );
        require(
            getPool[_poolProvider][_underlyingAcceptedCurrency] == address(0),
            "League Of Pools: POOL_EXISTS");
        // bytes memory bytecode = type(LOPPool).creationCode;
        // bytes32 salt = keccak256(abi.encodePacked(poolProvider,underlyingAddress));
        // assembly {
        //     pool := create2(0, add(bytecode, 32), mload(bytecode), salt)
        // }
        pool = IPoolProviderFactory(templateAddressFor[_poolProvider]).createPool(
            _underlyingAcceptedCurrency
        );
        getPool[_poolProvider][_underlyingAcceptedCurrency] = pool;
        allPools.push(pool);
        emit PoolCreated(_underlyingAddress, pool, allPools.length);
    }
}
