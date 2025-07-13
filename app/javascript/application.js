// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"   // Turboを読み込む
import Rails from "@rails/ujs"   // Rails UJSを読み込み
Rails.start()                    // 明示的に起動
