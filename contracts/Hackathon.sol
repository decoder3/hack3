//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Hackathon{
    // create a struct of team
    // address tokenMint =  ;

    struct Team{
        uint leader_idx;
        address[]  p_addresses;
        uint[] judge_scores;
        uint participant_scores;
        uint people_scores;
    }

    mapping(address => uint) person_category;

    uint endDate;
    uint judgeDate;

    mapping(address => bool) public hasVotedOthers;
    mapping(address => bool[]) public hasVotedJudges;

    uint[3][] public prizes;

    address public admin;
    address[] public judges;
    Team[] public teams;
    uint public max_team_size;
    uint public num_tracks;
    
    constructor(
        uint _max_team_size,
        uint _num_tracks,
        uint[3][] memory _prizes,
        address[] memory _judges,
        uint _judgeDate,
        uint _endDate
    ){
        max_team_size = _max_team_size;
        num_tracks = _num_tracks;
        admin = msg.sender;
        prizes = _prizes;
        judges = _judges;
        for(uint i = 0; i < _judges.length; i++){
            person_category[_judges[i]] = 1;
        }
        endDate = _endDate;
        judgeDate = _judgeDate;
        admin = msg.sender;
    }

    function addTeam(address[] memory _taddress, uint leader_idx) public {
        require (_taddress.length <= max_team_size);
        require(leader_idx < _taddress.length);
        teams.push(Team(leader_idx, _taddress, new uint[](num_tracks), 0, 0));
        for(uint i = 0; i < _taddress.length; i++){
            person_category[_taddress[i]] = 2;
        }
        console.log("team added successfully!!");
    }

    // judge -> 0, participant -> 1, player -> 2;
    function vote(uint team_idx, uint track_idx) public {
        // require(block.timestamp > judgeDate);
        require(team_idx < teams.length);
        uint voterCategory = person_category[msg.sender];
        if(voterCategory == 1){
            // judge
            require(track_idx >= 0 && track_idx < 3);
            require(!hasVotedJudges[msg.sender][track_idx]);
            hasVotedJudges[msg.sender][track_idx] = true;
            teams[team_idx].judge_scores[track_idx]++;
        }
        else{
            require(!hasVotedOthers[msg.sender]);
            hasVotedOthers[msg.sender] = true;
            if(voterCategory == 2){
                // particiants
                teams[team_idx].participant_scores++;
            }
            else{
                // people
                // TODO: check if the person holds people NFT or something
                teams[team_idx].people_scores++;
            }
        }
    }

    function gettop3(uint[] memory arr) public pure returns(uint[3] memory){
        uint len = arr.length;
        require(len >= 3);
        uint[] memory idx = new uint[](len);
        for(uint i = 0; i < len; i++) idx[i] = i;
        uint[3] memory ans;
        for(uint i = 0; i < 3; i++){
            for(uint j = i + 1; j < len; j++){
                if(arr[j] > arr[i]){
                    uint tmp = arr[j];
                    arr[j] = arr[i];
                    arr[i] = tmp;
                    uint tidx = idx[j];
                    idx[j] = idx[i];
                    idx[i] = tidx;
                }
            }
        }
        for(uint i = 0; i < 3; i++) ans[i] = idx[i];
        return ans;
    }

    function conclude() public {
        // TODO: give participants participation NFT or something

        // for(uint i = 0; i < num_tracks; i++){
        //     uint[] memory tmp;
        // }
        
        require(block.timestamp > endDate);

    }
    

}