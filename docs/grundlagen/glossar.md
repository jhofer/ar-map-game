# Glossar und Verweise

[← Grundlagen](README.md)

## 14. Glossar

| Begriff | Kurz |
|---|---|
| Actor | Objekt mit privatem Zustand, nur über Nachrichten erreichbar |
| Addressables | Unity-System für nachladbare, austauschbare Assets |
| Assembly Definition (asmdef) | Unity-Gegenstück zur `.csproj` |
| Attestation | Plattformprüfung, dass eine echte, unmanipulierte App spricht |
| Backpressure | Rückstau-Schutz bei langsamen Empfängern |
| Balancing | Abstimmen der Spielwerte auf Fairness und Spannung |
| Burst | Compiler für schnellen nativen Job-Code in Unity |
| CDN | Verteiltes Auslieferungsnetz für statische Dateien |
| ClickHouse | Spaltenorientierte Datenbank für Event-Auswertungen |
| Code Stripping | Entfernen scheinbar unbenutzten Codes beim IL2CPP-Build |
| Config-Version | Unveränderlicher Satz aller Balance-Parameter |
| Dead Reckoning | Position fortschreiben aus Richtung und Tempo, wenn kein Messwert vorliegt |
| Delta | Änderungsnachricht statt Vollzustand |
| Domain Event | Fachliches Ereignis, Quelle für Deltas, Journal und Telemetrie |
| DuckDB | Eingebettete SQL-Engine für Parquet-Dateien |
| Earcut | Verfahren, ein Polygon in Dreiecke zu zerlegen |
| ENU | Lokales Meter-Koordinatensystem (East, North, Up) |
| Feature | Geoobjekt: Geometrie + Attribute |
| Feldmaske | Bitmaske im Delta: welche Felder folgen |
| Floating Origin | Mitwandernder lokaler Nullpunkt gegen Float-Ungenauigkeit |
| Fog of War | Spielregel, welche fremden Objekte ein Spieler sehen darf |
| Follow-Kamera | Kamera, die starr am Avatar hängt und ihm folgt |
| Footprint | Gebäudegrundriss als Polygon |
| GameCI | Open-Source-Actions für Unity-Builds in CI |
| GC-Spike | Ruckler durch Pause des Garbage Collectors |
| GeoParquet | Parquet mit Geometriespalte |
| GERS | Stabile Objekt-ID in Overture Maps |
| GNSS | Oberbegriff für Satellitennavigation (GPS, Galileo, …) |
| GPX | XML-Format für aufgezeichnete GPS-Strecken |
| Grafana | Dashboard-Werkzeug über Metrik- und SQL-Quellen |
| Ground Drop | Beute als kurzlebiges Objekt auf der Karte, bis zum Aufheben |
| H3 | Hexagonales Zellsystem von Uber |
| Heading | Blickrichtung des Avatars, aus der Bewegungsrichtung abgeleitet |
| Hot Reload | Neue Konfiguration im Betrieb übernehmen, ohne Neustart |
| IL2CPP | Unitys Übersetzung von C# nach C++ (AOT) |
| Interest Area | Abonnierter Weltausschnitt eines Clients |
| Jobs System | Unity-Arbeitsaufträge auf Worker-Threads |
| Journal | Änderungsliste seit dem letzten Snapshot |
| Kalman-Filter | Glättungsverfahren, das Messungen nach ihrer Genauigkeit gewichtet |
| Kardinalität | Anzahl unterschiedlicher Label-Kombinationen einer Metrik |
| LOD | Detailstufe abhängig von der Distanz |
| Mailbox | Eingangs-Queue eines Actors |
| Main Thread | Einziger Thread mit Zugriff auf Unity-Objekte |
| MemoryPack | Binärer C#-Serialisierer mit Source Generator |
| Mono | Ältere .NET-Laufzeit im Unity-Editor |
| MonoBehaviour | Unity-Klasse an einem Szenenobjekt, pro Bild aufgerufen |
| MVT | Mapbox Vector Tile, Protobuf-Kachelformat |
| NetTopologySuite | .NET-Geometriebibliothek |
| Object Pooling | Objekte wiederverwenden statt neu erzeugen |
| ODbL | Open Database License (OSM) |
| Orleans | Actor-Framework von Microsoft |
| PMTiles | Einzeldatei-Kachelarchiv mit HTTP-Range-Zugriff |
| POI | Point of Interest |
| Polycount | Anzahl Dreiecke eines Modells |
| Polylinie | Streckenzug aus Punkten — hier: eine Route |
| PostGIS | Räumliche Erweiterung für PostgreSQL |
| Prefab | Vorgefertigtes Objekt im Client-Build, aus dem Instanzen entstehen |
| Prometheus | Zeitreihen-Datenbank für aggregierte Metriken |
| R3 | Reactive Extensions für Unity und .NET |
| Region Actor | Zuständiger Simulationsprozess für eine Weltregion |
| Slippy Map | Übliche Kachelkarte mit XYZ-Schema |
| Snapshot | Vollständiger Zustand eines Ausschnitts |
| Telemetrie-Event | Einzelnes Spielereignis mit Details, für spätere Auswertung |
| Texture Atlas | Mehrere Texturen in einer Datei, damit ein Material genügt |
| Tick | Simulationsschritt in festem Takt |
| UniTask | Allokationsfreies `async/await` für Unity |
| UPM | Unity Package Manager |
| URP | Universal Render Pipeline, Unitys Mobil-Renderpfad |
| VContainer | Dependency Injection für Unity ohne Reflection |
| Vertical Slice | Ausbaustufe, die ein Feature durch alle Schichten (Client, Server, DB, Deployment) spielbar liefert |
| Walking Skeleton | Erster Vertical Slice: dünnster lauffähiger Durchstich durch alle Schichten, noch ohne Fachlogik |
| WGS84 | Weltweites geodätisches Bezugssystem (GPS-Koordinaten) |
| Write-Behind | Zustand im Speicher, gebündelt asynchron persistiert |

## 15. Begriff → Stelle in der Architektur

| Grundlage | Architekturabschnitt |
|---|---|
| Kapitel 1, 3 — Koordinaten, Datenquellen | [Map Data Pipeline](../architecture/map-data.md#map-data-pipeline) |
| Kapitel 2 — GPS | [Anti-Cheat](../architecture/anti-cheat.md#anti-cheat) |
| Kapitel 3 — DuckDB, GeoParquet, NetTopologySuite | [Tech Stack § Map Pipeline](../architecture/tech-stack.md#map-pipeline) |
| Kapitel 4 — Kacheln | [Two Delivery Planes](../architecture/README.md#two-delivery-planes), [Map Component Evaluation](../architecture/map-data.md#map-component-evaluation) |
| Kapitel 4, 7 — statisch vs. live | [Tile Payload](../architecture/map-data.md#tile-payload) |
| Kapitel 5 — H3 | [Spatial Index](../architecture/streaming.md#spatial-index), [Subscription Set](../architecture/streaming.md#subscription-set) |
| Kapitel 6 — PostGIS | [Components](../architecture/backend.md#components) |
| Kapitel 7 — Streaming | [Message Flow](../architecture/streaming.md#message-flow), [Wire Budget](../architecture/streaming.md#wire-budget) |
| Kapitel 7 — Route + Fortschritt, Fog of War | [Entity Streaming](../architecture/streaming.md#entity-streaming), [Subscription Set](../architecture/streaming.md#subscription-set) |
| Kapitel 7 — Ground Drops | [Entity Classes](../architecture/streaming.md#entity-classes), [Game Design § Ground Drops](../design/rpg.md#ground-drops) |
| Kapitel 8 — Tick, Autorität | [Region Actors](../architecture/backend.md#region-actors), [Transport & Protocol](../architecture/transport.md#transport--protocol) |
| Kapitel 8 — Mailbox, Write-Behind, Domain Events | [Implementation Patterns § Region Actor](../architecture/code-patterns.md#region-actor), [§ Persistence](../architecture/code-patterns.md#persistence), [Tech Stack § Actor Choice](../architecture/tech-stack.md#actor-choice) |
| Kapitel 9 — Unity, Floating Origin | [Chosen: Custom Tile Pipeline](../architecture/map-data.md#chosen-custom-tile-pipeline) |
| Kapitel 9 — Kartenansicht, Kamera, Avatar | [Client Presentation](../architecture/client.md#client-presentation) |
| Kapitel 9 — Low-Poly, Darstellungskosten | [Client Presentation](../architecture/client.md#client-presentation), [Game Design § Art Direction](../design/presentation.md#art-direction) |
| Kapitel 9 — Triangulierung | [Implementation Patterns § Tile Loading](../architecture/code-patterns.md#tile-loading) |
| Kapitel 10 — Routing | [Components](../architecture/backend.md#components) |
| Kapitel 11 — Grössenordnungen | [Scaling Model](../architecture/scaling.md#scaling-model), [Cost Model](../architecture/scaling.md#cost-model) |
| Kapitel 12 — Live-Konfiguration, Metriken | [Game Config & Metrics](../architecture/live-ops.md#game-config--metrics), [Operations](../architecture/operations.md#operations) |
| Glossar — Vertical Slice, Walking Skeleton | [Build Phases](../architecture/operations.md#build-phases) |
| Kapitel 13 — Unity und .NET, Shared Assembly, Frame-Budget | [Tech Stack](../architecture/tech-stack.md#tech-stack), [Implementation Patterns](../architecture/code-patterns.md#implementation-patterns) |

## 16. Weiterführend

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
| Unity-Scripting, IL2CPP | [Unity Manual: IL2CPP](https://docs.unity3d.com/Manual/IL2CPP.html) |
| Code Stripping | [Unity Manual: Managed code stripping](https://docs.unity3d.com/Manual/ManagedCodeStripping.html) |
| .NET Standard, API-Umfang | [Microsoft Learn: .NET Standard](https://learn.microsoft.com/dotnet/standard/net-standard) |
| Channels | [Microsoft Learn: System.Threading.Channels](https://learn.microsoft.com/dotnet/core/extensions/channels) |
| Serialisierung Unity + .NET | [MemoryPack](https://github.com/Cysharp/MemoryPack) |
| Overture-Daten abfragen | [Overture Maps — Getting data with DuckDB](https://docs.overturemaps.org/getting-data/duckdb/) |
