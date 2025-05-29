pragma solidity ^0.8.30;

contract vote {
     
     struct Voter{
        string name;
        uint age;
        Gender gender;
        uint voterId;
        uint voteCandidateId;
        address voterAddress;
     }

     struct Candidate{
        string name;
        string party;
        uint age;
        Gender gender;
        uint candidateId;
        address candidateAddress;
        uint votes;
     }

     address electionCommission;

     address public winner; 

     uint nextCandidateId = 1;
     uint nextVoterId = 1;
     
     uint startTime;
     uint endTime;
     bool stopVoting;

     mapping(uint=>Voter) voterDetails;
     mapping(uint=>Candidate) candidateDetails;

     enum Gender {Male, Female, Other}

     constructor(){
        electionCommission=msg.sender;
     }

     modifier isVotingOver(){
        require(block.timestamp<endTime && stopVoting==false,"Voting time is over");
        _;
     }
    
     modifier onlyCommissioner(){
        require(msg.sender==electionCommission, "You are not authorized");
        _;
     }

     function emergencyStopVoting() public onlyCommissioner(){
        stopVoting=true;
     } 

     function registerCandidate(
        string calldata _name,
        string calldata _party,
        uint _age,
        Gender _gender
     ) external {

        require(_age>=18,"You are underage");
        require(isCandidateNotRegistered(msg.sender),"You are already registered");
        require(msg.sender!=electionCommission,"Election Commission not allowed to register as candidate");

        candidateDetails[nextCandidateId] = Candidate(
         {
          name:_name,
          party:_party,
          age:_age,
          gender:_gender,
          candidateId:nextCandidateId,
          candidateAddress:msg.sender,
          votes:0
          });
          nextCandidateId++;
     }

      function registerVoter(
        string calldata _name,
        uint _age,
        Gender _gender
      ) external {

         require(_age>=18,"You are underage");
         require(isVoterNotRegistered(msg.sender),"You are already registered");
         voterDetails[nextVoterId] = Voter(
         {
          name:_name,
          age:_age,
          gender:_gender,
          voterId:nextVoterId,
          voteCandidateId:0,
          voterAddress:msg.sender
          j});
          nextVoterId++;
      }

      function isCandidateNotRegistered(address _person) internal view returns (bool) {
         for (uint i=1; i<nextCandidateId; i++){
            if(candidateDetails[i].candidateAddress==_person)(
               return false;
            )
         }
         return true;
      }

      
      function isVoterNotRegistered(address _person) internal view returns (bool) {
         for (uint i=1; i<nextVoterId; i++){
            if(voterDetails[i].voterAddress==_person)(
               return false;
            )
         }
         return true;
      }


     }

     
     





    
}
