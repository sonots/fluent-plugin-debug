require 'fluent/input'

module Fluent
  class DebugInput < Input
    Plugin.register_input('debug', self)
    config_param :debug_all, :bool, :default => false

    def configure(conf)
      super
      Debuggable.extend_configure(::Fluent::Output)
    end

    def start
      # Engine.matches are created after input plugins are configured, so matches are empty in #configure
      # cf. https://github.com/fluent/fluentd/blob/56f198ecf5ca95dcddef7bdc21b5a309468670e3/lib/fluent/engine.rb#L123
      # #start is called after that, so we can access to Engine.matches here
      super
      if @debug_all
        Engine.matches.each do |match|
          Debuggable.extend_emit(match.output)
        end
      end
    end
  end

  # WOW! WHAT A FUCKING META PROGRAMMING!
  class Debuggable
    def self.extend_emit(obj)
      klass = obj.singleton_class
      unless klass.method_defined?(:emit_without_debug)
        klass.__send__(:alias_method, :emit_without_debug, :emit)
        klass.__send__(:define_method, :emit_with_debug) do |tag, es, chain|
          es.each do |time, record|
            $log.write "#{Time.at(time).localtime} #{tag}: #{Yajl.dump(record)}\n"
          end
          emit_without_debug(tag, es, chain)
        end 
        klass.__send__(:alias_method, :emit, :emit_with_debug)
      end
    end

    def self.extend_configure(klass)
      unless klass.method_defined?(:configure_without_debug)
        klass.config_param :debug, :bool, :default => false
        klass.__send__(:alias_method, :configure_without_debug, :configure)
        klass.__send__(:define_method, :configure_with_debug) do |conf|
          configure_without_debug(conf)
          Debuggable.extend_emit(self) if conf['debug']
        end
        klass.__send__(:alias_method, :configure, :configure_with_debug)
      end
    end
  end
end
