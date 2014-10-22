require 'fileutils'
require 'tmpdir'

module Vagrant
  module Util
    class Tempfile < ::Tempfile

      def initialize(basename)
        super(basename, private_tmpdir)
      end

      def private_tmpdir
        self.class.private_tmpdir
      end

      def self.private_tmpdir
        @private_tmpdir ||=
          begin
            user = Etc.getpwuid.name
            pid = Process.pid
            tmpdir = File.join(Dir.tmpdir, "vagrant-#{user}-#{pid}")
            FileUtils.mkdir_p(tmpdir)
            FileUtils.chmod(0700, tmpdir)
            tmpdir
          end
      end

      def self.mktmpdir(prefix_suffix)
        Dir.mktmpdir(prefix_suffix, private_tmpdir)
      end


    end
  end
end

at_exit do
  FileUtils.rm_rf(Vagrant::Util::Tempfile.private_tmpdir)
end
