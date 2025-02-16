require "spec"
require "../src/cb"

Colorize.enabled = false
TEST_TOKEN = CB::Token.new("localhost", "token", Time.local.to_unix + 1.hour.seconds)

def expect_cb_error(message, file = __FILE__, line = __LINE__)
  expect_raises(CB::Program::Error, message, file: file, line: line) { yield }
end
