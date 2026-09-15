# 8. Autoritativer Server und Tick

[← Grundlagen](README.md)

**Problem:** In einer Business-App darf der Client sagen „Bestellung angelegt". In einem Spiel darf er das nie.

**Analogie:** Command/Event statt CRUD. Der Client sendet **Absichten** („ich will erobern"), der Server entscheidet und verkündet das Ergebnis. Validierung ist nicht Komfort, sondern das Sicherheitsmodell.

| Aspekt | Business-Backend | Game-Server hier |
|---|---|---|
| Client-Eingabe | Daten | Absichtserklärung |
| Zeitmodell | Request-getrieben | Tick-getrieben + ereignisgesteuert |
| Zustand | In der Datenbank | Im Speicher, periodisch persistiert |
| Konsistenz | Transaktion pro Request | Ein Schreiber pro Region, sequenziell |
| Skalierung | Stateless-Instanzen | Zustandsbehaftete Regionen, nach Zelle geshardet |
| Ausfall | Retry | Snapshot + Journal, Region wird neu geladen |

## Tick

Ein Tick ist ein Simulationsschritt in festem Takt: Bewegungen fortschreiben, Reichweiten prüfen, Schaden anwenden, Änderungen sammeln, Deltas versenden.

| Frequenz | Einsatz |
|---|---|
| 60 Hz | Shooter |
| **2–4 Hz** | **Dieses Spiel** — Auto-Kampf, kein Zielen |
| 1/60 Hz | Punkte-Akkumulation |
| Ereignisgesteuert | Eroberung, Bau, Crafting |

## Region Actors und schlafende Regionen

Eine Region (H3 r8) wird von genau einem Akteur simuliert — ein Schreiber, keine Sperren, deterministische Reihenfolge. Eine Region ohne Spieler **schläft**.

| Zustand | Tick | Was trotzdem passiert |
|---|---|---|
| Live | 2–4 Hz | Alles |
| Schlafend | Keiner | Punkte werden beim Aufwachen per Formel nachgerechnet; geplante Ereignisse liegen in einer Timer-Queue |

Das ist der zentrale Kostenhebel: `Punkte = Rate × verstrichene Zeit` braucht keinen Tick. Nur wo ein Angreifer ist, muss simuliert werden — und ein Angreifer ist entweder ein Spieler (also ist die Region ohnehin wach) oder eine geplante Dämonenwelle (weckt die Region per Timer).

> Rechenkosten skalieren mit **aktiven Spielern**, nicht mit der Grösse der Welt. Genau das macht fünf Spieler für wenige Euro im Monat möglich.

**Im Projekt:** → [Architecture § Region Actors](../architecture/backend.md#region-actors) und [§ Cost Model](../architecture/scaling.md#cost-model).

---
