pragma solidity 0.6.7;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/LOPPoolFactory.sol";
import "../contracts/LOPPoolTemplates/aave/ILendingPool.sol";
import "../contracts/LOPPoolTemplates/aave/ILendingPoolAddressesProvider.sol";

contract TestLOPPoolFactory {
   LOPPoolFactory factory = LOPPoolFactory(DeployedAddresses.LOPPoolFactory());

  /* function testCreateAavePoolTemplate() public {
    address expected = DeployedAddresses.AaveFactory();
    factory.createPoolProviderTemplate(bytes32('aave'),DeployedAddresses.AaveFactory());
    Assert.equal(factory.templateAddressFor(bytes32('aave')), expected, "New provider should be recorded.");
  }

  function testCreateAavePool() public {
    bytes32 aaveId = bytes32("aave");
    //getReserveData()
    address Dai = address(0xaD6D458402F60fD3Bd25163575031ACDce07538D);
    (,,,,,,,,,,,address aDai,) = ILendingPool(ILendingPoolAddressesProvider(0x1c8756FD2B28e9426CDBDcC7E3c4d64fa9A54728).getLendingPool()).getReserveData(Dai);
    address expected = factory.createPool(aaveId, aDai, Dai);

    Assert.equal(factory.getPool(bytes32('aave'),Dai), expected, "New pool can be created");
  } */
} 
