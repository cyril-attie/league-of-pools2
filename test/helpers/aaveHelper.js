const LendingPoolAddressesProviderABI = require("../../build/contracts/LendingPoolAddressesProvider.json").abi;
const LendingPoolABI = require("../../build/contracts/LendingPool.json").abi;

const lpAddressProviderAddress = '0x1c8756FD2B28e9426CDBDcC7E3c4d64fa9A54728'; //ropsten
// const lpAddressProviderAddress = '0x24a42fD28C976A61Df5D00D0599C34c4f90748c8' // mainnet 
const lpAddressProviderContract = new web3.eth.Contract(LendingPoolAddressesProviderABI, lpAddressProviderAddress)

let lpAddress;
// Get the latest LendingPoolCore address
async() => {
    lpAddress = await lpAddressProviderContract.methods
        .getLendingPool()
        .call()
        .catch((e) => {
            throw Error(`Error getting lendingPool address: ${e.message}`)
        });
}

const lpContract = new web3.eth.Contract(LendingPoolABI, lpAddress);

module.exports = { lpContract, lpAddressProviderAddress };