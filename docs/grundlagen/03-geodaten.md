# 3. Geodaten: Quellen, Modell, Lizenz

[← Grundlagen](README.md)

**Problem:** Woher kommen Gebäude, Strassen und POIs?

**Analogie:** Ein Stammdaten-Import aus einer Fremdquelle — Schema-Mapping, Qualitätsprüfung, Lizenzbedingungen.

## Datenmodell

| Begriff | Bedeutung | Entspricht |
|---|---|---|
| Feature | Ein Objekt mit Geometrie + Attributen | Datensatz / Row |
| Geometry | `Point`, `LineString`, `Polygon`, … | Spaltenwert |
| Footprint | Grundriss eines Gebäudes als Polygon | Geometrie des Gebäudes |
| POI | Point of Interest (Laden, Schule, Werkstatt) | Punkt mit Kategorie |
| Tag | Freies Schlüssel/Wert-Paar (OSM) | JSONB-Spalte |
| Strassengraph | Knoten + Kanten aus dem Strassennetz | Graph-Tabelle |

## Quellen

| Quelle | Inhalt | Lizenz | Bemerkung |
|---|---|---|---|
| OpenStreetMap (OSM) | Alles, community-gepflegt | ODbL | Basis der meisten offenen Daten |
| Overture Maps | Gebäude, Orte, Verkehr, Adressen; > 2 Mrd. Gebäude | Gemischt, quellenabhängig (ODbL-Anteile) | Konsolidiert OSM + Microsoft + Esri, stabile IDs (GERS) |
| Amtliche Daten (z. B. swisstopo) | Sehr präzise, teils mit Höhen | Regional unterschiedlich | Nur regional verfügbar |
| Kommerzielle SDKs (Mapbox, Esri, Google) | Fertige Darstellung | Kostenpflichtig, pro Nutzer/Request | Siehe Kapitel 4 |

## Qualität ist regional sehr unterschiedlich

| Fall | Häufigkeit | Umgang |
|---|---|---|
| Footprint + Höhe vorhanden | Städte, Mitteleuropa | Direkt nutzen |
| Footprint ohne Höhe | Häufig | Schätzen aus Stockwerkzahl/Typ |
| Nur Adress- oder POI-Punkt | Ländlich, viele Länder | Gebäude synthetisieren |
| Nur Strassennetz | Sehr dünn besiedelt | Knoten an Kreuzungen erzeugen |
| Nichts | Unbewohnt | Kachel als unspielbar markieren |

**ODbL in einem Satz:** Nutzung frei, Namensnennung Pflicht, und eine veränderte *Datenbank*, die man veröffentlicht, muss wieder unter ODbL stehen. Ein Spiel, das die Daten nur benutzt, veröffentlicht keine Datenbank — die abgeleiteten Kacheln sollten aber sauber vom Spielzustand getrennt bleiben.

**Im Projekt:** → [Architecture § Map Data Pipeline](../architecture/map-data.md#map-data-pipeline) und die Coverage-Kaskade in [Game Design § Data Coverage Fallback](../design/world.md#data-coverage-fallback).

---
