# HUSTLE TRACKER — Contexto del Proyecto

## Qué es
Herramienta profesional para cuerpos técnicos de baloncesto. El entrenador registra acciones defensivas (hustle defense) en tiempo real durante entrenamientos y partidos. Al acabar genera un ranking, historial de jugadores y análisis acumulados de temporada.

---

## Origen
Arrancó como un HTML sencillo (`home.html`) con lead gate de Brevo, localStorage básico y una pantalla de sesión única sin historial. En esta conversación se ha rediseñado y ampliado completamente.

**El lead gate fue eliminado** — la app se venderá directamente (App Store + licencias web), no como freemium con captura de email.

---

## Decisiones de producto tomadas

### Modelo de negocio
- **App Store (iOS/iPadOS/Mac)** — suscripción anual ~29€ via Apple (ya funciona bien con DrawSports)
- **Web (Stripe)** — licencia por equipo ~29€/año
- **Multi-equipo / club** — hasta 5 equipos ~79€/año
- Tecnología: **PWA** envuelta con **Capacitor** para App Store. Sin backend en v1.
- Android cubierto por la versión web (PWA instalable desde navegador)

### Flujo de uso real
- Un entrenador usa iPad/iPhone durante el ejercicio, toca acciones en tiempo real
- Un solo entrenador por sesión (posible expansión multi-entrenador futura)
- Los 12 jugadores son fijos pero puede haber invitados (juniors) por sesión
- Al acabar: resumen para staff + exportar imagen/PDF para vestuario

### Sesión = Entrenamiento o Partido
- Se distinguen con colores: **azul = entrenamiento**, **rojo = partido**
- Esta distinción es clave para el análisis comparativo

---

## Arquitectura técnica

### Stack
- HTML + CSS + JS vanilla — un solo archivo `home.html`
- `localStorage` con prefijo `ht_teams` y `ht_sessions`
- `html2canvas` (CDN) para exportar imagen
- SVG puro para gráficos de evolución
- CSS para gráficos de barras horizontales

### Estructura de datos

```js
// Team
{
  id, name,
  players: [{ id, number, name }],
  actions: [{ id, name, weight }],  // personalizables por equipo
  createdAt
}

// Session
{
  id, teamId,
  type: 'entrenamiento' | 'partido',
  date, name,
  activePlayers: [{ id, number, name }],
  stats: {
    [playerId]: { totalScore, actions: { [actionId]: count } }
  },
  history: [{ playerId, actionId, value }],  // para deshacer
  status: 'live' | 'done',
  completedAt
}
```

### Vistas (SPA con show/hide)
1. `view-home` — lista de equipos
2. `view-team` — detalle equipo (tabs: Acumulados / Sesiones / Jugadores)
3. `view-player` — perfil de jugador
4. `view-setup` — configurar nueva sesión
5. `view-live` — sesión en directo
6. `view-summary` — resumen de sesión

---

## Acciones defensivas por defecto

| ID | Nombre | Peso |
|----|--------|------|
| a1 | Contested T2P | 15 |
| a2 | Contested T3P | 20 |
| a3 | Deflections | 25 |
| a4 | Fly By | 35 |
| a5 | Steals | 50 |
| a6 | Deny Pass | 10 |
| a7 | Fifty/Fifty | 15 |
| a8 | Falta Táctica | 15 |
| a9 | Verticality | 20 |
| a10 | Great PnR Def | 20 |

Personalizables por equipo desde la vista de configuración.

---

## Funcionalidades implementadas

### Home
- Lista de equipos como cards con inicial, nombre, nº jugadores, sesiones y última fecha
- Botón `+` para crear equipo (auto-genera 12 jugadores genéricos)
- Logo HT dorado en header

### Equipo — Tab Acumulados
- **Tarjetas resumen**: total sesiones / entrenamientos / partidos
- **Ranking de temporada**: barras horizontales doradas proporcionales al score, clicables → perfil jugador
- **Entrenamiento vs Partido**: barras dobles (azul/rojo) con media por sesión para cada jugador (solo aparece si hay datos de ambos tipos)
- **Acciones más registradas**: barras azules ordenadas por frecuencia

### Equipo — Tab Sesiones
- Historial ordenado por fecha (reciente primero)
- Badge E/P por tipo, score del mejor jugador, nombre de sesión
- Sesiones "en vivo" marcadas en naranja

### Equipo — Tab Jugadores
- Textarea de edición masiva: `4 Raul`, `5 Jose` — uno por línea
- Guardar reemplaza toda la plantilla preservando IDs existentes por número

### Perfil de Jugador
- Botón **Editar** en el hero (nombre + dorsal, modal inline)
- Stats: total temporada, sesiones jugadas, media entreno, media partido
- Acciones: ranking de acciones con conteo y puntos generados
- **Gráfico de evolución** SVG: barras compactas por sesión (azul=entreno, rojo=partido), score visible encima, fecha debajo
- Lista de sesiones navegables → toca una sesión y va al resumen de esa sesión

### Setup de sesión
- Tipo (Entrenamiento / Partido)
- Fecha + nombre opcional
- Selección de jugadores activos (todos por defecto)
- Añadir jugador invitado (solo esa sesión)

### Sesión en directo
- Vista split: jugadores izquierda / acciones derecha
- Selección de jugador → registrar acción con un toque
- Score parcial visible por jugador
- Contador de cada acción para el jugador seleccionado
- Deshacer última acción
- Acceso rápido al resumen sin finalizar

### Resumen de sesión
- Ranking con barras proporcionales al score (color según tipo de sesión)
- Score del jugador alineado con la barra
- Detalle de acciones por jugador
- **Exportar A4 blanco**: fondo blanco, texto negro, acentos dorados — imprimible

---

## Decisiones de diseño

- **Colores**: fondo `#121212`, primario `#FFD700` (dorado), azul `#3a86ff` (entreno), rojo `#ef476f` (partido)
- **Sin emojis** en rankings — números 1, 2, 3 con dorado para el top 3
- **Sin lead gate** — eliminado completamente
- Referencia visual: DrawSports (cards grandes, header con logo, espaciado generoso, tipografía bold)
- Gráficos: CSS puro para barras horizontales, SVG para evolución temporal

---

## Datos de demo

Al abrir la app sin datos se carga automáticamente:
- **Equipo**: Lakers Demo — 12 jugadores NBA (LeBron, Curry, Durant, Giannis, Jokic, Tatum, Doncic, Embiid, Lillard, A. Davis, Booker, J. Brown)
- **3 entrenamientos**: Bloque Defensivo I/II/III (mayo 2026)
- **3 partidos**: vs Boston Celtics, vs Golden State Warriors, vs Miami Heat

---

## Fases del proyecto

### Fase 1 — COMPLETADA ✓
- Multi-equipo con historial persistente
- Sesiones Entrenamiento / Partido
- Acumulados con gráficos
- Perfil de jugador con evolución
- Exportar A4 blanco

### Fase 2 — PENDIENTE
- Perfil de jugador más visual (foto, posición)
- Comparativa entre jugadores
- Filtros por periodo / tipo de sesión en acumulados
- Configuración de acciones por equipo desde UI

### Fase 3 — PENDIENTE
- PWA instalable (manifest + service worker)
- Capacitor → App Store (iOS/iPadOS/Mac)
- Sistema de pago (RevenueCat para iOS, Stripe para web)
- Sincronización cloud opcional (multi-dispositivo)

---

## Archivos

```
#HUSTLE Stats/
├── home.html       — app completa (único archivo)
├── index.html      — redirect a home.html
└── PROYECTO.md     — este documento
```

---

## Cómo correr en local

```bash
cd "/Users/jorgelorenzo/Desktop/Desarrollo APPs/#HUSTLE Stats"
python3 -m http.server 8080
# Abrir: http://localhost:8080/home.html
```

---

*Última actualización: junio 2026*
