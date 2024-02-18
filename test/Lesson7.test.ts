import { ethers } from "hardhat";
import { expect } from "chai";
import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { Signer, TransactionResponse } from "ethers";

describe("Lesson7", () => {
  const deploy = async () => {
    const [owner, client] = await ethers.getSigners();

    const Contract = await ethers.getContractFactory("Lesson7");

    const contract = await Contract.deploy();

    return { owner, client, contract };
  };

  const sendMoney = async (sender: Signer) => {
    const { contract } = await loadFixture(deploy);

    const amount = 100;
    const txData = {
      to: contract.getAddress(),
      value: amount,
    };
    const tx: TransactionResponse = await sender.sendTransaction(txData);
    await tx.wait();
    type Tx = [TransactionResponse, number];
    const result: Tx = [tx, amount];

    return result;
  };

  it("should allow to send money", async () => {
    const { client, contract } = await loadFixture(deploy);
    const [sendMoneyTx, amount] = await loadFixture(
      sendMoney.bind(null, client)
    );
    await expect(() => sendMoneyTx).to.changeEtherBalance(client.address, -100);
    await expect(() => sendMoneyTx).to.changeEtherBalance(contract, amount);
  });

  it("check event Paid", async () => {
    const { client, contract } = await loadFixture(deploy);

    const [sendMoneyTx, amount] = await loadFixture(
      sendMoney.bind(null, client)
    );

    const timestamp = (
      await ethers.provider.getBlock(sendMoneyTx.blockNumber as number)
    )?.timestamp;

    await expect(sendMoneyTx)
      .to.emit(contract, "Paid")
      .withArgs(client.address, amount, timestamp);
  });

  it("withdraw reverted other account", async () => {
    const { contract, client } = await loadFixture(deploy);

    await loadFixture(sendMoney.bind(null, client));

    await expect(
      contract.connect(client).withdraw(client.address)
    ).to.be.revertedWith("your are not an owner!");
  });

  it("withdraw money only owner", async () => {
    const { contract, client, owner } = await loadFixture(deploy);

    const [_, amount] = await loadFixture(sendMoney.bind(null, client));

    const tx = await contract.withdraw(owner.address);

    await expect(() => tx).to.changeEtherBalances(
      [contract, owner.address],
      [-amount, amount]
    );
  });
});
