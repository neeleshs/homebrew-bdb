require 'formula'

class OpenldapBdb < Formula
  homepage 'http://www.openldap.org/software/'
  url 'ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-2.4.39.tgz'
  sha256 '8267c87347103fef56b783b24877c0feda1063d3cb85d070e503d076584bf8a7'

  depends_on 'bdb-5.1.29' => :optional
  option 'with-memberof', 'Include memberof overlay'
  option 'with-sssvlv', 'Enable server side sorting and virtual list view'

  def install
    args = %W[--disable-dependency-tracking
              --prefix=#{prefix}
              --sysconfdir=#{etc}
              --localstatedir=#{var}]
    args << "--enable-bdb=no" << "--enable-hdb=no" if build.without? "bdb-5.1.29"
    args << "--enable-memberof" if build.with? "memberof"
    args << "--enable-sssvlv=yes" if build.with? "sssvlv"
    exec({"LDFLAGS" => "-L/usr/local/Cellar/bdb-5.1.29/5.1.29/lib", "CPPFLAGS" => "-I/usr/local/Cellar/bdb-5.1.29/5.1.29/include", "LD_LIBRARY_PATH" => "/usr/local/Cellar/bdb-5.1.29/5.1.29/lib"}, "./configure "+ args.join(" "))
    system "make install"
    (var+'run').mkpath
  end
end
