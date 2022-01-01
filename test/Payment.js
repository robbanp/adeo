const { expect } = require("chai");

describe("Payment contract", function () {
    let Token;
    let hardhatToken;
    let payment;
    let owner;
    let addr1;
    let addr2;
    let addrs;
    let receiver;
    let sender;

    // `beforeEach` will run before each test, re-deploying the contract every
  // time. It receives a callback, which can be async.
  beforeEach(async function () {
    // Get the ContractFactory and Signers here.
    Token = await ethers.getContractFactory("Token");
    [owner, addr1, addr2, sender, receiver, ...addrs] = await ethers.getSigners();

    // To deploy our contract, we just have to call Token.deploy() and await
    // for it to be deployed(), which happens once its transaction has been
    // mined.
    hardhatToken = await Token.deploy();
    const Payment = await ethers.getContractFactory("Payment");
    payment = await Payment.deploy(hardhatToken.address, owner.address);
  });
  
  it("Deployment should assign the total supply of tokens to the owner", async function () {
    const ownerBalance = await hardhatToken.balanceOf(owner.address);
    expect(await hardhatToken.totalSupply()).to.equal(ownerBalance);
  });

  it("Sender can auth", async function () {
    await hardhatToken.transfer(sender.address, 500);
    const balance = await hardhatToken.balanceOf(sender.address);
    // sender need to approve allowance to contract address
    const amount = "20";
    await hardhatToken.connect(sender).approve(payment.address, amount);
    const trx = await payment.connect(sender).authorize(
        "1",
        "1",
        amount,
        receiver.address,
        );
//        console.log("trx:", trx);
        await trx.wait();
        expect(await payment.totalAuthBalance()).to.equal(amount);
  });


});