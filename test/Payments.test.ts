import { ethers } from "hardhat";
import { expect } from "chai";
import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";

const MESSAGE = "Hello!";
const SUM = 100;

describe("Payments", () => {
  const deploy = async () => {
    const [owner, client] = await ethers.getSigners();

    const ContractPayments = await ethers.getContractFactory("Payments");

    const contractPayments = await ContractPayments.deploy();

    return { owner, client, contractPayments };
  };

  it("should be deployed", async () => {
    const { contractPayments } = await loadFixture(deploy);
    const address = await contractPayments.getAddress();
    expect(address).to.be.properAddress;
  });

  it("should have o ether by default", async () => {
    const { contractPayments } = await loadFixture(deploy);
    const balance = await contractPayments.currentBalance();
    expect(balance).to.eq(0);
    console.log("~ ~ it ~ balance:", balance);
  });

  it("should be possible to send funds", async () => {
    const { contractPayments, owner, client } = await loadFixture(deploy);

    const tx = await contractPayments
      .connect(client)
      .pay(MESSAGE, { value: SUM });

    console.log("tx", tx);

    await expect(tx).to.changeEtherBalances(
      [client, contractPayments],
      [-SUM, SUM]
    );
    await tx.wait();

    const balance = await contractPayments.currentBalance();
    console.log("~ ~ it ~ balance:", balance);
  });
});
