# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

map "/" do
  run Wtf::Application
end

pinocchio_path = ::File.expand_path('../pinocchio/app', __FILE__)
if ::File.exist? "#{pinocchio_path}.rb"
  require pinocchio_path

  map "/go" do
    secret_file_path = ::File.expand_path('../session_key', __FILE__)
    secret_key = "Ouppvx4UKRIJ7zHCDuFEYh7IOwaJ3dIClmROlIzj5Y5RkSVeN2CIZMOar6FxwYL"
    if ::File.exist? secret_file_path
      secret_key = ::File.read secret_file_path
    end
    use Rack::Session::Cookie, key: "_sse_session",
                               secret: secret_key

    run Pinocchio
  end
end

