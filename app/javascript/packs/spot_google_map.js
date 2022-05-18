// Initialize and add the map

window.addEventListener("load", () => {
  if (typeof gon !== 'undefined') {
    initMap();
  };
});

const marker = [];

function initMap() {
  const zoom_level_of_map = gon.zoom_level_of_map;
  const center_of_map = {
    lat: parseFloat(gon.center_of_map_lat),
    lng: parseFloat(gon.center_of_map_lng)
  };
  // 地図の作成、中心位置の設定
  const map = new google.maps.Map(document.getElementById("map"), {
    zoom: zoom_level_of_map,
    center: center_of_map
  });

  const spots_on_map = gon.spots_on_map;
  // 各shopデータを格納する箱 obj
  var spotsData = {};
  // shopデータを格納するオブジェクト markerData
  var markerData = [];
  // markerDataにshopデータをループ処理で格納
  //文字列に入っているので表示されなかった
  //日付情報・回数
  for (let i = 0; i < spots_on_map.length; i++) {
    spotsData = {
      id: spots_on_map[i]['id'],
      name: spots_on_map[i]['name'],
      address: spots_on_map[i]['address'],
      lat: parseFloat(spots_on_map[i]['latitude']),
      lng: parseFloat(spots_on_map[i]['longitude'])
    };
    markerData.push(spotsData);
  }

  // markerDataに入っているデータのピンを立てる。(googlemapに@shopsのピンを立てる)
  for (let i = 0; i < markerData.length; i++) {
    console.log(markerData[i]['lat']);
    markerLatLng = new google.maps.LatLng({ lat: markerData[i]['lat'], lng: markerData[i]['lng'] }); // 緯度経度のデータ作成
    marker[i] = new google.maps.Marker({ // マーカーの追加
      position: markerLatLng, // マーカーを立てる位置を指定
      map: map // マーカーを立てる地図を指定
    });
  }
}
