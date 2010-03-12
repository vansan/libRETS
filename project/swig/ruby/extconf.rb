=begin
ruby extconf.rb --with-librets-config=../../../librets-config-inplace
=end
require 'mkmf'

puts "Platform: " + RUBY_PLATFORM.to_s

if RUBY_PLATFORM =~ /darwin/
  CONFIG['LDSHARED'].sub!(/^cc/, "c++")
elsif RUBY_PLATFORM =~ /linux/ || RUBY_PLATFORM =~ /freebsd/
  CONFIG['LDSHARED'].sub!(/\$\(CC\)/, "$(CXX)")
end

makefile_prefix = ""
if RUBY_PLATFORM =~ /darwin/ || RUBY_PLATFORM =~ /linux/ || RUBY_PLATFORM =~ /freebsd/
  librets_config = with_config("librets-config",
    "../../../librets-config-inplace")
  $libs += ' ' + `#{librets_config} --libs`.chomp
  if ENV['CFLAGS'].nil?
    $CFLAGS += ' ' + `#{librets_config} --cflags`.chomp
  else
    $CFLAGS += ' ' + ENV['CFLAGS'] + ' ' + `#{librets_config} --cflags`.chomp
  end
  swig_dir=with_config("swig-dir", "../../../swig")
elsif RUBY_PLATFORM =~ /i386-mingw32/ 
  $CFLAGS += ' -I/c/librets/mingw-x64/include -I/c/librets/mingw-x64/include/boost-1_41  -I.. -I../../librets/include -I/c/librets/vs2008-x64/include -I/c/librets/vs2008-x64 '
  $libs += ' ../../librets/src/build-x64/liblibrets-vs2008-1.4.1trunk.lib '
  swig_dir=with_config("swig-dir", "..")
elsif RUBY_PLATFORM =~ /win32/ 
  $CFLAGS += ' $(CFLAGS_STD) $(BOOST_CFLAGS) -I.. -I../../librets/include'
  $libs += ' $(LIBRETS_LIB) winmm.lib wldap32.lib gdi32.lib'
  makefile_prefix = %{
!include <../../build/Makefile.vc>
LIBRETS_LIB = ../../librets/src/$(BUILD_DIR)/$(LIBRETS_LIB_NAME)
}
  swig_dir=with_config("swig-dir", "..")
end

$INSTALLFILES = [['librets.rb', "$(RUBYLIBDIR)", "lib"]]

create_makefile('librets_native')

orig_makefile = IO::read("Makefile")
File.open("Makefile", "w") do |mfile|
  mfile << makefile_prefix
  mfile << orig_makefile

  mfile.print %{
librets_wrap.cxx: #{swig_dir}/librets.i
\tswig -c++ -ruby #{swig_dir}/librets.i

librets_wrap.cpp: #{swig_dir}/librets.i
\tswig -c++ -ruby #{swig_dir}/librets.i
  }

end
