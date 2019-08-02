"use strict";

const axios = require("axios");

exports["axios"] = function (url) {
    return function (method) {
        return function (body) {
            return function (cb) {
                return function () {
                    axios(url, {
                        method : method,
                        data : body
                    }).then(res => {
                        return cb (res.data) ();
                    }).catch(err => {
                        console.log(err);
                    });
                }
            }
        }
    }
}