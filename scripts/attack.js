const { ethers } = require("ethers");
const { connect } = require("http2");
const { basename } = require("path/posix");

async function main() {
  // We get the contract to deploy

  const magic_eth = '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE';
  const [addr1, addr2] = await hre.ethers.getSigners();

  const HAK = await hre.ethers.getContractFactory("HAKTest1");
  const PO = await hre.ethers.getContractFactory("PriceOracleTest1");
  const Bank = await hre.ethers.getContractFactory("Test");

  const po = await PO.deploy();
  const hak = await HAK.connect(addr1).deploy();

  const bank = await Bank.deploy(po.address, hak.address);

  console.log("PO deployed to:", po.address);
  console.log("HAK deployed to:", hak.address);
  console.log("BANK deployed to:", bank.address);

  console.log("Approval: " + await hak.approve(bank.address, 15000));
  console.log("Allowance: " + await hak.allowance(addr1.address, bank.address));
  console.log("Deposit: " + await bank.connect(addr1).deposit(hak.address, 15000));
  console.log("GetBalance: " + await bank.connect(addr1).getBalance(hak.address));
  console.log("Borrow: " + await bank.connect(addr1).borrow(magic_eth, 1000));
  console.log("Withdraw: " + await bank.connect(addr1).withdraw(hak.address, 1000));

  console.log("Liquidate: " + await bank.connect(addr2).liquidate(hak.address, addr1.address));
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
