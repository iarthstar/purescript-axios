"use strict";

const axios = require("axios");

const arr2json = (arr) => {
    let json = {};
    arr.forEach(elem => json[elem[0]] = elem[1]);
    return json;
}

const doSomethingAsync = (url, options, req, cb) => {
    let config = arr2json(options);

    let headers = options.filter(elem => elem[0] == "headers");
    if (headers.length == 1) {
        config.headers = arr2json(headers[0][1]);
    }

    config.data = req;
    config.url = url;

    if (config.method == "GET" || config.method == "DELETE") {
        config.params = config.data;
        delete config.data;
    }

    axios(config)
        .then(res => cb(false, res))
        .catch(err => cb(true, err));
}

exports._axios = function (url) {
    return function (options) {
        return function (req) {
            return function (onError, onSuccess) {
                let cancel = doSomethingAsync(url, options, req, function (err, res) {
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