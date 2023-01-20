nats = require 'nats'

client = nats.connect({host = 'nats',port = 4222})

-- connect to the server
client:connect()

-- publish to a subject
local subscribe_id = client:publish('foo', 'message to be published')