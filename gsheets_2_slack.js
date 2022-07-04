 function buildReport() {
  const ss = SpreadsheetApp.getActive();
  var numRows = ss.getLastRow();
  let pessoa = ss.getSheetByName('Respostas').getRange(numRows, 2).getValues();
  let pontos = ss.getSheetByName('Respostas').getRange(numRows, 3).getValues();
  let payload = buildAlert(pessoa, pontos);
  sendAlert(payload);
}

function buildAlert(pessoa, pontos) {
  let score = pontos[0][0];
  let name = pessoa[0][0];

  let payload = {
    "blocks": [
      {
        "type": "section",
        "text": {
          "type": "mrkdwn",
          "text": ":bell: <LINK|*Novo teste recebido*> :bell:"
        }
      },
      {
        "type": "divider"
      },
      {
        "type": "section",
        "text": {
          "type": "mrkdwn",
          "text": "*Isaacker*: " + name
        }
      },
      {
        "type": "section",
        "text": {
          "type": "mrkdwn",
          "text": "*Score*: " + score
        }
      }
    ]
  };
  return payload;
}

function sendAlert(payload) {
  const webhook = ""; //Adicionar Webhook aqui
  var options = {
    "method": "post",
    "contentType": "application/json",
    "muteHttpExceptions": true,
    "payload": JSON.stringify(payload)
  };
 
  try {
    UrlFetchApp.fetch(webhook, options);
  } catch(e) {
    Logger.log(e);
  }
}
