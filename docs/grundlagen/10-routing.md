# 10. Routing auf Strassengraphen

[← Grundlagen](README.md)

**Problem:** Einheiten sollen Strassen folgen, nicht durch Häuser laufen.

**Analogie:** Ein klassisches Graphenproblem mit einem vorberechneten Index — vergleichbar mit einem Suchindex, der vor der Abfrage gebaut wird.

| Begriff | Bedeutung |
|---|---|
| Knoten | Kreuzung |
| Kante | Strassenabschnitt, gewichtet mit Kosten (Länge, Zeit) |
| Dijkstra / A* | Kürzester Weg; A* mit Luftliniendistanz als Heuristik |
| Contraction Hierarchies | Vorberechnung, macht Anfragen um Grössenordnungen schneller |
| Map Matching | Rohe GPS-Punkte auf Kanten legen |

| Engine | Sprache | Eigenschaft |
|---|---|---|
| OSRM | C++ | Sehr schnell, hoher Speicherbedarf |
| GraphHopper | Java | Flexibel, gute Anpassbarkeit |
| Valhalla | C++ | Gekachelt, sparsam beim Speicher, gut für grosse Gebiete |

Der Graph bleibt **serverseitig**. Der Client sendet nie eine Route, nur „gehe zu dieser Station" — sonst wäre Bewegung manipulierbar. Ausserdem wäre das Strassennetz einer Region ein unnötig grosser Download.

**Im Projekt:** → [Architecture § Components](../architecture/backend.md#components).

---
