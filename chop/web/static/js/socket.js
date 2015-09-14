let Phoenix = require("./phoenix");

let socket = module.exports = new Phoenix.Socket("/socket");

socket.connect();
