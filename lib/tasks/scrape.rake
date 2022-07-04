# URLにアクセスするためのライブラリの読み込み
require 'open-uri'

namespace :scrape do

  desc 'goo自動車＆バイクのページからバイク名を取得'
  task :bike_name => :environment do
    # スクレイピング先のURL
    url = 'https://autos.goo.ne.jp/bikeused/1/750cc.html'
    bikes = []

    charset = nil
    html = URI.open(url) do |f|
      charset = f.charset # 文字種別を取得
      f.read # htmlを読み込んで変数htmlに渡す
    end

    # htmlをパース(解析)してオブジェクトを作成
    doc = Nokogiri::HTML.parse(html, nil, charset)

    doc.xpath('//span[@class="text"]').each do |node|
      # タイトルの取得
      puts node.inner_text.tr("０-９ａ-ｚＡ-Ｚ （）－−", "0-9a-zA-Z  ()-")
      bike_name = node.inner_text.tr("０-９ａ-ｚＡ-Ｚ （）－−", "0-9a-zA-Z  ()-")
      bikes = Bike.new(name: bike_name)
      bikes.save
    end
  end

end
