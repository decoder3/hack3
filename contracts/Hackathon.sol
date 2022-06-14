//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Hackathon{
    // address tokenMint =  ;

    struct Team{
        uint leader_idx;
        address payable[]  p_addresses;
        uint[] judge_scores;
        uint participant_scores;
        uint people_scores;
    }

    mapping(address => uint) person_category;

    uint endDate;
    uint judgeDate;

    mapping(address => bool) public hasVotedOthers;
    mapping(address => bool[]) public hasVotedJudges;

    uint[] public prizes;

    address public admin;
    address[] public judges;
    Team[] public teams;
    uint public max_team_size;
    uint public num_tracks;
    uint public creation_time;
    
    constructor(
        uint _max_team_size,
        uint _num_tracks,
        uint[] memory _prizes,
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
        creation_time = block.timestamp;
    }

    function addTeam(address payable[] memory _taddress, uint leader_idx) public {
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
        require(block.timestamp > judgeDate && block.timestamp < endDate);
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
                // for now we can allow anyone to vote
                teams[team_idx].people_scores++;
            }
        }
    }



    function getBest(uint[] memory arr) private pure returns(uint){
        uint len = arr.length;
        require(len >= 1);
        uint mx = arr[0];
        uint idx = 0;
        for(uint i = 1; i < len; i++){
            if(arr[i] > mx){
                mx = arr[i];
                idx = i;
            }
        }
        return idx;
    }

    function transfer_prize_money(uint team_idx, uint amount) private {
        require(team_idx < teams.length);
        // divide the money among all the team members and transfer it to them.
        uint team_size = teams[team_idx].p_addresses.length;
        uint money_per_person = amount / team_size;
        for(uint i = 0; i < team_size; i++){
            teams[team_idx].p_addresses[i].transfer(money_per_person);
        }
        // transfer the remaining amount to the team leader.
        if(amount % team_size != 0){
            uint leader_idx = teams[team_idx].leader_idx;
            teams[team_idx].p_addresses[leader_idx].transfer(amount % team_size);
        }
    }

    function conclude() public {
        require(block.timestamp > endDate);
        // TODO: give participants participation NFT or something

        // ids of best teams in each track
        uint[] memory best_teams = new uint[](num_tracks);
        for(uint i = 0; i < num_tracks; i++){
            uint[] memory scores = new uint[](teams.length);
            for(uint j = 0; j < teams.length; j++){
                scores[j] = teams[j].judge_scores[i];
            }
            best_teams[i] = getBest(scores);
        }

        for(uint i = 0; i < num_tracks; i++){
            transfer_prize_money(best_teams[i], prizes[i]);
        }

        uint[] memory participant_scores = new uint[](teams.length);
        uint[] memory people_scores = new uint[](teams.length);
        for(uint i = 0; i < teams.length; i++){
            participant_scores[i] = teams[i].participant_scores;
            people_scores[i] = teams[i].people_scores;
        }

        uint participant_favourite = getBest(participant_scores);
        uint people_favourite = getBest(people_scores);
    }

    // this function was made considering there would we three prizes for each track
    // function gettop3(uint[] memory arr) public pure returns(uint[3] memory){
    //     uint len = arr.length;
    //     require(len >= 3);
    //     uint[] memory idx = new uint[](len);
    //     for(uint i = 0; i < len; i++) idx[i] = i;
    //     uint[3] memory ans;
    //     for(uint i = 0; i < 3; i++){
    //         for(uint j = i + 1; j < len; j++){
    //             if(arr[j] > arr[i]){
    //                 uint tmp = arr[j];
    //                 arr[j] = arr[i];
    //                 arr[i] = tmp;
    //                 uint tidx = idx[j];
    //                 idx[j] = idx[i];
    //                 idx[i] = tidx;
    //             }
    //         }
    //     }
    //     for(uint i = 0; i < 3; i++) ans[i] = idx[i];
    //     return ans;
    // }
}