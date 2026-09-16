# 13. Unity und .NET: ein Code, zwei Laufzeiten

[← Grundlagen](README.md)

**Problem:** Client (Unity) und Server (.NET) sind beide C#, laufen aber auf unterschiedlichen Laufzeiten mit unterschiedlichen Regeln. Gemeinsamer Code muss in beiden funktionieren — und der Client hat ein hartes Zeitbudget pro Bild.

**Analogie:** Eine Bibliothek, die gleichzeitig in einer modernen ASP.NET-Anwendung und in einer älteren Desktop-App (WPF, eingeschränktes Framework) laufen muss. Man schreibt gegen den **kleinsten gemeinsamen Nenner** und prüft jede Abhängigkeit gegen beide Ziele.

## Laufzeiten

| Begriff | Bedeutung | Business-Gegenstück |
|---|---|---|
| .NET (CoreCLR) | Aktuelle Microsoft-Laufzeit, JIT, neueste C#-Version | Normale Server-Anwendung |
| Mono | Ältere Laufzeit, die Unity im Editor verwendet | Älteres .NET Framework |
| IL2CPP | Unity übersetzt C# vor dem Build nach C++ und kompiliert nativ (AOT) | Native AOT in .NET |
| .NET Standard 2.1 | API-Vertrag, den beide Welten verstehen | Gemeinsames Interface-Paket |
| CoreCLR in Unity | Angekündigter Wechsel von Unity auf die .NET-Laufzeit | Framework-Migration; hebt die Grenzen unten auf |

| Grenze in Unity 6 LTS | Folge für gemeinsamen Code |
|---|---|
| C# 9 | Keine file-scoped namespaces, kein `required`, keine primary constructors |
| .NET Standard 2.1 | Neuere BCL-APIs (`TimeProvider`, `FrozenDictionary`) fehlen |
| IL2CPP / AOT | Kein Code zur Laufzeit erzeugen; Reflection nur eingeschränkt |
| Code Stripping | Build entfernt scheinbar unbenutzten Code — per Reflection Aufgerufenes fehlt dann zur Laufzeit |

## Projektstruktur in Unity

| Unity-Begriff | Bedeutung | Business-Gegenstück |
|---|---|---|
| Assembly Definition (`.asmdef`) | Legt fest, welcher Ordner zu welcher Assembly kompiliert wird, und deren Referenzen | `.csproj` |
| `noEngineReferences` | Assembly darf `UnityEngine` nicht verwenden | Domänenprojekt ohne UI-Framework-Referenz |
| UPM (Unity Package Manager) | Paketverwaltung von Unity; Pakete per Registry, Git oder lokalem Pfad | NuGet / npm |
| Lokales UPM-Paket | Ordner mit `package.json`, per `file:`-Pfad eingebunden | Projektreferenz statt Paket |
| NuGetForUnity | Holt NuGet-Pakete in ein Unity-Projekt | NuGet-Client |
| Source Generator | Erzeugt C#-Code beim Kompilieren (z. B. Serialisierer) — ersetzt Reflection | T4 / Code-Gen im Build |
| MemoryPack | Binärer Serialisierer mit Source Generator; läuft in Unity und .NET | `System.Text.Json` mit Source-Gen, aber binär |
| Addressables | Unity-System, um Assets nachladbar und ohne App-Update austauschbar zu machen | Lazy-Loading von Modulen über CDN |
| GameCI | Open-Source-Actions für Unity-Builds und -Tests in GitHub Actions | Build-Agent-Image für ein proprietäres SDK |

## Frame-Budget und Main Thread

**Analogie:** Der UI-Thread in WPF oder WinForms. Alles, was ein Fenster anfasst, muss dort laufen; blockiert er, friert die Oberfläche.

| Begriff | Bedeutung |
|---|---|
| Frame / Bild | Ein Durchlauf von Logik + Rendering; bei 30 fps ≈ 33 ms Budget |
| Main Thread | Einziger Thread, der Unity-Objekte (GameObject, Mesh, Transform) anfassen darf |
| `MonoBehaviour` | Klasse, die an einem Szenenobjekt hängt; Unity ruft `Update()` einmal pro Bild |
| Hitch / Ruckler | Einzelnes Bild, das das Budget überschreitet |
| GC-Spike | Garbage Collector hält das Programm an — im Spiel als Ruckler sichtbar |
| Object Pooling | Objekte wiederverwenden statt erzeugen/zerstören |
| Jobs System | Unity-Arbeitsaufträge auf Worker-Threads, mit Schutz vor Datenkonflikten |
| Burst | Compiler, der Job-Code (Teilmenge von C#) zu schnellem nativem Code macht |
| `UniTask` | `async/await` ohne Allokation, an Unity-Lebenszyklus gebunden |
| `VContainer` | Dependency Injection für Unity, per Source Generator statt Reflection |
| `R3` | Reactive Extensions für Unity und .NET — Zustandsänderungen als Datenstrom |
| URP | Universal Render Pipeline — Unitys Render-Pfad für Mobilgeräte |

- Auf dem Server kostet eine Allokation kaum etwas. Im Client summieren sich Allokationen pro Bild zu GC-Spikes.
- Netzwerk und Dekodieren laufen im Hintergrund; das Ergebnis wird über eine Queue an den Main Thread übergeben und dort pro Bild in Portionen angewendet.

```mermaid
flowchart LR
    S[Socket, Worker-Thread] --> D[Dekodieren] --> Q[(Queue)]
    Q -->|pro Bild, begrenzt| M[Main Thread: Store aktualisieren]
    M --> V[Views: Transforms, Materialien]
```

## Gemeinsamer Code: was hinein darf

| Gehört in die gemeinsame Assembly | Warum |
|---|---|
| Nachrichtenformate, IDs, Enums | Beide Seiten müssen Bytes gleich lesen |
| Kachel-Codec | Pipeline schreibt, Client liest — ein Code, keine Abweichung |
| Koordinatenumrechnung, Routenauswertung | Gleiche Position auf beiden Seiten |

| Gehört **nicht** hinein | Warum |
|---|---|
| Spielregeln (Kampf, Eroberung) | Der Client würde sie kennen und könnte sie „vorwegnehmen" — der Server entscheidet (Kapitel 8) |
| Konfigurationswerte | Kommen zur Laufzeit vom Server (Kapitel 12) |

**Fallstricke**

| Fehler | Folge |
|---|---|
| NuGet-Paket in Shared, das Unity nicht kennt | Server baut, Unity-Projekt kompiliert nicht |
| Reflection-basierter Serialisierer oder DI im Client | Läuft im Editor (Mono), bricht im IL2CPP-Build |
| Source-Generator-DLL in Unity nicht als Analyzer markiert | Serialisierer fehlen, Laufzeitfehler statt Kompilierfehler |
| Neuere C#-Syntax in Shared | Server-Build grün, Unity-Build rot |
| `UnityEngine`-Aufruf aus einem Hintergrund-Task | Exception oder Absturz nur auf dem Gerät |
| Allokationen pro Bild (LINQ, Strings, Closures) | Periodische Ruckler durch GC |
| `Instantiate`/`Destroy` pro Delta | Ruckler bei vielen Einheiten; Pool verwenden |
| Nur im Editor testen | IL2CPP-, Stripping- und Plattformfehler zeigen sich erst im Geräte-Build |

**Im Projekt:** → [Architecture § Tech Stack](../architecture/tech-stack.md#tech-stack), [§ Implementation Patterns](../architecture/code-patterns.md#implementation-patterns).

---
