require('dotenv');
const fs = require('fs');
const ethers = require('ethers');

var LOPPoolFactory = artifacts.require("./LOPPoolFactory.sol");
var AaveFactory = artifacts.require("./LOPPoolTemplates/aave/AaveFactory.sol");
var ProviderConfig = artifacts.require("./LOPPoolTemplates/TemplatesConfig.sol");

let batchManagerBuild = require('../build/contracts/LOPPoolFactory.json');

module.exports = async(deployer, network, accounts) => {
    /*  console.log('Trying to load mnemonic...');
         const mnemonic = process.env.MNEMONIC;

         if (mnemonic) {
             
            //   * Generate seven wallets from mnemonic browsable via Metamask.
            //   * Using ethers, we derive each Metamask usable account from
            //   * the mnemonic to ensure we can test the system afterwards.
             
        console.log('Mnemonic Loaded', mnemonic);
        accounts = [...Array(7)].map((_, i) => ethers.Wallet.fromMnemonic(mnemonic, `m/44'/60'/0'/0/${i}`).address);

        console.log('Available Accounts');
        accounts.map((account, i) => console.log(`(${i}) ${account}`));
    } */
    await deployer.deploy(LOPPoolFactory);
    await deployer.deploy(ProviderConfig);
    await deployer.deploy(AaveFactory, ProviderConfig.address);

};