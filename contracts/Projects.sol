// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Projects {
    struct Milestone {
        bytes32 name;
        string description;
        string proof; // hash returned from IPFS or swarm
    }

    enum Role {
        FOUNDER,
        CO_FOUNDER,
        EMPLOYEE
    }

    struct Member {
        bytes32 name;
        Role role;
        string image; // url for their image
    }

    struct Project {
        bytes32 name;
        string description;
        string main_video_link;
        string pitch_deck_link;
        uint32 target_fund;
        uint32 raised_funds;
        uint32 disburst_funds;
        uint64 deadline;
        bytes32[] backers;
        Milestone[] milestones;
        Member[] members;
    }
}
