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
  
describe("BasicToken", () => {
  const [address, address(0)] = new MockProvider().getTokens()
  let token: Contract

  beforeEach(async () => {
    token = await deployContract(wallet, BasicToken, [1000])
  })
})
it("Assigns initial balance", async () => {
  expect(await token.balanceOf(wallet.address)).to.equal(1000)
})
it("Transfer emits event", async () => {
  await expect(token.transfer(walletTo.address, 7))
    .to.emit(token, "Transfer")
    .withArgs(address.address, addressTo.address, 7)
})
it('Can not transfer above the amount', async () => {
    await expect(token.transfer(addressTo.address, 1007))
      .to.be.revertedWith('VM Exception while processing transaction: revert ERC20: transfer amount exceeds balance');
  });

  it('Send transaction changes receiver balance', async () => {
    await expect(() => address.sendTransaction({to: addressTo.address, gasPrice: 0, value: 200}))
      .to.changeBalance(walletTo, 200);
  });

  it('Send transaction changes sender and receiver balances', async () => {
    await expect(() =>  address.sendTransaction({to: addressTo.address, gasPrice: 0, value: 200}))
      .to.changeBalances([address, addressTo], [-200, 200]);
  });
});
