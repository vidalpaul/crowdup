// to review completely

const path = require('path');
const solc = require('solc');
const fs = require('fs-extra');

// Delete build folder
const buildPath = path.resolve(__dirname, 'build');
fs.removeSync(buildPath);

// Read .sol from contracts folder
const campaignPath = path.resolve(__dirname, 'contracts', 'Campaign.sol');
const source = fs.readFileSync(campaignPath, 'utf8');

// Compile both contracts from source
const output = solc.compile(source, 1).contracts;

// Write output to the 'build' directory
fs.ensureDirSync(buildPath);
for (let contract in output) {
   fs.outputJSONSync(
      path.resolve(buildPath, contract.replace(':', '') + '.json'),
      output[contract]
   );
}
