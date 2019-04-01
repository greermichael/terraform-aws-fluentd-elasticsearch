rbac:
  create: true
elasticsearch:
  logstash_prefix: ${logstash_prefix}
image:
  repository: ${image_url}
  tag: ${image_tag}
  pullPolicy: Always
configMaps:
  output.conf: |-
    <match **>
      @id elasticsearch
      @type "aws-elasticsearch-service"
      @log_level info
      include_tag_key true
      type_name _doc
      logstash_format true
      logstash_prefix "#{ENV['LOGSTASH_PREFIX']}"
      flush_interval 1s

      <endpoint>
        url ${elasticsearch_endpoint}
        region ${region}
      </endpoint>
    </match>