const { ethers } = require("ethers");

async function main() {
  // We get the contract to deploy
  const HAK = await hre.ethers.getContractFactory("HAKTest1");
  const PO = await hre.ethers.getContractFactory("PriceOracleTest1");
  const Bank = await hre.ethers.getContractFactory("Test");

  const po = await PO.deploy();
  const hak = await HAK.deploy();

  const bank = await Bank.deploy(po.address, hak.address);

  console.log("PO deployed to:", po.address);
  console.log("HAK deployed to:", hak.address);
  console.log("BANK deployed to:", bank.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
