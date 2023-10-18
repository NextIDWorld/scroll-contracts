// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// RIght now there is NO VRF in Scroll ZKEVM so we will just mock that it is always pair
// import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
// import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract NextWorld {
    uint256 public s_randomResult = 2; // Mocked random result

    mapping(uint256 => string) public requestUri;
    mapping(uint256 => uint8[2]) public requestPosition;
    mapping(uint8 => mapping(uint8 => bool)) public posOccupied;
    mapping(uint8 => mapping(uint8 => string)) public uri;

    event Result(string uri, uint256 number, bool result, uint8 x, uint8 z);

    function requestRandomWords(
        string memory _uri,
        uint8[2] memory coords
    ) external {
        uint256 requestId = block.timestamp;

        if (!posOccupied[coords[0]][coords[1]]) {
            uri[coords[0]][coords[1]] = _uri;
            posOccupied[coords[0]][coords[1]] = true;
            emit Result(_uri, 0, true, coords[0], coords[1]);
        } else {
            requestUri[requestId] = _uri;
            requestPosition[requestId] = coords;
            fulfillRandomWords(requestId, s_randomResult);
        }
    }

    function fulfillRandomWords(
        uint256 requestId,
        uint256 randomResult
    ) internal {


        string memory _uri = requestUri[requestId];
        uint8[2] memory coords = requestPosition[requestId];
        bool result = false;

        if (randomResult % 2 == 0) {
            result = true;
            uri[coords[0]][coords[1]] = _uri;
        }

        emit Result(_uri, randomResult, result, coords[0], coords[1]);
    }
}
