import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";
dotenv.config();

const ALCHEMY_API_KEY = process.env.ALCHEMY_API_KEY;
const config: HardhatUserConfig = {
  solidity: "0.8.24",
  networks: {
    hardhat: {
      forking: {
        url: `${ALCHEMY_API_KEY}`, 
      }
    },

    'lisk-sepolia': {
      url: `${process.env.LISK_API_KEY}`,
      accounts: [process.env.WALLET_KEY as string],
      gasPrice: 1000000000,
    },
  },

};

export default config;