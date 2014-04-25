# encoding: UTF-8
require_relative 'spec_helper'
require 'fluent/plugin/out_stdout'

# Capture the log output of the block given
def capture_log(&block)
  tmp = $log
  $log = StringIO.new
  yield
  return $log
ensure
  $log = tmp
end

describe Fluent::DebugInput do
  before { Fluent::Test.setup }

  def create_driver(conf=%[])
    Fluent::Test::InputTestDriver.new(Fluent::DebugInput).configure(conf)
  end

  describe 'test configure' do
    it { expect { create_driver }.not_to raise_error }
  end
end

describe "extends Fluent::StdoutOutput" do
  before { Fluent::Test.setup }

  def create_driver(conf=CONFIG, tag = 'test')
    Fluent::Test::OutputTestDriver.new(Fluent::StdoutOutput, tag).configure(conf)
  end
  let(:driver) { create_driver(config) }

  describe 'test configure' do
    let(:config) { %[debug true] }
    let(:subject) { driver.instance }
    its(:debug) { should == true }
  end

  describe 'test emit' do
    let(:config) { %[debug true] }

    before {
      time = Fluent::Engine.now
      Fluent::Engine.stub(:now).and_return(time)
    }

    it 'should flush' do
      d = driver.instance
      out = capture_log do
        chain = Fluent::NullOutputChain.instance
        d.emit('tag', Fluent::OneEventStream.new(0, {'a'=>1}), chain)
      end
      debug_stdout = out.gets
      out_stdout   = out.gets
      debug_stdout.should == out_stdout
    end
  end
end

