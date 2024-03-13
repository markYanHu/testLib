Pod::Spec.new do |spec|
  spec.name = "testLib"
  spec.version = "0.0.1"
  spec.summary = "loding and message framework for Apple platforms"
  spec.homepage = "https://github.com/markYanHu/testLib"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "markYanHu" => '994370053@qq.com' }
  spec.platform = :ios, "11.0"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/markYanHu/testLib.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = "testLib/testLib/*.{h,m,swift}"

end
