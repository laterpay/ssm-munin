# munin::master - Define a munin master
#
# The munin master will install munin, and collect all exported munin
# node definitions as files into /etc/munin/munin-conf.d/.
#
# Parameters:
#
# - node_definitions: A hash of node definitions used by
#   create_resources to make static node definitions.
#
# - graph_strategy: 'cgi' (default) or 'cron'
#   Controls if munin-graph graphs all services ('cron') or if graphing is done
#   by munin-cgi-graph (which must configured seperatly)
#
# - html_strategy: 'cgi' (default) or 'cron'
#   Controls if munin-html will recreate all html pages every run interval
#   ('cron') or if html pages are generated by munin-cgi-graph (which must
#   configured seperatly)
class munin::master (
  $node_definitions={},
  $graph_strategy = 'cgi',
  $html_strategy = 'cgi',
  $config_root = '/etc/munin',
  ) {

  validate_hash($node_definitions)
  validate_re($graph_strategy, [ '^cgi$', '^cron$' ])
  validate_re($html_strategy, [ '^cgi$', '^cron$' ])
  validate_absolute_path($config_root)

  # The munin package and configuration
  package { 'munin':
    ensure => latest,
  }

  File {
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['munin'],
  }

  file { "${config_root}/munin.conf":
    content => template('munin/munin.conf.erb'),
  }

  file { "${config_root}/munin-conf.d":
    ensure  => directory,
    recurse => true,
    purge   => true,
    force   => true,
  }

  # Collect all exported node definitions
  Munin::Master::Node_definition <<| |>>

  # Create static node definitions
  create_resources(munin::master::node_definition, $node_definitions, {})
}
