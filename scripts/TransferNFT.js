const hre = require("hardhat");
require("dotenv").config();

const TransferNFT = async (accounts) => {
    const MyNftFactory = await hre.ethers.getContractFactory("Test");
    const myNft = await MyNftFactory.attach(process.env.NFT_ADDRESS);
    for (let i = 0; i < accounts.length; i++) {
        await myNft.makeAnEpicNFT(accounts[i]);
    }
};

modules.exports = TransferNFT

