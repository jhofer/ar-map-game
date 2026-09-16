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

**Off-Road-Segment:** Stationen und Gebäude liegen selten genau auf einer Strasse. Die Route endet am nächsten Strassenpunkt; das letzte Stück bis zum Ziel ist eine Luftlinie mit Längenlimit (30 m). Liegt das Ziel weiter weg, ist es unerreichbar — und wird von der Pipeline gar nicht erst als eroberbar markiert, damit es keine unangreifbaren Gebäude gibt.

**Fallstricke**

| Fehler | Folge |
|---|---|
| Ganze Erde in eine Engine laden | RAM-Bedarf in zweistelligen GB, Vorverarbeitung in Tagen; gekachelte Engine wählen |
| Route bis exakt zum Ziel verlangen | Jedes Gebäude abseits der Strasse ist unerreichbar |
| Kein Limit für das Off-Road-Segment | Einheiten laufen quer durch Blöcke |

**Im Projekt:** Valhalla als eigener Container hinter `IRouteProvider`, Fussgänger-Kostenmodell → [Architecture § Routing Engine](../architecture/backend.md#routing-engine). Off-Road-Regel → [Game Design § Reachability](../design/rts.md#reachability).

---
