# write tester for Erlang sockets
require 'socket'
require 'json'

puts " -- example data"
data  = {
  type: 'users',
  ids: (1..10).to_a,
  event: 'add blip',
  message: 'whoa! tcp worked!',
}.to_json

puts " -- data in json:"
puts "#{data}"

Socket.tcp('localhost', 8001) do |sock|
  sock.print data
  sock.close_write
  puts " -- readed from tcp socket: #{sock.read}"
end
