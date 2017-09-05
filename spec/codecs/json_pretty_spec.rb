require "logstash/devutils/rspec/spec_helper"
require "logstash/codecs/json_pretty"
require "logstash/event"
require "logstash/json"

describe LogStash::Codecs::JsonPretty do
  context "#decode" do
    it "should return an event from json data" do
      data = {"foo" => "bar", "baz" => {"bah" => ["a","b","c"]}}
      chunk = LogStash::Json.dump(data, :pretty => true)
      expect(chunk).to include("\n")
      subject.decode(chunk) do |event|
        expect(event).to be_a(LogStash::Event)
        expect(event.get("foo")).to eq(data["foo"])
        expect(event.get("baz")).to eq(data["baz"])
        expect(event.get("bah")).to eq(data["bah"])
      end
    end
  end

  context "#encode" do
    it "should return json data" do
      data = {"foo" => "bar", "baz" => {"bah" => ["a","b","c"]}, "@timestamp" => Time.at(0)}
      event = LogStash::Event.new(data)
      compared = []
      compared.push <<-JSON
{
  "@timestamp" : "1970-01-01T00:00:00.000Z",
  "foo" : "bar",
  "@version" : "1",
  "baz" : {
    "bah" : [ "a", "b", "c" ]
  }
}
JSON
      subject.on_event {|e, d| compared.push(d.concat("\n")) }
      subject.encode(event)
      expect(compared.first).to eq(compared.last)
    end
  end
end
