require 'formula'

class Shogun < Formula
  homepage 'http://www.shogun-toolbox.org'
  url 'http://shogun-toolbox.org/archives/shogun/releases/2.0/sources/shogun-2.0.0.tar.bz2'
  sha1 '4077b520c07669caf77f4c92e0fa6e5955dc929c'

  depends_on 'pkg-config' => :build
  depends_on 'r' => :optional
  depends_on 'lua' => :optional

  def install
    cd 'src' do
      system "./configure", "--prefix=#{prefix}"
      system "make"
      system "make install"
    end
  end

  test do
    Pathname.new('test.sg').write <<-EOF.undent
      new_classifier LIBSVM
      save_classifier test.model
      exit
    EOF
    
    system bin/"shogun", "test.sg"
    File.exist?("test.model")
  end
end
