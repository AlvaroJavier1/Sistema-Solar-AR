# Sistema Solar educativo en realidad aumentada (iOS)

Aplicación nativa en **Swift + SwiftUI + RealityKit** con datos en **Cloud Firestore** y arquitectura **MVVM**.
Proyecto de ETPS4 – Investigación 4.

> **Importante:** este código se escribió sin poder compilarlo (no hay Xcode en el entorno donde se generó).
> Es posible que Xcode muestre algún error o advertencia al compilar por primera vez. Si pasa, copia el mensaje
> completo y se corrige rápido.

## Contenido del .zip

```
app/SistemaSolarAR/        Código fuente de la app (arrastrar a Xcode)
  SistemaSolarARApp.swift  Punto de entrada; configura Firebase
  ContentView.swift        Pestañas: Planetas / Realidad aumentada
  Models/                  Planeta (modelo)
  Repositories/            Firestore + copia local (planetas.json)
  ViewModels/              PlanetasViewModel (MVVM)
  Views/                   Lista, ficha y escena de RA
  AR/                      SistemaSolarFactory: crea el Sol y los planetas (esferas)
  Support/                 Utilidad para colores hexadecimales
  Resources/planetas.json  Copia local de los datos (modo sin conexión)
firebase/
  firestore.rules          Reglas de seguridad para pegar en la consola
  seed/                    Script para cargar los planetas en Firestore
.gitignore
```

## Parte 1. En tu casa (no necesitas Mac)

### 1. Crear el proyecto de Firebase
1. Entra a https://console.firebase.google.com y crea un proyecto.
2. **Firestore Database > Crear base de datos** (modo producción).
3. Pestaña **Reglas**: pega el contenido de `firebase/firestore.rules` y publica.
4. Registra una **app de iOS** (icono de iOS en la página principal del proyecto).
   El **ID del paquete (Bundle ID)** debe ser el mismo que usarás en Xcode, por ejemplo `com.tunombre.SistemaSolarAR`.
5. Descarga `GoogleService-Info.plist` y guárdalo (lo usarás en la Mac).

### 2. Cargar los planetas en Firestore
Necesitas Node.js. Desde la carpeta `firebase/seed`:

```bash
pnpm add firebase-admin
```

1. En la consola: **Configuración del proyecto > Cuentas de servicio > Generar nueva clave privada**.
2. Guarda el archivo como `firebase/seed/serviceAccountKey.json` (**no lo subas a Git**; ya está en `.gitignore`).
3. Ejecuta:

```bash
node seed.js
```

4. Verifica en la consola que existe la colección `planetas` con 8 documentos.

### 3. Subir el código a GitHub
Crea el repositorio con esta carpeta y haz `git push`, así lo clonas en la Mac del laboratorio.

## Parte 2. En la Mac del laboratorio

### 1. Crear el proyecto en Xcode
1. **File > New > Project > iOS > App**.
2. Product Name: `SistemaSolarAR`. Interface: **SwiftUI**. Language: **Swift**.
3. Organization Identifier: el que corresponda a tu Bundle ID.
4. En el target, **General > Minimum Deployments**: **iOS 18.0** (la escena de RA usa `RealityView`).
   Verifica que tu iPhone tenga iOS 18 o superior (Ajustes > General > Información).

### 2. Agregar el código
1. Borra de Xcode (Move to Trash) los archivos generados `ContentView.swift` y `SistemaSolarARApp.swift`.
2. Arrastra al proyecto el contenido de `app/SistemaSolarAR/` (los dos `.swift` y las carpetas
   `Models`, `Repositories`, `ViewModels`, `Views`, `AR`, `Support`, `Resources`).
   Marca **Copy items if needed** y deja seleccionado el target.
3. Comprueba que `planetas.json` aparece en **Build Phases > Copy Bundle Resources**.

### 3. Agregar Firebase
1. **File > Add Package Dependencies...** y pega: `https://github.com/firebase/firebase-ios-sdk`
2. Selecciona el producto **FirebaseFirestore** y agrégalo al target (FirebaseCore se incluye solo).
3. Arrastra `GoogleService-Info.plist` al proyecto (con el target seleccionado).

### 4. Permiso de cámara
En el target, pestaña **Info**, agrega la clave **Privacy - Camera Usage Description**
(`NSCameraUsageDescription`) con un texto como:
*Se usa la cámara para mostrar el sistema solar en realidad aumentada.*

### 5. Ejecutar en tu iPhone
1. **Signing & Capabilities**: marca *Automatically manage signing* y elige tu Apple ID como Team.
2. Conecta el iPhone por cable y activa el **Modo desarrollador**
   (Ajustes > Privacidad y seguridad > Modo de desarrollador; el teléfono se reinicia).
3. Selecciona tu iPhone como destino y presiona **Run (⌘R)**.
4. Si iOS lo pide: Ajustes > General > VPN y gestión de dispositivos > confiar en tu perfil.

> Con un Apple ID gratuito, la app firmada dura 7 días. Vuelve a instalarla antes de la defensa.
> En la Mac compartida, **cierra sesión de tu Apple ID** (Xcode > Settings > Accounts) al terminar.

## Cómo probarla
- **Pestaña Planetas:** lista de 8 planetas; toca uno para ver su ficha.
- **Pestaña Realidad aumentada:** acepta el permiso de cámara, apunta a una mesa o al piso, espera a que se detecte
  la superficie y toca un planeta para abrir su ficha.
- **Firestore:** cada toque en un planeta crea un documento en la colección `consultas` (compruébalo en la consola).
- **Modo sin conexión:** si Firestore no responde, la app muestra los datos de `planetas.json` y avisa abajo en la lista.

## Problemas comunes
- **La app se cierra al abrir:** falta `GoogleService-Info.plist` en el proyecto o su Bundle ID no coincide con el de Xcode.
- **No aparece ningún planeta en la RA:** la cámara necesita ver bien una superficie con textura y luz; muévete despacio.
- **Error de `RealityView` o `@Observable`:** revisa que el destino mínimo sea iOS 18.0.
- **La lista dice "Mostrando datos locales":** revisa que las reglas estén publicadas y que la colección se llame `planetas`.
- **Errores de concurrencia (Swift 6):** en Build Settings, pon **Swift Language Mode = Swift 5** o pásame el mensaje.

## Notas sobre los datos
Los datos de los planetas son aproximados y hay que contrastarlos con NASA antes de la defensa:
https://science.nasa.gov/solar-system/planets/ (los conteos de lunas cambian con frecuencia, por eso se muestran como "Más de N").
Los tamaños y las distancias en la escena de RA **no están a escala real**; sirven solo para visualizar.
