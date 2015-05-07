(function() {

  var peerId = $('.player span').text();
  console.log('PEER ID: ' + peerId);
  var peer = new Peer(peerId, {
    key: '45x3b24gg5qdj9k9',
    debug: 3,
    logFunction: function() {
      var copy = Array.prototype.slice.call(arguments).join(' ');

      $('.log').append(copy + '<br>');
    },
    iceservers: ['stun.l.google.com:19302']
  });

  var connectedPeers = {};
  var $messageContent = $('.messages-content');
  //show peers ID
  peer.on('open', function(id) {
    $('.user-id span').text(id);
  });

  peer.on('connection', connect);

  function connect(con) {
    $('.connected-peer span').text(con.peer);

    $('.send').click(function() {
      var message = $('.chat-message').val();
      con.send(message);
    });


    con.on('data', function(data) {
      console.log('Recieving data: ' + data);
      $messageContent.append('<div>' + data + '</div>');
    });

    con.on('close', function(data) {
      $messageContent.append('div' + con.peer +' has left the building</div>');
      delete connectedPeers[con.peer];
    });

  }

  $(document).ready(function() {
    $('.connect').click(function(e) {
      var requestedPeer = $('.req-peer').text();
      if(!connectedPeers[requestedPeer]) {
        var con = peer.connect(requestedPeer, {
          serialization: 'none',
          reliable: false,
          metadata: { message: 'Hi i wanna connect! '}
        });

        if(!con) {
          return peer.reconnect();
        }

        con.on('open', function() {
          connect(con);
        });

        con.on('error', function(err) {
          alert(err);
        });
      }
      connectedPeers[requestedPeer] = 1;


    });
  });


})();
