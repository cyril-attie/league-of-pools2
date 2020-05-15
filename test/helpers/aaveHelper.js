// Import the ABIs, see: https://docs.aave.com/developers/developing-on-aave/deployed-contract-instances
const LendingPoolAddressesProviderABI = require("../abi/LendingPoolAddressesProvider.json");
const LendingPoolABI = require("../abi/LendingPool.json");

// Retrieve the LendingPool address
const lpAddressProviderAddress = '0x1c8756FD2B28e9426CDBDcC7E3c4d64fa9A54728' // ropsten address, for other addresses: https://docs.aave.com/developers/developing-on-aave/deployed-contract-instances
console.log(LendingPoolAddressesProviderABI);
const lpAddressProviderContract = new web3.eth.Contract(LendingPoolAddressesProviderABI, lpAddressProviderAddress);

console.log(` Lending Address provider at: ${lpAddressProviderContract}`);
let lpAddress;
// Get the latest LendingPool contract address
lpAddressProviderContract.methods
    .getLendingPool()
    .call()
    .catch((e) => {
        throw Error(`Error getting lendingPool address: ${e.message}`)
    }).then((result) => { console.log(result);
        this.lpAddress = result; });
console.log(`Fetched Lending pool address is ${lpAddress}`);

const lpContract = new web3.eth.Contract(LendingPoolABI, lpAddress);
console.log(lpContract.address);

module.exports = { lpContract, lpAddressProviderAddress };