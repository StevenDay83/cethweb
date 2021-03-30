pragma solidity ^0.8.0;

import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/master/contracts/utils/math/SafeMath.sol";

contract WebServerCore {
    using SafeMath for uint256;
    
    mapping (address => bool) internal ContractOwners;
    mapping (bytes32 => bool) internal WebDirectoryExist;
    mapping (bytes32 => WebPage) internal WebDirectory;
    
    uint256 public WebPageCount;
    
    bytes32 constant emptyString = 0x569e75fc77c1a856f6daaf9e69d8a9566ca34aa47f9133711ce065a571af0cfd;
    
    event WebHashCreated(bytes32);
    event ShowWebHashList(bytes32[]);
    
    struct WebPage {
        string pageName;
        address owner;
        string webData;
        uint256 created;
        uint256 lastUpdate;
    }
    
    constructor() {
        ContractOwners[msg.sender] = true;
        
        string memory _webData = string(abi.encodePacked(
            
            '<!DOCTYPE html><html lang="en" dir="ltr"><head>','<meta charset="utf-8"><title>Welcome to the CheapETH Web</title>',
            '</head><body><p>Welcome to the CheapETH Web.</p><p>More to come</p></body></html>'
        
        ));
        
        bytes32 _webhash = 0x0;
        
        WebPage memory _newPage = WebPage("Owners Page", msg.sender, _webData, block.timestamp, block.timestamp);
        WebDirectoryExist[_webhash] = true;
        WebDirectory[_webhash] = _newPage;
        
        WebPageCount = 1;
    }
    
    modifier onlyOwner {
        require(ContractOwners[msg.sender], "Error: Not the administrator.");
        _;
    }
    
    modifier uniqueWebHash (bytes32 _webHash) {
        require(!WebDirectoryExist[_webHash], "Error: WebHash exists.");
        _;
    }
    
    modifier webOwner (bytes32 _webHash) {
        WebPage memory _thisPage = WebDirectory[_webHash];
        address _thisOwner = _thisPage.owner;
        
        require(_thisOwner == msg.sender, "Error: Not the WebPage owner.");
        _;
    }
    
    modifier webPageExists (bytes32 _webHash) {
        require(WebDirectoryExist[_webHash], "Error: WebHash does not exist.");
        
        _;
    }
    
    function uploadNewWebPage (string memory _pageName, string memory _webData) public returns (bytes32) {
        bytes32 _thisWebHash = generateHash(_pageName);
        
        require(!WebDirectoryExist[_thisWebHash], "Error: Webhash exists.");
        require(!isEmptyString(_pageName), "Error: Page name cannot be blank.");
        
        WebPage memory _newPage = WebPage(_pageName, msg.sender, _webData, block.timestamp, block.timestamp);
        WebDirectoryExist[_thisWebHash] = true;
        WebDirectory[_thisWebHash] = _newPage;
        
        WebPageCount++;
        
        emit WebHashCreated(_thisWebHash);
        
        return _thisWebHash;
    }
    
    function updateWebPage (bytes32 _webHash, string memory _webData) public webOwner (_webHash) webPageExists(_webHash) returns (bytes32) {
        WebPage memory _thisPage = WebDirectory[_webHash];
        
        _thisPage.webData = _webData;
        _thisPage.lastUpdate = block.timestamp;
        
        WebDirectory[_webHash] = _thisPage;
        
        return _webHash;
    }
    
    function deleteWebPage (bytes32 _webHash) public webOwner(_webHash) webPageExists(_webHash) returns (bool) {
        delete WebDirectory[_webHash];
        delete WebDirectoryExist[_webHash];
        
        WebPageCount--;
        
        return true;
    }
    
    function retrieveWebPageData (bytes32 _webHash) public view webPageExists(_webHash) returns (string memory) {
        WebPage memory _thisPage = WebDirectory[_webHash];
        
        return _thisPage.webData;
    }
    
    function retrieveWebPageMetaData (bytes32 _webHash) public view webPageExists(_webHash) returns (WebPage memory) {
        WebPage memory _metaDataPage = WebDirectory[_webHash];
        _metaDataPage.webData = "METADATA";
        
        return _metaDataPage;
    }
    
    function generateHash(string memory _stringID) internal view returns (bytes32){
        return keccak256(abi.encode(_stringID, block.timestamp, block.number));
    }
    
    function isEmptyString(string memory _string) internal pure returns (bool) {
        bytes32 _bytesStrings = keccak256(abi.encode(_string));
        
        return (_bytesStrings == emptyString);
    }
}