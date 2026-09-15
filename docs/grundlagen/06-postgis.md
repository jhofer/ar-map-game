# 6. Räumliche Abfragen mit PostGIS

[← Grundlagen](README.md)

**Problem:** Die fachlichen Regeln sind geometrisch („innerhalb des Radius", „auf freier Fläche").

**Analogie:** PostGIS ist eine PostgreSQL-Erweiterung — zusätzliche Spaltentypen, Funktionen und Indextypen. Kein eigenes System, keine eigene Betriebsschiene.

| Typ | Rechnet in | Einsatz |
|---|---|---|
| `geometry` | Karteneinheiten (Grad oder projizierte Meter) | Schnell, für lokale Berechnungen |
| `geography` | Metern auf dem Ellipsoid | Korrekte Distanzen weltweit |

| Funktion | Bedeutung |
|---|---|
| `ST_DWithin(a, b, m)` | Liegt `b` innerhalb `m` Metern um `a`? Nutzt den Index |
| `ST_Contains(poly, pt)` | Punkt im Polygon (z. B. Standort in Gebäude) |
| `ST_Intersects(a, b)` | Überschneiden sich zwei Geometrien (z. B. Bauplatz mit Gebäude) |
| `ST_Area(geog)` | Fläche — Basis der Dichteberechnung |
| `ST_Distance(a, b)` | Abstand in Metern (bei `geography`) |

```sql
-- Eroberbare Gebäude im Umkreis von 30 m
SELECT id, kind FROM buildings
WHERE ST_DWithin(geom::geography, ST_MakePoint(:lon, :lat)::geography, 30)
  AND owner_faction IS NULL;
```

**Fallstricke**

| Fehler | Folge |
|---|---|
| `ST_Distance(...) < x` statt `ST_DWithin` | Index wird nicht genutzt, Full Scan |
| GiST-Index vergessen | Sekunden statt Millisekunden |
| `geometry` mit Gradwerten in Meter-Logik | Radius wird breitenabhängig falsch |
| Alles in der Datenbank rechnen | Für Ticks zu langsam — heisser Zustand gehört in den Speicher |

**Im Projekt:** PostGIS ist der **dauerhafte** Speicher und liefert Abfragen ausserhalb des Ticks. Der laufende Kampf rechnet im Arbeitsspeicher der Region → [Architecture § Components](../architecture/backend.md#components).

---
