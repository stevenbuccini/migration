OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '364241897031917', '551264d684e2301056b34ee911a625d3'
end