// Generated from: assets/europe/belarus.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for europe/belarus.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE51dS4udxxHd61cMWpum3l3lZUKyyiJkF4IJIpkYgawx8nhhjP97qL6WsX3rSzhXCzGaqznqR3U9T5V+fPP09Pb1h2+f33759PbPz+9ev//0/MeXDx+e//X6/uXj2y/64//cvv3d2y+f/vHm6enp6cfz+/0Pnr9+Pvj208u3z59e358f+vzXn57efnz3zfmBPzx/ePfp++9++YGnp7fvv3v55zs5H/797vt6vv+Xv/36g3+9fHx9//H542t/9qfv+198+/OnP/2ykK+fX755fv30w2+X8Xndf3358MPXP2/zF9SXT/9+//Hd66/2e/v1669//6enJ+W1Q3VnffG7T1wWE9M2+c0HX33xf/E8vTQnPPFUYhAvikJ8gBOhcFMUzqpIdMILEdooHLFfLC8t2RzE873VxtNTFiVD1+c7LtZnEiRuKF66W0zS4iq28fNjL5626xZcDC9PgjdPywtVop0oHpepxoRXuZXg6w21HRPeVjZzVJo9LGdx2V4iCa9PveV5wqsUE1QZmEkL9ICXwcmB3q+6kuzp9Zaq2UbPT8qZ97TfytplheJ57iy+w9NFHFGFnp+SlNSe8IIyE31uGuZO9/KiizUrDH0fmjkaD138kPoz3rl5Oj+uIIPvw0Mq815edAmJFaH3EZGtYUY8KtnofWzbFnRxfrwLxtvbjO/fmy62yI1eR1ptmnbLFEKMnZ4satuRk/RRlrliroEsNq6S+9eri4o5BMUTp8hB2+tiSY1C8UxCou6Nry5h8nLsdmVZlKpP0iKblAW7Xlm+c9Sm2s6GkWDaVFaYjdZSl0q2GwfibTKpwdnQpRoqid7HZhLXEW+zqaPntynaZg94dvMb0PNL3zbKs7UyBbXpkZeQUTu3D7cFlj8TTZner+8S0Hj083Cu8fiCt6Sj4mJONTlXusJVhVBxNqer9ZUUF2aMpE2EFk3r24k+Xl5Vwrkn5bLrEVUvlDR6BrtamFFPbftRzgNechtyOKzM479PeG6VsCee4lLT3ZY6UaGOUOreA5wt6lWDlvKsbhRlW6S0WVA/qO9wspTWNrkoYT9I0oawzRYzt1+Pun2kwTodH5fXI259sQxupC0pfsANl/aaB+GzpcXhhD4OTuu4fMAzl9pw2EbbkuzeUbNlxbsCFRdKrsmQ23LelPDrYLecDIetYCqFlRW7sOW9m2srxNUYXp+wTGGbrY6vMzD5o1U3533CK89KTF6og++UnNa3UwU0lA3HnbYa4JKCyDFxoZVHoU/aJQO/XlopdSEuxSd9h+JF7MmPtFVGW0A/iFbtTmrci58vcrJMWFyu8bLNCgrnmRn30ueLdXuBQSqtvAgqfYmoPXC9J9N1L82+pKN/gsWPacxJ+lKKTlvB4kdVMa1PT/YJxruluia8ICPQetAqos6xT3i1jcGwt/HmpJUvf0CbNl7kFKb68k3tUqPnlyIyOEO+vEIzYHn2jr0HuKDtDyzv5uGNeMxgEE1rC8dkO3yFCDOYhKAVceoGE95Jx6CnF+IX0hcR4qBvQMszNg9JIV+bSGDlZ9vHIMvXjmw7iuKN5RNfOwPOX9OSzt8M+XpfacenAfHIJLaPeBomDuFJrdJNPOQ3b+sLhYRFamWf0XgbqaKCFRcbT7Rk3O++ZfJBvGPYZmnZZIx5GlIr0nzTfSDT0ldbAgqMGu8EvZNq3r1dhkyl1LJLVfrzylE8nvPrvrZYukK6VKrrO1Nc2c8NdTQa7VZUG6XPNgf6OvSUhCZNn8cHQV+HVrvH03aL0Vr02e601dLcOJZcpFt8VZwSDYhHuW0qu8ciYTZBHwYpbx0E7+C1Ow3h5aqLQkwsouMOgni7bM8PrUx8Y6nrxjNKGRVLuSt6H9msihHv7DcU86kar8sjdq+oYlHwjo2en4d2OXLCu6WyQDyjrpCM+80iBg1bLi3pPMiI1/4MjMehlPfyEovaCce8Pslmn3TlfcSDE36Si21WfbHY4Fx4410UehvPOxEN4lHn98f7ZW3mB4a3V57KySjPO2DDu1dU107G92vsjqUgGs+a3TGZomq/AJS/vfxWgJ1MGxVaiG68HdtH+7ELzmnIXuY1ZtR6fYezguLJHjOIjYdWZmUvpf+xPLTyKfvzox89F/LA4g6JVRe8GV/JUorFvBIrRUZz2UEbzDuSWHuPtSxfUVplmPaLFUIdTE14u1MG2PXG8lL3OYaO7WCQevCurHmINGEPxYsI4jFDYp3BRsXFuS601QOFaIkuRPuknb0L7/1PoXjeSnjSfmpiYDGw8Xp5Y5ivnMSg9xIr8gLtRhhAH8chmU6nJ4cPgt7u3j7SXDr/qoQqv1j7JIEnOAvYFY8VM9aha8FYlldro1OfRvGIR35pp9aJN5hviS5HjpWJxitHw45oBtPO8aGxWGcMULyLZ0HtM4NBQixhv1B75MdMgni8ZwKJLyKVzagaoJKa+Gm2KmDytXSoPBc6uu4Epx98pdfo03dZrCQ3ZiU7p0LpNVVRU9GqYsNd+AS2NuMpg8abc33WwSYpvj6dc5HW5lgTKzvJLcM1F909TowP4kX6qOatWdkbjADbk6Dx8doyvOokvvw49JMw697kYITVnsnWGDkfqtz1IxTPjzaY8JiisKpdnx9Hx0QzXjfGoOJCs0vfnJSjdlC8myc24XkFrFx2tAoel3eqTvB2w2WqadvqQAkk953tNt9tpBw5XOQ9r+3EUROekYEUnBa/rTQVoa0teRaY4PTl3HHtpK3YK8AyoPiyunpuvF0MDLG6NDw3Kllbedg38OXnOkb5CyuD5c+CWUcOiRwriuLppiCfnxuerPd1I5RP8td4AUbk3q/qgoMj/Ig14s7Kj9aX3Uoxip/4IptrHf0+TkoDwmtm0RxS9vt1xuFkjoma0ZhwBqJ5WSVT/ktX4Y1UjXeqzVNjTG0LB/O5zZM7CfERrxJ8HbZaYU6MsqbT4sa8TewePXFd+YCxtCUaMRFCtV3nAtsWpWmpPKbrdZWTofk0W3zCn5GOfGOhg3hEaROF6dxHe8EQXq/iqrOj8L4x0ZW7WSQznsPOmq6tszbVU0l1UP503Woks7gkSlvQZWkRozJQuMuwV9cOxaCb+5PTFYCe3qWykk0o/bpv9yJZr4tZmMCEla48rMDpdkk2XBzTVYeUegcnq+jwlFG4i9qdrGSwEeOguU0tn9KUFJiC05vlsQmt25cO6x69DJsr27IiTMAoWpftw4ge4Py0IqPHZ3x1ud4dgfD6lE7r0IBneE+g6Mk7Tql6WWcMA6yZeUw1yyPU10bb3UM1CZ/ksaAoXp0+swmv1TzWIde3cVG26+aqRPu/W1o8tUY8Pv4lquj9Ij/cvap4jqn1+Vx27+EcShssFGlPQdCpy0sWdWcCNpyj8U7oOJ0fPbTf8DNy5A6PV20pjFvacA02XAevfCAJoc19HaME7iq5Cnwdnqw2PLeeygI34DaeWXsnE96t9RXFOySc++vtuR2ZFahyDjppgwHPecMsku4T1T3ZNj7MdVyZBs2za3q/ZLj4WYxU7tM/172+qJ92QazvqTYnHkHxbs1wE57uR/y0W9573G+3JsBRh8/a9IyhIYf3W90tNdhyXl74+dliifQhJ9RzIk7dHcSTnNm+PdcBna3TQbRoj6iZtJUeehiKdybyTMvLB1gQ3ZvoI0uDV+YjKaFbxm9cX5aDXG67rMc0XHfjoXgZHXiPeLd2VRCvto5NgdwUsD4JCM8XRVxog1JylAThS2Im9TTe6SgD8fwMq5iMR4ltNMbv8uc8baHxzsmCeDV3lPd1qIOTtrpYHntkmHL3L6GNMRJLeyLFaDzyltwB8Wym6vNqnwZVLofCNJbb2rXiImzO2yG5zKyU1qUn9QnilUvq6Fm59VwHCG53x/bYod6eH3VMAuJdjcLp9Qlcnd2d+BkHY7UnpA5OBWy8Cz5tm164Z7EJl6eBflqf12npAfGsq5Wz50fRpTgQLw4/Zjw/4jZUKF62/zSe35YHzi8u+Lm87JQ7MG211+Tk2t7oLINGsjm13ivr8Ate2WmGHiVFisHZDc0Ml8x5fX7rk0bxLuZltiQfOwTh5boN7Rz32zNFQKZ0Lro0u36jDIB4fFFKuL2MAN20XHwm0E0vI2hngC8tz4SQKUHXQQdeysplhxU1n58GGOJnj9kcGx3OrDtz0CvNrhiQzNfb48vgPiDbexqxxd1IC05rvbUpjSwSXqbnWYN4e6RENZoqOJbjNHnpOA2QP7M3QLy0E/GOd0Gc2Hyybmq7VUdmWWG0aJyXcypa9eFNd7WoNf3okv5c4ULx4kr1hThcla3FdFynEQ+vO9Vi9ZgoW/zIwLPG6+zmUCVvVUXBMF5zXKeqOzd7iATk09aSi7E1PedTSUHCai29NTMMePqAa1CX8/F6IFWqgezrWj53EbR6eaS5+jCOBoJp45WjPn1dzvlo3ZzwcGRaFFfZV8tDPgXx+PL52t4JFhN62ALPFKHeL0zZUlra8fgsftWd3OgwCL0ZnQlPTlMviGeX5kO2KT6swg97fTo/wT2/xtunpjbt9zhW6PpCZWT89pjoM30QxTudk6P6o57bDU9KoauY0vaZr4qe3+X7cGUDOWqNp3OPP5+5OrrR8/PUce4Ur0h8uHTf79yTelI4BKr7Mwlnjz2znbIyBmPyntTjV9WsLJSC2HOEjo0Y87kO13rPEDoaGbVdm31ktj7tGqfxSrdEFzq9mRefkSMTXMAtqT2j8YIy2GOnCSU492hz83EKWJfe4YkL539imKsxjdfTQ9D9gv9vx5vp689f/fTm8+9fvfnpzX8BXYIIM15lAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for europe/belarus.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get europeBelarus50m {
  if (_cached != null) return _cached!;

  // Decode base64 and decompress
  final compressed = base64Decode(_kCompressedData);
  final decompressed = GZipDecoder().decodeBytes(compressed);
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

/// Widget for rendering the europe/belarus.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// Belarus50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class Belarus50mWidget extends StatelessWidget {
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

  /// Creates a Belarus50mWidget.
  const Belarus50mWidget({
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
      geoJson: europeBelarus50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
