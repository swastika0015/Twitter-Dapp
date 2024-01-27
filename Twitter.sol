// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

contract Twitter{

    uint16 public MAX_TWEET_LENGTH = 288;

    struct Tweet{
        uint256 id;
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }
    mapping( address => Tweet[]) public tweets;

    address public owner;

    event tweetCreated(uint256 id, address author, string content, uint256 timestamp);
    event tweetLiked(address liker, address tweetAuthor, uint256 tweetId, uint256 newLikeCount);
    event tweetUnliked(address unliker, address tweetAuthor, uint256 tweetId, uint256 newUnlikeCount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not owner!!");
        _;
    }

    function changeTweetLength(uint16 newTweetLength) public onlyOwner{
        MAX_TWEET_LENGTH = newTweetLength;
    }

    function createTweet(string memory _tweet) public {
        
        require(bytes(_tweet).length <= MAX_TWEET_LENGTH, "Tweet too long!");

        Tweet memory newTweet = Tweet({
            id: tweets[msg.sender].length,
            author: msg.sender,
            content: _tweet,
            timestamp: block.timestamp,
            likes:0
        });

        tweets[msg.sender].push(newTweet);

        emit tweetCreated(newTweet.id, newTweet.author, newTweet.content, newTweet.timestamp);
    }

    function likeTweet(address author, uint256 id) external {
        require(tweets[author][id].id == id, "Tweet does not exist!!");

        tweets[author][id].likes++;

        emit tweetLiked(msg.sender, author, id, tweets[author][id].likes);
    }

    function unlikeTweet(address author, uint256 id) external {
        require(tweets[author][id].id == id, "Tweet does not exist!!");
        require(tweets[author][id].likes > 0, "There are no likes:(");

        tweets[author][id].likes--;

        emit tweetUnliked(msg.sender, author, id, tweets[author][id].likes);
    }

    function getTweet(address _owner, uint _i) public view returns (Tweet memory) {
        return tweets[_owner][_i];
    }

    function  getAllTweets(address _owner) public view returns (Tweet[] memory){
        return tweets[_owner];

    }
}
