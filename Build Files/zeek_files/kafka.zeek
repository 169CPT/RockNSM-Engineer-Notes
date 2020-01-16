#location: /usr/share/zeek/site/scripts/kafka.zeek
#
redef Kafka::topic_name = "zeek-raw";
redef Kafka::json_timestamps = JSON::TS_ISO8601;
redef Kafka::tag_json = F;
redef Kafka::kafka_conf = table(
   ["metadata.broker.list"] = "172.16.50.100:9092");
          # [“metadata.broker.list”] = “<172.16.50.100>:9092, 172.116.2.100:9092”);
event bro_init() &priority=-5
{
  for (stream_id in Log::active_streams)
  {
    if (|Kafka::logs_to_send| == 0 || stream_id in Kafka::logs_to_send)
    {
        local filter: Log::Filter = [
          $name = fmt("kafka-%s", stream_id),
          $writer = Log::WRITER_KAFKAWRITER,
          $config = table(["stream_id"] = fmt("%s", stream_id))
        ];

        Log::add_filter(stream_id, filter);
    }
  }
}
