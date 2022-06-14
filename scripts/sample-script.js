// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");
const fs = require('fs')
const { expect } = require("chai");

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

  const hackathon = await factory.createHackathon(5,2,[100,200],[],1000000,2000000);
  await hackathon.wait();

  const hackathonAddress = await factory.getLatestHackathon();
  console.log("hackathon deployed to:", hackathonAddress);

  const MyNftFactory = await hre.ethers.getContractFactory("Test");
  const myNft = await MyNftFactory.attach('0xB8dbd450Ae4667be85374991244a2F5171178976');
  await myNft.makeAnEpicNFT();

  console.log("called the nft");

  // let retVal = await hackathon.wait();
  // console.log(retVal.events);
  // const hackathonAddress = retVal.events[0].args.hackathonAddress;
  // console.log("Hackathon deployed to:", hackathonAddress);

  // const tfactory = await Factory.attach(factory.address);

  // let hackathonAddress = 0x0000000000000000000000000000000000000000;
  // const hackathonAddress = await tfactory.createHackathon(5,2,[[100,50,25],[200,100,50]],[],1000000,2000000)
  // await expect(tfactory.createHackathon(5,2,[[100,50,25],[200,100,50]],[],1000000,2000000))
  //       .to.emit(tfactory, 'HackathonCreated')
  //       .withArgs(hackathonAddress);
  
  // console.log(hackathonAddress);

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