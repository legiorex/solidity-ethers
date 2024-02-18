import { ethers } from "hardhat";
import { expect } from "chai";
import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { Signer, TransactionResponse } from "ethers";

describe("Lesson12", async () => {
  const deploy = async () => {
    const [owner, client] = await ethers.getSigners();

    const Logger = await ethers.getContractFactory("Logger", owner);
    const logger = await Logger.deploy();

    const Contract = await ethers.getContractFactory("Lesson12", owner);

    const contract = await Contract.deploy(logger.getAddress());

    return { owner, client, contract, logger };
  };

  it("allows to pay and payment info", async () => {
    const sum = 100;
    const { contract, owner } = await loadFixture(deploy);
    const txData = {
      value: sum,
      to: contract.getAddress(),
    }; // создаём данные для транзакции

    const tx: TransactionResponse = await owner.sendTransaction(txData);
    await tx.wait();

    await expect(tx).to.changeEtherBalance(contract, sum);

    const amount = await contract.payment(owner.address, 0);
    expect(amount).to.eq(sum);
  });
});
