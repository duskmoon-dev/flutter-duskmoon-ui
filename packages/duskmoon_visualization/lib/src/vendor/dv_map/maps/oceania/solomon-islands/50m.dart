// Generated from: assets/oceania/solomon-islands.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for oceania/solomon-islands.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE7Vd34udxw1991+x+DkV0szoVx5bKBRaWuhjKcUk22BwdoO9eQgh/3vRfE5InNEWn+X6YfHu3T137oxGo9E50vfjq7u7108/fHf/+su713++f/P0/fv7Pz2+e3f/1dPbx4fXX9TL/71+/OH1l3f/enV3d3f34/76+z/cv75f+O7943f375/e7j/6+dfv7l4/vPl2/8E/H989fvv4cPeXD+/ePHz94Zc/vLt7/fbD43/ejP1Lf/zdz+f++V9/88JXjw9Pbx/uH57qtb9/df/m4e2b1x9f/umXEX1z//jt/dP7H347np8/wN++f/f09h+P73745uOH/gX78f3Xbx/ePP3q01//fv3/T7/7/fd3d6JJFm6p84vfvfiHIGVP4fHJS//+9Hcb4GUjUo7AS3kmGwosxmJnYFlLp2DAmnvIR+DpuXKAU6E6xxh+Bs4cEgECz1huzVSoTHN0xJZjxtkqVr2nwovHPBur0CEr1gKBP9+OX3Xf/eYtP3tTmVGOlMxxGIwIme2VAT6mGYUrp59MqZBHWriCyKrLIs7I6hEcyJqbkSentMBSXgIEXr6MTxu2kJNj8AQngzW1m2X3uSayYwt47VE1yCFzOWgZiM3dbgfInIPnaZ8Lk6uHDNBOZWTEOJoTk6/tREBkG8K5zsiWk80Q57THrBbz5KcL2fcHwpB5zBjRzLOZyMSQlWrTeh73QI15TcFmQyk0w+ZxDzA5Tx4ObVulmJrTtUE2trUgq9PyYWt0s+FqrAvat4UsLNrYhsNnbc2G5Jx6dI9MsRYvdJrVdDXrF0sWGwicvMODBlllGba3ldJCbHX+CA7u9g707C3DGfdHrNuJdsg7EAD9EeCdb3VWMKnbsDzuWiFPDxVoBzDp9M6jC7mGg6EH01rhk5sxW2pkQN6Ria/w4oy8coQLOGZuMF3SB2JJmlSevDl/arTLh4E3haxtZV1wN+vQhLwME/PUxuNWQLoXD0SOZ+xNc5U7xpCbGTZhX5jnYpKVKtJFuWvmUnCGx+X2ulh0JujHmaYqe2dvLpKywN2xP6408bNHBHaZ3r5ih45n5JCVS0BfodwdxEJROQdo84Eu+VYHhJCu/YaH0STZFVojH1NoscU5QkqaFkuh81Vo7hzVyZaSps4lkPXXeMdYdrL+rBNJwPBWaIlljvOAVWalVlDgwWcfk2SMZgH3VGRFxmfgivVg4DVWHE/2JJdAnWKds12gmGQpIhMEVp2VnDmP2BI8gjfwdntn4DkcjGyhDX0j76JJEqG+zrYvY+pUMIk65sxYJ7+fxHVPBWFHrGM6LYlHZjCIK27czQOPwQ4l0wr4CsPPwPyCLLWMOolOIw5KOF+jWTG4zcbweSjOXfDswuV6U3DhuGb3eGNIEk4zkF2QUffAMyx8JmxD63LY9Z6ajl4ZgJ18q6CFSdqMQxnnDmOx2IyzI9bKvrbLwYCFa6M2wMFuAoVDXAsuZ26mgCsjjuGOCtgbAx1zYR62cNulSxKbAsabdS/a1t0Ah+kAL1znuRWrmy441umbjTsDo+l7psXbGM6wi+cEbWG2yc4kxvPg28iabEGdXj7HQq23JQUKOBU7bzHPc6voysltthT1WEMwvlKdTKW5ogYNMU9DUi0FLGPyOrP1Yisw7k+ddPM853XhTThiuCvZjm7QKU19YLk9pzX3aXIGjgXGFU5zNeONOttmQNx44Q7ROEeDshcVtLQxovEAZWnFGkKCE6chO9d+BrbhCQXcTqOckjRCFnmBBU8ea8nJIoLmnJMZBb7EKueZcB3oTCivhhQPGhr4gFWD2U8xdy1daXpA76O2VPkMPKfDNrHJDm6kQksXqPMqP9xIJYJWpjO4mX1tXdQRV8e+RmHAPSsa5forWwUCz2nZbA71YQqxogUculZjxFpvid1GnYqkOtPlpZkyUItSwKNLHwfNsXhM6GIORRO3Cm2CRnkAOUvOYsCkWnmmec7wROXep0GJwsJtsw9Bjkc2NROZZyFWkKFaHw0S7W6kQR6K5tCC5NKzNUtXhzI6xZ9vE7czULl0j+dliVXyHnD6WgY1SveLqjiDOIoaPPtQG7APDbqInga4EoWYDw2Si2Y7+1B9CTB3eswgnfuKh/nQfNbrlzoRDGfTOhIpSNcqQTEIvDVujbbX4FS6l8ZtuHfAapjf+j8Ha/hAg6JoNRFBBkp/9/xWXuocw/m0NRQ8F5hLAdIA2+SA5BCYZ7uVm3Wasb3W+VPKDliwdZnP+BZTBnnvfQP3onOaUFUXJq3ZUzFXHgnq8oZbuoEBL+FG2Rm0YClcjfjS/p2BB4M6rj3HJa5pgK8LOgY85vSusEblBVfP8UziS61KdsDFm3M2PHIQumzRJb2CfKARJ7SXb+VYrGpamju7U9ZaYSlOI+cue1FnTNXRQCu9Sz3GPJIGTn7pHzDg4CrnOOPu/BzkCY1c3FzPM2E7Bw/OxCVyO8+EbZYTnImPAc8RWB2+Wxtpm9zzKtuqdQWBW9/t5AxfD41MxM85Iq8KHpCwvIB5HoUFTmGakH5rG0WRSecNvbkBeCYq+Dv7CfyqADmgG3rDrRY7By3ilfpHF3tnpI64nFaSUtDuy3t0xAwsPi/glvpySq9cDAq8ypeeYxYWjgkJowu49YZB7KNCMBA4t3LxbBSXUAK0is+2tltZvtf7nbd3XYRCWMFgR1L0XG5TmRgJTK1ekSSzRpNjZ0H9p5OEFZF/NvwlVb4HAq/ic5qTJIYJJlFzkipmawKijxW3GDCP+rynW0AdUQ5WiajRVbvSsL5w2cUFPM9zXEaxpqJmzNfKn/eH+AIVkU7S7LnNr6IG8dl7+VZ+pcolK091tnpOF4zgV4orB3zGXXOAcZmSz+52ZpT4MaLkvPIs+nbifdhCRq9VLK7nfgdOfN010anI2jFH4L0dMC4HMYrbHXx2EdPn2/glTsd2oV1buMl4LlB7VTT7Mxla562DBoGHtQoJS0fV2U6r1bfViF+gStI+ReuTxbGkcikZtGz0DBwTD4ds17Q3bGOC5dKYFd9qSyX51XrnMJikgasUquiml7YPWNuquyCkCSaTpsC6rqo/8kYmtau0wIYnBdwmUpOuzDvYochGEzxUK6BRnVTQteOGa0wyPIFQ1taRmEk+9gJgwNHG1fmzSAQEfqZYxa/7EgC8q45HU9edFFcKAgOeoy//iAG312FaVxndGRgu7TYma7VdSTnqjgdOhcvmFM/AMvES3mCxrqAzPCbYaIgprorCMzAqAa2ZuIrNm/3hE2w4U90hdheOM7CgJFEZxZVwOPug3C3fQOCxCc2z13xJXbeOvqxFp4EH0y5yX3UJP58fA8x0lguy6ihyhpUXnNDpbHy8i+QWkYMqWyhYuV3kFLtTT6P0mauEJOCRs3bodAReLznLPGfjXKJK38GeRXvEXUeD0nfC/GFZy27geM4RjWTs9NWq5u95vsyFamiTRuzw6AxcDBTGxidJVlB28odbt4ReUXdJaMfG5aXrw3B5K9bOA47pYICjUZmdps2fU5EohknX4+MBe8YdA9fZ+mzUX05WbcQw2r5aenYXFi+BHdprpxQ0nRy2Mhq7EBADrkZh554Hu4ALLf0O0qzGBmdg360fMVyLfW6fjVgCLSkPct9XlmbbWU5MyxUUs4ubiqM1w3dHG4UUfZloD9ig3K3nzj5+MVqvVj0VOvHJViyDQfpu5JClCT8D4yRj0niGvRwM9omp064STk2oMowXmCev9r1dk6RqkVxVl+Da+aUaP4cq+7oCTnE5tk74rZc/BYE/Pxy8VWzqtMJaJcyclXdGdZcVDzQahln+GxUbrqtw8gxcSwbXKM6eIx5XngsDvurGzpEeXmm/yedOLe4vabSxyeeGfCo21sH2YMW47h6tp6kwit2GGJRzeBsv1Gu7bhgDtrYQ1KqhPINRr9G6LllnYIYpKqOl/eLZVRCBAndRZMkhFdf5reJfO2CD66Rt99M8KweMUuD6D6O8ovHzznuRr+Bn3OZLqlfHKnbyjKto5+TymtJT9nOhae8N7I2krEaMl+7MNiZzmnjvJ6e1Kol8vgstuNlg8ZZXiu084hcUGwFn/40CkUoP726WZw51ygsaf14dRZuUkxjOy9jVYvsMfBXMgsAr9CwiLuCoIg4MWNsGUJV9i4FdoDZw1+S8ovtRShZw8aRv+aHXRgbn2EZbuWZjZ6XBEftoK6SuHiUok9Qmh6pRnoGaSxO61PsN/+7ok1UKeHUq0axIncFGZlLy06bzfdLEG11LMaItTR7VAAkc8LyIsyOwwUqEAm5VYknq03Hg6oPUMK0r0W5bUr1Tmjq/0mRYcZoosLWcs8A3iwLmaKrmsmq4QYXvBl5N8UVlpAaoPq3todH2E0kTUJSxN3QTQ1bOD63RNKb0TqhTWUq0GV+ujskuVVaC9U4F/EySzDISq3ou4PAzrVBF2miXjcLdOdcGGO5cgwVtt4ogq4l7Q1IL06yHLmAPWqmnMuxS3wYZfw6VkLUNmAtZJTBp++4Z/cyDgwb+EAShGVsC2yDzbl0BIvNquvJu5P1cAdDV7oqJ5vEwI9Ca6kJumfJawWHog2eE5rNWt7tWoo3Kw5vW6oVsArZtKOTMprZEmNZFC2HI2t7aCzn3zRtF7koVhekKKsAD3luGvx6W85JgJ3eVVIdsaEmMDeI1GrnD9VCpwLhtG1X80ohV6hFN1x0EQx7cVTUWMlwnbIPms8iwcLaQfffI7GYDrROq2Yjt3JsVhIUlF/Lg7nlVVyMv0DS0e5qG7EeVoM9IG890pt4OCZVq10a5mgc0yG740Z1XSVuDDHfVMalHrNXDIhrkkspgESYUe/WB4KtP//fTq5+//vvVT6/+B+4p3KrmeQAA';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for oceania/solomon-islands.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get oceaniaSolomonIslands50m {
  if (_cached != null) return _cached!;

  // Decode base64 and decompress
  final compressed = base64Decode(_kCompressedData);
  final decompressed = gzip.decode(compressed);
  final jsonString = utf8.decode(decompressed);

  // Parse GeoJSON
  final data = parseGeoJson(
    jsonDecode(jsonString) as Map<String, dynamic>,
  );

  if (data is! GeoJsonFeatureCollection) {
    throw StateError('Invalid GeoJSON format');
  }

  _cached = data;
  return _cached!;
}

/// Widget for rendering the oceania/solomon-islands.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// SolomonIslands50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class SolomonIslands50mWidget extends StatelessWidget {
  /// The projection to use for rendering.
  final Projection projection;

  /// The color to use for filling shapes.
  final Color? fillColor;

  /// The color to use for stroking shapes.
  final Color? strokeColor;

  /// The stroke width for shape outlines.
  final double strokeWidth;

  /// Optional callback when a feature is tapped.
  final void Function(GeoJsonFeature feature, Point position)? onFeatureTap;

  /// Whether to enable anti-aliasing.
  final bool antiAlias;

  /// Creates a SolomonIslands50mWidget.
  const SolomonIslands50mWidget({
    super.key,
    required this.projection,
    this.fillColor,
    this.strokeColor,
    this.strokeWidth = 1.0,
    this.onFeatureTap,
    this.antiAlias = true,
  });

  @override
  Widget build(BuildContext context) {
    return MapWidget(
      geoJson: oceaniaSolomonIslands50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
