# encoding: utf-8
require "logstash/codecs/json"
require "logstash/json"
require "logstash/event"

# This codec may be used to decode (via inputs) and encode (via outputs) full JSON messages.
# This codec is intended for use with inputs, like redis or kafka, that produce a single string 'record',
# this can be a JSON array of objects or a JSON object that can span multiple lines.
#
# It is *not* intended for use with inputs, like tcp or file, that produce multiple records (events)
# separated with a newline. These inputs pass fixed size chunks of text to the codec,
# if your object is larger than the fixed size, you will get a parse failure.
#
# This codec is intended for use with outputs to produce a pretty printed JSON string.
#
# If the data being sent is a JSON array at its root multiple events will be created (one per element).
#
# If you are streaming JSON messages delimited
#   by '\n' then see the `json_lines` codec.
#
#If this codec receives a payload from an input that is not valid JSON, then
#   it will fall back to plain text and add a tag `_jsonparsefailure`. Upon a JSON
#   failure, the payload will be stored in the `message` field.

module LogStash module Codecs class JsonPretty < LogStash::Codecs::JSON
  config_name "json_pretty"

  # inherit all the decoding from the JSON codec.
  # the desired effect here is to defeat the fix_streaming_codecs hack in inputs/base.rb
  # so that this codec can decode multiline pretty print encoded JSON text representations.

  def encode(event)
    @on_event.call(event, LogStash::Json.dump(event, :pretty => true))
  end
end end end
