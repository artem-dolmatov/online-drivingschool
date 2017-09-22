Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.precompile += %w( admin.css admin.js )
Rails.application.config.assets.precompile += %w[*.png *.jpg *.jpeg *.gif *.ico]
Rails.application.config.assets.precompile += %w[*.otf *.eot *.woff *.woff2 *.ttf *.svg]
Rails.application.config.assets.precompile += %w( video-js.swf vjs.eot vjs.svg vjs.ttf vjs.woff )