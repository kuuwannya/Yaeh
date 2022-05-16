var pin = null;
var lat = gon.latitude;
var lng = gon.longitude;

function initMap() {
  var map = new google.maps.Map(document.getElementById('map'), {
    center: { lat: lat, lng: lng },
    scrollwheel: false,
    streetViewControl: false,
    fullscreenControl: false,
    mapTypeControl: false,
    gestureHandling: 'greedy',
    zoom: 13,
    styles: [
      {
        featureType: 'all',
        elementType: 'all',
      },
      {
        featureType: 'poi',
        elementType: 'all',
        stylers: [
          { visibility: 'off' },
        ],
      }
    ]
  });

  document.getElementById('lat').value = lat;
  document.getElementById('lng').value = lng;

  // 初期ピン
  pin = new google.maps.Marker({
    map: map,
    position: new google.maps.LatLng(lat, lng),
    animation: google.maps.Animation.BOUNCE
  });

  // ピンの移動
  map.addListener('click', function (e) {
    clickMap(e.latLng, map);
  });

  // 現在地へ移動ボタン
  const currentLocation = document.createElement('button');
  currentLocation.textContent = '現在地へ移動する';
  currentLocation.classList.add('block', 'mt-3', 'mr-5', 'text-white', 'text-white', 'bg-main-blue', 'rounded-full', 'hover:bg-dark-blue', 'font-semibold', 'text-sm', 'px-5', 'py-2.5', 'text-center', 'drop-shadow-lg')
  map.controls[google.maps.ControlPosition.TOP_RIGHT].push(currentLocation);

  currentLocation.addEventListener('click', () => {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          var pos = {
            lat: position.coords.latitude,
            lng: position.coords.longitude,
          };
          map.setCenter(pos);
          // pinを更新
          updatePin(pos, map);
          // フォームに値を入れる
          document.getElementById('lat').value = pos.lat;
          document.getElementById('lng').value = pos.lng;
        },
        (error) => {
          var errorInfo = [
            '原因不明のエラーが発生しました',
            '位置情報の取得が許可されませんでした。設定を確認してください。',
            '電波状況などで位置情報が取得できませんでした',
            '位置情報の取得に時間がかかり過ぎてタイムアウトしました'
          ];
          var errorNum = error.code;

          var errorMessage = errorInfo[errorNum]

          alert(errorMessage);
        }
      );
    } else {
      window.alert('お使いの端末では対応しておりません...。');
    }
  });

  // 検索ボックス
  const input = document.getElementById("pac-input");
  const searchBox = new google.maps.places.SearchBox(input);
  // 左側に設置
  map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);
  map.addListener("bounds_changed", () => {
    searchBox.setBounds(map.getBounds());
  });

  searchBox.addListener("places_changed", () => {
    const places = searchBox.getPlaces();

    if (places.length == 0) {
      return;
    }

    const bounds = new google.maps.LatLngBounds();

    places.forEach((place) => {
      if (!place.geometry || !place.geometry.location) {
        console.log("検索結果がありませんでした。");
        return;
      }

      if (place.geometry.viewport) {
        // Only geocodes have viewport.
        bounds.union(place.geometry.viewport);
      } else {
        bounds.extend(place.geometry.location);
      }
    });
    map.fitBounds(bounds);
  });
}
window.initMap = initMap;

clickMap = (lat_lng, map) => {
  lat = lat_lng.lat();
  lng = lat_lng.lng();

  lat = Math.floor(lat * 10000000) / 10000000;
  lng = Math.floor(lng * 10000000) / 10000000;

  //座標をhidden formに入力する
  document.getElementById('lat').value = lat;
  document.getElementById('lng').value = lng;

  //中心に移動
  map.panTo(lat_lng);

  // マーカーの更新
  updatePin(lat_lng, map);
}

updatePin = (pos, map) => {
  pin.setMap(null);
  pin = null;
  pin = new google.maps.Marker({
    position: pos,
    map: map
  });
}

var begin, end;
var directionsDisplay;
var directionsService;

$(function () {
  $('#getRoute').click(function (e) {
    e.preventDefault();         // hrefが無効になり、画面遷移が行わない

    begin = $('#data-start-point-name').val();
    end = $('#data-destination-name').val();
    google.maps.event.addDomListener(window, 'load', initialize(begin, end));
    google.maps.event.addDomListener(window, 'load', calcRoute(begin, end));
  });
});

function initialize(begin, end) {
  // インスタンス[geocoder]作成
  var geocoder = new google.maps.Geocoder();

  geocoder.geocode({
    // 起点のキーワード
    'address': begin

  }, function (result, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      // 中心点を指定
      var latlng = result[0].geometry.location;

      // オプション
      var myOptions = {
        zoom: 14,
        center: latlng,
        scrollwheel: false,     // ホイールでの拡大・縮小
        mapTypeId: google.maps.MapTypeId.ROADMAP
      };

      let rendererOptions = {
        map,
        draggable: true,
        suppressMarkers: false
      };

      // #map_canvasを取得し、[mapOptions]の内容の、地図のインスタンス([map])を作成する
      map = new google.maps.Map(document.getElementById('map'), myOptions);

      // 経路を取得
      directionsDisplay = new google.maps.DirectionsRenderer(rendererOptions);
      directionsDisplay.setMap(map);

      // 場所
      $('#data-start-point-name').text(begin);
      $('#data-destination-name').text(end);

    } else {
      alert('取得できませんでした…');
    }
  });
}

// ルート取得
function calcRoute(begin, end) {

  var request = {
    origin: begin,         // 開始地点
    destination: end,      // 終了地点
    travelMode: google.maps.TravelMode.DRIVING,     // [自動車]でのルート
    unitSystem: google.maps.DirectionsUnitSystem.METRIC,
    optimizeWaypoints: true,
    avoidHighways: true,
    avoidTolls: false
  };

  // インスタンス作成
  directionsService = new google.maps.DirectionsService();

  directionsService.route(request, function (response, status) {
    if (status == google.maps.DirectionsStatus.OK) {
      directionsDisplay.setDirections(response);
      directionsRenderer.setMap(map);
    } else {
      alert('ルートが見つかりませんでした…');
    }
  });

}
