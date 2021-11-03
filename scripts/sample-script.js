const hre = require("hardhat");

async function main() {
  const MyContract = await hre.ethers.getContractFactory("Leaderboard");
  const my_contract = await MyContract.deploy();

  await my_contract.deployed();

  console.log("MyContract deployed to:", my_contract.address);
}
main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });