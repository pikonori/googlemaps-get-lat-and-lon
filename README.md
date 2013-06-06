# 住所からgoogle mapを表示する

## 概要
google map apiを利用して座標を取得出来ます。  
座標の取得方法は「住所」と「座標」の二種類あり、両方共値を入れている場合は「座標」が優先されます。  
また、マーカー移動によってコールバック関数として緯度と経度を返します。  

## 条件
- jquery 1.7以上

## 利用シーン
- メンテナンスページで会社の座標登録
- 住所または座標から地図を表示

## 機能
Jqueryの拡張として作っていますので、$("").googleMaps()のような書き方で利用できます。  
第一引数がこのライブラリのオプションで、第二引数が地図を作成する際に渡す、google map apiのオプションになります。  
```$("").googleMaps(option, apiOption)```  
第二引数は省略しても構いません。

### html
```html
<div id="map_canvas"></div>
```

### js
```js
    $("#map_canvas").googleMaps({
        ad: "東京都新宿区",
        ido: "",
        keido: "",
        collback: function (ido, keido){}
    });
```

## オプション

- ad : 住所
- ido : 緯度
- keido : 軽度
- markerDrag : マーカーを移動するしない。 true マーカー移動 false マーカー固定 デフォルトはtrue
- collback : 今マーカーが指している緯度と経度が返ってくる。
