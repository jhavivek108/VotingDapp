// SPDX-License-Identifier: MIT
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
     enum votingStatus {NotStarted, InProgress, Ended}

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
         });
          nextVoterId++;
      }

      function isCandidateNotRegistered(address _person) internal view returns (bool) {
         for (uint i=1; i<nextCandidateId; i++){
            if(candidateDetails[i].candidateAddress==_person){
               return false;
            }
         }
         return true;
      }

      
      function isVoterNotRegistered(address _person) internal view returns (bool) {
         for (uint i=1; i<nextVoterId; i++){
            if(voterDetails[i].voterAddress==_person){
               return false;
            }
         }
         return true;
      }

      function getCandidateList() public view returns (Candidate[] memory){
         Candidate[] memory candidateList = new Candidate[](nextCandidateId-1);
         for (uint i=0; i < candidateList.length ; i++){
            candidateList[i]= candidateDetails[i+1];
         }
         return candidateList;
      } 

       function getVoterList() public view returns (Voter[] memory){
         Voter[] memory voterList = new Voter[](nextVoterId-1);
         for (uint i=0; i < voterList.length ; i++){
            voterList[i]= voterDetails[i+1];
         }
         return voterList;
      } 

      function castVote(uint _voterId, uint _candidateId) external {
          require(block.timestamp >= startTime, "Voting has not started yet");
          require( voterDetails[_voterId].voteCandidateId==0,"You have already voted");
          require( voterDetails[_voterId].voterAddress==msg.sender,"You are not authorized");
          require(_candidateId > 0 && _candidateId < nextCandidateId, "Invalid candidate ID");
          voterDetails[_voterId].voteCandidateId= _candidateId;
          candidateDetails[_candidateId].votes++;
      }

    
      function setVotingPeriod(uint _startTimeDuration, uint _endTimeDuration) external onlyCommissioner() {
          require(_endTimeDuration>3600,"_endTimeDuration must be greater than 1 hour");
          startTime= block.timestamp +_startTimeDuration; 
          endTime = startTime+_endTimeDuration;
      }

      function getVotingStatus() public view returns(votingStatus) {
         if (startTime==0){
           return votingStatus.NotStarted; 
         }
         else if (endTime>block.timestamp && stopVoting==false){
            return votingStatus.InProgress;
         }
         else{
            return votingStatus.Ended;
         }
      }

      function announceVotingResult() public onlyCommissioner(){
         uint max=0;
         for(uint i=1; i<nextCandidateId; i++)
          if(candidateDetails[i].votes>max){
            max=candidateDetails[i].votes;
            winner=candidateDetails[i].candidateAddress;
          }
      }
      
      function emergencyStopVoting() public onlyCommissioner(){
        stopVoting=true;
     } 

   }

     
     





    

