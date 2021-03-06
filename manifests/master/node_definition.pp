# munin::master::node_definition - A node definition for the munin
# master.
#
# - title: The title of the defined resource should be a munin FQN,
# ('hostname', 'group;hostname', 'group;subgroup;hostname')
#
# Parameters
#
# - address: The address of the munin node. A hostname, an IP address,
#   or a ssh:// uri for munin-async node. Required.
#
# - config: An array of configuration lines to be added to the node
#   definition. Default is an empty array.
#
define munin::master::node_definition (
  $address,
  $config=[],
)
{
  validate_string($address)
  validate_array($config)

  $filename=sprintf('/etc/munin/munin-conf.d/node.%s.conf',
                    regsubst($name, '[^[:alnum:]\.]', '_', 'IG'))

  file { $filename:
    content => template('munin/master/node.definition.conf.erb')
  }
}
