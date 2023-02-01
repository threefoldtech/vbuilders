import freeflowuniverse.crystallib.twinclient
import threefoldtech.vgrid.gridproxy.model as gmodel
import threefoldtech.vgrid.gridproxy as gp
import freeflowuniverse.crystallib.redisclient
import freeflowuniverse.crystallib.resp
import encoding.base64
import rand
import time
import json

pub struct RmbTwinClient {
pub mut:
	client  redisclient.Redis
	message Message
}

pub struct Message {
pub mut:
	event      string // Used for web socket events
	version    int    [json: ver] // protocol version, used for update
	id         string [json: uid] // unique identifier set by server
	command    string [json: cmd] // command to request in dot notation
	expiration int    [json: exp] // expiration in seconds, based on epoch
	retry      int    [json: try] // amount of retry if remote is unreachable
	data       string [json: dat] // binary payload to send to remote, base64 encoded
	twin_src   int    [json: src] // twinid source, will be set by server
	twin_dst   []int  [json: dst] // twinid of destination, can be more than one
	retqueue   string [json: ret] // return queue name where to send reply
	schema     string [json: shm] // schema to define payload, later could enforce payload
	epoch      i64    [json: now] // unix timestamp when request were created
	err        string [json: err] // optional error message if any
}

pub fn (mut rmb RmbTwinClient) init(dst []int, exp int, num_retry int) !RmbTwinClient {
	msg := Message{
		id: rand.uuid_v4()
		version: 1
		command: 'zos'
		expiration: exp
		retry: num_retry
		twin_src: 0
		twin_dst: dst
		retqueue: rand.uuid_v4()
		epoch: time.now().unix_time()
	}
	rmb.client = redisclient.get('localhost:6379')!
	rmb.message = msg
	return rmb
}

pub fn (mut rmb RmbTwinClient) send(functionPath string, args string) !Message {
	rmb.message.data = base64.encode_str(args)
	rmb.message.command = 'zos.' + functionPath
	request := json.encode_pretty(rmb.message)
	rmb.client.lpush('msgbus.system.local', request)!
	return rmb.read(rmb.message)
}

pub fn (mut rmb RmbTwinClient) read(msg Message) !Message {
	println('Waiting reply ${msg.retqueue}')
	response_json := rmb.client.blpop(msg.retqueue, rmb.message.expiration)!
	mut response := json.decode(Message, response_json)!
	response.data = base64.decode_str(response.data)
	return response
}

fn main() {
	mut transport := RmbTwinClient{}
	transport.init([11], 30, 3)!
	states := transport.send("statistics.get", "{}")!
	println(states)
}