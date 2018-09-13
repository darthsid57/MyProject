import web3 from './web3';
import CampaignFactory from './build/CampaignFactory.json';


const instance = new web3.eth.Contract(
  JSON.parse(CampaignFactory.interface),
  '0x19B35F617fE30F095C9105A067566f51197D40cD'
);

export default instance;
