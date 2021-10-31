// to review completely

import web3 from './web3';
import CampaignFactory from './build/CampaignFactory.json';

const instance = new web3.eth.Contract(
   JSON.parse(CampaignFactory.interface),
   '0xa0503d65D9538dB5D7769fe9EeB1F502486FA179'
);

export default instance;
