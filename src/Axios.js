"use strict";

const axios = require("axios");
const uuidv4 = require('uuid/v4');

async function doSomethingAsync(config, cb) {
    let headers = {
        "purs-axios-token": uuidv4()
    };
    config.headers.forEach(elem => {
        headers[elem[0]] = elem[1];
    });
    config.headers = headers;
    if(config.method == "GET" || config.method == "DELETE"){
        config.params = config.data;
        delete config.data;
    }
    await axios(config).then(res => {
        cb(false, res.data);
    }).catch(err => {
        cb(true, err);
    });
}

exports._axios = function (config) {
    return function (onError, onSuccess) {
        let cancel = doSomethingAsync(config, function (err, res) {
            if (err) {
                onError(res);
            } else {
                onSuccess(res);
            }
        });
        return function (cancelError, onCancelerError, onCancelerSuccess) {
            cancel();
            onCancelerSuccess();
        }
    }
}