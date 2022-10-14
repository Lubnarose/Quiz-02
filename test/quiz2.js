const { expect } = require("chai");
const { ethers } = require("hardhat");


describe("Token contract", function () {
  it("Deployment should assign the total supply of tokens to the owner", async function () {
    const [owner] = await ethers.getSigners();

    const Token = await ethers.getContractFactory("Token");

    const hardhatToken = await Token.deploy();

    const ownerBalance = await hardhatToken.balanceOf(owner.address);
    expect(await hardhatToken.totalSupply()).to.equal(ownerBalance);
  });
});

contract('ERCsell', async (account) => {
  let tokenSale;

  describe('Contract Attributes', async () => {
      it('Initializes the contract with the correct values', async () => {
          tokenSale = await ERCsell.deployed();
          assert.notEqual(tokenSale.address, 0x0, 'The smart contract address was set')
      })
  })

});