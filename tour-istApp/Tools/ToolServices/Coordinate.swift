import CoreLocation

struct Coordinate: Identifiable
{
    var id = UUID()
    var coordinate: CLLocationCoordinate2D
}

struct LocationAnnotation: Identifiable
{
    var id = UUID()
    var coordinate: CLLocationCoordinate2D
}
