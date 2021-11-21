const { ethers } = require("ethers");
const { connect } = require("http2");
const { basename } = require("path/posix");

async function main() {
  // We get the contract to deploy

  const magic_eth = '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE';
  const [addr1, addr2] = await hre.ethers.getSigners();

  const HAK = await hre.ethers.getContractFactory("HAKTest1");
  const PO = await hre.ethers.getContractFactory("PriceOracleTest1");
  const Bank = await hre.ethers.getContractFactory("Test3");

  const po = await PO.deploy();
  const hak = await HAK.connect(addr1).deploy();

  const bank = await Bank.deploy(po.address, hak.address);

  console.log("PO deployed to:", po.address);
  console.log("HAK deployed to:", hak.address);
  console.log("BANK deployed to:", bank.address);

  //console.log("Deposit ETH: " + await bank.connect(addr1).deposit(magic_eth, 500 * (10^18), {value: 500 * (10^18)}))
  //console.log("Transfer: " + await hak.connect(addr1).transfer(bank.address, 200 * (10^18)));

  console.log("Approval: " + await hak.approve(bank.address, 150 * (10^18)));
  console.log("Allowance: " + await hak.allowance(addr1.address, bank.address));
  console.log("Deposit: " + await bank.connect(addr1).deposit(hak.address, 150 * (10^18)));
  console.log("GetBalance: " + await bank.connect(addr1).getBalance(hak.address));
  console.log("GetBalance: " + await bank.connect(addr1).getBalance(magic_eth));

  console.log("HAK Balance: " + await hak.balanceOf(addr1.address));
  console.log("HAK Balance2: " + await hak.balanceOf(addr2.address));
  console.log("HAK Balance Bank: " + await hak.balanceOf(bank.address));

  console.log("Borrow: " + await bank.connect(addr1).borrow(magic_eth, 100 * (10^18)));
  console.log("Withdraw: " + await bank.connect(addr1).withdraw(hak.address, 100 * (10^18)));

  console.log("Repay: " + await bank.connect(addr2).liquidate(hak.address, addr1.address, {value: 150 * (10^18)}));
  console.log("HAK Balance1: " + await hak.balanceOf(addr1.address));
  console.log("HAK Balance2: " + await hak.balanceOf(addr2.address));
  console.log("HAK Balance Bank: " + await hak.balanceOf(bank.address));

  //const Bad = await hre.ethers.getContractFactory("Bad");
  //const bad = await Bad.connect(addr1).deploy(hak.address, bank.address, addr1.address);
  //console.log("Re-Entrancy: " + await bad.connect(addr1).call_liquidate());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
