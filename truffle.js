module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 7545,
      network_id: "*" // Match any network id
    },
    rinkeby: {
      host: "localhost", // Connect to geth on the specified
      port: 8545,
      from: "0x6e48E8Fa0a97893D89D66E1707fEe62f2d9F8D48", // default address to use for any transaction Truffle makes during migrations
      network_id: 4,
      gas: 4612388 // Gas limit used for deploys
    }
  }
};

//geth --rinkeby --rpc --rpcapi db,eth,net,web3,personal --unlock="0xAaaf382ae85C3c464db734182A7Fb4b85b17739f"
