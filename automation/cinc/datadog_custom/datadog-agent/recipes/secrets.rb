execute 'retrieve datadog api key' do
command 'aws secretsmanager get-secret-value --secret-id datadog/api_key --query SecretString --output text > /tmp/datadog-secret.json'

sensitive false
end

ruby_block 'load datadog secret' do
block do
require 'json'

secret = JSON.parse(
  ::File.read('/tmp/datadog-secret.json')
)

node.default['datadog']['api_key'] =
  secret['api_key']

end

action
end
