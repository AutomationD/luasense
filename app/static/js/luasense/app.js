var ws = new SockJS('http://' + window.location.hostname + ':15674/stomp');
var client = Stomp.over(ws);
// SockJS does not support heart-beat: disable heart-beats
client.heartbeat.outgoing = 0;
client.heartbeat.incoming = 0;
client.debug = 0;

// client.debug = pipe('#second');
var sendData = function(data){
    client.send('/topic/luasense',
        {"content-type": "text/plain"}, data);
};

var printFirst = function(data) {
    console.log("consumed: "+data);
};

onSubscribe =  function(message) {
    console.log("onSubscribe:");
    // called when the client receives a STOMP message from the server
    console.log(message.body);
    if (message.body) {
        console.log("got message with body " + message.body);
        $('#testws').text(message.body);
    } else {
        console.log("got empty message");
    }
};

var onConnect = function(x) {
    console.log("onConnect:");
    id = client.subscribe("/topic/luasense", onSubscribe);
};


var onError =  function() {
    console.log('error');
};
var $toptitle = $('#toptitle');

client.connect('luasense', 'luasense', onConnect, onError, '/');
// client.send('/amq/queue/my_queue1', {"content-type": "text/plain"}, "test");

// client.send('/topic/test1', {"content-type": "text/plain"}, "test");
