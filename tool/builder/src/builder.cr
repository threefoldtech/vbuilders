

# require "json"
puts "START"

require "crystaltools"

cl = CrystalTools::CDockers.new()
cl.deleteall()
c = cl.create "test"


pp c


# volumes = {
#   "/volumes/data": { }
# },


# data = {image: "builders_production" ,hostname: "test"}
# data = {hostname: "test",
#   exposedPorts: {
#     "22/tcp": nil
#   },
# }
# c = create_container("test",**data)

# data = NamedTuple(x: Int32, y: String)

# c = client.containers.create "builders_production" , **data
# pp c

# Docker::Api::Containers


# c=client.containers.create(image="builders_production")
# c.name = "production"


# pp c.status
# pp c.name
# pp c.attrs
# pp c.attrs.config.hostname


# c.update