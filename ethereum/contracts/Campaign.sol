pragma solidity ^0.4.24;

contract CampaignFactory {
  address[] public deployedCampaigns;

  function createCampaign(uint minimum) public {
    address newCampaign = new Campaign(minimum, msg.sender);
    deployedCampaigns.push(newCampaign);
  }

  function getDeployedCampaigns() public view returns (address[]){
    return deployedCampaigns;
  }
}

contract Campaign {
  //data in regards to Requests
    struct Request {
        string description;
        uint value;
        address recipient;
        bool complete;
        uint approvalCount;
        mapping (address => bool) approvals;
    }

  address public manager;
  uint public minimumContribution;
  //address[] public approvers;
  Request[] public requests;

  //image of array mapping of approvers
  mapping(address => bool) public approvers;
  uint public approversCount;

  //modifier that only allows sender
  modifier restricted(){
      require(msg.sender == manager);
      _;
  }

 //constructor
  constructor (uint minimum, address creater) public {
    manager = creater;
    minimumContribution = minimum;
  }

// payable function that takes in ether, allows contributions above minimumContribution
  function contribute() public payable {
    require(msg.value > minimumContribution);

    approvers[msg.sender] = true;
    approversCount++;
  }

// function that can create request
  function createRequest(string description, uint value, address recipient) public restricted {
    Request memory newRequest = Request({
        description: description,
        value: value,
        recipient: recipient,
        complete: false,
        approvalCount: 0
    });

    requests.push(newRequest);
  }

//allows approvers to approve requests
  function approveRequest(uint index) public {
    Request storage request = requests[index];

    require(approvers[msg.sender]);
    //statment is changed to false, whereby if user has voted, it will be unable to.
    require(!request.approvals[msg.sender]);

    request.approvals[msg.sender] = true;
    request.approvalCount++;
  }

  function finalizeRequest(uint index) public restricted {
    Request storage request = requests[index];

    require(request.approvalCount > (approversCount / 2));
    require(!request.complete);

    request.recipient.transfer(request.value);
    request.complete = true;

  }

}
