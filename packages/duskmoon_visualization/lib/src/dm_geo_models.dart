/// Public re-exports of geographic data types for the curated API.
///
/// These types are required when using [DmVizMapChart]:
/// - [GeoJsonFeatureCollection] — the primary data input
/// - [GeoJsonFeature] — individual features returned in callbacks
/// - [Projection] — abstract projection interface
/// - Concrete projections: [MercatorProjection], [EquirectangularProjection],
///   [AlbersProjection], [OrthographicProjection]
/// - [Point] — 2D coordinate used in projection output
export 'vendor/dv_geo_core/dv_geo_core.dart'
    show
        GeoJsonFeatureCollection,
        GeoJsonFeature,
        GeoJsonGeometry,
        GeoJsonPoint,
        GeoJsonMultiPoint,
        GeoJsonLineString,
        GeoJsonMultiLineString,
        GeoJsonPolygon,
        GeoJsonMultiPolygon,
        GeoJsonGeometryCollection,
        Projection,
        MercatorProjection,
        EquirectangularProjection,
        AlbersProjection,
        OrthographicProjection;
export 'vendor/dv_point/dv_point.dart' show Point;
