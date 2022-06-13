require("@nomiclabs/hardhat-waffle");
require("dotenv").config();

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});


// const RINKEBY_URL = https://eth-rinkeby.alchemyapi.io/v2/B5J6AoL6_A1iZHVAITUbgUuQwvF0XN9G
// const PRIVATE_KEY = 2b4aab310fc6f71ef7bc40a2c9ec1fa6351fc781edbc17e467753fd635477be4

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.4",
  networks: {
      rinkeby: {
        url: process.env.RINKEBY_URL || "",
        accounts:
          process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
      },
    },
};
