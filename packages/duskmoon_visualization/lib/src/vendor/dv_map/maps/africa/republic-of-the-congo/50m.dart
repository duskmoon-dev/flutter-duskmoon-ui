// Generated from: assets/africa/republic-of-the-congo.50m.json
// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:duskmoon_visualization/src/vendor/dv_geo_core/dv_geo_core.dart';
import 'package:duskmoon_visualization/src/vendor/dv_point/dv_point.dart';
import 'package:duskmoon_visualization/src/vendor/dv_map/src/map_widget.dart';

/// Gzipped GeoJSON data for africa/republic-of-the-congo.50m.json (base64 encoded)
const String _kCompressedData =
    'H4sIAAAAAAAAE51dTY9dxRHd+1c8zRq36rur2UVIyTJRthGKHGcAS8ZjmWGBEP89qr4eBLy6ROeysIZ5njPdt2/Xx6lT5Z9f3W4Pzz99fHz48vbw18c3zz9+evzq6f37x7fP754+PHxRH39zfPuHhy9v/3p1u91uP+8/739w//X9wcdPTx8fPz2/2z/08tdvt4cPb77fP/DPx48//uf9u7e3p29uz9893r56+vDt068/frs9vPvh6d9vpP7qV3+7+77u7//9dx+8ffrw/O7D44fn+uwv33x69/bNw+dPf/l1Wd8+Pn3/+Pzpp98v6mUX/3h6/9O3nzf9K+rTp/+++/Dm+Te7P/777dd//L/bjXmwEk/PL/7wyWsdi0Mp43cffP3F/8PTMHPlOzyr3+QRhuItTZuzwRMiWQrCRSRFWANnajInijfndF3ddj08hWC8pPTVrS9meIiDeEkssbzBm+R18Cie0KT2eKe7RcJ4SyW4O94MnyITxFsRc8Vq8JabLsOenwwimWrdeaw6XcbOVwZxane+PohMViwU7/T9Wy5siV03GRyTct2bAxupM5aj+5VjV937MjNYUTyluZikwwt3Ae+vDLV6Ybr3b4qxMKN400i0vb8+Jxt2P2Romk/SDo8XG2HmWYYTW1h3vp4TvRxhHGt1h+HK7IIexuRlqtEZ51hTAt3sXCkm3frsgi+SkZZs1hlTk1wU6H4zmdy6l8/MmaeAeGuyZnR4XrZ+Yi+fDrIkay9v8BJNbL86aEpZqw5Prdwbipf7tnV4xMsVu7w6WCOEO2MaF4yzjroCpt1li/IdoDPXwTNOLm+4V9gA4gmvkGyNM13Cq0vq3f2dUY8CxdN6Z7k735QFO3MdxraMO+Och91G8WYat76SbCWhy3PniN63eUz8uoWvE98xd2iAHkekq3N3vJEZk9HrEatOo71uR5QE4k2awbN1R7ajTBSPz2Ihc7MlmHnWMXVRSOs+TAx/X+bMik5b96Z1IiBe2iqv0+43r+ClqFjrftMiUG+0jFZ7266hnd1dCxYFz8IGWeRsj5YnfLSVK+8D7PBAJJFJTt1G1Sv8QFemHMLU+QwlY2LMh+9VKLXrk8M8gHhGsqQN6PVCDLmv5pxtQG+8yDCbXHAr6STk27cP3u5a0R6H06XjDbf+8XlWgo/Z+D87jkgONH+ph15pT8s/gOlLYdHs04OEg7M6vxPzlH7lXljwSSyasaMYFG8HTG0sdYQdIJ77mbPN4yMQL1RXtkRLppODPGRFsGdEQSbDwVS9XuuEyDgydNROLS4z2u13ksO5qQ8+Cy2CSR07XR8Sk3t/pkeQBeLpspNMQyqSAkNHH5a0vLMqPHmiLK4PF18zusiWcq4EXxYfQUSrJa1Ja+Eg3HTzLhDVsS4YZR85xTqnoWNdIMF9rEXUkZA6ZuxoAcKLwRZ1iA2eFeUE2qoY3MfdOnhZEU4gnJT9kO44SDddjOIRp/v9+qS2Oy0w01Lb5aAmT5MhZRNBV1T7ddV7SyqD50xFD0OmLmkKTjKYNqUO4pmqr4ZkqVoApS4sMYjhRlV3aPDSiBXMgmKE9JeNR6ysJwHizSSaeX/ZeOgMDdA0R2V93AUaPOQwEyheGczmdvAQ8ZyJ4q1pk7rjYF1wHDQHn5AEPOioXIJ4MjMp7y8bjbUjc3R9bpKzOQ6CA9w5pks2F5eG26oqBQp3VEQaPDmqUCje1JZOp0EuugSzU3Nk7grVH/FoiBor+CLPscS5hXOdSobZgVqdd9kGjfTIBAtDcywSa7hMHsy7wg3B5SDmyXl3a3mYSKVcKFwRt/cul4erZYBVv6zCQTbMI1fFSNFnt+E47vZaxVmVZMyA5hBuMzV5oZtBODW1+9BWiuI3XthLnMNWl5XKWPvtQY/VyxTfM8q7EkMoeZHlGptz0GKSyMHSf46d6Ny/JC80PbpV186u63AmIUefnK2W99GqLMEhWQ6b1lHnWo90gSFPDuXiYho0z00ioRdCZ5faavm2QCUnObhnLnQ4XbkRHLT0PrXVlyNC4XgbjWZ1vukl3DR1JTQdHju5gM16S3HV6iiVUI+9bC67L/jrpfpy+bDJDStQcBW4o/FJJmkTOum+yz5huHKj1B1FGs+F+n/XNjrREQfTB8JZn+RVle5KdGK6eY4OzgL1/3PISmsvWfAmllA46XIAHX78GhCNSDrNVL0nEbkwuBgzTJv0XYdryAQVijFialGhHZzDjifKK55YAPK6LSCcz/JXDZyVWNTR5M5NOzmmVrHGFQzFYtjWMzQnK5SpE12dzSirdg/H4ReYAOszdx1cbCFYmYph0VbiZKylwgJvtlcLyMgVxf/AqytqsoljU3H6PYb1OlYZk5jEUcpNe+WLVIgyLzB4h/trUgCKmRMm8HIXQ+7hZBIF6BcLTjrKQ4aEmMOXjA8hcgNHNhMsNcRg9o5v21LUFFCTE4P6S1bs4pWjoDh5UUg40CCgVjdLKHifyK4LWXsMVuuqvzzm8mUgj19wUcFsAycmnOhmeWvw7ixKZe1WYTP67BY1NHTRqCwO07zkXRbAJbMXIbRCs2bLFfGYuxSELc6rRNmFnjyySrVgtuhjWhsr1ltna4HllF3dktXsdTmVwglE+yyQ6eBw0ZsP1c0CNnBmsPzDh5SCmJsbti5UkX1IURT36V2ZE7MAfbZXLlul8QZO3fE646ElafwOFVusMFxPAhYcwYWAapDYBH1L29WRQ3B2RqAWnMAJlI1crU5IyoNUhQqFu7dNUr6tZGYg1AzpfE71jmyjhcJVTaGLE1l2fQCF2/RJB8elZodlJLG7Iho4FUqQ8LDh2113q1sL7g7ZSkXKJhBjt6lg+4ANOUjXLnLaTCgIR9ql7LW4K+LP2Wv9C24aKvio5LdCnS6s82p0QqWzsrTPTjgqHEWV1nLon5srtnaHDApHy+Z9SMxjyc6+QThuyx3Va7hLUihaSMdj8YhDlIPC9Q1OVSnCZV86RNrXjkuyXRoaFG7fy2Z1GnHlYHvbyUMvUNklX9mChHs4mUvAqlh1g+x+3wbNcJZNh8y2WlxwTAz3+uiU/iRka4XQXgGXlmXjoWy+Frq6uYukTTVWs15IdHW56aUm1zGYPLVBPU9UrdV1I1AhKfcdyiU/IUEbHG2IrpI4NXAijss+9ZBg3cOxUBp4rjZUrbfEtAUU6LPTDGu0T1zNv2bgS1xdh63UhsY6ujxROK2aQqdQsEvBTv/saCRzydrQZ9eK+Kj6zifKdtpQ48pW7+Fia/vQveomSJqTiAvMSUV2Wtr9ezjPCTN2dcc6tSxV1Y7BWGcrYruFacBxU5mm3bPdwF0gJmyQeENM0Dg4XdQIL2uzYRp6SANQOPbOWVMd9sKb8bKPm6iCAnjuhI48uV00HR2yoZW8WlNMLGHXtcX1NEcJz4oSvLDZvq+ZhpgUaQG/xn3fegnjCO7jtsF0otuT6roW1K6zZRfrvKahe4gAul2hTcw1eFbqZ0XXp6EdZVd4RxEJdoutYrSsSgY6lcBKa3Mie/SpcGBcJMCePdDgXWl7rcaj3UHR4B1KXNhv8ybaGrw19/QX/DjakRg8ePPFMJ5G2wJWAuMFF6CqudXb86hoWznB9oA6j74LnqvNpNpCULyTFjoevplF+H05xYs9ZgO/btpO2ag6z56AgJqD7DvBaljQ7jNB8WqUQd8gIJcylpISNL1MVbHY7D6K5/1IluLJr4TxoivsvnpceIeeATb3bXF7939sA4O6o56PrvaU/YvQ8/0TvAsjgfZcMe3xlPZYDHR9vfSz8DbpA0cHh5Vr8EqWho7gstMpKtV+FIlP2VgnE9ukxMjoBLMKdHtzX8vbvcooXmy1a4cn+OusZ10Hr/csKLiju4Ln7EqEhXeM6kPx+uJvXY/cnhTEm62yr6xB4GW4GopRxrQ7Xq7XCCzY6kv3bIeHUmelVmxFTLuTDp9ettsX2wE0UlzcBWZffbYTNkp4hGtxamBR7yplaFyZNrZW2bdufcr73FE81qpYtK5olyVAvDwZVllV212WBPFmX1aq0EB3bI/iFWPQhPY88kg5QbyQduhJjXVccHVEhi9qh0UUXmVu6HFY7Pyse3woUikg+xjt0qQ201YGUnhblYTCnZhQsglz3vXYqn29s1IX2BupdpkTB8QscJdP4Xlkw46Ux8CnyMmwvjOnjLJ5oCNP6jCinZonQ6uXBmx/kZc+0jY+2wcF4dUb1k8xrOGQ1a6GjoRd3sm3Cs6sfhMIlwcn1Ya3ePpSWsNWdL19JK7gqom/3s1lKZdm1QWDwtEec9s+Ppw75OG7etmGBEejEozXKhH345swe1P71c5llPHHI5aiLKzThL6WEbPkZ/Dj87aF6LWMeSh3UTyds70cWZ4YHm8cJyPfpKbkwO0XpU49s6WZAXcRbYam6157LWNpwNzNlruy3+ulCu8oacF4NRj0fr9aDcvwmDYe85CHd3gX+ld4RF83qdEiWyWDn0c/fmvP/ryC1ydrpUTBJ4HwyyimDm8LW9DlLd2ddA2eMs78V3DXD2mqTAlvsan9SqdgrUE0F6jDitqtEzu83j3KcD7JI1XaIVell6vRCjjeakOX3QlMuHPL3GN9G7yoFjwwn+TT2SL62cujcCejT2o0acDdHXXbWnnHxsPlIjyOTsD72KDwthuFrVU7gqLwLgyzL2cZLZVW8io4bjkZFF9Y+KxkLpa+0xXXXnfzCbpX6dUsx9le+Ice+E9mZuFZFvzveLzqvn756pdXL39+/eqXV/8D+elvoHxlAAA=';

/// Cached parsed GeoJSON
GeoJsonFeatureCollection? _cached;

/// Parses the GeoJSON for africa/republic-of-the-congo.50m.json
///
/// The data is stored as gzipped binary to reduce package size.
/// First access decompresses and parses; subsequent accesses use cached result.
GeoJsonFeatureCollection get africaRepublicOfTheCongo50m {
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

/// Widget for rendering the africa/republic-of-the-congo.50m.json map.
///
/// This widget provides a convenient way to render this specific map
/// with customizable projection and styling.
///
/// Example:
/// ```dart
/// RepublicOfTheCongo50mWidget(
///   projection: MercatorProjection(),
///   fillColor: Color(0xFFE0E0E0),
///   strokeColor: Color(0xFF333333),
///   onFeatureTap: (feature, position) {
///     print('Tapped: ${feature.properties}');
///   },
/// )
/// ```
class RepublicOfTheCongo50mWidget extends StatelessWidget {
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

  /// Creates a RepublicOfTheCongo50mWidget.
  const RepublicOfTheCongo50mWidget({
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
      geoJson: africaRepublicOfTheCongo50m,
      projection: projection,
      fillColor: fillColor,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      onFeatureTap: onFeatureTap,
      antiAlias: antiAlias,
    );
  }
}
