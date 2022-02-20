pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract StepNFTFactory is Ownable {
    // Event that is to be emmitted upon creation of NFT
    event NewStepNFT(uint256 tokenId, address accountHolder, uint8 level);

    uint256 idDigits = 16;
    uint256 idModulus = 10**idDigits;

    struct StepNFT {
        string name;
        uint256 tokenId;
        uint8 level;
        uint16 transferCount;
    }

    StepNFT[] public stepNFTs;

    mapping(uint256 => address) public tokenToOwner;
    mapping(address => uint256) ownerTokenCount;

    function _createNFT(string memory _name, uint256 _tokenId) internal {
        stepNFTs.push(StepNFT(_name, _tokenId, 1, 0));
        uint256 id = stepNFTs.length - 1;
        tokenToOwner[id] = msg.sender;
        ownerTokenCount[msg.sender] = ownerTokenCount[msg.sender] + 1;
    }

    function _generateRandomTokenId(string memory _str)
        private
        view
        returns (uint256)
    {
        uint256 rand = uint256(keccak256(abi.encodePacked(_str)));
        return rand % idModulus;
    }

    function createNFT(string memory _name) public {
        uint256 randId = _generateRandomTokenId(_name);
        randId = randId - (randId % 100);
        _createNFT(_name, randId);
    }
}
