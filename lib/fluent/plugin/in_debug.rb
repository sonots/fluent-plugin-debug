require 'fluent/input'

module Fluent
  class DebugInput < Input
    Plugin.register_input('debug', self)

    def configure(conf)
      ::Fluent::Output.__send__(:include, Debuggable)
    end
  end

  module Debuggable
    def self.included(klass)
      klass.config_param :debug, :bool, :default => false
      unless klass.method_defined?(:configure_withtout_debug)
        klass.__send__(:alias_method, :configure_without_debug, :configure)
        klass.__send__(:alias_method, :configure, :configure_with_debug)
      end
    end

    def configure_with_debug(conf)
      configure_without_debug(conf)
      if conf['debug']
        self.instance_eval <<'EOF'
          def emit(tag, es, chain)
            es.each do |time, record|
              $log.write "#{Time.at(time).localtime} #{tag}: #{Yajl.dump(record)}\n"
            end
            super
          end
EOF
      end
    end
  end
end
