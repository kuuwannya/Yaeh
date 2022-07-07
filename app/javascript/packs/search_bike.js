

$(function () {
  var search_bike_field = '.search-bike-field'
  var search_bike_form = '.search-bike-form'

  // 検索タグ予測変換イベント登録
  jobs.searchTag($(search_bike_field))

  // 追加ボタンを押した時の処理(入力された内容を元にチェックボックスを随時追加)
  var add_search_bike = function () {
    // エラーメッセージが存在する場合、削除
    if ($(".bike-alert").length) {
      $(".bike-alert").remove()
    }
    // 入力内容を取得added_tags
    tag_name = $(search_bike_field).val().trim()
    // 追加済みのタグを詰め込む箱
    added_bikes = []
    // 追加済みのタグを取得して配列に詰め込む
    $(".tag-label").each(function () {
      added_bikes.push($(this).text().trim())
    });

    // 追加済みのタグと追加予定のタグの重複チェック
    is_duplicate = added_bikes.some(value => value === bike_name)

    // 空ではなく、追加済みのタグと重複していない場合、追加
    if (bike_name && !is_duplicate) {
      // パラメータで渡す際に値が被るのを防ぐため現時刻を取得(被っていると統合されて複数渡せないため)
      var id = new Date().getTime();

      // 検索タグを登録できるチェックボックスを追加(入力内容を保持)
      $(search_bike_form).before($(`<label class="bike-label"><input class='bike-input' type='checkbox' checked='checked'  name='user[search_bikes_attributes][${id}][name]' value=${bike_name}>${' ' + bike_name}</label>`))

      // チェックボックス追加後、入力フォームをリセット
      $(search_bike_field).val('')
    }
    // 追加済みのタグと重複している場合、エラーメッセージを表示
    if (is_duplicate) {
      $(search_bike_form).after($(`<p class="bike-alert">※既に存在するタグです。</p>`))
    }
  }
  $('.add-search-bike').on('click', add_search_bike); //追加イベント発火
}
