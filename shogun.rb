require 'formula'

class Shogun < Formula
  homepage 'http://www.shogun-toolbox.org'
  url 'http://shogun-toolbox.org/archives/shogun/releases/2.0/sources/shogun-2.0.0.tar.bz2'
  sha1 '4077b520c07669caf77f4c92e0fa6e5955dc929c'

  depends_on 'pkg-config' => :build
  depends_on 'r' => :optional
  depends_on 'lua' => :optional

  def install
    args = ""
    pydir = "#{which_python}/site-packages"  # <-- using this works... but requires PYTHONPATH change
    # pydir = lib/which_python/"site-packages"   # <-- using this puts .so in wrong dir :(
    # pydir.mkpath                               # <-- blindly copied from another formula. smart, eh?
    ENV['PYTHONPATH'] = pydir
    args << "--prefix=#{prefix} --pydir=#{pydir}"
    puts args
    
    cd 'src' do
      system "./configure", args
      system "make"
      system "make install"
    end
  end

  def test
    Pathname.new('test.sg').write <<-EOF.undent
      new_classifier LIBSVM
      save_classifier test.model
      exit
    EOF
    
    system bin/"shogun", "test.sg"
    File.exist?("test.model")
  end
  
  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end
end
