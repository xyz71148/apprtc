/*
 *  Copyright (c) 2014 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree.
 */

/* More information about these options at jshint.com/docs/options */
// Variables defined in and used from main.js.
/* globals randomString, AppController, sendAsyncUrlRequest, parseJSON */
/* exported params */
'use strict';
function parse_url_query(url) {
    const query = {}
    if (url.indexOf("?")> -1) {
        const t = url.split("?")[1]
        const lines = t.split("&")
        for (let i in lines) {
            const line = lines[i];
            if (line.indexOf("=")) {
                query[line.split("=")[0]] = decodeURIComponent(line.split("=")[1])
            }
        }
    }
    return query
}
// Generate random room id and connect.
var roomServer = (
    location.href.indexOf("localhost") > 0 ||
    location.href.indexOf("0.0.0.0") > 0 ||
    location.href.indexOf("127.0.0.1") > 0
) ? 'http://127.0.0.1:8080' : "https://jie8.cc";

var loadingParams = {
  errorMessages: [],
  warningMessages: [],
  suggestedRoomId: randomString(9),
  roomServer: roomServer,
  connect: false,
  paramsFunction: function() {
    return new Promise(function(resolve, reject) {
      trace('Initializing; retrieving params from: ' + roomServer + '/params');
        const q = parse_url_query(location.href)

        const qstr = q.room_id ? ("?room_id="+q.room_id) : ""
      sendAsyncUrlRequest('GET', roomServer + '/api/rtc/params'+qstr).then(function(result) {
        var serverParams = parseJSON(result);
        var newParams = {};
        if (!serverParams) {
          resolve(newParams);
          return;
        }
        // Convert from server format to expected format.
        newParams.isLoopback = serverParams.is_loopback === 'true';
        newParams.mediaConstraints = parseJSON(serverParams.media_constraints);
        newParams.offerOptions = parseJSON(serverParams.offer_options);
        newParams.peerConnectionConfig = parseJSON(serverParams.pc_config);
        newParams.peerConnectionConstraints =
            parseJSON(serverParams.pc_constraints);
        newParams.iceServerRequestUrl = serverParams.ice_server_url;
        newParams.iceServerTransports = serverParams.ice_server_transports;
        newParams.wssUrl = serverParams.wss_url;
        newParams.wssPostUrl = serverParams.wss_post_url;
        newParams.versionInfo = parseJSON(serverParams.version_info);
        newParams.messages = serverParams.messages;
        newParams.roomId = serverParams.room_id;
        newParams.room_link = serverParams.room_link;

        trace('Initializing; parameters from server: ');
        trace(JSON.stringify(newParams));
        resolve(newParams);
      }).catch(function(error) {
        trace('Initializing; error getting params from server: ' +
            error.message);
        reject(error);
      });
    });
  }
};

new AppController(loadingParams);
