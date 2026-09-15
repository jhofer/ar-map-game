# 11. Grössenordnungen

[← Grundlagen](README.md)

Zahlen als grobe Orientierung, nicht als Messwerte.

| Grösse | Grössenordnung |
|---|---|
| Gebäude weltweit (Overture) | > 2 Mrd. |
| Gebäude Schweiz | einige Millionen |
| OSM-Planet, komprimiert (.pbf) | ≈ 80 GB |
| Vektor-Basiskarte Planet (PMTiles, z0–15) | ≈ 120 GB |
| Stadt-Extrakt (Geometrie, eigenes Format) | einige 10 MB |
| Eine z15-Kachel, städtisch | 10–100 KB |
| Zustands-Delta einer Entity | 8–24 Byte |
| Routen-Nachricht einer Einheit | 40–200 Byte, einmalig |
| Datenrate im Kampf | unter 1 KB/s |
| Tick-Kosten einer Region (≈ 200 Entities) | deutlich unter 1 ms |
| Objektspeicher (Cloudflare R2) | ≈ $0.015/GB/Monat, kein Egress-Entgelt |
| Kleiner VPS (Hetzner) | ≈ 4–6 €/Monat |

Daraus folgt die Kostenlogik des Projekts: die grossen Datenmengen sind **statisch** und liegen billig im Objektspeicher; die teure Rechenzeit fällt nur dort an, wo gerade jemand spielt.

---
