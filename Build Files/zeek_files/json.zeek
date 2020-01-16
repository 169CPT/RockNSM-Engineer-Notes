#location: /usr/share/zeek/site/scripts/json.zeek  
#
redef LogAscii::use_json = T;
redef LogAscii::json_timestamps = JSON::TS_ISO8601;
