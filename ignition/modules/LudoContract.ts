import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";


const LudoContract = buildModule("LudoContract", (m) => {

  const ludoGame = m.contract("LudoGame");

  return { ludoGame };
});

export default LudoContract;
