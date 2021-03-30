var cthweb3;

function initCWeb(callback) {
  cthweb3 = new Web3(CthwebSettings.ethrpc);

  var providerError;
  if (cthweb3 == undefined){
    providerError = new Error("Invalid Provider");
  }

  callback(providerError);
}

function writeTest(){
  window.document.write("<h1>This is a test</h1>");
}

function getURLWebHash() {
  var urlSearchParams = new URLSearchParams(window.location.search);

  return urlSearchParams.get('wh');
}

function parseWebHash(hashAddress) {
  var parsedHash = CthwebSettings.defaultwebhash;
  if (hashAddress.length > 2) {
    parsedHash = hashAddress.substr(2,hashAddress.length);
  }

  return parsedHash;
}

function loadCthHashPage() {
  var thisWebHash = getURLWebHash();

  if (thisWebHash == undefined){
    thisWebHash = "0x0000000000000000000000000000000000000000000000000000000000000000";
  }

  cthweb3.eth.call({
    "to":CthwebSettings.webcorecontract,
    "data":CthwebSettings.cthwebfunctionsig + parseWebHash(thisWebHash)
  }).then(processCwebData);
}

function processCwebData(cwebDataHexString){
  var cwebDataString = cthweb3.utils.hexToAscii(cwebDataHexString);
  cwebDataString = cwebDataString.substr(64, cwebDataString.length);
  // console.log(cwebDataString);
  // console.log(cwebDataHexString);
  window.document.write(cwebDataString);
}
