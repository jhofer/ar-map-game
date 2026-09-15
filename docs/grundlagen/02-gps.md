# 2. GPS in der Praxis

[← Grundlagen](README.md)

**Problem:** Die Position des Spielers ist eine Messung mit Fehler, keine Tatsache.

**Analogie:** Benutzereingabe aus einem fremden System — plausibilisieren, nie blind übernehmen.

| Umgebung | Typische Genauigkeit | Ursache |
|---|---|---|
| Freies Feld | 3–5 m | Gute Satellitensicht |
| Vorstadt | 5–15 m | Teilabschattung |
| Innenstadt (Urban Canyon) | 15–50 m | Reflexionen an Fassaden (Mehrwegempfang) |
| Innenräume | 30–100 m+ | WLAN-/Mobilfunk-Fallback statt GNSS |

- Jedes Betriebssystem liefert zur Position einen **Genauigkeitsradius**. Der gehört ins Protokoll und in die Validierung.
- Die Position „springt" auch bei stehendem Gerät (Jitter). Ohne Glättung flackert jede radiusbasierte Prüfung.
- „GPS" heisst heute GNSS: GPS, Galileo, GLONASS, BeiDou kombiniert.

**Fallstricke**

| Fehler | Folge |
|---|---|
| Rohe Fixes ohne Genauigkeitsfilter verwenden | Eroberung schlägt scheinbar zufällig fehl |
| Client-gemeldete Geschwindigkeit vertrauen | Trivial manipulierbar |
| Position nur clientseitig prüfen | Spielstand per gefälschter Position generierbar |
| Keine Hysterese an Zonengrenzen | Spieler flackert in/out, Effekte triggern doppelt |

**Im Projekt:** Der Server akzeptiert Fixes, prüft Plausibilität (Sprungdistanz, Geschwindigkeit, Genauigkeit) und rechnet **alle** Präsenzregeln gegen seinen eigenen zuletzt akzeptierten Fix → [Architecture § Anti-Cheat](../architecture/anti-cheat.md#anti-cheat).

---
