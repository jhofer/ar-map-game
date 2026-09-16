# Glossar und Verweise

[← Grundlagen](README.md)

## 13. Glossar

| Begriff | Kurz |
|---|---|
| Attestation | Plattformprüfung, dass eine echte, unmanipulierte App spricht |
| Balancing | Abstimmen der Spielwerte auf Fairness und Spannung |
| Backpressure | Rückstau-Schutz bei langsamen Empfängern |
| CDN | Verteiltes Auslieferungsnetz für statische Dateien |
| ClickHouse | Spaltenorientierte Datenbank für Event-Auswertungen |
| Dead Reckoning | Position fortschreiben aus Richtung und Tempo, wenn kein Messwert vorliegt |
| Delta | Änderungsnachricht statt Vollzustand |
| ENU | Lokales Meter-Koordinatensystem (East, North, Up) |
| Config-Version | Unveränderlicher Satz aller Balance-Parameter |
| Feature | Geoobjekt: Geometrie + Attribute |
| Feldmaske | Bitmaske im Delta: welche Felder folgen |
| Fog of War | Spielregel, welche fremden Objekte ein Spieler sehen darf |
| Floating Origin | Mitwandernder lokaler Nullpunkt gegen Float-Ungenauigkeit |
| Follow-Kamera | Kamera, die starr am Avatar hängt und ihm folgt |
| Footprint | Gebäudegrundriss als Polygon |
| GERS | Stabile Objekt-ID in Overture Maps |
| GNSS | Oberbegriff für Satellitennavigation (GPS, Galileo, …) |
| Ground Drop | Beute als kurzlebiges Objekt auf der Karte, bis zum Aufheben |
| Grafana | Dashboard-Werkzeug über Metrik- und SQL-Quellen |
| H3 | Hexagonales Zellsystem von Uber |
| Heading | Blickrichtung des Avatars, aus der Bewegungsrichtung abgeleitet |
| Hot Reload | Neue Konfiguration im Betrieb übernehmen, ohne Neustart |
| Interest Area | Abonnierter Weltausschnitt eines Clients |
| Kardinalität | Anzahl unterschiedlicher Label-Kombinationen einer Metrik |
| Kalman-Filter | Glättungsverfahren, das Messungen nach ihrer Genauigkeit gewichtet |
| LOD | Detailstufe abhängig von der Distanz |
| MVT | Mapbox Vector Tile, Protobuf-Kachelformat |
| ODbL | Open Database License (OSM) |
| PMTiles | Einzeldatei-Kachelarchiv mit HTTP-Range-Zugriff |
| POI | Point of Interest |
| Polylinie | Streckenzug aus Punkten — hier: eine Route |
| Polycount | Anzahl Dreiecke eines Modells |
| Prometheus | Zeitreihen-Datenbank für aggregierte Metriken |
| PostGIS | Räumliche Erweiterung für PostgreSQL |
| Prefab | Vorgefertigtes Objekt im Client-Build, aus dem Instanzen entstehen |
| Region Actor | Zuständiger Simulationsprozess für eine Weltregion |
| Slippy Map | Übliche Kachelkarte mit XYZ-Schema |
| Snapshot | Vollständiger Zustand eines Ausschnitts |
| Telemetrie-Event | Einzelnes Spielereignis mit Details, für spätere Auswertung |
| Texture Atlas | Mehrere Texturen in einer Datei, damit ein Material genügt |
| Tick | Simulationsschritt in festem Takt |
| WGS84 | Weltweites geodätisches Bezugssystem (GPS-Koordinaten) |

## 14. Begriff → Stelle in der Architektur

| Grundlage | Architekturabschnitt |
|---|---|
| Kapitel 1, 3 — Koordinaten, Datenquellen | [Map Data Pipeline](../architecture/map-data.md#map-data-pipeline) |
| Kapitel 2 — GPS | [Anti-Cheat](../architecture/anti-cheat.md#anti-cheat) |
| Kapitel 4 — Kacheln | [Two Delivery Planes](../architecture/README.md#two-delivery-planes), [Map Component Evaluation](../architecture/map-data.md#map-component-evaluation) |
| Kapitel 5 — H3 | [Spatial Index](../architecture/streaming.md#spatial-index), [Subscription Set](../architecture/streaming.md#subscription-set) |
| Kapitel 6 — PostGIS | [Components](../architecture/backend.md#components) |
| Kapitel 7 — Streaming | [Message Flow](../architecture/streaming.md#message-flow), [Wire Budget](../architecture/streaming.md#wire-budget) |
| Kapitel 7 — Route + Fortschritt, Fog of War | [Entity Streaming](../architecture/streaming.md#entity-streaming), [Subscription Set](../architecture/streaming.md#subscription-set) |
| Kapitel 7 — Ground Drops | [Entity Classes](../architecture/streaming.md#entity-classes), [Game Design § Ground Drops](../design/rpg.md#ground-drops) |
| Kapitel 4, 7 — statisch vs. live | [Tile Payload](../architecture/map-data.md#tile-payload) |
| Kapitel 8 — Tick, Autorität | [Region Actors](../architecture/backend.md#region-actors), [Transport & Protocol](../architecture/transport.md#transport--protocol) |
| Kapitel 9 — Unity, Floating Origin | [Chosen: Custom Tile Pipeline](../architecture/map-data.md#chosen-custom-tile-pipeline) |
| Kapitel 9 — Kartenansicht, Kamera, Avatar | [Client Presentation](../architecture/client.md#client-presentation) |
| Kapitel 9 — Low-Poly, Darstellungskosten | [Client Presentation](../architecture/client.md#client-presentation), [Game Design § Art Direction](../design/presentation.md#art-direction) |
| Kapitel 10 — Routing | [Components](../architecture/backend.md#components) |
| Kapitel 11 — Grössenordnungen | [Scaling Model](../architecture/scaling.md#scaling-model), [Cost Model](../architecture/scaling.md#cost-model) |
| Kapitel 12 — Live-Konfiguration, Metriken | [Game Config & Metrics](../architecture/live-ops.md#game-config--metrics), [Operations](../architecture/operations.md#operations) |

## 15. Weiterführend

| Thema | Quelle |
|---|---|
| Kachelschema, Zoomstufen | [OSM Wiki: Slippy map tilenames](https://wiki.openstreetmap.org/wiki/Slippy_map_tilenames) |
| H3, Auflösungstabelle | [h3geo.org — Tables](https://h3geo.org/docs/core-library/restable/) |
| Vektor-Kachelformat | [Mapbox Vector Tile Specification](https://github.com/mapbox/vector-tile-spec) |
| Einzeldatei-Kacheln | [Protomaps / PMTiles](https://docs.protomaps.com/) |
| Offene Gebäudedaten | [Overture Maps — Buildings](https://docs.overturemaps.org/guides/buildings/) |
| Räumliche Abfragen | [PostGIS Reference](https://postgis.net/docs/reference.html) |
| OSM-Lizenz | [ODbL / OSM Copyright](https://www.openstreetmap.org/copyright) |
| Netcode-Grundlagen | [Valve: Source Multiplayer Networking](https://developer.valvesoftware.com/wiki/Source_Multiplayer_Networking) |
| Entity-Interpolation, Autorität | [Gabriel Gambetta: Fast-Paced Multiplayer](https://www.gabrielgambetta.com/client-server-game-architecture.html) |
| Standortdienste auf Mobilgeräten | [Android: Location strategies](https://developer.android.com/develop/sensors-and-location/location/strategies) |
| Rendering-Kosten auf Mobilgeräten | [Unity: Optimizing graphics performance](https://docs.unity3d.com/Manual/OptimizingGraphicsPerformance.html) |
| Asset-Budget und Modellierung | [Unity: Art asset best practice guide](https://docs.unity3d.com/Manual/HOWTO-ArtAssetBestPracticeGuide.html) |
| Metrik-Labels, Kardinalität | [Prometheus: Metric and label naming](https://prometheus.io/docs/practices/naming/) |
| Dashboards, Annotationen | [Grafana: Annotations](https://grafana.com/docs/grafana/latest/dashboards/build-dashboards/annotate-visualizations/) |
| Spaltenorientierte Auswertung | [ClickHouse Docs](https://clickhouse.com/docs) |
