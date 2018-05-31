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
      from: "0xAaaf382ae85C3c464db734182A7Fb4b85b17739f", // default address to use for any transaction Truffle makes during migrations
      network_id: 4,
      gas: 4612388 // Gas limit used for deploys
    }
  }
};

//geth --rinkeby --rpc --rpcapi db,eth,net,web3,personal --unlock="0xAaaf382ae85C3c464db734182A7Fb4b85b17739f"
