const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Hackathon", function () {
  it("testing the deployment of the Hackthon", async function () {
    let max_team_size = 5;
    let num_tracks = 2;
    let prizes = [[100,50,25],[200,100,50]];
    let judges = []
    let judgeDate = 1000000;
    let endDate = 2000000;

    const Hackathon = await hre.ethers.getContractFactory("Hackathon");
    const hackathon = await Hackathon.deploy(max_team_size, num_tracks, prizes, judges, judgeDate, endDate);

    await hackathon.deployed();
    console.log("Hackathon deployed to:", hackathon.address);


    // expect(await greeter.greet()).to.equal("Hello, world!");

    // const setGreetingTx = await greeter.setGreeting("Hola, mundo!");

    // // wait until the transaction is mined
    // await setGreetingTx.wait();

    // expect(await greeter.greet()).to.equal("Hola, mundo!");
  });
});

// 5, 2, [[100,200],[50,100],[25,50]],[],1000000,2000000
// 5, 2, [[100,50,25],[200,100,50]],[],1000000,2000000
// [10,33,2,43,12,100,10,3]
// ["0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266","0x70997970C51812dc3A010C7d01b50e0d17dc79C8"], 0