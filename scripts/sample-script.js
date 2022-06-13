// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");
const fs = require('fs')

async function main() {
  // let max_team_size = 5;
  // let num_tracks = 2;
  // let prizes = [[100,200],[50,100], [25,50]];
  // let judges = []
  // let judgeDate = 1000000;
  // let endDate = 2000000;

  const Factory = await hre.ethers.getContractFactory("Factory");
  const factory = await Factory.deploy();
  await factory.deployed();
  console.log("Factory deployed to:", factory.address);

  const tfactory = await Factory.attach(factory.address);

  await tfactory.createHackathon(5,2,[[100,50,25],[200,100,50]],[],1000000,2000000)

  // console.log("Hackathon address:", hackathonAddress[0].args.hackathon);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });