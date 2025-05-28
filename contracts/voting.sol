pragma solidity ^0.8.30;

contract vote {
     
     struct Voter{
        string name;
        uint age;
        uint voterId;
        Gender gender;
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
     





    
}

