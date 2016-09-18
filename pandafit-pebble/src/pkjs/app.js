var xhrRequest = function (url, type, callback) {
  var xhr = new XMLHttpRequest();
  xhr.onload = function () {
    callback(this.responseText);
  };
  xhr.open(type, url);
  xhr.send();
};

function scoreToImageId(score){
  var id = null;
  if (80 < score){ // case ecstatic
    id = 0;
  } else if (60 < score && score < 80){ // case happy
    id = 1;
  }else if (40 < score && score < 60){ // case content
    id = 2;
  }else if (20 < score && score < 40){ // case angry
    id = 3;
  }else if (score < 20){ // case dying
    id = 4;
  }
  return id;
}

 
function getUserScore(pos) {
  console.log("Requesting score..")
  // Construct URL
  var url = "http://ec2-52-39-53-104.us-west-2.compute.amazonaws.com/score/Philipp"; // TODO
 
  // Send request to Backend
  xhrRequest(url, 'GET', 
    function(responseText) {
      console.log("Got JSON from server: " + responseText);
      // responseText contains a JSON object with weather info
      var json = JSON.parse(responseText);
      var score = json.score;
      // calc image ID from score

      var imageId = scoreToImageId(score);
      
      // Assemble dictionary using our keys
      var dictionary = {
        "KEY_IMAGE": imageId,
        "KEY_SCORE": " " + score
      };
      
      console.log("Sending score: " + JSON.stringify(dictionary));

 
      // Send to Pebble
      Pebble.sendAppMessage(dictionary,
        function(e) {
          console.log("image and score info sent to Pebble successfully!");
        },
        function(e) {
          console.log("Error sending score and image info to Pebble!");
        }
      );
      
    }      
  );
}

 
// Listen for when the watchface is opened
Pebble.addEventListener('ready', 
  function(e) {
    console.log("PebbleKit JS ready!");
 
    // Get the initial weather
    //selectRandomImage();
    getUserScore();
  }
);
 
// Listen for when an AppMessage is received
Pebble.addEventListener('appmessage',
  function(e) {
    console.log("AppMessage received!");
    getUserScore();
  }                     
);
