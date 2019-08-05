"use strict";

const axios = require("axios");

async function doSomethingAsync(config, cb) {
    let headers = {};
    config.headers.forEach(elem => {
        headers[elem[0]] = elem[1];
    });
    config.headers = headers;
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