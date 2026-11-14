// Carga los planetas en Firestore usando el SDK de administración.
// Requiere seed/serviceAccountKey.json (NO subirlo a Git).
import { readFileSync } from 'node:fs'
import { initializeApp, cert } from 'firebase-admin/app'
import { getFirestore } from 'firebase-admin/firestore'

const llave = JSON.parse(
  readFileSync(new URL('./serviceAccountKey.json', import.meta.url), 'utf8')
)
initializeApp({ credential: cert(llave) })
const db = getFirestore()

const planetas = JSON.parse(
  readFileSync(new URL('./planetas.json', import.meta.url), 'utf8')
)

const lote = db.batch()
for (const { id, ...datos } of planetas) {
  lote.set(db.collection('planetas').doc(id), datos)
}
await lote.commit()

console.log(`Se cargaron ${planetas.length} planetas en Firestore.`)
