require 'formula'

class Bdb5129 < Formula
  homepage 'http://www.oracle.com/technology/products/berkeley-db/index.html'
  url 'http://download.oracle.com/berkeley-db/db-5.1.29.tar.gz'
  md5 'a94ea755ab695bc04f82b94d2e24a1ef'

  bottle do
    cellar :any
    sha1 "82b52acb094e7f5cfb8f807f4501b47653744285" => :mavericks
    sha1 "32db77b55f8f864af939d842a85bed64347912e8" => :mountain_lion
    sha1 "6846c61e17ff5dcfe25f5aaf2e7e88b71758ea09" => :lion
  end


  # Fix build under Xcode 4.6
  # Double-underscore names are reserved, and __atomic_compare_exchange is now
  # a built-in, so rename this to something non-conflicting.
  patch :DATA

  def install
    # BerkeleyDB dislikes parallel builds
    ENV.deparallelize
    # --enable-compat185 is necessary because our build shadows
    # the system berkeley db 1.x
    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --mandir=#{man}
      --enable-cxx
      --enable-compat185
    ]

    # BerkeleyDB requires you to build everything from the build_unix subdirectory
    cd 'build_unix' do
      system "../dist/configure", *args
      system "make install"

      # use the standard docs location
      doc.parent.mkpath
      mv prefix/'docs', doc
    end
  end
end

__END__
