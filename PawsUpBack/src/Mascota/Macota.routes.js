import { Router } from 'express'
import { subirImagen } from '../Middleware/Storage.js'
import { 
    addMascota,
    testMascota 
} from './Mascota.controller.js'

const app = Router()

app.get('/testMascota', testMascota)
app.post('/addMascota', subirImagen.single('imagen'), addMascota)

export default app