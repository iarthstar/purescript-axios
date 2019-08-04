"use strict";

const axios = require("axios");

async function doSomethingAsync(url, method, data, cb) {
    await axios(url, {
        method: method.toLowerCase(),
        data: data
    }).then(res => {
        cb(false, res.data);
    }).catch(err => {
        cb(true, err);
    });
}

exports._axios = function (url) {
    return function (method) {
        return function (body) {
            return function (onError, onSuccess) {
                var cancel = doSomethingAsync(url, method, body, function (err, res) {
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
    }
}