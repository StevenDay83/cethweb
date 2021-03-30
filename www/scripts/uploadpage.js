var cthweb3;
var WebContractObj;

function initWallet(callback) {
  cthweb3 = new Web3(Web3.givenProvider);
  console.log("load");
  if (cthweb3.givenProvider != undefined){
    if (/*cthweb3.givenProvider.chainId == CthwebSettings.chainId*/ true) {
      cthweb3.givenProvider.enable().then(function (address, e) {
        // TODO: Catch errors
        console.log("Wallet connected to address " + address);
        WebContractObj = new cthweb3.eth.Contract(JSON.parse(CthwebSettings.webcoreJSON), CthwebSettings.webcorecontract);
        callback(undefined);
      }).catch((err) => {
        callback(new Error("Misc Error"));
      });
    } else {
      callback(new Error("Wrong provider"));
    }
  } else {
    callback(new Error("No Provider"));
  }
}

function uploadFileFromPage(event){
  try {
    var input = event.target;

    var reader = new FileReader();
    reader.onload = function() {
      var text = reader.result;
      console.log(text);

      WebContractObj.methods.uploadNewWebPage("I need a name", text).send({from:cthweb3.givenProvider.selectedAddress})
      .then(function (receipt) {
        var webHash = receipt.events.WebHashCreated.returnValues[0];
        // console.log(receipt.events.WebHashCreated.returnValues[0]);
        statusField.innerText = "Webhash created at " + webHash;
      });
    }

    reader.readAsText(input.files[0]);
  } catch (e) {
    // TODO: Throw error
    console.error(e);
  }
}
