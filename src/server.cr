require "kemal"
require "uuid"
require "./rantai"

# Crete a UUID for this node
node_identifier = UUID.random.to_s

# Create the black chain
blockchain = Rantai::Blockchain.new

get "/chain" do
  { chain: blockchain.chain }.to_json
end

get "/mine" do
  blockchain.mine
  "Block with index=#{blockchain.chain.last.index} is mined."
end

get "/pending" do
  { transactions: blockchain.uncommitted_transactions }.to_json
end

post "/transactions/new" do |env|

  transaction = Rantai::Block::Transaction.new(
    from: env.params.json["from"].as(String),
    to:  env.params.json["to"].as(String),
    amount:  env.params.json["amount"].as(Int64)
  )

  blockchain.add_transaction(transaction)

  "Transaction #{transaction} has been added to the node"
end

Kemal.run