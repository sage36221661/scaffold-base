// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract YourContract {
    // Event definitions
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    // Variables
    string public name = "NonTransferableNFT";
    string public symbol = "NTNFT";

    uint256 public tokenCounter;

    // Mapping from tokenId to owner
    mapping(uint256 => address) private _owners;

    // Mapping owner address to token count
    mapping(address => uint256) private _balances;

    // Mapping from tokenId to approved address (not used but kept for compatibility)
    mapping(uint256 => address) private _tokenApprovals;

    // Constructor
    constructor() {
        tokenCounter = 0;
    }

    // Mint function, anyone can call
    function mint() public {
        uint256 tokenId = tokenCounter;
        _owners[tokenId] = msg.sender;
        _balances[msg.sender] += 1;
        tokenCounter += 1;

        emit Transfer(address(0), msg.sender, tokenId);
    }

    // Function to query the owner of a token
    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "Token does not exist");
        return owner;
    }

    // Function to query the balance of an address
    function balanceOf(address owner) public view returns (uint256) {
        require(owner != address(0), "Address cannot be zero");
        return _balances[owner];
    }

    // Disable transfer functions
    function transferFrom(address, address, uint256) public pure {
        revert("This NFT is non-transferable");
    }

    function safeTransferFrom(address, address, uint256) public pure {
        revert("This NFT is non-transferable");
    }

    function safeTransferFrom(address, address, uint256, bytes memory) public pure {
        revert("This NFT is non-transferable");
    }

    // Disable approval functions
    function approve(address, uint256) public pure {
        revert("Approval is not allowed");
    }

    function setApprovalForAll(address, bool) public pure {
        revert("Approval is not allowed");
    }

    function getApproved(uint256) public pure returns (address) {
        return address(0);
    }

    function isApprovedForAll(address, address) public pure returns (bool) {
        return false;
    }

    // Burn function
    function burn(uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(msg.sender == owner, "You are not the owner of this NFT");

        // Clear ownership and balance
        _balances[owner] -= 1;
        delete _owners[tokenId];

        emit Transfer(owner, address(0), tokenId);
    }

    // ERC165 interface support
    function supportsInterface(bytes4 interfaceId) public pure returns (bool) {
        return
            interfaceId == 0x80ac58cd || // ERC721 interface ID
            interfaceId == 0x5b5e139f;   // ERC721Metadata interface ID
    }

    // Metadata function
    function tokenURI(uint256) public pure returns (string memory) {
        return "";
    }
}
