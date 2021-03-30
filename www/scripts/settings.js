const CthwebSettings = {
  "webcorecontract":"0x54A4A4D677c5B85B68e537633C014fA4968aCD4D",
  "ethrpc":"http://localhost:7545",
  "chainId":"0x539",
  "cthwebfunctionsig":"0x086f7940",
  "cthwebuploadfunctionsig":"0x5a654d14",
  "defaultwebhash":"00000000000000000000000000000000000000000000000000000000000000000",
  "webcoremetadata":"/metadata/webcorecontract.json",
  "webcoreJSON":""
}

fetch(CthwebSettings.webcoremetadata)
.then(response => response.text())
.then((data) => {
  CthwebSettings.webcoreJSON = data;
});
