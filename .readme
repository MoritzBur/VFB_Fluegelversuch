# Flügel-Biegeversuch - Analyse Pipeline

Dieses Repository enthält die Skripte und Daten für die Analyse eines Flügel-Biegeversuchs. Ziel des Versuchs ist es, die Verformungen eines Flügels unter verschiedenen Belastungskonfigurationen zu untersuchen und den Schubmittelpunkt experimentell zu ermitteln. Das Projekt beinhaltet verschiedene Skripte zur Datenvorverarbeitung, Filterung und zur Anpassung von Biegelinien-Modellen.

## 📍 Aufbau des Repositories

- **`run_analysis.m`**: Top-Level Skript, das alle anderen Skripte aufruft und die komplette Analyse-Pipeline steuert. Hier werden die Rohdaten geladen, verarbeitet, gefiltert, und die entsprechenden Fits erstellt.
- **`transform_data.m`**: Dieses Skript korrigiert die Rohdaten der Verformung um die Verschiebung der Drehachse (M0) und wendet eine Winkelkorrektur an, um die Flügelverformung zu bereinigen. Die Ergebnisse werden weiterverarbeitet und in gefilterter Form gespeichert.
- **`filter_data.m`**: Filtert die korrigierten Daten aus der Vorverarbeitung, um spezifische Zeitintervalle zu extrahieren, die für die Analyse interessant sind. Die gefilterten Daten werden als `*_filtered.mat` gespeichert.
- **`fit_biegelinie.m`**: Nimmt die gefilterten Daten und erstellt lineare Fits der Verformung über der Kraft für jede Messstelle entlang der Vorder- und Hinterkante des Flügels. Zudem werden Polynom-Fits 3. Grades für die Biegelinie erstellt. Die Ergebnisse werden in Dateien wie `*_fit.mat` gespeichert.
- **Sensor-Koordinaten (`V_sensors.mat`, `H_sensors.mat`)**: Enthält die x-Koordinaten der Messstellen entlang der Vorder- und Hinterkante des Flügels.

## 📊 Struktur der Ausgabedateien

### `*_filtered.mat`
Diese Dateien enthalten die aus den korrigierten Daten gefilterten Intervalle, die für die Analyse weiterverwendet werden sollen. Sie enthalten:
- **`filteredData`**: Eine Matrix, die nur die ausgewählten Zeilen aus den korrigierten Daten für die angegebenen Zeitintervalle enthält.
- **`Head`**: Ein Zell-Array, das die Namen der Messkanäle enthält (z.B. `V0`, `H0`, etc.), um die Spalten der `filteredData` zu identifizieren.

### `*_fit.mat`
Diese Dateien enthalten die Ergebnisse der linearen Fits und der Polynom-Fits für die Biegelinie. Sie enthalten:
- **`vFits`**, **`hFits`**: Zell-Arrays, die die Koeffizienten der linearen Fits für die Verschiebung an der Vorder- und Hinterkante enthalten.
- **`vCoeffs`**, **`hCoeffs`**: Arrays, die die Steigungen der linearen Fits für die Vorder- und Hinterkante angeben. Diese beschreiben die Abhängigkeit der Verschiebung von der aufgebrachten Kraft.
- **`polyV`**, **`polyH`**: Polynome 3. Grades, die die Biegelinie für die Vorder- bzw. Hinterkante des Flügels darstellen.
- **`V_x`**, **`H_x`**: Arrays mit den x-Koordinaten der Messstellen entlang der Vorder- und Hinterkante des Flügels.

## 🚀 Wie man das Projekt verwendet
1. **Analyse starten**: Rufe `run_analysis.m` auf, um den kompletten Prozess durchzuführen. Dieses Skript startet alle notwendigen Schritte: Von der Datenvorverarbeitung, über das Filtern bis hin zur Erstellung der Fits.
2. **Intervalle anpassen**: Die Zeitintervalle für die Filterung der Daten sind in `filter_data.m` definiert. Passe diese an, um nur relevante Bereiche der Messdaten zu verwenden.
3. **Ergebnisse auswerten**: Die Ergebnisse sind in den `*_fit.mat` Dateien gespeichert. Diese können in MATLAB geladen und für weitere Analysen verwendet werden.

## 🛠️ Anforderungen
- MATLAB (empfohlene Version R2024b)
- Die MATLAB-Dateien (`.mat`) für die Rohdaten und Sensor-Koordinaten.

## 📘 Zusätzliche Hinweise
- Achte darauf, dass die Dateien `V_sensors.mat` und `H_sensors.mat` im selben Verzeichnis liegen, da sie in verschiedenen Skripten verwendet werden.
- Die Struktur der Ausgabedateien ist so konzipiert, dass sie einfach in weiteren Analysen wiederverwendet werden können. Falls benötigt, können die Polynome (`polyV` und `polyH`) zur Visualisierung der Biegelinie oder für weitere Berechnungen verwendet werden.

Falls Fragen zur Nutzung der Skripte oder zur Struktur der Daten bestehen, wende dich gerne an mich.

Viel Erfolg bei der weiteren Analyse!

