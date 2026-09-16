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
- **Glättung:** Ein gleitender Mittelwert (Exponential Moving Average) über die letzten Fixes reicht bei Gehtempo; ein Kalman-Filter bringt bei 0,2–1 Fixes pro Sekunde kaum Gewinn, aber mehr Tuning. Gewichtung nach Genauigkeitsklasse: guter Fix zählt viel, schlechter wenig.
- **Hysterese:** Ein Zustand, der von einem Messwert abhängt (in der Zone / ausserhalb; zu schnell / langsam genug), wird mit **zwei** Schwellen oder Zeitfenstern geschaltet — eine zum Ein-, eine tiefer liegende zum Ausschalten. Sonst flackert er bei jedem Jitter. Beispiel Speed-Lock: sperren bei > 30 km/h über 20 s, freigeben bei < 20 km/h über 30 s.
- **GPX** ist ein XML-Format für aufgezeichnete Strecken. Abgespielt ersetzt es im Editor und in Tests das echte GPS — wie ein aufgezeichneter HTTP-Mitschnitt statt eines Live-Systems.

**Fallstricke**

| Fehler | Folge |
|---|---|
| Rohe Fixes ohne Genauigkeitsfilter verwenden | Eroberung schlägt scheinbar zufällig fehl |
| Client-gemeldete Geschwindigkeit vertrauen | Trivial manipulierbar |
| Position nur clientseitig prüfen | Spielstand per gefälschter Position generierbar |
| Keine Hysterese an Zonengrenzen | Spieler flackert in/out, Effekte triggern doppelt |

**Im Projekt:** Der Server akzeptiert Fixes, prüft Plausibilität (Sprungdistanz, Geschwindigkeit, Genauigkeit) und rechnet **alle** Präsenzregeln gegen seinen eigenen zuletzt akzeptierten Fix → [Architecture § Anti-Cheat](../architecture/anti-cheat.md#anti-cheat). Glättung im Client → [Architecture § Avatar Position Pipeline](../architecture/client.md#avatar-position-pipeline); Speed-Lock mit Hysterese → [Game Design § Speed Lock](../design/combat.md#speed-lock).

---
