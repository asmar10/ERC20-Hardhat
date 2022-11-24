const hre = require("hardhat");

async function main() {
  const Token = await hre.ethers.getContractFactory("token");
  const token = await Token.deploy(1000000000000, 50);

  await token.deployed();

  console.log("deployed at: " + token.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
