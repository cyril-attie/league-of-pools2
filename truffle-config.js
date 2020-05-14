require('dotenv').config();
const Web3 = require("web3");
const HDWalletProvider = require("@truffle/hdwallet-provider");
// const Wallet = require('ethereumjs-wallet');

const mnemonic = process.env.MNEMONIC;
const infuraKey = process.env.INFURA_API_KEY;

module.exports = {
    networks: {
        development: {
            host: "localhost",
            port: 8545,
            network_id: "*" // Match any network id
        },

        ropsten: {
            provider: () => new HDWalletProvider(mnemonic, `https://ropsten.infura.io/v3/${infuraKey}`),
            network_id: 3 // Ropsten's id
                // ,from: "0xda9b1a939350dc7198165ff84c43ce77a723ef73"
        },
        // can be used for tests with command
        // $ ganache-cli -f https://ropsten.infura.io/v3/0372c431ba564ecdbd644c7075cd6f52 -i 999
        ropsten_fork: {
            host: "localhost",
            port: 8545,
            network_id: 999 // Ropsten's id
                // ,from: "0xda9b1a939350dc7198165ff84c43ce77a723ef73"
        },
        kovan: {
            provider: () => new HDWalletProvider(mnemonic, `https://kovan.infura.io/v3/${infuraKey}`),
            network_id: 42
                // ,from: "0xda9b1a939350dc7198165ff84c43ce77a723ef73"

        }
    },
    compilers: {
        solc: {
            version: "0.6.7"
        }
    }
};