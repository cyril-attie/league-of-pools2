const { lpContract, lpAddressProviderAddress } = require('./helpers/aaveHelper');
// const {
//     BN, // Big Number support 
//     constants, // Common constants, like the zero address and largest integers
//     expectEvent, // Assertions for emitted events
//     expectRevert, // Assertions for transactions that should fail
// } = require('@openzeppelin/test-helpers');

var LOPPoolFactory = artifacts.require("LOPPoolFactory");
var AaveFactory = artifacts.require("AaveFactory");

contract('LOPPoolFactory', async(accounts) => {
    const aaveId = web3.utils.fromAscii("aave");

    before(async() => {
        let factory = await LOPPoolFactory.deployed();
        console.log(factory.address);
        console.log(lpContract.address);
        let reserves = await lpContract.methods
            .getReserves()
            .call()
            .catch((e) => {
                throw Error(`Error depositing to the LendingPool contract: ${e.message}`)
            });

        console.log(`Reserves are :${reserves}`);
        console.log(`aaveId is type ${typeof aaveId}`);
    });

    beforeEach(async function() {});

    it("should create a provider pool template", async() => {
        let expected = AaveFactory.deployed().then(aaveFactory => aaveFactory.address);
        console.log(`Aave Factory deployed to ${expected} will be used for aave template address`);
        // let aaveId = web3.utils.fromAscii("aave");
        await factory.createPoolProviderTemplate(aaveId, expected);
        assert.equal(await factory.templateAddressFor.call(aaveId), expected, "New provider should be recorded.");
    });
    /* 
        it("should create pools based on provider template", async() => {
            let aaveId = web3.utils.fromAscii("aave");
            console.log("aaveId : ", aaveId);
            let Dai = "0xf80A32A835F79D7787E8a8ee5721D0fEaFd78108";

            let aDai = "0xcB1Fe6F440c49E9290c3eb7f158534c2dC374201";
            let expected = await factory.createPool(aaveId, aDai, Dai);
            console.log("Expected pool address : ", expected);
            assert.equal(await factory.getPool.call(bytes32('aave'), Dai), expected, "New pool can be created");
        }); */

    // it("should create pools based on provider template", function() {

    // });
    // it("should record provider-pool meronym relationship", function() {

    // });

});