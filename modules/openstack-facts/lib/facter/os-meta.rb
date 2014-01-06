require 'net/http'
require 'json'
require 'facter'

# Recursively descend the JSON metadata tree
def parsetree(root, tree)
    tree.each_pair do |key, val|
        if val.respond_to?(:each_pair) then
            parsetree(root + '_' + key, val)
        else
            Facter.add(root + '_' + key) do
                setcode do
                    val
                end
            end
        end
    end
end

# Get the JSON metadata
response = Net::HTTP.get('169.254.169.254','/openstack/latest/meta_data.json')
parsed_response = JSON.parse(response)

# Convert to facts with the prefix 'openstack'
parsetree('openstack',parsed_response)
