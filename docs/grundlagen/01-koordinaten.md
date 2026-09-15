# 1. Koordinaten und Projektionen

[← Grundlagen](README.md)

**Problem:** Die Erde ist rund, Bildschirme und Datenbanken sind flach.

**Analogie:** Wie Zeichensatz-Encoding. Es gibt einen Standard (UTF-8 / WGS84), mehrere Repräsentationen, und Fehler entstehen fast immer beim Umrechnen zwischen ihnen.

## Die drei Systeme, die vorkommen

| System | Code | Einheit | Verwendung |
|---|---|---|---|
| WGS84 (geografisch) | EPSG:4326 | Grad (Länge/Breite) | GPS, Datenaustausch, Datenbank |
| Web Mercator | EPSG:3857 | Meter (projiziert) | Kartenkacheln, alle Slippy Maps |
| Lokales ENU-System | — | Meter (X/Y/Z) | Rendering in Unity |

- **Latitude (Breite)** = Nord/Süd, −90 bis +90. **Longitude (Länge)** = Ost/West, −180 bis +180.
- Reihenfolge ist eine klassische Fehlerquelle: GeoJSON und die meisten APIs nutzen `[lon, lat]`, menschliche Schreibweise und viele Bibliotheken `lat, lon`.
- Zürich ≈ `47.3769, 8.5417`.

## Grad sind keine Meter

| Grössenordnung | Meter (Breite) | Meter (Länge bei 47° N) |
|---|---|---|
| 1° | ≈ 111 320 m | ≈ 75 900 m |
| 0.001° | ≈ 111 m | ≈ 76 m |
| 0.00001° (5 Nachkommastellen) | ≈ 1.1 m | ≈ 0.76 m |

```
meter_pro_grad_laenge = 111320 × cos(breite)
```

Konsequenz: `lat`/`lon`-Differenzen darf man **nie** direkt als Distanz verrechnen. Ein Quadrat in Grad ist auf der Erde ein Rechteck, das Richtung Pol immer schmaler wird.

## Distanzberechnung

| Verfahren | Genauigkeit | Kosten | Einsatz |
|---|---|---|---|
| Euklidisch auf Grad | Falsch | Trivial | Nie |
| Äquirektangulare Näherung | ± 0.5 % auf kurzen Distanzen | Sehr billig | Radiusprüfungen im Tick |
| Haversine | ± 0.5 % (Kugel) | Billig | Standard |
| Vincenty / Geodesic | Zentimeter (Ellipsoid) | Teuer | Vermessung, hier nicht nötig |
| PostGIS `geography` | Ellipsoid, in Metern | Mittel | Datenbankabfragen |

## Web Mercator, kurz

- Zylinderprojektion, winkeltreu, **nicht** flächentreu.
- Abgeschnitten bei ±85.05° — die Welt wird dadurch quadratisch und lässt sich in Vierer-Bäume teilen.
- Verzerrungsfaktor = `1 / cos(breite)`: Grönland erscheint so gross wie Afrika, ist aber 14× kleiner.

**Fallstricke**

| Fehler | Symptom |
|---|---|
| `lat`/`lon` vertauscht | Objekte landen im Meer vor Somalia (0,0) oder gespiegelt |
| Distanz in Grad gerechnet | Radien stimmen am Äquator, schrumpfen Richtung Pol |
| Flächen in Web Mercator gerechnet | Dichtewerte in Skandinavien systematisch falsch |
| `float32` für Koordinaten | ≈ 1 m Auflösung — zu grob für Gebäudegeometrie |

**Im Projekt:** Datenhaltung in WGS84, Kachelschnitt in Web Mercator, Rendering in lokalen Metern → [Architecture § Map Data Pipeline](../architecture/map-data.md#map-data-pipeline), Kapitel 9 hier.

---
