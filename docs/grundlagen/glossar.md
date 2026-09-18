# Glossar und Verweise

[← Grundlagen](README.md)

## 17. Glossar

| Begriff | Kurz |
|---|---|
| Affix | Zufällige Zusatzeigenschaft eines Gegenstands mit Wert aus einem Bereich |
| Aggressor | Avatar, der zuerst angreift und dadurch selbst zum Ziel wird |
| Actor | Objekt mit privatem Zustand, nur über Nachrichten erreichbar |
| Addressables | Unity-System für nachladbare, austauschbare Assets |
| Assembly Definition (asmdef) | Unity-Gegenstück zur `.csproj` |
| Attestation | Plattformprüfung, dass eine echte, unmanipulierte App spricht |
| APNs / FCM | Push-Dienste von Apple und Google; der Server schickt Benachrichtigungen nur darüber |
| Backpressure | Rückstau-Schutz bei langsamen Empfängern |
| Auslieferungsebene (Delivery Plane) | Getrennter Weg für statische Geometrie (CDN) und lebenden Zustand (WebSocket) |
| Balancing | Abstimmen der Spielwerte auf Fairness und Spannung |
| Blender | Freie 3D-Software, per Python steuerbar |
| Blender MCP | MCP-Server, über den Claude Blender fernsteuert |
| Blockout | Grobform eines Modells aus einfachen Körpern |
| Burst | Compiler für schnellen nativen Job-Code in Unity |
| CDN | Verteiltes Auslieferungsnetz für statische Dateien |
| ClickHouse | Spaltenorientierte Datenbank für Event-Auswertungen |
| Code Stripping | Entfernen scheinbar unbenutzten Codes beim IL2CPP-Build |
| ComputeBuffer | GPU-Puffer mit Pro-Objekt-Daten, den der Shader per Index liest |
| Concept Art | Gemaltes Zielbild eines Objekts |
| Config-Version | Unveränderlicher Satz aller Balance-Parameter |
| Dead Reckoning | Position fortschreiben aus Richtung und Tempo, wenn kein Messwert vorliegt |
| Dichteklasse | City / Suburb / Rural pro H3-Zelle, nach Gebäuden pro km² |
| Drehrate | Zulässige Winkeländerung pro Sekunde eines Unter- oder Aufbaus |
| Douglas-Peucker | Vereinfachung von Umrissen mit Fehlerschranke |
| DPS | Schaden pro Sekunde |
| Delta | Änderungsnachricht statt Vollzustand |
| Domain Event | Fachliches Ereignis, Quelle für Deltas, Journal und Telemetrie |
| DuckDB | Eingebettete SQL-Engine für Parquet-Dateien |
| Earcut | Verfahren, ein Polygon in Dreiecke zu zerlegen |
| Entity-Klasse | Statisch verankert, platziert, beweglich oder Ereignis — bestimmt, woher Geometrie, Position und Zustand kommen |
| ENU | Lokales Meter-Koordinatensystem (East, North, Up) |
| FBX / glTF | Austauschformate für 3D-Modelle mit Skelett und Animation |
| Facing | Ausrichtung eines Objekts, unabhängig von seiner Bewegungsrichtung |
| Feature (Arbeitspaket) | Nummeriertes Lieferpaket `F<nn>` mit Abnahmekriterien; **nicht** das Geoobjekt |
| Feature (Geodaten) | Geoobjekt: Geometrie + Attribute |
| Feuerbogen | Winkelfenster um die Zielrichtung, in dem ein Angriff überhaupt zählt |
| Feldmaske | Bitmaske im Delta: welche Felder folgen |
| Floating Origin | Mitwandernder lokaler Nullpunkt gegen Float-Ungenauigkeit |
| Fog of War | Spielregel, welche fremden Objekte ein Spieler sehen darf |
| fastlane | Werkzeugkette, die Store-Uploads (TestFlight, Play) automatisiert |
| Follow-Kamera | Kamera, die starr am Avatar hängt und ihm folgt |
| Footprint | Gebäudegrundriss als Polygon |
| GameCI | Open-Source-Actions für Unity-Builds in CI |
| GC-Spike | Ruckler durch Pause des Garbage Collectors |
| Ghost | Besiegter Avatar: beweglich und sichtbar, aber handlungsunfähig, bis er seinen Respawnpunkt erreicht |
| GeoParquet | Parquet mit Geometriespalte |
| GERS | Stabile Objekt-ID in Overture Maps |
| Git LFS | Git-Erweiterung für grosse Binärdateien |
| GNSS | Oberbegriff für Satellitennavigation (GPS, Galileo, …) |
| GPX | XML-Format für aufgezeichnete GPS-Strecken |
| Greybox | Szene oder Objekt vollständig aus grauen Grundkörpern |
| Grafana | Dashboard-Werkzeug über Metrik- und SQL-Quellen |
| Ground Drop | Beute als kurzlebiges Objekt auf der Karte, bis zum Aufheben |
| H3 | Hexagonales Zellsystem von Uber |
| Heading | Blickrichtung des Avatars, aus der Bewegungsrichtung abgeleitet |
| Hot Reload | Neue Konfiguration im Betrieb übernehmen, ohne Neustart |
| Hysterese | Zwei Schwellen fürs Ein- und Ausschalten gegen Flackern |
| IL2CPP | Unitys Übersetzung von C# nach C++ (AOT) |
| Image-to-3D | KI erzeugt aus einem Bild ein 3D-Modell |
| IoU | Überlappungsmass zweier Flächen, 0–1 |
| Interest Area | Abonnierter Weltausschnitt eines Clients |
| Jobs System | Unity-Arbeitsaufträge auf Worker-Threads |
| Journal | Änderungsliste seit dem letzten Snapshot |
| Kill Credit | Exklusiver Beuteanspruch des Spielers mit dem letzten Treffer, zeitlich begrenzt |
| Kachelserver (Tile-Server) | Dienst, der Kacheln pro Request rendert oder ausliefert; hier **nicht** verwendet — Kacheln sind statische Dateien |
| Kalman-Filter | Glättungsverfahren, das Messungen nach ihrer Genauigkeit gewichtet |
| Kardinalität | Anzahl unterschiedlicher Label-Kombinationen einer Metrik |
| LOD | Detailstufe abhängig von der Distanz |
| Mailbox | Eingangs-Queue eines Actors |
| MinIO | Selbst gehosteter Objektspeicher mit S3-API; lokaler Ersatz für den Cloud-Speicher |
| Main Thread | Einziger Thread mit Zugriff auf Unity-Objekte |
| MCP | Model Context Protocol: offenes Protokoll für Werkzeugaufrufe durch KI-Assistenten |
| MemoryPack | Binärer C#-Serialisierer mit Source Generator |
| Mesh | Oberfläche aus Vertices und Dreiecken |
| Mono | Ältere .NET-Laufzeit im Unity-Editor |
| MonoBehaviour | Unity-Klasse an einem Szenenobjekt, pro Bild aufgerufen |
| MVT | Mapbox Vector Tile, Protobuf-Kachelformat |
| NetTopologySuite | .NET-Geometriebibliothek |
| Off-Road-Segment | Letztes Wegstück per Luftlinie, längenbegrenzt |
| Object Pooling | Objekte wiederverwenden statt neu erzeugen |
| ODbL | Open Database License (OSM) |
| Orleans | Actor-Framework von Microsoft |
| Pivot | Bezugspunkt eines Modells für Position und Drehung |
| Platzhalter-Asset | Grundkörper mit den Massen des späteren Modells, als Zwischenstand |
| PMTiles | Einzeldatei-Kachelarchiv mit HTTP-Range-Zugriff |
| POI | Point of Interest |
| Polycount | Anzahl Dreiecke eines Modells |
| Polylinie | Streckenzug aus Punkten — hier: eine Route |
| PostGIS | Räumliche Erweiterung für PostgreSQL |
| Prefab | Vorgefertigtes Objekt im Client-Build, aus dem Instanzen entstehen |
| Prefab-Vertrag | Vereinbarte Objektnamen, Masse und Pivot für Platzhalter und fertiges Modell |
| Primitive | Von der Engine mitgelieferter Grundkörper: Würfel, Kugel, Kapsel, Zylinder, Quad |
| Prometheus | Zeitreihen-Datenbank für aggregierte Metriken |
| Quaternion | Drehungsdarstellung ohne Gimbal Lock |
| Rarity | Seltenheitsstufe eines Gegenstands; bestimmt die Anzahl Affixe |
| Relation | Eigen / verbündet / rivalisierend / Dämon aus Sicht eines Spielers |
| Ribbon-Mesh | Flaches Band entlang einer Polylinie, hier für Strassen |
| R3 | Reactive Extensions für Unity und .NET |
| Region Actor | Zuständiger Simulationsprozess für eine Weltregion |
| Respawnpunkt | Selbst gesetzter Ort, an dem ein Ghost wieder lebendig wird; alle 48 h verschiebbar |
| Retopologie | Schlankes Mesh über ein dichtes legen |
| Rig | Knochenhierarchie, die ein Mesh bewegt |
| Root Motion | Animation, die das Objekt selbst verschiebt |
| Roll | Serverseitiger Zufallsvorgang für Beute und Crafting |
| Roster | Liste der Einheitentypen einer Fraktion |
| Schwenkbereich (Traverse Arc) | Wie weit der Aufbau gegen den Unterbau verdreht werden darf |
| Skinning | Zuordnung von Vertices zu Knochen |
| Stance | Kampfhaltung des Avatars: nur Dämonen oder alles Feindliche |
| Slippy Map | Übliche Kachelkarte mit XYZ-Schema |
| Slerp | Gleichmässige Interpolation zwischen zwei Drehungen |
| Snapshot | Vollständiger Zustand eines Ausschnitts |
| Telemetrie-Event | Einzelnes Spielereignis mit Details, für spätere Auswertung |
| Testcontainers | Bibliothek, die echte Dienste (z. B. PostgreSQL) als Container für Tests startet |
| Tier | Stufe T1–T3 von Gegenständen, Einheiten und Gates |
| Turret | Aufbau oder Oberkörper, der sich unabhängig vom Unterbau dreht |
| Timer-Queue | Dauerhafte Tabelle geplanter Ereignisse mit In-Memory-Kopie |
| Texture Atlas | Mehrere Texturen in einer Datei, damit ein Material genügt |
| Texture Baking | Details und Licht in eine Textur vorberechnen |
| Tick | Simulationsschritt in festem Takt |
| Topologie | Anordnung der Polygone eines Mesh |
| Turnaround Sheet | Objekt in Vorder-, Seiten-, Rückansicht ohne Perspektive |
| UniTask | Allokationsfreies `async/await` für Unity |
| UPM | Unity Package Manager |
| URP | Universal Render Pipeline, Unitys Mobil-Renderpfad |
| UV-Mapping | Abwicklung einer 3D-Oberfläche auf eine 2D-Textur |
| Validator | Import-Prüfung eines Assets gegen Budget, Masse und Namensvertrag |
| VContainer | Dependency Injection für Unity ohne Reflection |
| Valhalla | Gekachelte Routing-Engine (C++), hier für Fussgänger-Routen der Einheiten |
| Vertical Slice | Ausbaustufe, die ein Feature durch alle Schichten (Client, Server, DB, Deployment) spielbar liefert |
| Walking Skeleton | Erster Vertical Slice: dünnster lauffähiger Durchstich durch alle Schichten, noch ohne Fachlogik |
| Yaw (Gierwinkel) | Drehung um die Hochachse — die einzige in der Draufsicht sichtbare Drehachse |
| WGS84 | Weltweites geodätisches Bezugssystem (GPS-Koordinaten) |
| Write-Behind | Zustand im Speicher, gebündelt asynchron persistiert |

## 18. Begriff → Stelle in der Architektur

| Grundlage | Architekturabschnitt |
|---|---|
| Kapitel 1, 3 — Koordinaten, Datenquellen | [Map Data Pipeline](../architecture/map-data.md#map-data-pipeline) |
| Kapitel 2 — GPS | [Anti-Cheat](../architecture/anti-cheat.md#anti-cheat) |
| Kapitel 3 — DuckDB, GeoParquet, NetTopologySuite | [Tech Stack § Map Pipeline](../architecture/tech-stack.md#map-pipeline) |
| Kapitel 4 — Kacheln | [Two Delivery Planes](../architecture/README.md#two-delivery-planes), [Map Component Evaluation](../architecture/map-data.md#map-component-evaluation) |
| Kapitel 4, 7 — statisch vs. live | [Tile Payload](../architecture/map-data.md#tile-payload) |
| Kapitel 4 — Auslieferung, Tile-Server vs. statische Dateien | [Map Data § Delivery: No Tile Server](../architecture/map-data.md#delivery-no-tile-server) |
| Kapitel 16 — zwei Ebenen, Join über Entity-ID, platzierte Objekte | [Two Delivery Planes](../architecture/README.md#two-delivery-planes), [Entity Classes](../architecture/streaming.md#entity-classes), [Client § Building Tint](../architecture/client.md#building-tint) |
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
| Glossar — Vertical Slice, Walking Skeleton | [Build Phases](../architecture/operations.md#build-phases), [Feature Backlog](../features/README.md) |
| Kapitel 13 — Unity und .NET, Shared Assembly, Frame-Budget | [Tech Stack](../architecture/tech-stack.md#tech-stack), [Implementation Patterns](../architecture/code-patterns.md#implementation-patterns) |
| Kapitel 14 — 3D-Assets, Blender MCP, Image-to-3D | [Asset Pipeline](../architecture/asset-pipeline.md#asset-pipeline), [Game Design § Art Direction](../design/presentation.md#art-direction) |
| Kapitel 14 — Platzhalter, Prefab-Vertrag, Validator | [Placeholder Assets](../architecture/placeholder-assets.md#placeholder-assets), [Asset Pipeline § Model Conventions](../architecture/asset-pipeline.md#model-conventions) |
| Kapitel 15 — Facing, Schwenkbereich, Feuerbogen | [Game Design § Facing & Rotation](../design/facing.md#facing--rotation), [Rotation & Facing](../architecture/rotation.md#rotation--facing) |
| Kapitel 9 — Ausrichtung, Transform-Hierarchie, Slerp | [Rotation & Facing § Client Rendering](../architecture/rotation.md#client-rendering), [Client § Client Layers](../architecture/client.md#client-layers) |
| Kapitel 2 — Hysterese, Glättung | [Game Design § Speed Lock](../design/combat.md#speed-lock), [Client § Avatar Position Pipeline](../architecture/client.md#avatar-position-pipeline) |
| Kapitel 3 — Douglas-Peucker, IoU | [Map Data § Geometry Processing](../architecture/map-data.md#geometry-processing), [Map Data § Data Refresh](../architecture/map-data.md#data-refresh) |
| Kapitel 8 — Timer-Queue | [Backend § Timer Queue](../architecture/backend.md#timer-queue) |
| Kapitel 10 — Valhalla, Off-Road-Segment | [Backend § Routing Engine](../architecture/backend.md#routing-engine), [Game Design § Reachability](../design/rts.md#reachability) |
| Kapitel 15 — Relation, Fog of War, Dichteklasse | [Game Design § Relations](../design/factions.md#relations), [Game Design § Density Classes](../design/world.md#density-classes), [Streaming § Vision Cache](../architecture/streaming.md#vision-cache) |
| Kapitel 15 — Zielwahl, Aggressor, Stance | [Game Design § Target Order](../design/rts.md#target-order), [Game Design § Avatar Targeting](../design/combat.md#avatar-targeting), [Game Design § Target Selection](../design/combat.md#target-selection) |
| Kapitel 15 — Ghost, Respawnpunkt | [Game Design § Defeat](../design/rpg.md#defeat), [Anti-Cheat](../architecture/anti-cheat.md#anti-cheat) |
| Kapitel 15 — Tier, Rarity, Affix, Roll | [Game Design § Roll Model](../design/rpg.md#roll-model), [Game Design § Tech Access](../design/rpg.md#tech-access) |
| Glossar — ComputeBuffer, Ribbon-Mesh | [Client § Building Tint](../architecture/client.md#building-tint), [Client § Client Layers](../architecture/client.md#client-layers) |
| Glossar — APNs / FCM | [Backend § Push Notifications](../architecture/backend.md#push-notifications) |

## 19. Weiterführend

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
| Blender per KI steuern | [blender-mcp](https://github.com/ahujasid/blender-mcp) |
| Blender-Grundlagen, Modifier, UV | [Blender Manual](https://docs.blender.org/manual/en/latest/) |
| Bildgenerierung mit Gemini | [Gemini API: Image generation](https://ai.google.dev/gemini-api/docs/image-generation) |
| Modellimport in Unity | [Unity Manual: Importing models](https://docs.unity3d.com/Manual/ImportingModelFiles.html) |
| Grundkörper der Engine | [Unity Manual: Primitive objects](https://docs.unity3d.com/Manual/PrimitiveObjects.html) |
| Prefab-Varianten | [Unity Manual: Prefab Variants](https://docs.unity3d.com/Manual/PrefabVariants.html) |
| Drehungen und Interpolation | [Unity Scripting: Quaternion](https://docs.unity3d.com/ScriptReference/Quaternion.html) |
| Model Context Protocol | [modelcontextprotocol.io](https://modelcontextprotocol.io/) |
| Routing-Engine | [Valhalla Docs](https://valhalla.github.io/valhalla/) |
| Linienvereinfachung | [Wikipedia: Douglas-Peucker-Algorithmus](https://de.wikipedia.org/wiki/Douglas-Peucker-Algorithmus) |
| Hysterese in der Regelung | [Wikipedia: Hysterese](https://de.wikipedia.org/wiki/Hysterese) |
| Push-Benachrichtigungen | [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging) |
