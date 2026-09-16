# Grundlagen — Geodaten, Karten und Game-Server

Einstiegsdokument für Entwickler mit Business-Application-Hintergrund (Web, Backend, Enterprise) **ohne** Vorwissen in Karten, Geodaten, Echtzeit-Streaming oder Spielarchitektur.

Ziel: nach diesem Dokument ist [Architecture](../architecture/README.md) lesbar.

Jedes Kapitel folgt demselben Muster:

| Abschnitt | Inhalt |
|---|---|
| Problem | Was gelöst wird |
| Analogie | Das Gegenstück aus der Business-Welt |
| Fakten | Tabellen, Zahlen, Formeln |
| Fallstricke | Was erfahrungsgemäss schiefgeht |
| Im Projekt | Wo das in unserer Architektur auftaucht |

## Contents

| Datei | Inhalt |
|---|---|
| [01-koordinaten.md](01-koordinaten.md) | 1. Koordinaten und Projektionen |
| [02-gps.md](02-gps.md) | 2. GPS in der Praxis |
| [03-geodaten.md](03-geodaten.md) | 3. Geodaten: Quellen, Modell, Lizenz |
| [04-kacheln.md](04-kacheln.md) | 4. Kacheln (Tiles): Pagination für die Welt |
| [05-indizes.md](05-indizes.md) | 5. Räumliche Indizes |
| [06-postgis.md](06-postgis.md) | 6. Räumliche Abfragen mit PostGIS |
| [07-streaming.md](07-streaming.md) | 7. Streaming und Interest Management |
| [08-server-tick.md](08-server-tick.md) | 8. Autoritativer Server und Tick |
| [09-rendering.md](09-rendering.md) | 9. Rendering im Unity-Client |
| [10-routing.md](10-routing.md) | 10. Routing auf Strassengraphen |
| [11-groessenordnungen.md](11-groessenordnungen.md) | 11. Grössenordnungen |
| [12-live-konfiguration.md](12-live-konfiguration.md) | 12. Live-Konfiguration und Spielmetriken |
| [13-unity-dotnet.md](13-unity-dotnet.md) | 13. Unity und .NET: ein Code, zwei Laufzeiten |
| [14-3d-assets.md](14-3d-assets.md) | 14. 3D-Assets: von der Skizze zum Prefab |
| [glossar.md](glossar.md) | Glossar und Verweise |

## Lesepfad

| Ziel | Kapitel |
|---|---|
| Nur die Architektur verstehen | [1](01-koordinaten.md), [4](04-kacheln.md), [5](05-indizes.md), [7](07-streaming.md), [8](08-server-tick.md) |
| Am Map-Pipeline-Code arbeiten | [1](01-koordinaten.md), [3](03-geodaten.md), [4](04-kacheln.md), [5](05-indizes.md), [6](06-postgis.md), [10](10-routing.md) |
| Am Server arbeiten | [5](05-indizes.md), [6](06-postgis.md), [7](07-streaming.md), [8](08-server-tick.md), [11](11-groessenordnungen.md), [12](12-live-konfiguration.md), [13](13-unity-dotnet.md) |
| Balancing auswerten | [8](08-server-tick.md), [12](12-live-konfiguration.md) |
| Am Unity-Client arbeiten | [1](01-koordinaten.md), [2](02-gps.md), [4](04-kacheln.md), [7](07-streaming.md), [9](09-rendering.md), [13](13-unity-dotnet.md) |
| 3D-Assets erstellen | [9](09-rendering.md), [14](14-3d-assets.md) |
| Kosten beurteilen | [4](04-kacheln.md), [11](11-groessenordnungen.md) |

## Mentales Modell

Die meisten Konzepte haben ein direktes Gegenstück in einer Business-Anwendung. Das Neue ist fast nie die Technik, sondern die **Dimension**: zwei Raumachsen statt einer Sortierreihenfolge, und ein Datenbestand, der grösser ist als jeder Client.

| Business-Anwendung | Dieses Projekt | Unterschied |
|---|---|---|
| Tabelle mit Millionen Zeilen | Welt mit Milliarden Gebäuden | Kein `ORDER BY` — Relevanz ist räumlich |
| Pagination (`LIMIT`/`OFFSET`) | Kacheln (Tiles) | Seite = Rechteck auf der Karte, nicht Zeilenbereich |
| Index auf einer Spalte (B-Tree) | Räumlicher Index (R-Tree, H3) | Zwei Achsen lassen sich nicht linear sortieren |
| `WHERE kunde = 42` | `WHERE distanz < 300 m` | Filterkriterium ist Geometrie |
| REST-Request/Response | Persistente Verbindung + Deltas | Server sendet ungefragt |
| Cronjob / Batch | Simulations-Tick | Zeit ist Teil des Zustands |
| CRUD-Backend vertraut dem Client | Autoritativer Server | Client-Angaben sind Absichtserklärungen |
| Session im Cookie | Interest-Subscription | Session hat eine geografische Ausdehnung |
| CDN für statische Assets | CDN für Kartengeometrie | Gleiches Prinzip, andere Nutzlast |
| Sharding nach Mandant | Sharding nach Weltregion | Shard-Key ist eine Zelle auf der Erde |

Ein Satz, der das ganze Projekt trägt:

> Die Welt ist gross und ändert sich selten. Der Spielzustand ist klein und ändert sich ständig. Beides muss getrennt ausgeliefert werden.

---
