var pin = null;
var lat = gon.latitude;
var lng = gon.longitude;
var spotMarker = [];
var infoWindow = [];
let shopsData = {};
let markerData = [];
// マーカーを消すためのcurrentInfoWindow
let currentInfoWindow;



function initMap() {
  var map = new google.maps.Map(document.getElementById('map'), {
    center: { lat: lat, lng: lng },
    scrollwheel: false,
    streetViewControl: false,
    fullscreenControl: false,
    mapTypeControl: false,
    gestureHandling: 'greedy',
    zoom: 13,
  });

  document.getElementById('lat').value = lat;
  document.getElementById('lng').value = lng;

  // 初期ピン
  pin = new google.maps.Marker({
    map: map,
    position: new google.maps.LatLng(lat, lng),
    animation: google.maps.Animation.BOUNCE,
    icon: '/assets/bike_icon.png'
  });

  if (gon.spots) {

    for (let i = 0; i < gon.spots.length; i++) {
      shopsData = {
        id: gon.spots[i]['id'],
        name: gon.spots[i]['name'],
        address: gon.spots[i]['address'],
        lat: gon.spots[i]['latitude'],
        lng: gon.spots[i]['longitude'],
        spotPostCount: gon.spots[i]['spot_post_count']
      };
      markerData.push(shopsData);
    }

    for (let i = 0; i < gon.spots.length; i++) {

      // 検索結果のスポットの座標取得
      markerLatLng = new google.maps.LatLng({
        lat: parseFloat(gon.spots[i]['latitude']),
        lng: parseFloat(gon.spots[i]['longitude'])
      });


      // マーカーの作成
      spotMarker[i] = new google.maps.Marker({
        position: markerLatLng,
        map: map,
        animation: google.maps.Animation.DROP,
        icon: '/assets/love-pin.png'
      });

      //検索一回目のマーカー変更
      spotPostCounter(gon.spots[i]['spot_post_count']);

      //投稿数に合わせてマーカーの変更のメソッド
      function spotPostCounter(spot) {
        if (spot > 5) {
          spotMarker[i].setIcon({ url: '/assets/pink-pin.png' });
        } else if (spot > 3) {
          spotMarker[i].setIcon({ url: '/assets/green-pin.png' });
        } else {
          spotMarker[i].setIcon({ url: '/assets/lightblue-pin.png' });
        }
      }

      console.log('ズーム値:', map.getZoom());
      // ズーム値変更時
      map.addListener('zoom_changed', function () {
        console.log('ズーム値:', map.getZoom());
        // 20未満の場合はマーカーサイズ縮小&&マーカーの変更
        if (map.getZoom() < 12) {
          if (gon.spots[i]['spot_post_count'] > 5) {
            spotMarker[i].setIcon({
              url: '/assets/pink-pin.png',
              scaledSize: new google.maps.Size(40, 40)
            });
          } else if (gon.spots[i]['spot_post_count'] > 3) {
            spotMarker[i].setIcon({
              url: '/assets/green-pin.png',
              scaledSize: new google.maps.Size(40, 40)
            });
          } else {
            spotMarker[i].setIcon({
              url: '/assets/lightblue-pin.png',
              scaledSize: new google.maps.Size(40, 40)
            });
          }
          // 20以上の場合はマーカーサイズを戻す
        } else {
          spotPostCounter(gon.spots[i]['spot_post_count']);
        }
      });


      contentStr =
        '<div name="marker" class="map">' +
        '<a href="/shops/' + markerData[i]['id'] + '" data-turbolinks="false">' +
        markerData[i]['name'] +
        '</a>' +
        '<p class="mb-0">' + '住所：' + markerData[i]['address'] + '</p>' +
        '<p class="mb-0">' + markerData[i]['spotPostCount'] + '</p>' +
        `<form name="newPost" action="/posts/new" method="get">` +
        `<input type="hidden" name="spot_ids" value= "${markerData[i]['id']}" />` +
        `<input type="submit" value="投稿">` +
        `</form>` +
        '</div>'
        ;

      infoWindow[i] = new google.maps.InfoWindow({ // 吹き出しの追加
        content: contentStr // 吹き出しに表示する内容
      });

      spotMarker[i].addListener('click', () => {
        if (currentInfoWindow) { // 表示している吹き出しがあれば閉じる
          currentInfoWindow.close();
        }
        infoWindow[i].open(map, spotMarker[i]);
        currentInfoWindow = infoWindow[i]
      });
    }
  }

  // ピンの移動
  map.addListener('click', function (e) {
    clickMap(e.latLng, map);
    if (e.placeId) {
      let placeId = e.placeId;
      let service = new google.maps.places.PlacesService(map);
      service.getDetails(
        {
          placeId: placeId,
          fields: ["name", "formatted_address", "geometry", "formatted_phone_number", "rating"],
        },
        function (placeOnMap, status) {
          if (status == google.maps.places.PlacesServiceStatus.OK) {
            let contentOnMap =
              `<div id="ababab">` +
              `<p>${placeOnMap.name}</p>` +
              `<p>${placeOnMap.formatted_address}</p>` +
              `<a href="/spots/new?name=${placeOnMap.name}&address=${placeOnMap.formatted_address}&place_id=${placeId}&latitude=${lat}&longitude=${lng}&tel_number=${placeOnMap.formatted_phone_number}&opening_at=${placeOnMap.weekday_text}&rating=${placeOnMap.rating}">` +
              `New Spot` +
              `</a>` +
              `</div>`;
            let infowindow = new google.maps.InfoWindow({
              content: contentOnMap,
              position: e.latLng,
            });
            if (currentInfoWindow) {
              currentInfoWindow.close();
            }
            infowindow.open(map);
            currentInfoWindow = infowindow;
          }
        }
      );
    }
  });

  $(function () {
    $('.lat').on('submit', function () {
      console.log("キーボードを入力した時に発生");
    })
  });

  // 現在地へ移動ボタン
  const currentLocation = document.createElement('button');
  currentLocation.textContent = '現在地へ移動する';
  currentLocation.classList.add('block', 'mt-3', 'mr-5', 'text-black', 'text-black', 'bg-main-blue', 'rounded-full', 'hover:bg-dark-blue', 'font-semibold', 'text-sm', 'px-5', 'py-2.5', 'text-center', 'drop-shadow-lg')
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
    map: map,
    animation: google.maps.Animation.BOUNCE,
    icon: '/assets/bike_icon.png'
  });
}
