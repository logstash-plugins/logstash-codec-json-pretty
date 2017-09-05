## 1.0.0
  - Initial release
  - This codec is intended for use with inputs, like redis or kafka, that produce a single string 'record' - this can be a JSON array of objects or a JSON object that can span multiple lines.
  - It is not intended for use with inputs, like tcp or file, that produce multiple records (events) separated with a newline. These inputs pass fixed size chunks of text to the codec - if your object is larger than the fixed size, you will get a parse failure. 
  - This codec is intended for use with outputs to produce a pretty printed JSON string.